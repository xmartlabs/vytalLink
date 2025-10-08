// Common Download Modal
// This script dynamically creates and manages the download modal across all pages

// Create and inject the download modal HTML
function createDownloadModal() {
    const modalHTML = `
        <div id="downloadModal" class="download-modal">
            <div class="modal-overlay" onclick="closeDownloadModal()"></div>
            <div class="modal-content">
                <button class="modal-close" onclick="closeDownloadModal()">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M18 6L6 18M6 6L18 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
                <div class="modal-header">
                    <h2>Download vytalLink</h2>
                    <p>Get the app to start tracking your health data and unlock AI-powered insights</p>
                </div>
                <div class="modal-body">
                    <div class="download-options">
                        <a href="https://apps.apple.com/app/id_id6752308627" target="_blank" class="download-card ios" onclick="closeDownloadModal()">
                            <div class="card-icon">
                                <svg width="20" height="24" viewBox="0 0 20 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M16.7045 12.7631C16.7166 11.8432 16.9669 10.9413 17.4321 10.1412C17.8972 9.34108 18.5621 8.66885 19.3648 8.18702C18.8548 7.47597 18.1821 6.89081 17.4 6.478C16.6178 6.0652 15.7479 5.83613 14.8592 5.80898C12.9635 5.61471 11.1258 6.91644 10.1598 6.91644C9.17506 6.91644 7.68776 5.82827 6.08616 5.86044C5.05021 5.89311 4.04059 6.18722 3.15568 6.7141C2.27077 7.24099 1.54075 7.98268 1.03674 8.86691C-1.14648 12.5573 0.482005 17.9809 2.57338 20.964C3.61975 22.4247 4.84264 24.0564 6.44279 23.9985C8.00863 23.9351 8.59344 23.0237 10.4835 23.0237C12.3561 23.0237 12.9048 23.9985 14.5374 23.9617C16.2176 23.9351 17.2762 22.4945 18.2859 21.02C19.0377 19.9792 19.6162 18.8288 20 17.6116C19.0238 17.2085 18.1908 16.5338 17.6048 15.6716C17.0187 14.8094 16.7056 13.7979 16.7045 12.7631Z" fill="white"/>
                                    <path d="M13.6208 3.84713C14.5369 2.77343 14.9883 1.39335 14.879 0C13.4794 0.143519 12.1865 0.796596 11.258 1.82911C10.804 2.33351 10.4563 2.92033 10.2348 3.55601C10.0132 4.19168 9.92221 4.86375 9.96687 5.5338C10.6669 5.54084 11.3595 5.3927 11.9924 5.10054C12.6254 4.80838 13.1821 4.37982 13.6208 3.84713Z" fill="white"/>
                                </svg>
                            </div>
                            <div class="card-content">
                                <h3>iOS App</h3>
                                <p>Download from App Store</p>
                            </div>
                            <div class="card-arrow">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M7 17L17 7M17 7H7M17 7V17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </div>
                        </a>
                        <a href="https://play.google.com/store/apps/details?id=com.xmartlabs.vytallink" target="_blank" class="download-card android" onclick="closeDownloadModal()">
                            <div class="card-icon" style="display: flex; align-items: center; justify-content: center; padding-left: 3px;">
                                <svg width="21" height="24" viewBox="0 0 21 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M9.80482 11.4617L0.0895996 22.0059C0.0905121 22.0078 0.090512 22.0106 0.0914244 22.0125C0.389807 23.1574 1.41179 24 2.62539 24C3.11083 24 3.56616 23.8656 3.95671 23.6305L3.98773 23.6118L14.9229 17.1593L9.80482 11.4617Z" fill="#EA4335"/>
                                    <path d="M19.6331 9.66619L19.624 9.65966L14.9028 6.86123L9.58392 11.7013L14.9219 17.1582L19.6176 14.3878C20.4406 13.9324 21 13.045 21 12.0223C21 11.0052 20.4489 10.1225 19.6331 9.66619Z" fill="#FBBC04"/>
                                    <path d="M0.0894234 1.99332C0.0310244 2.21353 0 2.44495 0 2.68383V21.3164C0 21.5552 0.0310245 21.7866 0.0903359 22.0059L10.1386 11.7314L0.0894234 1.99332Z" fill="#4285F4"/>
                                    <path d="M9.87657 11.9999L14.9044 6.85936L3.98192 0.383511C3.58499 0.139966 3.12145 -9.53674e-07 2.62597 -9.53674e-07C1.41237 -9.53674e-07 0.388562 0.844472 0.0901797 1.99034C0.0901797 1.99127 0.0892677 1.99221 0.0892677 1.99314L9.87657 11.9999Z" fill="#34A853"/>
                                </svg>
                            </div>
                            <div class="card-content">
                                <h3>Android App</h3>
                                <p>Download from Google Play</p>
                            </div>
                            <div class="card-arrow">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M7 17L17 7M17 7H7M17 7V17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Insert the modal at the end of the body
    document.body.insertAdjacentHTML('beforeend', modalHTML);
}

// Modal functionality
function openDownloadModal() {
    const modal = document.getElementById('downloadModal');
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden'; // Prevent background scrolling
    }
}

function closeDownloadModal(event) {
    const modal = document.getElementById('downloadModal');
    if (modal && (!event || event.target.classList.contains('modal-overlay') || event.target.classList.contains('modal-close') || event.target.classList.contains('fas'))) {
        modal.classList.remove('active');
        document.body.style.overflow = 'auto'; // Restore scrolling
    }
}

// Keyboard event listener for ESC key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeDownloadModal();
    }
});

// Auto-initialize the modal when the script loads
document.addEventListener('DOMContentLoaded', function() {
    createDownloadModal();
});

// Also initialize if DOM is already loaded
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', createDownloadModal);
} else {
    createDownloadModal();
}
