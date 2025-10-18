// Live Streaming functionality using WebRTC
// This creates a real-time streaming solution where others can join

import fixWebmDuration from 'webm-duration-fix';

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
        signalingServer: SignalingServer;
    }
}

// Simple in-memory signaling server simulation
class SignalingServer {
    private streams: Map<string, LiveStreamingManager> = new Map();
    private viewers: Map<string, StreamViewer[]> = new Map();

    registerStream(streamId: string, manager: LiveStreamingManager): void {
        this.streams.set(streamId, manager);
        console.log(`Stream ${streamId} registered`);
    }

    unregisterStream(streamId: string): void {
        this.streams.delete(streamId);
        this.viewers.delete(streamId);
        console.log(`Stream ${streamId} unregistered`);
    }

    getStream(streamId: string): LiveStreamingManager | undefined {
        return this.streams.get(streamId);
    }

    getAllStreams(): Map<string, LiveStreamingManager> {
        return this.streams;
    }

    addViewer(streamId: string, viewer: StreamViewer): void {
        if (!this.viewers.has(streamId)) {
            this.viewers.set(streamId, []);
        }
        this.viewers.get(streamId)!.push(viewer);
        console.log(`Viewer added to stream ${streamId}`);
    }

    removeViewer(streamId: string, viewer: StreamViewer): void {
        const viewers = this.viewers.get(streamId);
        if (viewers) {
            const index = viewers.indexOf(viewer);
            if (index > -1) {
                viewers.splice(index, 1);
            }
        }
    }

    getViewers(streamId: string): StreamViewer[] {
        return this.viewers.get(streamId) || [];
    }
}

export class LiveStreamingManager {
    dotnetCaller: DotNetObject;
    
    // Media components
    webcam: Webcam;
    microphone: Microphone;
    
    // Video preview
    videoPreview: HTMLVideoElement;
    
    // Canvas for video processing
    canvas: HTMLCanvasElement;
    canvasContext: CanvasRenderingContext2D;
    canvasStream: MediaStream;
    
    // Audio context
    audioContext: AudioContext;
    microphoneInput: MediaStreamAudioSourceNode | null = null;
    audioOutput: MediaStreamAudioDestinationNode;
    
    // Streaming state
    isStreaming: boolean = false;
    streamId: string | null = null;
    outputStream: MediaStream | null = null;
    
    // Recording state
    isRecording: boolean = false;
    recorder: MediaRecorder | null = null;
    recordingStore: StreamRecordingStore | null = null;
    
    // WebRTC components
    peerConnection: RTCPeerConnection | null = null;
    dataChannel: RTCDataChannel | null = null;
    viewers: Set<MediaStream> = new Set();
    
    // Signaling server simulation (in real app, this would be a WebSocket server)
    signalingServer: any = null;
    
    saveInterval: number = 500;
    
    constructor(dotnetCaller: DotNetObject) {
        this.dotnetCaller = dotnetCaller;
        
        // Initialize media components
        this.webcam = new Webcam();
        this.microphone = new Microphone();
        
        // Video preview
        this.videoPreview = document.createElement("video");
        this.videoPreview.controls = false;
        this.videoPreview.muted = true;
        this.videoPreview.autoplay = true;
        this.videoPreview.style.pointerEvents = "none";
        this.videoPreview.classList.add("preview");
        
        // Canvas for video processing
        this.canvas = document.createElement("canvas");
        this.canvasContext = this.canvas.getContext("2d")!;
        this.canvasStream = this.canvas.captureStream(30);
        
        // Audio context
        this.audioContext = new AudioContext();
        this.audioOutput = this.audioContext.createMediaStreamDestination();
        
        // Bind methods
        this.drawCanvasFrame = this.drawCanvasFrame.bind(this);
        this.drawCanvasFrame();
    }
    
    canStream(): boolean {
        return this.microphone.isActive(); // Only require microphone, webcam is optional
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
        if (!this.canStream()) {
            alert("Please select a microphone.");
            return;
        }
        
        this.streamId = streamId;
        this.audioContext.resume();
        
        // Create output stream for streaming
        const videoTracks = this.webcam.isActive() ? this.canvasStream.getVideoTracks() : [];
        const audioTracks = this.audioOutput.stream.getAudioTracks();
        this.outputStream = new MediaStream([...videoTracks, ...audioTracks]);
        
        // Set up video preview
        this.videoPreview.srcObject = this.outputStream;
        
        // Start recording the stream
        await this.startRecording();
        
        // Initialize WebRTC for streaming
        await this.initializeWebRTC();
        
        this.isStreaming = true;
        
        // Register with signaling server
        if (window.signalingServer) {
            window.signalingServer.registerStream(streamId, this);
        }
        
        await this.dotnetCaller.invokeMethodAsync("StreamingStateChanged", true);
        
        console.log(`Live stream started with ID: ${streamId}`);
    }
    
