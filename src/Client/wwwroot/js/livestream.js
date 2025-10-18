// Live Streaming functionality using WebRTC
// This creates a real-time streaming solution where others can join

class LiveStreamingManager {
    constructor(dotnetCaller) {
        this.dotnetCaller = dotnetCaller;
        
        // Media components
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
        this.canvasContext = this.canvas.getContext("2d");
        this.canvasStream = this.canvas.captureStream(30);
        
        // Audio context
        this.audioContext = new AudioContext();
        this.microphoneInput = null;
        this.audioOutput = this.audioContext.createMediaStreamDestination();
        
        // Streaming state
        this.isStreaming = false;
        this.streamId = null;
        this.outputStream = null;
        
        // WebRTC components
        this.peerConnection = null;
        this.dataChannel = null;
        this.viewers = new Set();
        
        // Signaling server simulation (in real app, this would be a WebSocket server)
        this.signalingServer = null;
        
        this.saveInterval = 500;
        
        // Bind methods
        this.drawCanvasFrame = this.drawCanvasFrame.bind(this);
        this.drawCanvasFrame();
    }
    
    canStream() {
        return this.microphone.isActive(); // Only require microphone, webcam is optional
    }
    
    appendPreviews(parentId) {
        let videoPreviewParent = document.getElementById(parentId);
        if (videoPreviewParent) {
            videoPreviewParent.appendChild(this.videoPreview);
        }
    }
    
    removePreview() {
        this.videoPreview?.remove();
    }
    
    async setWebcam(deviceId) {
        await this.webcam.start(deviceId);
        if (!this.webcam.isActive()) return;
        
        this.canvas.width = this.webcam.getWidth();
        this.canvas.height = this.webcam.getHeight();
    }
    
    async setMicrophone(deviceId) {
        if (this.microphoneInput) {
            this.microphoneInput.disconnect();
            this.microphoneInput = null;
        }
        
        await this.microphone.start(deviceId);
        if (!this.microphone.isActive()) return;
        
        this.microphoneInput = this.audioContext.createMediaStreamSource(this.microphone.getStream());
        this.microphoneInput.connect(this.audioOutput);
    }
    
    async startStream(streamId) {
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
        
        // Initialize WebRTC for streaming
        await this.initializeWebRTC();
        
        this.isStreaming = true;
        await this.dotnetCaller.invokeMethodAsync("StreamingStateChanged", true);
        
        console.log(`Live stream started with ID: ${streamId}`);
    }
    
    async stopStream() {
        if (this.peerConnection) {
            this.peerConnection.close();
            this.peerConnection = null;
        }
        
        if (this.dataChannel) {
            this.dataChannel.close();
            this.dataChannel = null;
        }
        
        this.viewers.clear();
        this.isStreaming = false;
        this.streamId = null;
        
        await this.dotnetCaller.invokeMethodAsync("StreamingStateChanged", false);
        console.log("Live stream stopped");
    }
    
    async initializeWebRTC() {
        // In a real implementation, this would connect to a signaling server
        // For now, we'll simulate the streaming setup
        console.log("WebRTC initialized for streaming");
        
        // Simulate peer connection setup
        this.peerConnection = new RTCPeerConnection({
            iceServers: [{ urls: 'stun:stun.l.google.com:19302' }]
        });
        
        // Add tracks to peer connection
        this.outputStream.getTracks().forEach(track => {
            this.peerConnection.addTrack(track, this.outputStream);
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
    getStreamUrl() {
        if (!this.streamId) return null;
        return `${window.location.origin}/viewstream/${this.streamId}`;
    }
    
    // Method to get current viewer count
    getViewerCount() {
        return this.viewers.size;
    }
    
    async dispose() {
        await this.stopStream();
        this.webcam.stop();
        this.microphone.stop();
        this.removePreview();
    }
    
    // Canvas drawing for video preview
    drawCanvasFrame() {
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
    constructor() {
        this.active = false;
        this.deviceId = null;
        this.width = null;
        this.height = null;
        this.preview = document.createElement("video");
        this.preview.muted = true;
        this.preview.autoplay = true;
        this.stream = null;
    }
    
    isActive() { return this.active; }
    getPreview() { return this.preview; }
    getStream() { return this.stream; }
    getWidth() { return this.width; }
    getHeight() { return this.height; }
    
    async start(deviceId) {
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
        this.width = settings.width;
        this.height = settings.height;
        
        this.preview.srcObject = this.stream;
        this.preview.play();
        this.active = true;
    }
    
    stop() {
        this.stream?.getTracks().forEach((track) => track.stop());
        this.preview.remove();
        this.deviceId = null;
        this.width = this.height = null;
        this.active = false;
    }
}

// Microphone class (reused from recorder)
class Microphone {
    constructor() {
        this.active = false;
        this.deviceId = null;
        this.stream = null;
    }
    
    isActive() { return this.active; }
    getStream() { return this.stream; }
    
    async start(deviceId) {
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
    
    stop() {
        this.stream?.getTracks().forEach((track) => track.stop());
        this.deviceId = null;
        this.active = false;
    }
}

// Global functions for DotNet interop
window.initializeLiveStreamingManager = async function(videoPreviewParentId, dotNetCaller) {
    if (window.liveStreamingManager !== undefined && window.liveStreamingManager !== null) {
        throw new Error("LiveStreamingManager already initialized");
    }
    
    let streamingManager = new LiveStreamingManager(dotNetCaller);
    if (videoPreviewParentId) {
        streamingManager.appendPreviews(videoPreviewParentId);
    }
    window.liveStreamingManager = streamingManager;
    return streamingManager;
};

// Stream Viewer functionality
class StreamViewer {
    constructor(videoElement, streamId, dotnetCaller) {
        this.videoElement = videoElement;
        this.streamId = streamId;
        this.dotnetCaller = dotnetCaller;
        this.peerConnection = null;
        this.isConnected = false;
    }
    
    async connect() {
        try {
            // In a real implementation, this would connect to a signaling server
            // and establish a WebRTC connection with the streamer
            console.log(`Attempting to connect to stream: ${this.streamId}`);
            
            // Simulate connection process
            await this.initializeWebRTC();
            
            // For demo purposes, we'll simulate a successful connection
            setTimeout(() => {
                this.isConnected = true;
                this.dotnetCaller.invokeMethodAsync("StreamConnected");
            }, 2000);
            
        } catch (error) {
            console.error('Failed to connect to stream:', error);
            this.dotnetCaller.invokeMethodAsync("StreamError", error.message);
        }
    }
    
    async initializeWebRTC() {
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
    
    async dispose() {
        if (this.peerConnection) {
            this.peerConnection.close();
            this.peerConnection = null;
        }
        this.isConnected = false;
    }
}

// Global functions for DotNet interop
window.initializeStreamViewer = async function(videoElementId, streamId, dotNetCaller) {
    const videoElement = document.getElementById(videoElementId);
    if (!videoElement) {
        throw new Error(`Video element with id '${videoElementId}' not found`);
    }
    
    const viewer = new StreamViewer(videoElement, streamId, dotNetCaller);
    await viewer.connect();
    
    return viewer;
};

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { LiveStreamingManager, StreamViewer, Webcam, Microphone };
}
