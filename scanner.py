from buzzheavier import BuzzHeavier

dir_id = "klx2uowss2at"

class PDFScanner:
    def __init__(self, bzid):
        self.bzid = bzid
        self.buzzheavier = BuzzHeavier(bzid)
    
    def scan_pdfs(self, pdf_dir="."):
        pdf_dict = self.buzzheavier.find_file_by_suffix(dir_id, ".pdf")
        md_dict = self.buzzheavier.find_file_by_suffix(dir_id, ".md")
        # remove the .pdf files that have the same name as the .md files
        for md_file in md_dict.keys():
            pdf_file = md_file.replace(".md", ".pdf")
            if pdf_file in pdf_dict:
                print(f"Removing {pdf_file} because {md_file} exists.")
                del pdf_dict[pdf_file]
        # download the remaining .pdf files
        paths = []
        for pdf_file, pdf_url in pdf_dict.items():
            save_path = f"{pdf_dir}/{pdf_file}"
            self.buzzheavier.download_file(pdf_url, save_path)
            paths.append(save_path)
        # return the list of downloaded pdf files
        return paths

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("bzid", help="BuzzHeavier API token")
    args = parser.parse_args()
    scanner = PDFScanner(args.bzid)
    downloaded_pdfs = scanner.scan_pdfs()
    print(f"Downloaded PDFs: {downloaded_pdfs}，测试完成")