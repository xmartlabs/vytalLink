// Mobile menu toggle
document.addEventListener('DOMContentLoaded', function() {
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');
    
    if (hamburger && navMenu) {
        hamburger.addEventListener('click', function() {
            navMenu.classList.toggle('active');
            hamburger.classList.toggle('active');
            document.body.classList.toggle('menu-open', navMenu.classList.contains('active'));
        });
        
        // Close menu when clicking on a link
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', (e) => {
                if (e.currentTarget.classList.contains('nav-dropdown-toggle')) {
                    return; // don't close menu when toggling dropdown
                }
                navMenu.classList.remove('active');
                hamburger.classList.remove('active');
                document.body.classList.remove('menu-open');
            });
        });
        
        // Close menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!hamburger.contains(event.target) && !navMenu.contains(event.target)) {
                navMenu.classList.remove('active');
                hamburger.classList.remove('active');
                document.body.classList.remove('menu-open');
            }
        });
    }
});

// Navbar dropdown (Setup Guides)
document.addEventListener('DOMContentLoaded', function() {
    const dropdown = document.querySelector('.nav-dropdown');
    const toggle = document.querySelector('.nav-dropdown-toggle');
    if (dropdown && toggle) {
        toggle.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            dropdown.classList.toggle('open');
        });
        document.addEventListener('click', function() {
            dropdown.classList.remove('open');
        });
    }
});

// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        
        const href = this.getAttribute('href');
        const target = document.querySelector(href);
        if (target) {
            const navbar = document.querySelector('.navbar');
            const navbarHeight = navbar ? navbar.offsetHeight : 80;
            const subnav = document.querySelector('.subnav');
            const subnavHeight = subnav ? subnav.offsetHeight : 0;
            const targetPosition = target.offsetTop - navbarHeight - subnavHeight;
            
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// Highlight active section in navbar
function updateActiveNavLink() {
    const sections = document.querySelectorAll('section[id]');
    const navLinks = document.querySelectorAll('.nav-link[href^="#"]');
    const navbar = document.querySelector('.navbar');
    const navbarHeight = navbar ? navbar.offsetHeight : 80;
    const subnav = document.querySelector('.subnav');
    const subnavHeight = subnav ? subnav.offsetHeight : 0;
    
    let currentSection = '';
    
    sections.forEach(section => {
        const rect = section.getBoundingClientRect();
        // Adjust for navbar + subnav
        if (rect.top <= navbarHeight + subnavHeight + 10 && rect.bottom >= navbarHeight + subnavHeight + 10) {
            currentSection = section.getAttribute('id');
        }
    });
    
    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === `#${currentSection}`) {
            link.classList.add('active');
        }
    });
}

window.addEventListener('scroll', updateActiveNavLink);
window.addEventListener('load', updateActiveNavLink);

// Animate elements on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe all feature cards and step cards
document.querySelectorAll('.feature-card, .step-card').forEach(card => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(30px)';
    card.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
    observer.observe(card);
});

// Navbar background on scroll
window.addEventListener('scroll', function() {
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        navbar.style.background = 'rgba(255, 255, 255, 0.98)';
        navbar.style.boxShadow = '0 2px 20px rgba(0, 0, 0, 0.1)';
    } else {
        navbar.style.background = 'rgba(255, 255, 255, 0.95)';
        navbar.style.boxShadow = 'none';
    }
});

// Simulate real-time health data updates
function updateHealthMetrics() {
    const heartRate = document.querySelector('.metric-item:nth-child(1) .metric-value');
    const steps = document.querySelector('.metric-item:nth-child(2) .metric-value');
    const sleep = document.querySelector('.metric-item:nth-child(3) .metric-value');
    
    if (heartRate) {
        // Generate realistic health data variations
        const baseHeartRate = 72;
        const heartRateVariation = Math.floor(Math.random() * 10) - 5;
        heartRate.textContent = `${baseHeartRate + heartRateVariation} BPM`;
        
        const baseSteps = 8547;
        const stepsVariation = Math.floor(Math.random() * 200) - 100;
        steps.textContent = (baseSteps + stepsVariation).toLocaleString();
        
        const baseSleep = 7.5;
        const sleepVariation = (Math.random() * 1) - 0.5;
        sleep.textContent = `${(baseSleep + sleepVariation).toFixed(1)}h`;
    }
    
    // Update connection codes occasionally
    if (Math.random() < 0.1) { // 10% chance
        const codeValue = document.querySelector('.code-value');
        const codes = ['HEALTH7', 'VITAL12', 'SYNC89', 'DATA45', 'LINK33'];
        const passwords = ['sunset42', 'blue78', 'green23', 'red56', 'wave91'];
        
        if (codeValue) {
            const codeDisplays = document.querySelectorAll('.code-value');
            if (codeDisplays[0]) codeDisplays[0].textContent = codes[Math.floor(Math.random() * codes.length)];
            if (codeDisplays[1]) codeDisplays[1].textContent = passwords[Math.floor(Math.random() * passwords.length)];
        }
    }
}

