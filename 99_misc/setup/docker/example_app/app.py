import random
import time
from flask import Flask

DEBUG=True
HOST='0.0.0.0'
PORT=80

error_codes= [200, 302, 404, 403, 500]

app = Flask(__name__)

@app.route('/')
@app.route('/alive')
def index():
    time.sleep(2)
    error_code = random.choice(error_codes)
    return f'''
<html>
    <head>
        <title>Home Page - Py app test</title>
    </head>
    <body>
        <h1>{error_code} '''


app.run(debug=DEBUG, port=PORT, host=HOST)

