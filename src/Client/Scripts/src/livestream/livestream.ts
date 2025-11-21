import fixWebmDuration from "webm-duration-fix";
import * as signalR from "@microsoft/signalr";

declare const DotNet: typeof import("@microsoft/dotnet-js-interop").DotNet;

interface DotNetObject {
    invokeMethod<T>(methodIdentifier: string, ...args: any[]): T;
    invokeMethodAsync<T>(methodIdentifier: string, ...args: any[]): Promise<T>;
    dispose(): void;
}

declare global {
    interface Window {
        liveStreamingManager: LiveStreamingManager | null | undefined;
        initializeLiveStreamingManager: (
            videoPreviewParentId: string,
            dotNetCaller: DotNetObject
        ) => Promise<LiveStreamingManager>;
        initializeStreamViewer: (
            videoElementId: string,
            streamId: string,
            dotNetCaller: DotNetObject
        ) => Promise<StreamViewer>;
        resumeStreamPlayback?: (videoElementId: string, unmute?: boolean) => Promise<boolean>;
    }
}

const APP_SETTINGS_ENDPOINT = new URL("AppSettings/GetClientAppSettings", document.baseURI).toString();

type RawIceServer = {
    urls?: string | string[];
    Urls?: string | string[];
    url?: string;
    Url?: string;
    username?: string;
    Username?: string;
    credential?: string;
    Credential?: string;
};

let cachedIceServers: RTCIceServer[] | null = null;
let iceServerFetchPromise: Promise<RTCIceServer[]> | null = null;

async function getConfiguredIceServers(): Promise<RTCIceServer[]> {
    if (cachedIceServers) {
        return cachedIceServers;
    }

    if (!iceServerFetchPromise) {
        iceServerFetchPromise = fetchIceServersFromApi();
    }

    cachedIceServers = await iceServerFetchPromise;
    iceServerFetchPromise = null;
    return cachedIceServers;
}

async function fetchIceServersFromApi(): Promise<RTCIceServer[]> {
    try {
        const response = await fetch(APP_SETTINGS_ENDPOINT, { credentials: "include" });
        if (!response.ok) {
            throw new Error(`Failed to load ICE servers. Status: ${response.status}`);
        }

        const payload = await response.json();
        const configured = normalizeIceServers(payload?.IceServers ?? payload?.iceServers);

        if (configured.length > 0) {
            console.log(`Loaded ${configured.length} ICE server entries from API`);
            return configured;
        }

        console.warn("AppSettings returned no ICE servers, falling back to defaults");
    } catch (error) {
        console.warn("Unable to download ICE server configuration, using defaults instead", error);
    }

    return getFallbackIceServers();
}

function normalizeIceServers(raw: any): RTCIceServer[] {
    if (!Array.isArray(raw)) {
        return [];
    }

    const normalized: RTCIceServer[] = [];

    for (const entry of raw as RawIceServer[]) {
        if (!entry) {
            continue;
        }

        const urls = entry.urls ?? entry.Urls ?? entry.url ?? entry.Url;
        if (!urls || (Array.isArray(urls) && urls.length === 0)) {
            continue;
        }

        normalized.push({
            urls: Array.isArray(urls) ? [...urls] : urls,
            username: entry.username ?? entry.Username ?? undefined,
            credential: entry.credential ?? entry.Credential ?? undefined,
        });
    }

    return normalized;
}

function getFallbackIceServers(): RTCIceServer[] {
    return [
        // Google STUN servers (primary)
        { urls: "stun:stun.l.google.com:19302" },
        { urls: "stun:stun1.l.google.com:19302" },
        { urls: "stun:stun2.l.google.com:19302" },

        // Metered TURN servers (free tier - primary)
        {
            urls: "turn:openrelay.metered.ca:80",
            username: "openrelayproject",
            credential: "openrelayproject",
        },
        {
            urls: "turn:openrelay.metered.ca:443",
            username: "openrelayproject",
            credential: "openrelayproject",
        },
        {
            urls: "turn:openrelay.metered.ca:443?transport=tcp",
            username: "openrelayproject",
            credential: "openrelayproject",
        },

        // Numb STUN/TURN (free - backup)
        { urls: "stun:stun.relay.metered.ca:80" },
        {
            urls: "turn:a.relay.metered.ca:80",
            username: "e870da5e4a03f95e2f5bd3b7",
            credential: "AvWnGLU7mwL+Z2YY",
        },
        {
            urls: "turn:a.relay.metered.ca:80?transport=tcp",
            username: "e870da5e4a03f95e2f5bd3b7",
            credential: "AvWnGLU7mwL+Z2YY",
        },
        {
            urls: "turn:a.relay.metered.ca:443",
            username: "e870da5e4a03f95e2f5bd3b7",
            credential: "AvWnGLU7mwL+Z2YY",
        },
        {
            urls: "turns:a.relay.metered.ca:443?transport=tcp",
            username: "e870da5e4a03f95e2f5bd3b7",
            credential: "AvWnGLU7mwL+Z2YY",
        },

        // Additional STUN servers for fallback
        { urls: "stun:stun.voipbuster.com" },
        { urls: "stun:stun.ekiga.net" },
        { urls: "stun:stun.ideasip.com" },
    ];
}

