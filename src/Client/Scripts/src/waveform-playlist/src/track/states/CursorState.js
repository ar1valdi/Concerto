import { pixelsToSeconds } from "../../utils/conversions";
import PlaylistEvents from "../../PlaylistEvents";

export default class CursorState {
  constructor(track) {
    this.track = track;
  }

  setup(samplesPerPixel, sampleRate) {
    this.samplesPerPixel = samplesPerPixel;
    this.sampleRate = sampleRate;
  }

  click(e) {
    e.preventDefault();
    //if(this.track.isLocked())
    //  return;

    const startX = e.offsetX;
    const startTime = pixelsToSeconds(
      startX,
      this.samplesPerPixel,
      this.sampleRate
    );

    this.track.ee.emit(PlaylistEvents.SELECT, startTime, startTime, this.track);
  }

  static getClass() {
    return ".state-cursor";
  }

  static getEvents() {
    return ["click"];
  }
}
