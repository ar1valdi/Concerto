import { pixelsToSeconds } from "../../utils/conversions";
import { getXOffsetOnTouchEvent } from "../../utils/mobiles";
import PlaylistEvents from "../../PlaylistEvents";

export default class {
  constructor(track) {
    this.track = track;
    this.active = false;
  }

  setup(samplesPerPixel, sampleRate) {
    this.samplesPerPixel = samplesPerPixel;
    this.sampleRate = sampleRate;
  }

  emitSelection(x, complete = false) {
    const minX = Math.min(x, this.startX);
    const maxX = Math.max(x, this.startX);
    const startTime = pixelsToSeconds(
      minX,
      this.samplesPerPixel,
      this.sampleRate
    );
    const endTime = pixelsToSeconds(
      maxX,
      this.samplesPerPixel,
      this.sampleRate
    );

    this.track.ee.emit(PlaylistEvents.SELECT, startTime, endTime, this.track);
  }

  complete(x) {
    this.emitSelection(x);
    this.active = false;
  }

  mousedown(e) {
    e.preventDefault();
    //if(this.track.isLocked()) return;
    this.active = true;

    this.startX = e.offsetX;
    const startTime = pixelsToSeconds(
      this.startX,
      this.samplesPerPixel,
      this.sampleRate
    );

    this.track.ee.emit(PlaylistEvents.SELECT, startTime, startTime, this.track);
  }

  touchstart(e) {
    e.preventDefault();
    //if(this.track.isLocked()) return;
    const offsetX = getXOffsetOnTouchEvent(e);
    if (offsetX) {
      this.active = true;
      this.startX = offsetX;
      const startTime = pixelsToSeconds(
        this.startX,
        this.samplesPerPixel,
        this.sampleRate
      );

      this.track.ee.emit(PlaylistEvents.SELECT, startTime, startTime, this.track);
    }
  }

  mousemove(e) {
    if (this.active) {
      e.preventDefault();
      //if(this.track.isLocked()) return;
      this.emitSelection(e.offsetX);
    }
  }

  touchmove(e) {
    if (this.active) {
      e.preventDefault();
      //if(this.track.isLocked()) return;
      const offsetX = getXOffsetOnTouchEvent(e);
      if (offsetX) this.emitSelection(offsetX);
    }
  }

  mouseup(e) {
    if (this.active) {
      e.preventDefault();
      //if(this.track.isLocked()) return;
      this.complete(e.offsetX);
    }
  }

  mouseleave(e) {
    if (this.active) {
      e.preventDefault();
      //if(this.track.isLocked()) return;
      this.complete(e.offsetX);
    }
  }

  touchend(e) {
    if (this.active) {
      e.preventDefault();
      //if(this.track.isLocked()) return;
      const offsetX = getXOffsetOnTouchEvent(e);
      if (offsetX) this.complete(offsetX);
    }
  }

  static getClass() {
    return ".state-select";
  }

  static getEvents() {
    return [
      "mousedown",
      "mousemove",
      "mouseup",
      "mouseleave",
      "touchstart",
      "touchmove",
      "touchend",
    ];
  }
}
