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

  emitShift(x, complete = false) {
    const deltaX = x - this.prevX;
    const deltaTime = pixelsToSeconds(
      deltaX,
      this.samplesPerPixel,
      this.sampleRate
    );
    this.prevX = x;
    if(complete)
    {
      this.track.ee.emit(PlaylistEvents.COMPLETE_SHIFT, deltaTime, this.track);
    }
    else
    {
      this.track.ee.emit(PlaylistEvents.SHIFT, deltaTime, this.track);
    }
  }

  complete(x) {
    this.emitShift(x, true);
    this.active = false;

  }

  mousedown(e) {
    e.preventDefault();
    if(this.track.isLocked()) return;
    this.active = true;
    this.el = e.target;
    this.prevX = e.offsetX;
  }

  touchstart(e) {
    e.preventDefault();
    if(this.track.isLocked()) return;
    const offsetX = getXOffsetOnTouchEvent(e);
    if (offsetX) {
      this.active = true;
      this.el = e.target;
      this.prevX = offsetX;
    }
  }

  mousemove(e) {
    if (this.active) {
      e.preventDefault();
      if(this.track.isLocked()) return;
      this.emitShift(e.offsetX);
    }
  }

  touchmove(e) {
    if (this.active) {
      e.preventDefault();
      if(this.track.isLocked()) return;
      const offsetX = getXOffsetOnTouchEvent(e);
      if (offsetX) this.emitShift(offsetX);
    }
  }

  mouseup(e) {
    if (this.active) {
      e.preventDefault();
      if(this.track.isLocked()) return;
      this.complete(e.offsetX);
    }
  }

  mouseleave(e) {
    if (this.active) {
      e.preventDefault();
      if(this.track.isLocked()) return;
      this.complete(e.offsetX);
    }
  }

  touchend(e) {
    if (this.active) {
      e.preventDefault();
      if(this.track.isLocked()) return;
      const offsetX = getXOffsetOnTouchEvent(e);
      if (offsetX) this.complete(offsetX);
    }
  }

  static getClass() {
    return ".state-shift";
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
