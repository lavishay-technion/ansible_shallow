FROM python:3.9
EXPOSE 8000
EXPOSE 5000
COPY id_rsa.pub  /root/.ssh/authorized_keys
COPY example_app /home/app
RUN pip3 install -r /home/app/requirements.txt
CMD [ "python3", "/home/app/app.py"]
