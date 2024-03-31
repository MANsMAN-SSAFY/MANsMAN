FROM python:3.9.16
COPY ./requirements.txt /requirements.txt
RUN python -m pip install -U pip && pip install --no-cache-dir --upgrade -r /requirements.txt

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]