class SignalingClient {
    private connection: signalR.HubConnection | null = null;
    private streamId: string | null = null;
    private isHost: boolean = false;
    private dotnetCaller: DotNetObject;

    constructor(dotnetCaller: DotNetObject) {
        this.dotnetCaller = dotnetCaller;
    }

    async connect(): Promise<void> {
        this.connection = new signalR.HubConnectionBuilder()
            .withUrl("/streaming", {
                accessTokenFactory: async () => {
                    try {
                        console.log("Requesting access token for SignalR connection...");
                        const token = await this.dotnetCaller.invokeMethodAsync<string>("GetAccessToken");
                        console.log("Access token received:", token ? "Token present" : "No token");
                        return token || "";
                    } catch (error) {
                        console.error("Failed to get access token:", error);
                        return "";
                    }
                },
            })
            .withAutomaticReconnect()
            .build();

        this.setupEventHandlers();
        await this.connection.start();
        console.log("SignalR connection started");
    }

    private setupEventHandlers(): void {
        if (!this.connection) return;

        this.connection.on("StreamStarted", (streamId: string) => {
            console.log(`Stream ${streamId} started successfully`);
        });

        this.connection.on("StreamEnded", (streamId: string) => {
            console.log(`Stream ${streamId} ended`);
            this.dotnetCaller.invokeMethodAsync("StreamEnded", streamId);
        });

        this.connection.on("StreamNotFound", (streamId: string) => {
            console.log(`Stream ${streamId} not found`);
            this.dotnetCaller.invokeMethodAsync("StreamError", `Stream ${streamId} not found`);
        });

        this.connection.on("StreamJoined", (streamId: string, hostConnectionId: string) => {
            console.log(`Joined stream ${streamId}, host: ${hostConnectionId}`);
            this.dotnetCaller.invokeMethodAsync("StreamJoined", streamId, hostConnectionId);
        });

        this.connection.on("ViewerJoined", (viewerConnectionId: string) => {
            console.log(`Viewer joined: ${viewerConnectionId}`);
            this.dotnetCaller.invokeMethodAsync("ViewerJoined", viewerConnectionId);
        });

        this.connection.on("ViewerLeft", (viewerConnectionId: string) => {
            console.log(`Viewer left: ${viewerConnectionId}`);
            this.dotnetCaller.invokeMethodAsync("ViewerLeft", viewerConnectionId);
        });

        this.connection.on("ReceiveOffer", (streamId: string, fromConnectionId: string, offer: string) => {
            console.log(`Received offer from ${fromConnectionId}`);
            this.dotnetCaller.invokeMethodAsync("ReceiveOffer", streamId, fromConnectionId, offer);
        });

        this.connection.on("ReceiveAnswer", (streamId: string, fromConnectionId: string, answer: string) => {
            console.log(`Received answer from ${fromConnectionId}`);
            this.dotnetCaller.invokeMethodAsync("ReceiveAnswer", fromConnectionId, answer);
        });

        this.connection.on("ReceiveIceCandidate", (streamId: string, fromConnectionId: string, candidate: string) => {
            console.log(`Received ICE candidate from ${fromConnectionId}`);
            this.dotnetCaller.invokeMethodAsync("ReceiveIceCandidate", streamId, fromConnectionId, candidate);
        });
    }

    async startStream(streamId: string): Promise<void> {
        if (!this.connection) throw new Error("Not connected to signaling server");

        this.streamId = streamId;
        this.isHost = true;
        await this.connection.invoke("StartStream", streamId);
        console.log(`Stream ${streamId} started on signaling server`);
    }

    async stopStream(): Promise<void> {
        if (!this.connection || !this.streamId) return;

        await this.connection.invoke("StopStream", this.streamId);
        console.log(`Stream ${this.streamId} stopped on signaling server`);
        this.streamId = null;
        this.isHost = false;
    }

    async joinStream(streamId: string): Promise<void> {
        if (!this.connection) throw new Error("Not connected to signaling server");

        this.streamId = streamId;
        this.isHost = false;
        await this.connection.invoke("JoinStream", streamId);
        console.log(`Joined stream ${streamId} on signaling server`);
    }

    async leaveStream(): Promise<void> {
        if (!this.connection || !this.streamId) return;

        await this.connection.invoke("LeaveStream", this.streamId);
        console.log(`Left stream ${this.streamId}`);
        this.streamId = null;
        this.isHost = false;
    }

