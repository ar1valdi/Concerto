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
        liveStreamingManager?: LiveStreamingManager | null;
        initializeLiveStreamingManager?: (
            videoPreviewParentId: string,
            dotNetCaller: DotNetObject
        ) => Promise<LiveStreamingManager>;
        initializeStreamViewer?: (
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

const FALLBACK_ICE_SERVERS: RTCIceServer[] = [
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
];

class IceServerProvider {
    private static cache: RTCIceServer[] | null = null;
    private static pending: Promise<RTCIceServer[]> | null = null;

    static async getServers(): Promise<RTCIceServer[]> {
        if (this.cache) {
            return this.cloneServers(this.cache);
        }

        if (!this.pending) {
            this.pending = this.fetchFromApi().catch((error) => {
                console.warn("Falling back to default ICE servers", error);
                return this.cloneServers(FALLBACK_ICE_SERVERS);
            });
        }

        try {
            const servers = await this.pending;
            this.cache = servers;
            return this.cloneServers(servers);
        } finally {
            this.pending = null;
        }
    }

    private static async fetchFromApi(): Promise<RTCIceServer[]> {
        const response = await fetch(APP_SETTINGS_ENDPOINT, { credentials: "include" });
        if (!response.ok) {
            throw new Error(`Failed to download ICE servers (${response.status})`);
        }

        const payload = await response.json();
        const normalized = this.normalize(payload?.IceServers ?? payload?.iceServers);
        if (normalized.length === 0) {
            console.warn("API returned an empty ICE server list, using fallback values");
            return this.cloneServers(FALLBACK_ICE_SERVERS);
        }

        console.log(`Loaded ${normalized.length} ICE server definition(s) from API`);
        return normalized;
    }

    private static normalize(raw: RawIceServer[] | undefined): RTCIceServer[] {
        if (!Array.isArray(raw)) {
            return [];
        }

        const sanitized: RTCIceServer[] = [];
        for (const entry of raw) {
            if (!entry) {
                continue;
            }

            const urls = entry.urls ?? entry.Urls ?? entry.url ?? entry.Url;
            if (!urls || (Array.isArray(urls) && urls.length === 0)) {
                continue;
            }

            sanitized.push({
                urls: Array.isArray(urls) ? [...urls] : urls,
                username: entry.username ?? entry.Username ?? undefined,
                credential: entry.credential ?? entry.Credential ?? undefined,
            });
        }

        return sanitized;
    }

    private static cloneServers(servers: RTCIceServer[]): RTCIceServer[] {
        return servers.map((server) => ({
            urls: Array.isArray(server.urls) ? [...server.urls] : server.urls,
            username: server.username,
            credential: server.credential,
        }));
    }
}

class SignalClient {
    private connection: signalR.HubConnection | null = null;
    private connectionPromise: Promise<void> | null = null;
    private currentStreamId: string | null = null;
    private isHost: boolean = false;

    constructor(private readonly dotnetCaller: DotNetObject) {}

    async connect(): Promise<void> {
        if (this.connection && this.connection.state !== signalR.HubConnectionState.Disconnected) {
            return;
        }

        if (!this.connectionPromise) {
            this.connectionPromise = this.createConnection();
        }

        try {
            await this.connectionPromise;
        } finally {
            this.connectionPromise = null;
        }
    }

    async disconnect(): Promise<void> {
        if (!this.connection) {
            return;
        }

        try {
            await this.connection.stop();
        } finally {
            this.connection = null;
            this.currentStreamId = null;
            this.isHost = false;
        }
    }

    async startStream(streamId: string): Promise<void> {
        await this.connect();
        const connection = this.ensureConnection();
        await connection.invoke("StartStream", streamId);
        this.currentStreamId = streamId;
        this.isHost = true;
        console.log(`SignalClient: StartStream ${streamId}`);
    }

    async stopStream(): Promise<void> {
        if (!this.connection || !this.currentStreamId || !this.isHost) {
            this.currentStreamId = null;
            this.isHost = false;
            return;
        }

        await this.connection.invoke("StopStream", this.currentStreamId);
        console.log(`SignalClient: StopStream ${this.currentStreamId}`);
        this.currentStreamId = null;
        this.isHost = false;
    }

    async joinStream(streamId: string): Promise<void> {
        await this.connect();
        const connection = this.ensureConnection();
        await connection.invoke("JoinStream", streamId);
        this.currentStreamId = streamId;
        this.isHost = false;
        console.log(`SignalClient: JoinStream ${streamId}`);
    }

    async leaveStream(): Promise<void> {
        if (!this.connection || !this.currentStreamId) {
            this.currentStreamId = null;
            return;
        }

        await this.connection.invoke("LeaveStream", this.currentStreamId);
        console.log(`SignalClient: LeaveStream ${this.currentStreamId}`);
        this.currentStreamId = null;
    }

    async sendOffer(targetConnectionId: string, offer: RTCSessionDescriptionInit): Promise<void> {
        if (!this.currentStreamId) {
            return;
        }

        const connection = this.ensureConnection();
        await connection.invoke("SendOffer", this.currentStreamId, targetConnectionId, JSON.stringify(offer));
    }

    async sendAnswer(targetConnectionId: string, answer: RTCSessionDescriptionInit): Promise<void> {
        if (!this.currentStreamId) {
            return;
        }

        const connection = this.ensureConnection();
        await connection.invoke("SendAnswer", this.currentStreamId, targetConnectionId, JSON.stringify(answer));
    }

    async sendIceCandidate(targetConnectionId: string, candidate: RTCIceCandidateInit): Promise<void> {
        if (!this.currentStreamId) {
            return;
        }

        const connection = this.ensureConnection();
        await connection.invoke(
            "SendIceCandidate",
            this.currentStreamId,
            targetConnectionId,
            JSON.stringify(candidate)
        );
    }

    private async createConnection(): Promise<void> {
        const connection = new signalR.HubConnectionBuilder()
            .withUrl("/streaming", {
                accessTokenFactory: () => this.fetchAccessToken(),
            })
            .withAutomaticReconnect()
            .build();

        this.registerHandlers(connection);
        await connection.start();
        this.connection = connection;
        console.log("SignalClient: connection established");
    }

    private async fetchAccessToken(): Promise<string> {
        try {
            const token = await this.dotnetCaller.invokeMethodAsync<string>("GetAccessToken");
            return token ?? "";
        } catch (error) {
            console.warn("SignalClient: failed to fetch access token", error);
            return "";
        }
    }

    private registerHandlers(connection: signalR.HubConnection): void {
        const forward = (method: string, ...args: any[]): void => {
            try {
                void this.dotnetCaller.invokeMethodAsync(method, ...args);
            } catch (error) {
                console.warn(`SignalClient: failed to forward ${method}`, error);
            }
        };

        connection.on("StreamStarted", (streamId: string) => console.log(`Stream ${streamId} started`));
        connection.on("StreamEnded", (streamId: string) => forward("StreamEnded", streamId));
        connection.on("StreamNotFound", (streamId: string) => forward("StreamError", `Stream ${streamId} not found`));
        connection.on("StreamJoined", (streamId: string, hostConnectionId: string) =>
            forward("StreamJoined", streamId, hostConnectionId)
        );
        connection.on("ViewerJoined", (viewerConnectionId: string) => forward("ViewerJoined", viewerConnectionId));
        connection.on("ViewerLeft", (viewerConnectionId: string) => forward("ViewerLeft", viewerConnectionId));
        connection.on("ReceiveOffer", (streamId: string, fromConnectionId: string, offer: string) =>
            forward("ReceiveOffer", streamId, fromConnectionId, offer)
        );
        connection.on("ReceiveAnswer", (_streamId: string, fromConnectionId: string, answer: string) => {
            try {
                void this.dotnetCaller.invokeMethodAsync("ReceiveAnswer", fromConnectionId, answer);
            } catch (error) {
                console.warn("SignalClient: failed to forward ReceiveAnswer", error);
            }
        });
        connection.on("ReceiveIceCandidate", (streamId: string, fromConnectionId: string, candidate: string) =>
            forward("ReceiveIceCandidate", streamId, fromConnectionId, candidate)
        );
    }

    private ensureConnection(): signalR.HubConnection {
        if (!this.connection) {
            throw new Error("SignalR connection is not ready");
        }

        return this.connection;
    }
}

class CameraController {
    private stream: MediaStream | null = null;
    private deviceId: string | null = null;
    private active: boolean = false;
    private width: number = 1280;
    private height: number = 720;
    private readonly element: HTMLVideoElement;

    constructor() {
        this.element = document.createElement("video");
        this.element.muted = true;
        this.element.autoplay = true;
        this.element.playsInline = true;
        this.element.setAttribute("playsinline", "");
        this.element.style.display = "none";
    }

    isActive(): boolean {
        return this.active;
    }

    getElement(): HTMLVideoElement {
        return this.element;
    }

    getDimensions(): { width: number; height: number } {
        return { width: this.width, height: this.height };
    }

    async useDevice(deviceId: string | null | undefined): Promise<void> {
        if (!deviceId) {
            this.stop();
            return;
        }

        if (this.active && deviceId === this.deviceId) {
            return;
        }

        this.stop();

        try {
            this.stream = await navigator.mediaDevices.getUserMedia({
                video: { deviceId },
            });
        } catch (error) {
            console.error("CameraController: failed to start camera", error);
            this.stop();
            throw error;
        }

        const track = this.stream.getVideoTracks()[0];
        const settings = track.getSettings();
        this.width = settings.width ?? this.width;
        this.height = settings.height ?? this.height;

        this.element.srcObject = this.stream;
        try {
            await this.element.play();
        } catch (error) {
            console.warn("CameraController: autoplay rejected", error);
        }

        this.deviceId = deviceId;
        this.active = true;
    }

    stop(): void {
        this.stream?.getTracks().forEach((track) => track.stop());
        this.stream = null;
        this.element.srcObject = null;
        this.deviceId = null;
        this.active = false;
    }
}

class MicrophoneController {
    private stream: MediaStream | null = null;
    private deviceId: string | null = null;
    private active: boolean = false;

    isActive(): boolean {
        return this.active;
    }

    getStream(): MediaStream | null {
        return this.stream;
    }

    async useDevice(deviceId: string | null | undefined): Promise<void> {
        if (!deviceId) {
            this.stop();
            return;
        }

        if (this.active && deviceId === this.deviceId) {
            return;
        }

        this.stop();

        try {
            this.stream = await navigator.mediaDevices.getUserMedia({
                audio: { deviceId },
            });
        } catch (error) {
            console.error("MicrophoneController: failed to start microphone", error);
            this.stop();
            throw error;
        }

        this.deviceId = deviceId;
        this.active = true;
    }

    stop(): void {
        this.stream?.getTracks().forEach((track) => track.stop());
        this.stream = null;
        this.deviceId = null;
        this.active = false;
    }
}

class RecordingStore {
    private readonly chunks: Blob[] = [];
    private output: Blob | null = null;

    constructor(private readonly mimeType: string, public readonly extension: string) {}

    addChunk(chunk: Blob): void {
        this.chunks.push(chunk);
    }

    async finalize(): Promise<void> {
        let recording = new Blob(this.chunks, { type: this.mimeType });
        if (this.extension === "webm") {
            try {
                recording = await fixWebmDuration(recording);
            } catch (error) {
                console.warn("RecordingStore: failed to fix WebM duration", error);
            }
        }

        this.output = recording;
    }

    getOutput(): Blob {
        if (!this.output) {
            throw new Error("RecordingStore: output not generated");
        }

        return this.output;
    }

    clear(): void {
        this.output = null;
        this.chunks.length = 0;
    }

    async save(filename?: string): Promise<void> {
        if (!this.output) {
            throw new Error("RecordingStore: nothing to save");
        }

        const sanitizedName = this.buildFilename(filename ?? "stream-recording");
        const url = URL.createObjectURL(this.output);
        const anchor = document.createElement("a");
        anchor.href = url;
        anchor.download = sanitizedName;
        document.body.appendChild(anchor);
        anchor.click();
        document.body.removeChild(anchor);
        URL.revokeObjectURL(url);
    }

    private buildFilename(base: string): string {
        const cleaned = base.replace(/[^a-z0-9.-]/gi, "_");
        return `${cleaned}.${this.extension}`;
    }
}

export class LiveStreamingManager {
    private readonly signaling: SignalClient;
    private readonly camera = new CameraController();
    private readonly microphone = new MicrophoneController();
    private readonly canvas: HTMLCanvasElement;
    private readonly canvasContext: CanvasRenderingContext2D;
    private readonly canvasStream: MediaStream;
    private readonly audioContext = new AudioContext();
    private readonly audioDestination = this.audioContext.createMediaStreamDestination();
    private microphoneInput: MediaStreamAudioSourceNode | null = null;
    private streamId: string | null = null;
    private outputStream: MediaStream | null = null;
    private recorder: MediaRecorder | null = null;
    private recordingStore: RecordingStore | null = null;
    private readonly peerConnections = new Map<string, RTCPeerConnection>();
    private isStreaming = false;
    private isRecording = false;
    private animationHandle: number | null = null;
    private readonly saveIntervalMs = 500;

    constructor(private readonly dotnetCaller: DotNetObject) {
        this.signaling = new SignalClient(dotnetCaller);
        this.canvas = document.createElement("canvas");
        this.canvas.width = 1280;
        this.canvas.height = 720;
        this.canvas.style.width = "100%";
        this.canvas.style.height = "100%";
        this.canvas.style.objectFit = "contain";
        this.canvas.classList.add("preview");

        const ctx = this.canvas.getContext("2d");
        if (!ctx) {
            throw new Error("Unable to acquire 2D canvas context");
        }
        this.canvasContext = ctx;
        this.canvasStream = this.canvas.captureStream(30);
        this.startPreviewLoop();
    }

    async initialize(): Promise<void> {
        await this.signaling.connect();
    }

    appendPreviews(parentId: string): void {
        const parent = document.getElementById(parentId);
        if (parent && !parent.contains(this.canvas)) {
            parent.appendChild(this.canvas);
        }
    }

    removePreview(): void {
        this.canvas.remove();
    }

    async setWebcam(deviceId: string): Promise<void> {
        await this.camera.useDevice(deviceId);
        const { width, height } = this.camera.getDimensions();
        this.canvas.width = width;
        this.canvas.height = height;
    }

    async setMicrophone(deviceId: string): Promise<void> {
        if (this.microphoneInput) {
            this.microphoneInput.disconnect();
            this.microphoneInput = null;
        }

        await this.microphone.useDevice(deviceId);
        if (!this.microphone.isActive()) {
            return;
        }

        const stream = this.microphone.getStream();
        if (!stream) {
            return;
        }

        this.microphoneInput = this.audioContext.createMediaStreamSource(stream);
        this.microphoneInput.connect(this.audioDestination);
    }

    async startStream(streamId: string): Promise<void> {
        if (this.isStreaming) {
            console.warn("LiveStreamingManager: stream already running");
            return;
        }

        if (!this.microphone.isActive()) {
            await this.reportError("Please select a microphone before starting the stream.");
            return;
        }

        this.streamId = streamId;
        await this.audioContext.resume();
        this.outputStream = this.buildOutputStream();
        await this.startRecording();
        await this.signaling.startStream(streamId);
        this.isStreaming = true;
        await this.notifyDotNet("StreamingStateChanged", true);
        console.log(`LiveStreamingManager: started stream ${streamId}`);
    }

    async stopStream(): Promise<void> {
        if (!this.isStreaming && !this.streamId) {
            return;
        }

        for (const peer of this.peerConnections.values()) {
            peer.close();
        }
        this.peerConnections.clear();

        await this.stopRecording();
        await this.signaling.stopStream();

        this.streamId = null;
        this.outputStream = null;
        this.isStreaming = false;
        await this.notifyDotNet("StreamingStateChanged", false);
        console.log("LiveStreamingManager: stream stopped");
    }

    async handleViewerJoined(viewerConnectionId: string): Promise<void> {
        if (!this.outputStream) {
            console.warn("LiveStreamingManager: no output stream for viewer");
            return;
        }

        const peerConnection = await this.createPeerConnection(viewerConnectionId);
        try {
            const offer = await peerConnection.createOffer({ offerToReceiveAudio: false, offerToReceiveVideo: false });
            await peerConnection.setLocalDescription(offer);
            await this.signaling.sendOffer(viewerConnectionId, offer);
        } catch (error) {
            console.error("LiveStreamingManager: failed to send offer", error);
        }
    }

    async handleAnswer(viewerConnectionId: string, answer: string): Promise<void> {
        const peer = this.peerConnections.get(viewerConnectionId);
        if (!peer) {
            console.warn(`LiveStreamingManager: missing peer ${viewerConnectionId}`);
            return;
        }

        try {
            await peer.setRemoteDescription(JSON.parse(answer));
        } catch (error) {
            console.error("LiveStreamingManager: failed to set remote description", error);
        }
    }

    async handleIceCandidate(viewerConnectionId: string, candidate: string): Promise<void> {
        const peer = this.peerConnections.get(viewerConnectionId);
        if (!peer) {
            console.warn(`LiveStreamingManager: missing peer ${viewerConnectionId}`);
            return;
        }

        try {
            await peer.addIceCandidate(JSON.parse(candidate));
        } catch (error) {
            console.error("LiveStreamingManager: failed to add ICE candidate", error);
        }
    }

    async saveStreamLocally(filename: string): Promise<void> {
        if (!this.recordingStore) {
            throw new Error("LiveStreamingManager: recording not available");
        }

        await this.recordingStore.save(filename);
    }

    async finalizeStreaming(): Promise<void> {
        this.recordingStore?.clear();
        this.recordingStore = null;
        this.recorder = null;
        this.isRecording = false;
    }

    async dispose(): Promise<void> {
        await this.stopStream();
        await this.finalizeStreaming();
        await this.signaling.disconnect();
        this.camera.stop();
        this.microphone.stop();
        this.removePreview();
        this.stopPreviewLoop();
    }

    private buildOutputStream(): MediaStream {
        const tracks: MediaStreamTrack[] = [];
        if (this.camera.isActive()) {
            tracks.push(...this.canvasStream.getVideoTracks());
        }
        tracks.push(...this.audioDestination.stream.getAudioTracks());

        if (tracks.length === 0) {
            throw new Error("LiveStreamingManager: no media tracks available");
        }

        return new MediaStream(tracks);
    }

    private async startRecording(): Promise<void> {
        if (!this.outputStream || this.isRecording) {
            return;
        }

        const [mimeType, extension] = this.getSupportedMimeType();
        this.recordingStore = new RecordingStore(mimeType, extension);
        this.recorder = new MediaRecorder(this.outputStream, { mimeType });

        this.recorder.ondataavailable = (event) => {
            if (event.data.size > 0) {
                this.recordingStore?.addChunk(event.data);
            }
        };

        this.recorder.onstop = async () => {
            if (!this.recordingStore) {
                return;
            }
            await this.recordingStore.finalize();
            const output = this.recordingStore.getOutput();
            await this.notifyDotNet(
                "StreamingFinished",
                DotNet.createJSStreamReference(output),
                this.recordingStore.extension
            );
        };

        this.recorder.start(this.saveIntervalMs);
        this.isRecording = true;
    }

    private async stopRecording(): Promise<void> {
        if (!this.recorder || !this.isRecording) {
            return;
        }

        this.recorder.stop();
        this.isRecording = false;
    }

    private getSupportedMimeType(): [string, string] {
        const options: Array<[string, string]> = [
            ["video/webm;codecs=vp9,opus", "webm"],
            ["video/webm;codecs=vp8,opus", "webm"],
            ["video/webm", "webm"],
            ["video/mp4", "mp4"],
        ];

        for (const entry of options) {
            if (MediaRecorder.isTypeSupported(entry[0])) {
                return entry;
            }
        }

        return ["video/webm", "webm"];
    }

    private async createPeerConnection(viewerConnectionId: string): Promise<RTCPeerConnection> {
        const iceServers = await IceServerProvider.getServers();
        const peer = new RTCPeerConnection({
            iceServers,
            iceTransportPolicy: "relay",
            bundlePolicy: "max-bundle",
            rtcpMuxPolicy: "require",
        });

        if (this.outputStream) {
            for (const track of this.outputStream.getTracks()) {
                peer.addTrack(track, this.outputStream);
            }
        }

        peer.onicecandidate = (event) => {
            if (event.candidate) {
                void this.signaling.sendIceCandidate(viewerConnectionId, event.candidate);
            }
        };

        peer.oniceconnectionstatechange = () => {
            if (peer.iceConnectionState === "failed") {
                peer.restartIce();
            }
            if (peer.iceConnectionState === "disconnected" || peer.iceConnectionState === "closed") {
                this.peerConnections.delete(viewerConnectionId);
            }
        };

        peer.onconnectionstatechange = () => {
            if (peer.connectionState === "failed" || peer.connectionState === "closed") {
                peer.close();
                this.peerConnections.delete(viewerConnectionId);
            }
        };

        this.peerConnections.set(viewerConnectionId, peer);
        return peer;
    }

    private startPreviewLoop(): void {
        const tick = () => {
            this.renderFrame();
            this.animationHandle = requestAnimationFrame(tick);
        };
        this.animationHandle = requestAnimationFrame(tick);
    }

    private stopPreviewLoop(): void {
        if (this.animationHandle !== null) {
            cancelAnimationFrame(this.animationHandle);
            this.animationHandle = null;
        }
    }

    private renderFrame(): void {
        const { width, height } = this.camera.getDimensions();
        if (this.camera.isActive()) {
            this.canvasContext.drawImage(this.camera.getElement(), 0, 0, width, height);
            return;
        }

        this.canvasContext.fillStyle = "#000";
        this.canvasContext.fillRect(0, 0, width, height);
        this.canvasContext.fillStyle = "#fff";
        this.canvasContext.font = "18px Calibri";
        this.canvasContext.textAlign = "center";
        this.canvasContext.fillText("Camera preview unavailable", width / 2, height / 2);
    }

    private async reportError(message: string): Promise<void> {
        console.error(`LiveStreamingManager: ${message}`);
        await this.notifyDotNet("StreamError", message);
    }

    private async notifyDotNet(method: string, ...args: any[]): Promise<void> {
        try {
            await this.dotnetCaller.invokeMethodAsync(method, ...args);
        } catch (error) {
            console.warn(`LiveStreamingManager: failed to invoke ${method}`, error);
        }
    }
}

export class StreamViewer {
    private readonly signaling: SignalClient;
    private peerConnection: RTCPeerConnection | null = null;
    private hostConnectionId: string | null = null;
    private pendingIceCandidates: Array<{ streamId: string; fromConnectionId: string; candidate: string }> = [];
    private isConnected = false;

    constructor(
        private readonly videoElement: HTMLVideoElement,
        private readonly streamId: string,
        private readonly dotnetCaller: DotNetObject
    ) {
        this.signaling = new SignalClient(dotnetCaller);
        this.videoElement.autoplay = true;
        this.videoElement.muted = true;
        this.videoElement.playsInline = true;
        this.videoElement.setAttribute("playsinline", "");
    }

    async connect(): Promise<void> {
        try {
            await this.signaling.connect();
            await this.preparePeerConnection();
            await this.signaling.joinStream(this.streamId);
        } catch (error) {
            console.error("StreamViewer: failed to connect", error);
            await this.notifyDotNet("StreamError", (error as Error).message ?? "Connection failed");
            throw error;
        }
    }

    async handleStreamJoined(streamId: string, hostConnectionId: string): Promise<void> {
        if (streamId !== this.streamId) {
            return;
        }

        this.hostConnectionId = hostConnectionId;

        if (this.pendingIceCandidates.length > 0) {
            const queued = [...this.pendingIceCandidates];
            this.pendingIceCandidates = [];
            for (const candidate of queued) {
                await this.handleIceCandidate(candidate.streamId, candidate.fromConnectionId, candidate.candidate);
            }
        }
    }

    async handleOffer(streamId: string, fromConnectionId: string, offer: string): Promise<void> {
        if (streamId !== this.streamId) {
            return;
        }

        const peer = this.peerConnection;
        if (!peer) {
            await this.notifyDotNet("StreamError", "Peer connection is not ready");
            return;
        }

        try {
            await peer.setRemoteDescription(JSON.parse(offer));
            const answer = await peer.createAnswer();
            await peer.setLocalDescription(answer);
            await this.signaling.sendAnswer(fromConnectionId, answer);
        } catch (error) {
            console.error("StreamViewer: failed to handle offer", error);
            await this.notifyDotNet("StreamError", "Unable to negotiate stream");
        }
    }

    async handleAnswer(streamId: string, fromConnectionId: string, answer: string): Promise<void> {
        if (streamId !== this.streamId || !this.peerConnection) {
            return;
        }

        try {
            await this.peerConnection.setRemoteDescription(JSON.parse(answer));
        } catch (error) {
            console.warn("StreamViewer: failed to apply answer", error);
        }
    }

    async handleIceCandidate(streamId: string, fromConnectionId: string, candidate: string): Promise<void> {
        if (streamId !== this.streamId) {
            return;
        }

        const peer = this.peerConnection;
        if (!peer) {
            return;
        }

        if (!peer.remoteDescription) {
            this.pendingIceCandidates.push({ streamId, fromConnectionId, candidate });
            return;
        }

        try {
            await peer.addIceCandidate(JSON.parse(candidate));
        } catch (error) {
            console.warn("StreamViewer: failed to add ICE candidate", error);
        }
    }

    async dispose(): Promise<void> {
        if (this.peerConnection) {
            this.peerConnection.close();
            this.peerConnection = null;
        }

        await this.signaling.leaveStream();
        await this.signaling.disconnect();
        this.pendingIceCandidates = [];
        this.isConnected = false;
    }

    private async preparePeerConnection(): Promise<void> {
        const iceServers = await IceServerProvider.getServers();
        this.peerConnection = new RTCPeerConnection({
            iceServers,
            iceTransportPolicy: "relay",
            bundlePolicy: "max-bundle",
            rtcpMuxPolicy: "require",
        });

        this.peerConnection.ontrack = (event) => {
            const stream = event.streams[0];
            if (!stream) {
                return;
            }

            this.videoElement.srcObject = stream;
            this.videoElement.style.display = "block";
            const playPromise = this.videoElement.play();
            if (playPromise) {
                playPromise
                    .then(() => this.notifyDotNet("StreamConnected"))
                    .catch(async (error) => {
                        console.warn("StreamViewer: autoplay blocked", error);
                        await this.notifyDotNet("StreamAutoplayBlocked");
                    });
            }
            this.isConnected = true;
        };

        this.peerConnection.onicecandidate = (event) => {
            if (event.candidate && this.hostConnectionId) {
                void this.signaling.sendIceCandidate(this.hostConnectionId, event.candidate);
            }
        };

        this.peerConnection.oniceconnectionstatechange = () => {
            if (!this.peerConnection) {
                return;
            }

            if (this.peerConnection.iceConnectionState === "failed") {
                this.peerConnection.restartIce();
            } else if (this.peerConnection.iceConnectionState === "disconnected") {
                console.warn("StreamViewer: ICE connection disconnected");
            }
        };

        this.peerConnection.onconnectionstatechange = () => {
            if (!this.peerConnection) {
                return;
            }

            if (this.peerConnection.connectionState === "failed") {
                this.notifyDotNet("StreamError", "Connection lost");
                this.isConnected = false;
            }
        };
    }

    private async notifyDotNet(method: string, ...args: any[]): Promise<void> {
        try {
            await this.dotnetCaller.invokeMethodAsync(method, ...args);
        } catch (error) {
            console.warn(`StreamViewer: failed to notify ${method}`, error);
        }
    }
}

export async function initializeLiveStreamingManager(
    videoPreviewParentId?: string,
    dotNetCaller?: DotNetObject
): Promise<LiveStreamingManager> {
    if (window.liveStreamingManager) {
        return window.liveStreamingManager;
    }

    if (!dotNetCaller) {
        throw new Error("DotNet caller reference is required");
    }

    const manager = new LiveStreamingManager(dotNetCaller);
    await manager.initialize();
    if (videoPreviewParentId) {
        manager.appendPreviews(videoPreviewParentId);
    }
    window.liveStreamingManager = manager;
    return manager;
}

export async function initializeStreamViewer(
    videoElementId: string,
    streamId: string,
    dotNetCaller: DotNetObject
): Promise<StreamViewer> {
    const element = document.getElementById(videoElementId);
    if (!element) {
        throw new Error(`Video element '${videoElementId}' not found`);
    }

    const viewer = new StreamViewer(element as HTMLVideoElement, streamId, dotNetCaller);
    await viewer.connect();
    return viewer;
}

window.initializeLiveStreamingManager = initializeLiveStreamingManager;
window.initializeStreamViewer = initializeStreamViewer;

export async function resumeStreamPlayback(videoElementId: string, unmute: boolean = false): Promise<boolean> {
    const element = document.getElementById(videoElementId) as HTMLVideoElement | null;
    if (!element) {
        return false;
    }

    if (unmute) {
        element.muted = false;
    }

    try {
        await element.play();
        return true;
    } catch (error) {
        console.warn("resumeStreamPlayback: playback blocked", error);
        return false;
    }
}

window.resumeStreamPlayback = resumeStreamPlayback;
