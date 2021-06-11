FROM python:alpine
COPY . .
WORKDIR /bookstore-api
RUN pip install -r requirements.txt
EXPOSE 80
CMD python ./bookstore-api.py