    async sendOffer(targetConnectionId: string, offer: RTCSessionDescriptionInit): Promise<void> {
        if (!this.connection || !this.streamId) return;
        await this.connection.invoke("SendOffer", this.streamId, targetConnectionId, JSON.stringify(offer));
        console.log(`Sent offer to ${targetConnectionId}`);
    }

    async sendAnswer(targetConnectionId: string, answer: RTCSessionDescriptionInit): Promise<void> {
        if (!this.connection || !this.streamId) return;
        await this.connection.invoke("SendAnswer", this.streamId, targetConnectionId, JSON.stringify(answer));
        console.log(`Sent answer to ${targetConnectionId}`);
    }

    async sendIceCandidate(targetConnectionId: string, candidate: RTCIceCandidateInit): Promise<void> {
        if (!this.connection || !this.streamId) return;
        await this.connection.invoke("SendIceCandidate", this.streamId, targetConnectionId, JSON.stringify(candidate));
        console.log(`Sent ICE candidate to ${targetConnectionId}`);
    }

    async disconnect(): Promise<void> {
        if (this.connection) {
            await this.connection.stop();
            this.connection = null;
            console.log("SignalR connection stopped");
        }
    }
}

export class LiveStreamingManager {
    dotnetCaller: DotNetObject;

    webcam: Webcam;
    microphone: Microphone;

    canvas: HTMLCanvasElement;
    canvasContext: CanvasRenderingContext2D;
    canvasStream: MediaStream;

    audioContext: AudioContext;
    microphoneInput: MediaStreamAudioSourceNode | null = null;
    audioOutput: MediaStreamAudioDestinationNode;

    isStreaming: boolean = false;
    streamId: string | null = null;
    outputStream: MediaStream | null = null;

    isRecording: boolean = false;
    recorder: MediaRecorder | null = null;
    recordingStore: StreamRecordingStore | null = null;

    peerConnections: Map<string, RTCPeerConnection> = new Map();
    signalingClient: SignalingClient;

    saveInterval: number = 500;

    constructor(dotnetCaller: DotNetObject) {
        this.dotnetCaller = dotnetCaller;

        this.webcam = new Webcam();
        this.microphone = new Microphone();

        this.canvas = document.createElement("canvas");
        this.canvasContext = this.canvas.getContext("2d")!;
        this.canvasStream = this.canvas.captureStream(30);

        // Setup canvas for preview
        this.canvas.style.width = "100%";
        this.canvas.style.height = "100%";
        this.canvas.style.objectFit = "contain";
        this.canvas.classList.add("preview");

        this.audioContext = new AudioContext();
        this.audioOutput = this.audioContext.createMediaStreamDestination();

        this.signalingClient = new SignalingClient(dotnetCaller);

        this.drawCanvasFrame = this.drawCanvasFrame.bind(this);
        this.drawCanvasFrame();
    }

    async initialize(): Promise<void> {
        await this.signalingClient.connect();
    }

    canStream(): boolean {
        return this.microphone.isActive();
    }

    appendPreviews(parentId: string): void {
        let videoPreviewParent = document.getElementById(parentId);
        if (videoPreviewParent) {
            videoPreviewParent.appendChild(this.canvas);
        }
    }

    removePreview(): void {
        this.canvas?.remove();
    }

    async setWebcam(deviceId: string): Promise<void> {
        await this.webcam.start(deviceId);
        if (!this.webcam.isActive()) return;

        this.canvas.width = this.webcam.getWidth()!;
        this.canvas.height = this.webcam.getHeight()!;
    }

    async setMicrophone(deviceId: string): Promise<void> {
        if (this.microphoneInput) {
            this.microphoneInput.disconnect();
            this.microphoneInput = null;
        }

        await this.microphone.start(deviceId);
        if (!this.microphone.isActive()) return;

        this.microphoneInput = this.audioContext.createMediaStreamSource(this.microphone.getStream()!);
        this.microphoneInput.connect(this.audioOutput);
    }

    async startStream(streamId: string): Promise<void> {
        console.log("Starting stream with ID:", streamId);
        console.log("Microphone active:", this.microphone.isActive());
        console.log("Webcam active:", this.webcam.isActive());

        if (!this.canStream()) {
            console.error("Cannot start stream: No microphone selected");
            alert("Please select a microphone.");
            return;
        }

        this.streamId = streamId;
        this.audioContext.resume();

        const videoTracks = this.webcam.isActive() ? this.canvasStream.getVideoTracks() : [];
        const audioTracks = this.audioOutput.stream.getAudioTracks();
        this.outputStream = new MediaStream([...videoTracks, ...audioTracks]);

        await this.startRecording();
        await this.signalingClient.startStream(streamId);

        this.isStreaming = true;
        await this.dotnetCaller.invokeMethodAsync("StreamingStateChanged", true);

        console.log(`Live stream started with ID: ${streamId}`);
    }

