#!/bin/bash

# =========================
# Configuration
# =========================
URL="https://labs.usegalaxy.org.au/?content_root=https://github.com/paulzierep/docker-galaxy-microbiology-lab/blob/main/lab/usegalaxy.local.yml&cache=false"
MIRROR_DIR="labs.usegalaxy.org.au"  # wget mirror folder

# =========================
# Step 1: Mirror the site
# =========================
echo "Mirroring site from $URL ..."
wget --mirror --convert-links --adjust-extension --page-requisites --no-parent "$URL"

# =========================
# Step 2: Rename main HTML file to welcome.html
# =========================
MAIN_HTML=$(find "$MIRROR_DIR" -type f -name "*.html" | head -n 1)

if [ -z "$MAIN_HTML" ]; then
    echo "No HTML files found in $MIRROR_DIR"
    exit 1
fi

echo "Renaming main HTML file: $MAIN_HTML -> welcome.html"
mv "$MAIN_HTML" "$MIRROR_DIR/welcome.html"

# =========================
# Step 3: Fix all broken encoded links in all HTML files
# =========================
echo "Fixing encoded links in all HTML files..."

# Replace any links containing "index.html%3Fcontent_root=..." with welcome.html
find "$MIRROR_DIR" -type f -name "*.html" -exec sed -i \
  -E 's|index\.html%3Fcontent_root=[^"]+\.html|welcome.html|g' {} +

echo "All done! All dropdown/menu links now point to welcome.html."

rm -r "lab_interface"
mv "$MIRROR_DIR" "lab_interface"