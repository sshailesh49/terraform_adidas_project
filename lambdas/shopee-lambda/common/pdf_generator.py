from fpdf import FPDF
import io
def create_pdf_bytes(data: dict) -> bytes:
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=10)
    for k, v in data.items():
        pdf.cell(0, 6, txt=f"{k}: {v}", ln=True)
    out = io.BytesIO()
    pdf.output(out)
    return out.getvalue()
