// PWA Diagnostics and troubleshooting utilities for livestreaming

export interface PWADiagnostics {
    isPWA: boolean;
    isSecureContext: boolean;
    hasMediaDevices: boolean;
    hasGetUserMedia: boolean;
    hasWebRTC: boolean;
    hasWebSockets: boolean;
    displayMode: string;
    permissions: {
        camera?: PermissionState;
        microphone?: PermissionState;
    };
    errors: string[];
}

export async function checkPWACapabilities(): Promise<PWADiagnostics> {
    const diagnostics: PWADiagnostics = {
        isPWA: false,
        isSecureContext: window.isSecureContext,
        hasMediaDevices: 'mediaDevices' in navigator,
        hasGetUserMedia: 'mediaDevices' in navigator && 'getUserMedia' in navigator.mediaDevices,
        hasWebRTC: 'RTCPeerConnection' in window,
        hasWebSockets: 'WebSocket' in window,
        displayMode: 'browser',
        permissions: {},
        errors: []
    };

    // Check if running as PWA
    if (window.matchMedia('(display-mode: standalone)').matches) {
        diagnostics.isPWA = true;
        diagnostics.displayMode = 'standalone';
    } else if ((window.navigator as any).standalone === true) {
        diagnostics.isPWA = true;
        diagnostics.displayMode = 'standalone-ios';
    } else if (document.referrer.includes('android-app://')) {
        diagnostics.isPWA = true;
        diagnostics.displayMode = 'twa';
    } else if (window.matchMedia('(display-mode: fullscreen)').matches) {
        diagnostics.displayMode = 'fullscreen';
    } else if (window.matchMedia('(display-mode: minimal-ui)').matches) {
        diagnostics.displayMode = 'minimal-ui';
    }

    // Check permissions API
    if ('permissions' in navigator) {
        try {
            const cameraPermission = await navigator.permissions.query({ name: 'camera' as PermissionName });
            diagnostics.permissions.camera = cameraPermission.state;
        } catch (error) {
            console.warn('PWA Diagnostics: Cannot query camera permission', error);
        }

        try {
            const micPermission = await navigator.permissions.query({ name: 'microphone' as PermissionName });
            diagnostics.permissions.microphone = micPermission.state;
        } catch (error) {
            console.warn('PWA Diagnostics: Cannot query microphone permission', error);
        }
    }

    // Collect errors
    if (!diagnostics.isSecureContext) {
        diagnostics.errors.push('Not in secure context (HTTPS required for media access)');
    }

    if (!diagnostics.hasGetUserMedia) {
        diagnostics.errors.push('getUserMedia API not available');
    }

    if (!diagnostics.hasWebRTC) {
        diagnostics.errors.push('WebRTC not supported');
    }

    if (!diagnostics.hasWebSockets) {
        diagnostics.errors.push('WebSockets not supported');
    }

    if (diagnostics.permissions.camera === 'denied') {
        diagnostics.errors.push('Camera permission denied');
    }

    if (diagnostics.permissions.microphone === 'denied') {
        diagnostics.errors.push('Microphone permission denied');
    }

    return diagnostics;
}

export function logPWADiagnostics(diagnostics: PWADiagnostics): void {
    console.group('📱 PWA Livestream Diagnostics');
    console.log('Running as PWA:', diagnostics.isPWA);
    console.log('Display Mode:', diagnostics.displayMode);
    console.log('Secure Context:', diagnostics.isSecureContext);
    console.log('Media Devices API:', diagnostics.hasMediaDevices);
    console.log('getUserMedia:', diagnostics.hasGetUserMedia);
    console.log('WebRTC:', diagnostics.hasWebRTC);
    console.log('WebSockets:', diagnostics.hasWebSockets);
    console.log('Camera Permission:', diagnostics.permissions.camera || 'Unknown');
    console.log('Microphone Permission:', diagnostics.permissions.microphone || 'Unknown');
    
    if (diagnostics.errors.length > 0) {
        console.group('⚠️ Issues Detected:');
        diagnostics.errors.forEach(error => console.error(error));
        console.groupEnd();
    }
    
    console.groupEnd();
}

export async function requestMediaPermissions(): Promise<boolean> {
    try {
        // Request camera permission
        const videoStream = await navigator.mediaDevices.getUserMedia({ video: true });
        videoStream.getTracks().forEach(track => track.stop());

        // Request microphone permission
        const audioStream = await navigator.mediaDevices.getUserMedia({ audio: true });
        audioStream.getTracks().forEach(track => track.stop());

        console.log('✅ Media permissions granted');
        return true;
    } catch (error) {
        console.error('❌ Media permissions denied:', error);
        return false;
    }
}

export function getPWAInstallPrompt(): void {
    let deferredPrompt: any;

    window.addEventListener('beforeinstallprompt', (e) => {
        e.preventDefault();
        deferredPrompt = e;
        console.log('PWA install prompt available');
    });

    window.addEventListener('appinstalled', () => {
        console.log('PWA installed successfully');
        deferredPrompt = null;
    });
}

// Auto-run diagnostics when loaded
if (typeof window !== 'undefined') {
    checkPWACapabilities().then(logPWADiagnostics);
}
