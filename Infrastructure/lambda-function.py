import json
import boto3
import os
from fpdf import FPDF
import tempfile

s3 = boto3.client('s3')
BUCKET_NAME = os.environ['BUCKET_NAME']


def lambda_handler(event, context):
    order_id = event.get('order_id', 'unknown')

    # generate PDF
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=12)
    pdf.cell(200, 10, txt=f"Invoice for your order: {order_id}", ln=True)
    pdf.cell(200, 10, txt="Thank you for your purchase!", ln=True)

    # temporary file
    with tempfile.NamedTemporaryFile(suffix=".pdf") as tmp:
        pdf.output(tmp.name)
        tmp.seek(0)
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=f"invoice_{order_id}.pdf",
            Body=tmp.read(),
            ContentType="application/pdf"
        )

    return {
        'statusCode': 200,
        'body': json.dumps(f"PDF-invoice invoice_{order_id}.pdf has been saved in {BUCKET_NAME}.")
    }

# zip Datei muss erstellt werden (lokal), muss ins Readme
# folgende Befehle im projektverzeichnis ausführen (dort, wo auch lambda-function.py liegt)
'''pip install fpdf -t ./package             # FPDF in Ordner "package" installieren
cp lambda_function.py ./package           # Deine Lambda-Funktion dazu kopieren
cd package
zip -r ../lambda_function_payload.zip .   # Alles zippen
cd ..  '''
