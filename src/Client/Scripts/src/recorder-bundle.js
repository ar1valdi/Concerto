import { initializeRecordingManager, RecordingManager, getVideoInputs, getAudioInputs} from './recorder/recorder.ts';
import { disablePreventWindowClose, enablePreventWindowClose} from './utilities/preventWindowClose.ts';
import { isMobile } from 'is-mobile';

const window = global.window;

// utilities
window.disablePreventWindowClose = disablePreventWindowClose;
window.enablePreventWindowClose = enablePreventWindowClose;
window.isMobile = isMobile;
window.getVideoInputs = getVideoInputs;
window.getAudioInputs = getAudioInputs;

// video recorder
window.initializeRecordingManager = initializeRecordingManager;
window.RecordingManager = RecordingManager;