    async stopStream(): Promise<void> {
        if (this.peerConnection) {
            this.peerConnection.close();
            this.peerConnection = null;
        }
        
        if (this.dataChannel) {
            this.dataChannel.close();
            this.dataChannel = null;
        }
        
        // Stop recording
        await this.stopRecording();
        
        this.viewers.clear();
        this.isStreaming = false;
        
        // Unregister from signaling server
        if (this.streamId && window.signalingServer) {
            window.signalingServer.unregisterStream(this.streamId);
        }
        
        this.streamId = null;
        
        await this.dotnetCaller.invokeMethodAsync("StreamingStateChanged", false);
        console.log("Live stream stopped");
    }
    
    async initializeWebRTC(): Promise<void> {
        // In a real implementation, this would connect to a signaling server
        // For now, we'll simulate the streaming setup
        console.log("WebRTC initialized for streaming");
        
        // Simulate peer connection setup
        this.peerConnection = new RTCPeerConnection({
            iceServers: [{ urls: 'stun:stun.l.google.com:19302' }]
        });
        
        // Add tracks to peer connection
        this.outputStream!.getTracks().forEach(track => {
            this.peerConnection!.addTrack(track, this.outputStream!);
        });
        
        // Set up data channel for stream metadata
        this.dataChannel = this.peerConnection.createDataChannel('streamData');
        this.dataChannel.onopen = () => {
            console.log('Data channel opened');
        };
        
        // Handle ICE candidates (in real app, these would be sent to signaling server)
        this.peerConnection.onicecandidate = (event) => {
            if (event.candidate) {
                console.log('ICE candidate generated:', event.candidate);
                // In real app: send to signaling server
            }
        };
        
        // Handle incoming connections (viewers joining)
        this.peerConnection.ontrack = (event) => {
            console.log('Viewer connected');
            this.viewers.add(event.streams[0]);
        };
    }
    
    // Method to generate stream sharing URL (for demonstration)
    getStreamUrl(): string | null {
        if (!this.streamId) return null;
        return `${window.location.origin}/viewstream/${this.streamId}`;
    }
    
    // Method to get current viewer count
    getViewerCount(): number {
        return this.viewers.size;
    }
    
    async startRecording(): Promise<void> {
        if (!this.outputStream || this.isRecording) return;
        
        // Get supported MIME type
        const [mimeType, extension] = this.getSupportedMimeType();
        
        // Initialize recording store
        this.recordingStore = new StreamRecordingStore(mimeType, extension);
        
        // Create MediaRecorder
        this.recorder = new MediaRecorder(this.outputStream, { mimeType });
        
        // Handle data available
        this.recorder.ondataavailable = (event) => {
            if (event.data.size > 0) {
                this.recordingStore!.addChunk(event.data);
            }
        };
        
        // Handle recording stop
        this.recorder.onstop = async () => {
            await this.recordingStore!.generateOutputAsync();
            const output = this.recordingStore!.getOutput();
            
            // Convert Blob to IJSStreamReference for Blazor
            await this.dotnetCaller.invokeMethodAsync("StreamingFinished", DotNet.createJSStreamReference(output), this.recordingStore!.extension);
        };
        
        // Start recording
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
        
        return ['video/webm', 'webm']; // fallback
    }
    
    
    async dispose(): Promise<void> {
        await this.stopStream();
        await this.finalizeStreaming();
        this.webcam.stop();
        this.microphone.stop();
        this.removePreview();
    }
    
    // Canvas drawing for video preview
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

// Webcam class (reused from recorder)
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

// Microphone class (reused from recorder)
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

// Stream Recording Store class (similar to RecordingStore)
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
        
        // Apply WebM duration fix if needed
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

// Stream Viewer functionality
export class StreamViewer {
    videoElement: HTMLVideoElement;
    streamId: string;
    dotnetCaller: DotNetObject;
    peerConnection: RTCPeerConnection | null = null;
    isConnected: boolean = false;
    
