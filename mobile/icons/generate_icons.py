# Script to generate app icons using Font Awesome fa-heartbeat
# Save this file as icons/generate_icons.py

from PIL import Image, ImageDraw, ImageFont
import os
import shutil


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ICONS_DIR = BASE_DIR


# Configuration
ICON_COLOR = "#6366f1"  # vytalLink primary color (from landing)
ICON_SIZE = 1024  # Base size for icons
ICON_PATHS = [
    {
      "filename": "ic_launcher.png",
      "size": ICON_SIZE,
      "white_bg": False,
      "color": ICON_COLOR,
    },
    {
      "filename": "ic_launcher_ios.png",
      "size": 1024,
      "white_bg": True,
      "color": ICON_COLOR,
    },
    {
      "filename": "ic_launcher_foreground.png",
      "size": 432,
      "white_bg": False,
      "color": ICON_COLOR,
    },
    {
      "filename": "splash_logo.png",
      "size": 2048,
      "white_bg": True,
      "color": ICON_COLOR,
    },
    {
      "filename": "splash_logo_android_12.png",
      "size": 1024,
      "white_bg": True,
      "color": ICON_COLOR,
    },
    {
      "filename": "ic_notification.png",
      "size": 256,
      "white_bg": False,
      "color": "#FFFFFFFF",
      "scale": 0.82,
      "copy_to": os.path.join(
        BASE_DIR,
        "..",
        "android",
        "app",
        "src",
        "main",
        "res",
        "drawable",
        "ic_notification.png",
      ),
    },
]
FONT_AWESOME_PATH = os.path.join(BASE_DIR, "fonts", "fa-solid-900.ttf")
ICON_UNICODE = "\uf21e"  # Unicode for fa-heartbeat

# Create icons folder if it doesn't exist
os.makedirs(ICONS_DIR, exist_ok=True)


def draw_icon(filename, size, white_bg, color, scale=None):
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
        if scale is not None:
            font_scale = scale
        elif "ios" in filename:
            font_scale = 0.65
        elif "foreground" in filename:
            font_scale = 0.45
        elif is_splash:
            font_scale = 0.55
        else:
            font_scale = 0.45
        font = ImageFont.truetype(FONT_AWESOME_PATH, int(render_size * font_scale))
    except Exception as e:
        print(f"Could not load font: {e}")
        return
    bbox = draw.textbbox((0, 0), ICON_UNICODE, font=font)
    w = bbox[2] - bbox[0]
    h = bbox[3] - bbox[1]
    x = (render_size - w) / 2
    y = (render_size - h) / 2 - bbox[1]
    if scale is None and not white_bg and not is_splash:
        y += int(render_size * 0.02)
    draw.text((x, y), ICON_UNICODE, font=font, fill=color)
    # Downscale splash icons for antialiasing
    if is_splash:
        img = img.resize((size, size), Image.LANCZOS)
    output_path = os.path.join(ICONS_DIR, filename)
    img.save(output_path)
    print(f"Icon generated: {output_path}")
    return output_path

if __name__ == "__main__":
    for config in ICON_PATHS:
        output_path = draw_icon(
            config["filename"],
            config["size"],
            config.get("white_bg", False),
            config.get("color", ICON_COLOR),
            config.get("scale"),
        )
        copy_target = config.get("copy_to")
        if output_path and copy_target:
            os.makedirs(os.path.dirname(copy_target), exist_ok=True)
            shutil.copy2(output_path, copy_target)
            print(f"Copied {output_path} -> {copy_target}")
    print("All icons have been generated.")
