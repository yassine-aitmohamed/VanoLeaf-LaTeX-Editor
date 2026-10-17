#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "== VanoLeaf =="

if ! command -v python3 &> /dev/null; then
  echo "python3 not found. Install it with: brew install python3"
  exit 1
fi

if [ ! -d "venv" ]; then
  echo "Creating the Python virtual environment (one-time)..."
  python3 -m venv venv
fi

source venv/bin/activate
pip install --quiet --upgrade pip
pip install --quiet -r requirements.txt

if ! command -v pdflatex &> /dev/null; then
  echo ""
  echo "WARNING: pdflatex not found. VanoLeaf will start, but compilation"
  echo "won't work until MacTeX or BasicTeX is installed."
  echo "See README.md for instructions."
  echo ""
fi

if [ ! -f "vendor/codemirror/codemirror.min.js" ] || [ ! -f "vendor/codemirror/addon/edit/closebrackets.min.js" ] || [ ! -f "vendor/pdfjs/pdf.min.mjs" ]; then
  echo ""
  echo "First run: downloading the editor's front-end libraries"
  echo "(CodeMirror + PDF.js), one time only, requires internet..."
  chmod +x vendor_setup.sh
  ./vendor_setup.sh
  echo "From now on, VanoLeaf no longer needs an internet connection."
  echo ""
fi

python3 app.py
