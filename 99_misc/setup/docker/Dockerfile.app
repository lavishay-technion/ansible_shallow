FROM python:3.9
COPY example_app /home/app
RUN pip3 install -r /home/app/requirements.txt
CMD [ "python3", "/home/app/app.py"]