// Update metrics every 3 seconds to simulate real-time data
setInterval(updateHealthMetrics, 3000);

// Button click handlers
document.addEventListener('DOMContentLoaded', function() {
    // Download app buttons
    const downloadBtns = document.querySelectorAll('.btn-primary');
    downloadBtns.forEach(btn => {
        if (btn.textContent.includes('Download') || btn.textContent.includes('Get it')) {
            btn.addEventListener('click', function(e) {
                if (!btn.href) {
                    e.preventDefault();
                    alert('App coming soon to App Store and Google Play!');
                }
            });
        }
    });
    
    // ChatGPT integration button
    const chatgptBtns = document.querySelectorAll('a[href*="chatgpt.com"]');
    chatgptBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            // In a real app, this would open ChatGPT GPTs
            console.log('Opening ChatGPT GPTs integration...');
        });
    });
    
    // API Documentation button
    const apiBtns = document.querySelectorAll('a[href="/api"]');
    apiBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            if (btn.getAttribute('href') === '/api') {
                e.preventDefault();
                window.open('/api', '_blank');
            }
        });
    });
    
    // MCP Setup button
    const mcpBtns = document.querySelectorAll('.btn-secondary');
    mcpBtns.forEach(btn => {
        if (btn.textContent.includes('Setup Guide')) {
            btn.addEventListener('click', function(e) {
                // Let the link work normally to /mcp-setup
                console.log('Opening MCP setup guide...');
            });
        }
    });
});

// Code syntax highlighting simulation
document.addEventListener('DOMContentLoaded', function() {
    const codeContent = document.querySelector('.code-content code');
    if (codeContent) {
        const codeText = codeContent.textContent;
        const highlightedCode = codeText
            .replace(/(const|await|fetch|headers|Authorization|Bearer|Content-Type|application\/json|console\.log)/g, '<span style="color: #9f7efe;">$1</span>')
            .replace(/('.*?'|".*?")/g, '<span style="color: #90cdf4;">$1</span>')
            .replace(/(\/\/.*)/g, '<span style="color: #68d391;">$1</span>')
            .replace(/(\{|\}|\[|\]|\(|\))/g, '<span style="color: #f6ad55;">$1</span>');
        
        codeContent.innerHTML = highlightedCode;
    }
});

// Add mobile menu styles (synced with CSS overlay)
(function() {
  const style = document.createElement('style');
  style.textContent = `
    @media (max-width: 768px) {
      .nav-menu {
        position: fixed;
        top: 70px;
        left: -100%;
        width: 100%;
        height: calc(100vh - 70px);
        background: rgba(255,255,255,0.98);
        backdrop-filter: blur(6px);
        display: flex;
        flex-direction: column;
        justify-content: flex-start;
        align-items: stretch;
        gap: 0;
        padding: 0 0 1.5rem;
        transition: left 0.3s ease;
        z-index: 1001;
        overflow-y: auto;
        -webkit-overflow-scrolling: touch;
      }
      .nav-menu.active { left: 0; }
      .nav-menu .nav-link { width: 100%; max-width: 100%; font-size: 1.1rem; padding: 1rem 1.25rem; text-align: left; border-bottom: 1px solid #e5e7eb; border-radius: 0; }
      .hamburger.active span:nth-child(1) { transform: rotate(45deg) translate(5px, 5px); }
      .hamburger.active span:nth-child(2) { opacity: 0; }
      .hamburger.active span:nth-child(3) { transform: rotate(-45deg) translate(7px, -6px); }
    }
  `;
  document.head.appendChild(style);
})();