    async stopStream(): Promise<void> {
        console.log("Stopping stream, cleaning up peer connections...");

        for (const [connectionId, peerConnection] of this.peerConnections) {
            console.log(`Closing peer connection for ${connectionId}`);
            peerConnection.close();
        }
        this.peerConnections.clear();

        await this.stopRecording();
        await this.signalingClient.stopStream();

        this.isStreaming = false;
        this.streamId = null;

        await this.dotnetCaller.invokeMethodAsync("StreamingStateChanged", false);
        console.log("Live stream stopped");
    }

    async handleViewerJoined(viewerConnectionId: string): Promise<void> {
        if (!this.outputStream) {
            console.error("Cannot handle viewer joined: no output stream");
            return;
        }

        console.log(`Handling viewer joined: ${viewerConnectionId}`);

        const iceServers = await getConfiguredIceServers();

        const peerConnection = new RTCPeerConnection({
            iceServers,
            iceTransportPolicy: "all", // Try all candidates (relay, srflx, host)
            iceCandidatePoolSize: 10, // Pre-gather candidates for faster connection
            bundlePolicy: "max-bundle", // Bundle all media on single transport
            rtcpMuxPolicy: "require", // Multiplex RTP and RTCP
        });

        this.outputStream.getTracks().forEach((track) => {
            console.log(`Adding track to peer connection: ${track.kind}`);
            peerConnection.addTrack(track, this.outputStream!);
        });

        peerConnection.onicecandidate = (event) => {
            if (event.candidate) {
                console.log("Sending ICE candidate to viewer:", event.candidate.type, event.candidate.candidate);
                this.signalingClient.sendIceCandidate(viewerConnectionId, event.candidate);
            } else {
                console.log("All ICE candidates sent to viewer");
            }
        };

        peerConnection.oniceconnectionstatechange = () => {
            console.log(`ICE connection state for viewer ${viewerConnectionId}:`, peerConnection.iceConnectionState);
            if (peerConnection.iceConnectionState === "failed") {
                console.error(`ICE connection failed for viewer ${viewerConnectionId}, trying ICE restart`);
                peerConnection.restartIce();
            } else if (peerConnection.iceConnectionState === "disconnected") {
                console.warn(`ICE connection disconnected for viewer ${viewerConnectionId} - may recover`);
            }
        };

        peerConnection.onconnectionstatechange = () => {
            console.log(`Connection state for viewer ${viewerConnectionId}:`, peerConnection.connectionState);
            if (peerConnection.connectionState === "connected") {
                console.log(`? Connected to viewer ${viewerConnectionId}`);
            } else if (peerConnection.connectionState === "disconnected") {
                console.warn(`Viewer ${viewerConnectionId} disconnected - may recover`);
            } else if (peerConnection.connectionState === "failed") {
                console.error(`? Viewer ${viewerConnectionId} connection permanently failed`);
                this.peerConnections.delete(viewerConnectionId);
                peerConnection.close();
            }
        };

        peerConnection.onicegatheringstatechange = () => {
            console.log(`ICE gathering state for viewer ${viewerConnectionId}:`, peerConnection.iceGatheringState);
        };

        this.peerConnections.set(viewerConnectionId, peerConnection);

        try {
            const offer = await peerConnection.createOffer({
                offerToReceiveAudio: false,
                offerToReceiveVideo: false,
            });
            await peerConnection.setLocalDescription(offer);
            await this.signalingClient.sendOffer(viewerConnectionId, offer);
            console.log(`Offer created and sent to viewer ${viewerConnectionId}`);
        } catch (error) {
            console.error(`Failed to create/send offer to viewer ${viewerConnectionId}:`, error);
        }
    }

    async handleAnswer(viewerConnectionId: string, answer: string): Promise<void> {
        const peerConnection = this.peerConnections.get(viewerConnectionId);
        if (!peerConnection) {
            console.error(`No peer connection found for viewer ${viewerConnectionId}`);
            return;
        }

        try {
            await peerConnection.setRemoteDescription(JSON.parse(answer));
            console.log(`Answer set for viewer ${viewerConnectionId}`);
        } catch (error) {
            console.error(`Failed to set remote description for viewer ${viewerConnectionId}:`, error);
        }
    }

    async handleIceCandidate(viewerConnectionId: string, candidate: string): Promise<void> {
        const peerConnection = this.peerConnections.get(viewerConnectionId);
        if (!peerConnection) {
            console.error(`No peer connection found for viewer ${viewerConnectionId}`);
            return;
        }

        try {
            await peerConnection.addIceCandidate(JSON.parse(candidate));
            console.log(`ICE candidate added for viewer ${viewerConnectionId}`);
        } catch (error) {
            console.error(`Failed to add ICE candidate for viewer ${viewerConnectionId}:`, error);
        }
    }

