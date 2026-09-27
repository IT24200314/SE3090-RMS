import os
import sys
import win32com.client

def main():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    docx_path = os.path.join(base_dir, "SE3090_SEF_KDY_AI_04_Consolidated_Report.docx")
    pdf_path = os.path.join(base_dir, "SE3090_SEF_KDY_AI_04_Consolidated_Report.pdf")
    
    if not os.path.exists(docx_path):
        print(f"Error: DOCX file not found at {docx_path}")
        sys.exit(1)
        
    print(f"Converting:\n  Input: {docx_path}\n  Output: {pdf_path}")
    word = win32com.client.Dispatch("Word.Application")
    word.Visible = False
    try:
        doc = word.Documents.Open(docx_path)
        # 17 is wdFormatPDF
        doc.SaveAs(pdf_path, FileFormat=17)
        doc.Close()
        print("Conversion successful!")
    except Exception as e:
        print(f"Error during conversion: {e}")
        sys.exit(1)
    finally:
        word.Quit()

if __name__ == "__main__":
    main()
