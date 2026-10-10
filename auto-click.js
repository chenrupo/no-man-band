// Paste this entire file into the browser console, or copy the IIFE below.
// Clicks 20x/sec at the current mouse position. Call stopClicking() to stop.

(function () {
  if (window.__autoClicker) {
    console.log("Already running. Call stopClicking() first.");
    return;
  }

  let x = innerWidth / 2;
  let y = innerHeight / 2;

  const onMove = (e) => {
    x = e.clientX;
    y = e.clientY;
  };

  document.addEventListener("mousemove", onMove, true);

  const clickAt = () => {
    const el = document.elementFromPoint(x, y);
    if (!el) return;

    const opts = {
      bubbles: true,
      cancelable: true,
      clientX: x,
      clientY: y,
      view: window,
    };

    el.dispatchEvent(new MouseEvent("mousedown", opts));
    el.dispatchEvent(new MouseEvent("mouseup", opts));
    el.dispatchEvent(new MouseEvent("click", opts));
  };

  const intervalId = setInterval(clickAt, 50); // 20 clicks/sec

  window.stopClicking = () => {
    clearInterval(intervalId);
    document.removeEventListener("mousemove", onMove, true);
    delete window.stopClicking;
    delete window.__autoClicker;
    console.log("Auto-clicker stopped.");
  };

  window.__autoClicker = true;
  console.log("Auto-clicker running at 20 clicks/sec at mouse position.");
  console.log("Call stopClicking() to stop.");
})();
