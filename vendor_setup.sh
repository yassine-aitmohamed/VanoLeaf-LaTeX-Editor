#!/usr/bin/env bash
# ============================================================
#  VanoLeaf -- one-time download of the front-end libraries
#  (CodeMirror + PDF.js). Run this ONCE, with internet access.
#  After that, VanoLeaf never needs an internet connection again
#  (LaTeX compilation was already 100% local).
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

CM_BASE="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16"
PDF_BASE="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/6.1.200"

echo "== VanoLeaf: downloading libraries (one-time) =="

mkdir -p vendor/codemirror/mode/stex
mkdir -p vendor/codemirror/addon/hint
mkdir -p vendor/codemirror/addon/edit
mkdir -p vendor/codemirror/addon/comment
mkdir -p vendor/codemirror/addon/fold
mkdir -p vendor/codemirror/addon/selection
mkdir -p vendor/codemirror/theme
mkdir -p vendor/pdfjs

fetch() {
  local url="$1" dest="$2"
  echo "  - $dest"
  curl -fsSL "$url" -o "$dest"
}

fetch "$CM_BASE/codemirror.min.js"                 vendor/codemirror/codemirror.min.js
fetch "$CM_BASE/codemirror.min.css"                vendor/codemirror/codemirror.min.css
fetch "$CM_BASE/mode/stex/stex.min.js"              vendor/codemirror/mode/stex/stex.min.js
fetch "$CM_BASE/addon/hint/show-hint.min.js"        vendor/codemirror/addon/hint/show-hint.min.js
fetch "$CM_BASE/addon/hint/show-hint.min.css"       vendor/codemirror/addon/hint/show-hint.min.css
fetch "$CM_BASE/addon/edit/closebrackets.min.js"     vendor/codemirror/addon/edit/closebrackets.min.js
fetch "$CM_BASE/addon/edit/matchbrackets.min.js"     vendor/codemirror/addon/edit/matchbrackets.min.js
fetch "$CM_BASE/addon/comment/comment.min.js"        vendor/codemirror/addon/comment/comment.min.js
fetch "$CM_BASE/addon/fold/foldcode.min.js"          vendor/codemirror/addon/fold/foldcode.min.js
fetch "$CM_BASE/addon/fold/foldgutter.min.js"        vendor/codemirror/addon/fold/foldgutter.min.js
fetch "$CM_BASE/addon/fold/brace-fold.min.js"        vendor/codemirror/addon/fold/brace-fold.min.js
fetch "$CM_BASE/addon/fold/foldgutter.min.css"       vendor/codemirror/addon/fold/foldgutter.min.css
fetch "$CM_BASE/addon/selection/active-line.min.js"  vendor/codemirror/addon/selection/active-line.min.js
fetch "$CM_BASE/theme/material-darker.min.css"      vendor/codemirror/theme/material-darker.min.css
fetch "$PDF_BASE/pdf.min.mjs"                       vendor/pdfjs/pdf.min.mjs
fetch "$PDF_BASE/pdf.worker.min.mjs"                vendor/pdfjs/pdf.worker.min.mjs

echo ""
echo "Done. VanoLeaf can now run without an internet connection."