    async startRecording(): Promise<void> {
        if (!this.outputStream || this.isRecording) return;

        const [mimeType, extension] = this.getSupportedMimeType();

        this.recordingStore = new StreamRecordingStore(mimeType, extension);

        this.recorder = new MediaRecorder(this.outputStream, { mimeType });

        this.recorder.ondataavailable = (event) => {
            if (event.data.size > 0) {
                this.recordingStore!.addChunk(event.data);
            }
        };

        this.recorder.onstop = async () => {
            await this.recordingStore!.generateOutputAsync();
            const output = this.recordingStore!.getOutput();

            await this.dotnetCaller.invokeMethodAsync(
                "StreamingFinished",
                DotNet.createJSStreamReference(output),
                this.recordingStore!.extension
            );
        };

        this.recorder.start(this.saveInterval);
        this.isRecording = true;

        console.log("Stream recording started");
    }

    async stopRecording(): Promise<void> {
        if (!this.recorder || !this.isRecording) return;

        this.recorder.stop();
        this.isRecording = false;

        console.log("Stream recording stopped");
    }

    async saveStreamLocally(filename: string): Promise<void> {
        if (!this.recordingStore) {
            throw new Error("No recording to save");
        }

        await this.recordingStore.saveOutputAsync(filename);
    }

    async finalizeStreaming(): Promise<void> {
        if (this.recordingStore) {
            this.recordingStore.clearOutput();
            this.recordingStore = null;
        }

        if (this.recorder) {
            this.recorder = null;
        }

        this.isRecording = false;
    }

    private getSupportedMimeType(): [string, string] {
        const types = [
            ["video/webm;codecs=vp9,opus", "webm"],
            ["video/webm;codecs=vp8,opus", "webm"],
            ["video/webm", "webm"],
            ["video/mp4", "mp4"],
        ];

        for (const [mimeType, extension] of types) {
            if (MediaRecorder.isTypeSupported(mimeType)) {
                return [mimeType, extension];
            }
        }

        return ["video/webm", "webm"];
    }

    async dispose(): Promise<void> {
        await this.stopStream();
        await this.finalizeStreaming();
        await this.signalingClient.disconnect();
        this.webcam.stop();
        this.microphone.stop();
        this.removePreview();
    }

    drawCanvasFrame(): void {
        requestAnimationFrame(this.drawCanvasFrame);
        if (this.webcam.isActive()) {
            this.canvasContext.drawImage(this.webcam.getVideoElement(), 0, 0, this.canvas.width, this.canvas.height);
        } else {
            this.canvasContext.fillStyle = "black";
            this.canvasContext.fillRect(0, 0, this.canvas.width, this.canvas.height);
            this.canvasContext.fillStyle = "white";
            this.canvasContext.font = "12px Calibri";
            this.canvasContext.textAlign = "center";
            this.canvasContext.fillText("No camera input", this.canvas.width / 2, this.canvas.height / 2);
        }
    }
}

class Webcam {
    private active: boolean = false;
    private deviceId: string | null = null;
    private width: number | null = null;
    private height: number | null = null;
    private videoElement: HTMLVideoElement; // Changed from preview to videoElement for clarity
    private stream: MediaStream | null = null;

    constructor() {
        this.videoElement = document.createElement("video");
        this.videoElement.muted = true;
        this.videoElement.autoplay = true;
        this.videoElement.playsInline = true; // Critical for mobile devices, especially iOS
        this.videoElement.setAttribute("playsinline", ""); // Additional attribute for compatibility
        // Hide the video element - we'll render to canvas instead
        this.videoElement.style.display = "none";
    }

    isActive(): boolean {
        return this.active;
    }
    getVideoElement(): HTMLVideoElement {
        return this.videoElement;
    } // Changed method name
    getStream(): MediaStream | null {
        return this.stream;
    }
    getWidth(): number | null {
        return this.width;
    }
    getHeight(): number | null {
        return this.height;
    }

    async start(deviceId: string): Promise<void> {
        if (deviceId === this.deviceId) return;
        if (this.active) this.stop();
        if (!deviceId || deviceId === "none") return;

        this.deviceId = deviceId;

        try {
            this.stream = await navigator.mediaDevices.getUserMedia({
                video: { deviceId: deviceId },
            });
        } catch (e) {
            alert("Failed to start camera.");
            console.log(e);
            this.stop();
            return;
        }

        const videoTrack = this.stream.getVideoTracks()[0];
        const settings = videoTrack.getSettings();
        this.width = settings.width!;
        this.height = settings.height!;

        this.videoElement.srcObject = this.stream;

        // Ensure video plays on mobile
        try {
            await this.videoElement.play();
        } catch (e) {
            console.warn("Failed to autoplay video, this is expected on some mobile browsers", e);
            // Try playing with user interaction - add muted attribute
            this.videoElement.muted = true;
            try {
                await this.videoElement.play();
            } catch (retryError) {
                console.error("Video play failed even with muted attribute:", retryError);
            }
        }

        this.active = true;
    }

