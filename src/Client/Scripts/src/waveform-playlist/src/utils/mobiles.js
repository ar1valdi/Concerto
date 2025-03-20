export function getXOffsetOnTouchEvent(e) {
  try {
    const bcr = e.target.getBoundingClientRect();
    return e.targetTouches[0].clientX - bcr.x;
  } catch (e) {
    return NaN;
  }
}
