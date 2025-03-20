import { pixelsToSeconds } from "../../utils/conversions";
import PlaylistEvents from "../../PlaylistEvents";

export default class {
  constructor(track) {
    this.track = track;
  }

  setup(samplesPerPixel, sampleRate) {
    this.samplesPerPixel = samplesPerPixel;
    this.sampleRate = sampleRate;
  }

  click(e) {
    if(this.track.isLocked()) return;

    const startX = e.offsetX;
    const time = pixelsToSeconds(startX, this.samplesPerPixel, this.sampleRate);

    if (time > this.track.getStartTime() && time < this.track.getEndTime()) {
      this.track.ee.emit(PlaylistEvents.FADE_OUT, this.track.getEndTime() - time, this.track);
    }
  }

  static getClass() {
    return ".state-fadeout";
  }

  static getEvents() {
    return ["click"];
  }
}