    constructor(videoElement: HTMLVideoElement, streamId: string, dotnetCaller: DotNetObject) {
        this.videoElement = videoElement;
        this.streamId = streamId;
        this.dotnetCaller = dotnetCaller;
    }
    
    async connect(): Promise<void> {
        try {
            console.log(`Attempting to connect to stream: ${this.streamId}`);
            console.log("Signaling server available:", !!window.signalingServer);
            
            // Check if stream exists in signaling server
            if (!window.signalingServer) {
                console.error("Signaling server not available, initializing...");
                window.signalingServer = new SignalingServer();
                console.log("Signaling server initialized in connect method");
            }
            
            console.log("All streams in signaling server:", Array.from(window.signalingServer.getAllStreams().keys()));
            
            const streamManager = window.signalingServer.getStream(this.streamId);
            if (!streamManager) {
                // Get list of available streams for better error message
                const availableStreams = Array.from(window.signalingServer.getAllStreams().keys());
                const availableStreamsText = availableStreams.length > 0 
                    ? ` Available streams: ${availableStreams.join(', ')}` 
                    : ' No streams are currently active.';
                
                throw new Error(`Stream ${this.streamId} not found. Make sure the host is streaming.${availableStreamsText}`);
            }
            
            // Register as viewer
            window.signalingServer.addViewer(this.streamId, this);
            
            // Initialize WebRTC connection
            await this.initializeWebRTC();
            
            // For demo purposes, we'll simulate a successful connection
            // In a real implementation, this would establish actual WebRTC connection
            setTimeout(() => {
                this.isConnected = true;
                this.dotnetCaller.invokeMethodAsync("StreamConnected");
            }, 2000);
            
        } catch (error) {
            console.error('Failed to connect to stream:', error);
            this.dotnetCaller.invokeMethodAsync("StreamError", (error as Error).message);
        }
    }
    
    async initializeWebRTC(): Promise<void> {
        // In a real implementation, this would:
        // 1. Connect to signaling server
        // 2. Send join request with stream ID
        // 3. Receive offer from streamer
        // 4. Create answer and send back
        // 5. Establish peer connection
        
        this.peerConnection = new RTCPeerConnection({
            iceServers: [{ urls: 'stun:stun.l.google.com:19302' }]
        });
        
        // Handle incoming stream
        this.peerConnection.ontrack = (event) => {
            console.log('Received stream from broadcaster');
            this.videoElement.srcObject = event.streams[0];
        };
        
        // Handle ICE candidates
        this.peerConnection.onicecandidate = (event) => {
            if (event.candidate) {
                console.log('ICE candidate received');
                // In real app: send to signaling server
            }
        };
        
        console.log('WebRTC initialized for viewing');
    }
    
    async dispose(): Promise<void> {
        if (this.peerConnection) {
            this.peerConnection.close();
            this.peerConnection = null;
        }
        
        // Unregister from signaling server
        if (window.signalingServer) {
            window.signalingServer.removeViewer(this.streamId, this);
        }
        
        this.isConnected = false;
    }
}

// Global functions for DotNet interop
export async function initializeLiveStreamingManager(videoPreviewParentId?: string, dotNetCaller?: DotNetObject): Promise<LiveStreamingManager> {
    if (window.liveStreamingManager !== undefined && window.liveStreamingManager !== null) {
        console.log("LiveStreamingManager already initialized, returning existing instance");
        return window.liveStreamingManager;
    }
    
    let streamingManager = new LiveStreamingManager(dotNetCaller!);
    if (videoPreviewParentId) {
        streamingManager.appendPreviews(videoPreviewParentId);
    }
    window.liveStreamingManager = streamingManager;
    return streamingManager;
}

export async function initializeStreamViewer(videoElementId: string, streamId: string, dotNetCaller: DotNetObject): Promise<StreamViewer> {
    console.log(`Looking for video element with id: ${videoElementId}`);
    
    // Wait a bit to ensure DOM is fully rendered
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

// Initialize signaling server
if (!window.signalingServer) {
    window.signalingServer = new SignalingServer();
    console.log("Signaling server initialized");
} else {
    console.log("Signaling server already exists");
}

// Make functions available globally
window.initializeLiveStreamingManager = initializeLiveStreamingManager;
window.initializeStreamViewer = initializeStreamViewer;
