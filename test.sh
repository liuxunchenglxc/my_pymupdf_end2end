alias pip="uv pip"
# alias python="uv python"

git clone https://github.com/pymupdf/PyMuPDF.git && (pytest --tb=no --no-header --no-summary -q PyMuPDF/tests || true) ; rm -rf PyMuPDF