    stop(): void {
        this.stream?.getTracks().forEach((track) => track.stop());
        this.videoElement.srcObject = null;
        this.deviceId = null;
        this.width = this.height = null;
        this.active = false;
    }
}

class Microphone {
    private active: boolean = false;
    private deviceId: string | null = null;
    private stream: MediaStream | null = null;

    constructor() {}

    isActive(): boolean {
        return this.active;
    }
    getStream(): MediaStream | null {
        return this.stream;
    }

    async start(deviceId: string): Promise<void> {
        if (deviceId === this.deviceId) return;
        if (this.active) this.stop();
        if (!deviceId || deviceId === "none") return;

        this.deviceId = deviceId;

        try {
            this.stream = await navigator.mediaDevices.getUserMedia({
                audio: { deviceId: deviceId },
            });
        } catch (e) {
            alert("Failed to start microphone.");
            console.log(e);
            this.stop();
            return;
        }

        this.active = true;
    }

    stop(): void {
        this.stream?.getTracks().forEach((track) => track.stop());
        this.deviceId = null;
        this.active = false;
    }
}

class StreamRecordingStore {
    chunks: Blob[] = [];
    length: number = 0;
    mimeType: string;
    extension: string;
    output: Blob | null = null;

    constructor(mimeType: string, extension: string) {
        this.mimeType = mimeType;
        this.extension = extension;
    }

    addChunk(chunk: Blob): void {
        this.chunks.push(chunk);
        this.length += chunk.size;
    }

    async generateOutputAsync(): Promise<void> {
        let recording = new Blob([...this.chunks], { type: this.mimeType });

        if (this.extension === "webm") {
            try {
                recording = await fixWebmDuration(recording);
            } catch (e) {
                console.warn("WebM duration fix failed:", e);
            }
        }

        this.output = recording;
    }

    getOutput(): Blob {
        if (this.output === null) {
            throw new Error("No output to return.");
        }
        return this.output;
    }

    clearOutput(): void {
        this.output = null;
        this.chunks = [];
        this.length = 0;
    }

    async saveOutputAsync(filename: string | null = null): Promise<void> {
        if (this.output === null) {
            throw new Error("No output to save.");
        }

        let recording = this.output;
        if (filename === null) {
            filename = prompt("Please enter a filename", "stream-recording");
            if (filename === null || filename === "") {
                filename = "stream-recording";
            }
        }

        filename = `${filename}.${this.extension}`;
        filename = this.cleanFilename(filename);

        const recordingUrl = URL.createObjectURL(recording);
        const downloadLink = document.createElement("a");
        downloadLink.href = recordingUrl;
        downloadLink.download = filename;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        URL.revokeObjectURL(recordingUrl);
        document.body.removeChild(downloadLink);
    }

    private cleanFilename(filename: string): string {
        return filename.replace(/[^a-z0-9.-]/gi, "_");
    }
}

export class StreamViewer {
    videoElement: HTMLVideoElement;
    streamId: string;
    dotnetCaller: DotNetObject;
    peerConnection: RTCPeerConnection | null = null;
    isConnected: boolean = false;
    signalingClient: SignalingClient;
    hostConnectionId: string | null = null;
    pendingIceCandidates: Array<{ streamId: string; fromConnectionId: string; candidate: string }> = [];

    constructor(videoElement: HTMLVideoElement, streamId: string, dotNetCaller: DotNetObject) {
        this.videoElement = videoElement;
        this.streamId = streamId;
        this.dotnetCaller = dotNetCaller;
        this.signalingClient = new SignalingClient(dotNetCaller);

        // Ensure mobile compatibility for video playback
        this.videoElement.playsInline = true;
        this.videoElement.setAttribute("playsinline", "");
        this.videoElement.autoplay = true;
        this.videoElement.muted = true; // Initially muted for autoplay

        console.log(`StreamViewer created for stream: ${streamId}`);
    }

