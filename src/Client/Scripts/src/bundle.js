import { initializeRecordingManager, RecordingManager, getVideoInputs, getAudioInputs} from './recorder/recorder.ts';
import { disablePreventWindowClose, enablePreventWindowClose} from './utilities/preventWindowClose.ts';
import { initializeDaw } from './daw/daw.ts';
import { isMobile } from 'is-mobile';
import { initializeLiveStreamingManager, initializeStreamViewer, LiveStreamingManager, StreamViewer } from './livestream/livestream.ts';
import * as signalR from '@microsoft/signalr';

const window = global.window;

// Utilities
window.disablePreventWindowClose = disablePreventWindowClose;
window.enablePreventWindowClose = enablePreventWindowClose;
window.isMobile = isMobile;
window.getVideoInputs = getVideoInputs;
window.getAudioInputs = getAudioInputs;
window.signalR = signalR;

// Video recorder
window.initializeRecordingManager = initializeRecordingManager;
window.RecordingManager = RecordingManager;

// Live Streaming
window.initializeLiveStreamingManager = initializeLiveStreamingManager;
window.initializeStreamViewer = initializeStreamViewer;
window.LiveStreamingManager = LiveStreamingManager;
window.StreamViewer = StreamViewer;

// DAW
window.initializeDaw = initializeDaw;
