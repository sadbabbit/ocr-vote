FROM python:3.9-buster

RUN apt-get update && apt-get install libgl1 tesseract-ocr vim --yes

ENV HOME=/root
ENV PYTHONPATH=$PYTHONPATH:$HOME/ocr-vote
RUN mkdir -p $HOME/ocr-vote
WORKDIR $HOME/ocr-vote

COPY requirements.txt  .
RUN pip install -r requirements.txt

COPY table_ocr ./table_ocr
COPY batch.sh .
COPY Dockerfile .
COPY preprocess_image.py .
COPY run.sh  .
RUN chmod +x run.sh
RUN chmod +x batch.sh

#ENTRYPOINT ["/root/ocr-vote/run.sh"]