    async connect(): Promise<void> {
        try {
            console.log(`StreamViewer: Connecting to SignalR and joining stream: ${this.streamId}`);

            // First connect to SignalR
            await this.signalingClient.connect();

            // Initialize WebRTC BEFORE joining stream so peer connection is ready for incoming offers
            await this.initializeWebRTC();
            console.log("StreamViewer: WebRTC initialized, peer connection ready");

            // Now join the stream - offers and ICE candidates can arrive immediately after this
            await this.signalingClient.joinStream(this.streamId);

            console.log(`StreamViewer: Successfully requested to join stream ${this.streamId}`);
        } catch (error) {
            console.error("StreamViewer: Failed to connect to stream:", error);
            this.dotnetCaller.invokeMethodAsync("StreamError", (error as Error).message);
        }
    }

    async handleStreamJoined(streamId: string, hostConnectionId: string): Promise<void> {
        console.log(`StreamViewer: handleStreamJoined called - Stream: ${streamId}, Host: ${hostConnectionId}`);
        this.hostConnectionId = hostConnectionId;

        // Process any ICE candidates that arrived before we knew the host ID
        if (this.pendingIceCandidates.length > 0) {
            console.log(`StreamViewer: Processing ${this.pendingIceCandidates.length} pending ICE candidates`);
            const queuedCandidates = [...this.pendingIceCandidates];
            this.pendingIceCandidates = [];
            for (const pending of queuedCandidates) {
                await this.handleIceCandidate(pending.streamId, pending.fromConnectionId, pending.candidate);
            }
        }

        console.log(`StreamViewer: Ready to receive offer from ${hostConnectionId}`);
    }

    async initializeWebRTC(): Promise<void> {
        console.log("StreamViewer: Initializing WebRTC for viewing...");

        const iceServers = await getConfiguredIceServers();

        this.peerConnection = new RTCPeerConnection({
            iceServers,
            iceTransportPolicy: "relay", // Try all candidates (relay, srflx, host)
            iceCandidatePoolSize: 10, // Pre-gather candidates for faster connection
            bundlePolicy: "max-bundle", // Bundle all media on single transport
            rtcpMuxPolicy: "require", // Multiplex RTP and RTCP
        });

        this.peerConnection.ontrack = (event) => {
            console.log("StreamViewer: Received stream from broadcaster", event.streams[0]);
            this.videoElement.srcObject = event.streams[0];
            this.videoElement.style.display = "block"; // Show video element

            // Try to play the video
            const playPromise = this.videoElement.play();
            if (playPromise !== undefined) {
                playPromise
                    .then(() => {
                        console.log("StreamViewer: Video playing successfully");
                        // Once playing, can unmute if needed
                        // this.videoElement.muted = false;
                    })
                    .catch((error) => {
                        console.warn("StreamViewer: Autoplay prevented, user interaction may be required:", error);
                        this.dotnetCaller.invokeMethodAsync("StreamAutoplayBlocked");
                    });
            }

            this.isConnected = true;
            this.dotnetCaller.invokeMethodAsync("StreamConnected");
        };

        this.peerConnection.onicecandidate = (event) => {
            if (event.candidate && this.hostConnectionId) {
                console.log("StreamViewer: Sending ICE candidate to host:", event.candidate);
                this.signalingClient.sendIceCandidate(this.hostConnectionId, event.candidate);
            } else if (!event.candidate) {
                console.log("StreamViewer: All ICE candidates have been sent");
            }
        };

        this.peerConnection.oniceconnectionstatechange = () => {
            console.log("StreamViewer: ICE connection state:", this.peerConnection?.iceConnectionState);
            if (this.peerConnection?.iceConnectionState === "failed") {
                console.error("StreamViewer: ICE connection failed - trying to restart ICE");
                // Try ICE restart
                if (this.peerConnection) {
                    this.peerConnection.restartIce();
                }
            } else if (this.peerConnection?.iceConnectionState === "disconnected") {
                console.warn("StreamViewer: ICE connection disconnected - may recover");
            }
        };

        this.peerConnection.onconnectionstatechange = () => {
            console.log("StreamViewer: Connection state:", this.peerConnection?.connectionState);
            if (this.peerConnection!.connectionState === "connected") {
                console.log("? StreamViewer: Connected to stream");
            } else if (this.peerConnection!.connectionState === "disconnected") {
                console.warn("StreamViewer: Connection disconnected - may recover");
            } else if (this.peerConnection!.connectionState === "failed") {
                console.error("StreamViewer: Connection permanently failed");
                this.isConnected = false;
                this.dotnetCaller.invokeMethodAsync("StreamError", "Connection lost");
            }
        };

        this.peerConnection.onicegatheringstatechange = () => {
            console.log("StreamViewer: ICE gathering state:", this.peerConnection?.iceGatheringState);
        };

        console.log("StreamViewer: WebRTC peer connection initialized");
    }

