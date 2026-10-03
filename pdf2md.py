from buzzheavier import BuzzHeavier
from scanner import PDFScanner
import argparse
import pymupdf4llm

dir_id = "klx2uowss2at"

def main(args):
    scanner = PDFScanner(args.bzid)
    import os
    os.makedirs("pdfs", exist_ok=True)
    downloaded_pdfs = scanner.scan_pdfs("pdfs")

    if not downloaded_pdfs:
        print("No new PDFs to convert. Exiting.")
        return

    md_files = []
    for pdf_file in downloaded_pdfs:
        print(f"Converting {pdf_file} to markdown...")
        md = pymupdf4llm.to_markdown(pdf_file)
        md_file = pdf_file.replace(".pdf", ".md")
        with open(md_file, "w", encoding="utf-8") as f:
            f.write(md)
        md_files.append(md_file)
        print(f"Saved markdown to {md_file}")

    # upload the markdown files back to BuzzHeavier
    buzzheavier = BuzzHeavier(args.bzid)
    for md_file in md_files:
        print(f"Uploading {md_file} to BuzzHeavier...")
        buzzheavier.upload_file(dir_id, md_file)
        print(f"Uploaded {md_file} to BuzzHeavier.")
        
    print("All done! Converted and uploaded {} files.".format(len(md_files)))

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("bzid", help="BuzzHeavier API token")
    args = parser.parse_args()
    main(args)