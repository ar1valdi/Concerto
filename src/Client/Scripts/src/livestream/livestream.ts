import fixWebmDuration from 'webm-duration-fix';
import * as signalR from '@microsoft/signalr';

declare const DotNet: typeof import("@microsoft/dotnet-js-interop").DotNet;

interface DotNetObject {
    invokeMethod<T>(methodIdentifier: string, ...args: any[]): T;
    invokeMethodAsync<T>(methodIdentifier: string, ...args: any[]): Promise<T>;
    dispose(): void;
}

declare global {
    interface Window {
        liveStreamingManager: LiveStreamingManager | null | undefined;
        initializeLiveStreamingManager: (videoPreviewParentId: string, dotNetCaller: DotNetObject) => Promise<LiveStreamingManager>;
        initializeStreamViewer: (videoElementId: string, streamId: string, dotNetCaller: DotNetObject) => Promise<StreamViewer>;
    }
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
                        console.log('Requesting access token for SignalR connection...');
                        const token = await this.dotnetCaller.invokeMethodAsync<string>("GetAccessToken");
                        console.log('Access token received:', token ? 'Token present' : 'No token');
                        return token || '';
                    } catch (error) {
                        console.error('Failed to get access token:', error);
                        return '';
                    }
                }
            })
            .withAutomaticReconnect()
            .build();

        this.setupEventHandlers();
        await this.connection.start();
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
            this.dotnetCaller.invokeMethodAsync("ReceiveOffer", streamId, fromConnectionId, offer);
        });

        this.connection.on("ReceiveAnswer", (streamId: string, fromConnectionId: string, answer: string) => {
            this.dotnetCaller.invokeMethodAsync("ReceiveAnswer", streamId, fromConnectionId, answer);
        });

        this.connection.on("ReceiveIceCandidate", (streamId: string, fromConnectionId: string, candidate: string) => {
            this.dotnetCaller.invokeMethodAsync("ReceiveIceCandidate", streamId, fromConnectionId, candidate);
        });
    }

    async startStream(streamId: string): Promise<void> {
        if (!this.connection) throw new Error("Not connected to signaling server");
        
        this.streamId = streamId;
        this.isHost = true;
        await this.connection.invoke("StartStream", streamId);
    }

    async stopStream(): Promise<void> {
        if (!this.connection || !this.streamId) return;
        
        await this.connection.invoke("StopStream", this.streamId);
        this.streamId = null;
        this.isHost = false;
    }

    async joinStream(streamId: string): Promise<void> {
        if (!this.connection) throw new Error("Not connected to signaling server");
        
        this.streamId = streamId;
        this.isHost = false;
        await this.connection.invoke("JoinStream", streamId);
    }

    async leaveStream(): Promise<void> {
        if (!this.connection || !this.streamId) return;
        
        await this.connection.invoke("LeaveStream", this.streamId);
        this.streamId = null;
        this.isHost = false;
    }

    async sendOffer(targetConnectionId: string, offer: RTCSessionDescriptionInit): Promise<void> {
        if (!this.connection || !this.streamId) return;
        await this.connection.invoke("SendOffer", this.streamId, targetConnectionId, JSON.stringify(offer));
    }

    async sendAnswer(targetConnectionId: string, answer: RTCSessionDescriptionInit): Promise<void> {
        if (!this.connection || !this.streamId) return;
        await this.connection.invoke("SendAnswer", this.streamId, targetConnectionId, JSON.stringify(answer));
    }

    async sendIceCandidate(targetConnectionId: string, candidate: RTCIceCandidateInit): Promise<void> {
        if (!this.connection || !this.streamId) return;
        await this.connection.invoke("SendIceCandidate", this.streamId, targetConnectionId, JSON.stringify(candidate));
    }

    async disconnect(): Promise<void> {
        if (this.connection) {
            await this.connection.stop();
            this.connection = null;
        }
    }
}

export class LiveStreamingManager {
    dotnetCaller: DotNetObject;
    
    webcam: Webcam;
    microphone: Microphone;
    
    videoPreview: HTMLVideoElement;
    
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
        