    async handleOffer(streamId: string, fromConnectionId: string, offer: string): Promise<void> {
        console.log(`StreamViewer: Handling offer from ${fromConnectionId}`);

        if (!this.peerConnection) {
            console.error("StreamViewer: No peer connection available when handling offer - this should not happen!");
            this.dotnetCaller.invokeMethodAsync("StreamError", "Failed to initialize WebRTC");
            return;
        }

        try {
            console.log("StreamViewer: Setting remote description...");
            await this.peerConnection.setRemoteDescription(JSON.parse(offer));
            console.log("StreamViewer: Remote description set successfully");

            console.log("StreamViewer: Creating answer...");
            const answer = await this.peerConnection.createAnswer();
            console.log("StreamViewer: Answer created successfully");

            console.log("StreamViewer: Setting local description...");
            await this.peerConnection.setLocalDescription(answer);
            console.log("StreamViewer: Local description set successfully - ICE gathering should start now");

            await this.signalingClient.sendAnswer(fromConnectionId, answer);
            console.log("StreamViewer: Answer sent to host");
        } catch (error) {
            console.error("StreamViewer: Failed to handle offer:", error);
            this.dotnetCaller.invokeMethodAsync("StreamError", "Failed to establish connection");
        }
    }

    async handleAnswer(streamId: string, fromConnectionId: string, answer: string): Promise<void> {
        if (!this.peerConnection) {
            console.error("StreamViewer: No peer connection available for answer");
            return;
        }

        try {
            await this.peerConnection.setRemoteDescription(JSON.parse(answer));
            console.log("StreamViewer: Answer set from host");
        } catch (error) {
            console.error("StreamViewer: Failed to set answer:", error);
        }
    }

    async handleIceCandidate(streamId: string, fromConnectionId: string, candidate: string): Promise<void> {
        if (!this.peerConnection) {
            console.error("StreamViewer: No peer connection available for ICE candidate");
            return;
        }

        try {
            // Only add ICE candidates after we've set the remote description (received the offer)
            if (this.peerConnection.remoteDescription) {
                await this.peerConnection.addIceCandidate(JSON.parse(candidate));
                console.log("StreamViewer: ICE candidate added from host");
            } else {
                console.log("StreamViewer: Queueing ICE candidate - waiting for remote description");
                this.pendingIceCandidates.push({ streamId, fromConnectionId, candidate });
            }
        } catch (error) {
            console.error("StreamViewer: Failed to add ICE candidate:", error);
        }
    }

    async dispose(): Promise<void> {
        console.log("StreamViewer: Disposing...");

        if (this.peerConnection) {
            this.peerConnection.close();
            this.peerConnection = null;
        }

        await this.signalingClient.leaveStream();
        await this.signalingClient.disconnect();

        this.isConnected = false;
        this.pendingIceCandidates = [];
    }
}

export async function initializeLiveStreamingManager(
    videoPreviewParentId?: string,
    dotNetCaller?: DotNetObject
): Promise<LiveStreamingManager> {
    if (window.liveStreamingManager !== undefined && window.liveStreamingManager !== null) {
        console.log("LiveStreamingManager already initialized, returning existing instance");
        return window.liveStreamingManager;
    }

    let streamingManager = new LiveStreamingManager(dotNetCaller!);
    await streamingManager.initialize();

    if (videoPreviewParentId) {
        streamingManager.appendPreviews(videoPreviewParentId);
    }
    window.liveStreamingManager = streamingManager;
    return streamingManager;
}

export async function initializeStreamViewer(
    videoElementId: string,
    streamId: string,
    dotNetCaller: DotNetObject
): Promise<StreamViewer> {
    console.log(`Looking for video element with id: ${videoElementId}`);

    await new Promise((resolve) => setTimeout(resolve, 100));

    const videoElement = document.getElementById(videoElementId);
    if (!videoElement) {
        console.error(`Video element with id '${videoElementId}' not found in DOM`);
        console.log("Available elements with video tag:", document.querySelectorAll("video"));
        throw new Error(`Video element with id '${videoElementId}' not found`);
    }

    console.log(`Found video element:`, videoElement);

    const viewer = new StreamViewer(videoElement as HTMLVideoElement, streamId, dotNetCaller);
    await viewer.connect();

    return viewer;
}

window.initializeLiveStreamingManager = initializeLiveStreamingManager;
window.initializeStreamViewer = initializeStreamViewer;

export async function resumeStreamPlayback(videoElementId: string, unmute: boolean = false): Promise<boolean> {
    const element = document.getElementById(videoElementId) as HTMLVideoElement | null;
    if (!element) {
        console.warn(`resumeStreamPlayback: video element ${videoElementId} not found`);
        return false;
    }

    if (unmute) {
        element.muted = false;
    }

    try {
        await element.play();
        console.log("resumeStreamPlayback: playback resumed");
        return true;
    } catch (error) {
        console.warn("resumeStreamPlayback: playback still blocked", error);
        return false;
    }
}

window.resumeStreamPlayback = resumeStreamPlayback;
