# Script to generate app icons using Font Awesome fa-heartbeat
# Save this file as icons/generate_icons.py

from PIL import Image, ImageDraw, ImageFont
import os


# Configuration
ICON_COLOR = "#6366f1"  # vytalLink primary color (from landing)
ICON_SIZE = 1024  # Base size for icons
ICON_PATHS = [
    ("ic_launcher.png", ICON_SIZE, False),
    ("ic_launcher_ios.png", 1024, True),  # iOS: white background
    ("ic_launcher_foreground.png", 432, False),
    # Splash icons (always generate at high resolution)
    ("splash_logo.png", 2048, True),  # Main splash icon, white background
    ("splash_logo_android_12.png", 1024, True),  # Android 12 splash icon, white background
]
FONT_AWESOME_PATH = "icons/fonts/fa-solid-900.ttf"  # Local path in project
ICON_UNICODE = "\uf21e"  # Unicode for fa-heartbeat

# Create icons folder if it doesn't exist
os.makedirs("icons", exist_ok=True)


def draw_icon(filename, size, white_bg):
    # For splash icons, render at high resolution (no upscaling needed)
    is_splash = filename.startswith("splash_logo")
    render_size = size
    if white_bg:
        img = Image.new("RGBA", (render_size, render_size), (255, 255, 255, 255))  # White background
    else:
        img = Image.new("RGBA", (render_size, render_size), (255, 255, 255, 0))    # Transparent background
    draw = ImageDraw.Draw(img)
    try:
        # Platform-specific sizes
        if "ios" in filename:
            font = ImageFont.truetype(FONT_AWESOME_PATH, int(render_size * 0.65))
        elif "foreground" in filename:
            font = ImageFont.truetype(FONT_AWESOME_PATH, int(render_size * 0.45))
        elif is_splash:
            font = ImageFont.truetype(FONT_AWESOME_PATH, int(render_size * 0.55))
        else:
            font = ImageFont.truetype(FONT_AWESOME_PATH, int(render_size * 0.45))
    except Exception as e:
        print(f"Could not load font: {e}")
        return
    bbox = draw.textbbox((0, 0), ICON_UNICODE, font=font)
    w = bbox[2] - bbox[0]
    h = bbox[3] - bbox[1]
    x = (render_size - w) / 2
    y = (render_size - h) / 2 - bbox[1]
    if not white_bg and not is_splash:
        y += int(render_size * 0.02)
    draw.text((x, y), ICON_UNICODE, font=font, fill=ICON_COLOR)
    # Downscale splash icons for antialiasing
    if is_splash:
        img = img.resize((size, size), Image.LANCZOS)
    img.save(f"icons/{filename}")
    print(f"Icon generated: icons/{filename}")

if __name__ == "__main__":
    for filename, size, white_bg in ICON_PATHS:
        draw_icon(filename, size, white_bg)
    print("All icons have been generated.")