        this.videoPreview = document.createElement("video");
        this.videoPreview.controls = false;
        this.videoPreview.muted = true;
        this.videoPreview.autoplay = true;
        this.videoPreview.style.pointerEvents = "none";
        this.videoPreview.classList.add("preview");
        
        this.canvas = document.createElement("canvas");
        this.canvasContext = this.canvas.getContext("2d")!;
        this.canvasStream = this.canvas.captureStream(30);
        
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
            videoPreviewParent.appendChild(this.videoPreview);
        }
    }
    
    removePreview(): void {
        this.videoPreview?.remove();
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
        console.log('Starting stream with ID:', streamId);
        console.log('Microphone active:', this.microphone.isActive());
        console.log('Webcam active:', this.webcam.isActive());
        
        if (!this.canStream()) {
            console.error('Cannot start stream: No microphone selected');
            alert("Please select a microphone.");
            return;
        }
        
        this.streamId = streamId;
        this.audioContext.resume();
        
        const videoTracks = this.webcam.isActive() ? this.canvasStream.getVideoTracks() : [];
        const audioTracks = this.audioOutput.stream.getAudioTracks();
        this.outputStream = new MediaStream([...videoTracks, ...audioTracks]);
        
        this.videoPreview.srcObject = this.outputStream;
        
        await this.startRecording();
        await this.signalingClient.startStream(streamId);
        
        this.isStreaming = true;
        await this.dotnetCaller.invokeMethodAsync("StreamingStateChanged", true);
        
        console.log(`Live stream started with ID: ${streamId}`);
    }
    
    async stopStream(): Promise<void> {
        for (const [connectionId, peerConnection] of this.peerConnections) {
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
        if (!this.outputStream) return;
        
        const peerConnection = new RTCPeerConnection({
            iceServers: [
                { urls: 'stun:stun.l.google.com:19302' },
                { urls: 'stun:stun1.l.google.com:19302' },
                { urls: 'stun:stun2.l.google.com:19302' },
                { urls: 'stun:stun3.l.google.com:19302' },
                { urls: 'stun:stun4.l.google.com:19302' },
                { urls: 'stun:stun.voiparound.com' },
                { urls: 'stun:stun.voipbuster.com' },
                { urls: 'stun:stun.voipstunt.com' },
                { urls: 'stun:stun.counterpath.com' },
                { urls: 'stun:stun.1und1.de' },
                // Add TURN servers for better connectivity
                { 
                    urls: 'turn:openrelay.metered.ca:80',
                    username: 'openrelayproject',
                    credential: 'openrelayproject'
                },
                { 
                    urls: 'turn:openrelay.metered.ca:443',
                    username: 'openrelayproject',
                    credential: 'openrelayproject'
                }
            ]
        });
        
        this.outputStream.getTracks().forEach(track => {
            peerConnection.addTrack(track, this.outputStream!);
        });
        
        peerConnection.onicecandidate = (event) => {
            if (event.candidate) {
                console.log('Sending ICE candidate to viewer:', event.candidate);
                this.signalingClient.sendIceCandidate(viewerConnectionId, event.candidate);
            }
        };
        
        peerConnection.oniceconnectionstatechange = () => {
            console.log(`ICE connection state for viewer ${viewerConnectionId}:`, peerConnection.iceConnectionState);
            if (peerConnection.iceConnectionState === 'failed') {
                console.error(`ICE connection failed for viewer ${viewerConnectionId}`);
            }
        };
        
        peerConnection.onconnectionstatechange = () => {
            if (peerConnection.connectionState === 'connected') {
                console.log(`Connected to viewer ${viewerConnectionId}`);
            } else if (peerConnection.connectionState === 'disconnected' || 
                       peerConnection.connectionState === 'failed') {
                this.peerConnections.delete(viewerConnectionId);
                peerConnection.close();
            }
        };
        
        this.peerConnections.set(viewerConnectionId, peerConnection);
        
        const offer = await peerConnection.createOffer();
        await peerConnection.setLocalDescription(offer);
        await this.signalingClient.sendOffer(viewerConnectionId, offer);
    }
    
    async handleAnswer(viewerConnectionId: string, answer: string): Promise<void> {
        const peerConnection = this.peerConnections.get(viewerConnectionId);
        if (!peerConnection) return;
        
        await peerConnection.setRemoteDescription(JSON.parse(answer));
    }
    
    async handleIceCandidate(viewerConnectionId: string, candidate: string): Promise<void> {
        const peerConnection = this.peerConnections.get(viewerConnectionId);
        if (!peerConnection) return;
        
        await peerConnection.addIceCandidate(JSON.parse(candidate));
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
            
            await this.dotnetCaller.invokeMethodAsync("StreamingFinished", DotNet.createJSStreamReference(output), this.recordingStore!.extension);
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
            ['video/webm;codecs=vp9,opus', 'webm'],
            ['video/webm;codecs=vp8,opus', 'webm'],
            ['video/webm', 'webm'],
            ['video/mp4', 'mp4']
        ];
        
        for (const [mimeType, extension] of types) {
            if (MediaRecorder.isTypeSupported(mimeType)) {
                return [mimeType, extension];
            }
        }
        
        return ['video/webm', 'webm'];
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
            this.canvasContext.drawImage(this.webcam.getPreview(), 0, 0, this.canvas.width, this.canvas.height);
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
    private preview: HTMLVideoElement;
    private stream: MediaStream | null = null;
    
    constructor() {
        this.preview = document.createElement("video");
        this.preview.muted = true;
        this.preview.autoplay = true;
    }
    
    isActive(): boolean { return this.active; }
    getPreview(): HTMLVideoElement { return this.preview; }
    getStream(): MediaStream | null { return this.stream; }
    getWidth(): number | null { return this.width; }
    getHeight(): number | null { return this.height; }
    
    async start(deviceId: string): Promise<void> {
        if (deviceId === this.deviceId) return;
        if (this.active) this.stop();
        if (!deviceId || deviceId === "none") return;
        
        this.deviceId = deviceId;
        
        try {
            this.stream = await navigator.mediaDevices.getUserMedia({
                video: { deviceId: deviceId }
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
        
        this.preview.srcObject = this.stream;
        this.preview.play();
        this.active = true;
    }
    
    stop(): void {
        this.stream?.getTracks().forEach((track) => track.stop());
        this.preview.remove();
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
    
    isActive(): boolean { return this.active; }
    getStream(): MediaStream | null { return this.stream; }
    
    async start(deviceId: string): Promise<void> {
        if (deviceId === this.deviceId) return;
        if (this.active) this.stop();
        if (!deviceId || deviceId === "none") return;
        
        this.deviceId = deviceId;
        
        try {
            this.stream = await navigator.mediaDevices.getUserMedia({
                audio: { deviceId: deviceId }
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
        return filename.replace(/[^a-z0-9.-]/gi, '_');
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
    
    constructor(videoElement: HTMLVideoElement, streamId: string, dotnetCaller: DotNetObject) {
        this.videoElement = videoElement;
        this.streamId = streamId;
        this.dotnetCaller = dotnetCaller;
        this.signalingClient = new SignalingClient(dotnetCaller);
    }
    
    async connect(): Promise<void> {
        try {
            console.log(`Attempting to connect to stream: ${this.streamId}`);
            
            await this.signalingClient.connect();
            await this.signalingClient.joinStream(this.streamId);
            
        } catch (error) {
            console.error('Failed to connect to stream:', error);
            this.dotnetCaller.invokeMethodAsync("StreamError", (error as Error).message);
        }
    }
    
    async handleStreamJoined(streamId: string, hostConnectionId: string): Promise<void> {
        this.hostConnectionId = hostConnectionId;
        await this.initializeWebRTC();
    }
    
    async initializeWebRTC(): Promise<void> {
        this.peerConnection = new RTCPeerConnection({
            iceServers: [
                { urls: 'stun:stun.l.google.com:19302' },
                { urls: 'stun:stun1.l.google.com:19302' },
                { urls: 'stun:stun2.l.google.com:19302' },
                { urls: 'stun:stun3.l.google.com:19302' },
                { urls: 'stun:stun4.l.google.com:19302' },
                { urls: 'stun:stun.voiparound.com' },
                { urls: 'stun:stun.voipbuster.com' },
                { urls: 'stun:stun.voipstunt.com' },
                { urls: 'stun:stun.counterpath.com' },
                { urls: 'stun:stun.1und1.de' },
                { 
                    urls: 'turn:openrelay.metered.ca:80',
                    username: 'openrelayproject',
                    credential: 'openrelayproject'
                },
                { 
                    urls: 'turn:openrelay.metered.ca:443',
                    username: 'openrelayproject',
                    credential: 'openrelayproject'
                }
            ]
        });
        
        this.peerConnection.ontrack = (event) => {
            console.log('Received stream from broadcaster');
            this.videoElement.srcObject = event.streams[0];
            this.isConnected = true;
            this.dotnetCaller.invokeMethodAsync("StreamConnected");
        };
        
        this.peerConnection.onicecandidate = (event) => {
            if (event.candidate && this.hostConnectionId) {
                console.log('Sending ICE candidate:', event.candidate);
                this.signalingClient.sendIceCandidate(this.hostConnectionId, event.candidate);
            }
        };
        
        this.peerConnection.oniceconnectionstatechange = () => {
            console.log('ICE connection state:', this.peerConnection?.iceConnectionState);
            if (this.peerConnection?.iceConnectionState === 'failed') {
                console.error('ICE connection failed - WebRTC connection failed');
                this.dotnetCaller.invokeMethodAsync("StreamError", "WebRTC connection failed");
            }
        };
        
        this.peerConnection.onconnectionstatechange = () => {
            if (this.peerConnection!.connectionState === 'connected') {
                console.log('Connected to stream');
            } else if (this.peerConnection!.connectionState === 'disconnected' || 
                       this.peerConnection!.connectionState === 'failed') {
                this.isConnected = false;
                this.dotnetCaller.invokeMethodAsync("StreamError", "Connection lost");
            }
        };
        
        console.log('WebRTC initialized for viewing');
    }
    
    async handleOffer(streamId: string, fromConnectionId: string, offer: string): Promise<void> {
        if (!this.peerConnection) return;
        
        await this.peerConnection.setRemoteDescription(JSON.parse(offer));
        const answer = await this.peerConnection.createAnswer();
        await this.peerConnection.setLocalDescription(answer);
        await this.signalingClient.sendAnswer(fromConnectionId, answer);
    }
    
    async handleAnswer(streamId: string, fromConnectionId: string, answer: string): Promise<void> {
        if (!this.peerConnection) return;
        
        await this.peerConnection.setRemoteDescription(JSON.parse(answer));
    }
    
    async handleIceCandidate(streamId: string, fromConnectionId: string, candidate: string): Promise<void> {
        if (!this.peerConnection) return;
        
        await this.peerConnection.addIceCandidate(JSON.parse(candidate));
    }
    
    async dispose(): Promise<void> {
        if (this.peerConnection) {
            this.peerConnection.close();
            this.peerConnection = null;
        }
        
        await this.signalingClient.leaveStream();
        await this.signalingClient.disconnect();
        
        this.isConnected = false;
    }
}

export async function initializeLiveStreamingManager(videoPreviewParentId?: string, dotNetCaller?: DotNetObject): Promise<LiveStreamingManager> {
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

export async function initializeStreamViewer(videoElementId: string, streamId: string, dotNetCaller: DotNetObject): Promise<StreamViewer> {
    console.log(`Looking for video element with id: ${videoElementId}`);
    
    await new Promise(resolve => setTimeout(resolve, 100));
    
    const videoElement = document.getElementById(videoElementId);
    if (!videoElement) {
        console.error(`Video element with id '${videoElementId}' not found in DOM`);
        console.log('Available elements with video tag:', document.querySelectorAll('video'));
        throw new Error(`Video element with id '${videoElementId}' not found`);
    }
    
    console.log(`Found video element:`, videoElement);
    
    const viewer = new StreamViewer(videoElement as HTMLVideoElement, streamId, dotNetCaller);
    await viewer.connect();
    
    return viewer;
}

window.initializeLiveStreamingManager = initializeLiveStreamingManager;
window.initializeStreamViewer = initializeStreamViewer;