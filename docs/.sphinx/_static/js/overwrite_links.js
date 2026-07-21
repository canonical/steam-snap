 // Replaces oldDomain with newDomain in relevant anchor tags
 const oldDomain = 'canonical-steam-snap.readthedocs-hosted.com';
 const newDomain = 'ubuntu.com/docs/steam';

function overwriteMatchingAnchorUrls(container) {
    if (!container) return;

    container.querySelectorAll("a[href], link[href]").forEach((anchor) => {
        anchor.href = anchor.href.replace(oldDomain, newDomain);
    });
}

function patchFlyout() {
    const rtdFlyout = document.querySelector("readthedocs-flyout");
    if (!rtdFlyout) return false;

    overwriteMatchingAnchorUrls(rtdFlyout);
    overwriteMatchingAnchorUrls(rtdFlyout.shadowRoot);

    rtdFlyout.addEventListener("click", () => {
        overwriteMatchingAnchorUrls(rtdFlyout);
        overwriteMatchingAnchorUrls(rtdFlyout.shadowRoot);
    });

    return true;
}

function init() {
    overwriteMatchingAnchorUrls(document.querySelector("header"));

    if (patchFlyout()) return;

    const observer = new MutationObserver(() => {
        if (patchFlyout()) {
            observer.disconnect();
        }
    });

    observer.observe(document.body, { childList: true, subtree: true });
}

if (document.body) {
    init();
} else {
    document.addEventListener("DOMContentLoaded", init);
}
