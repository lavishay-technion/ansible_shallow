import os
from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import func

# try:
#     DB_USER=os.environ['DB_USER']
#     DB_HOST=os.environ['DB_HOST']
#     DB_PORT=os.environ['DB_PORT']
#     DB_PASSWD=os.environ['DB_PASSWD']
#     DB_NAME=os.environ['DB_NAME']
# except KeyError:
#     DB_USER='root'
#     DB_HOST='172.18.0.10'
#     DB_PORT=3306
#     DB_PASSWD='P@ssW0rd'
#     DB_NAME='users'

basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(__name__)
# app.config["SQLALCHEMY_DATABASE_URI"] = f"mysql://{DB_USER}:{DB_PASSWD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'database.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.app_context().push()

db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    firstname = db.Column(db.String(100), nullable=False)
    lastname = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(80), unique=True, nullable=False)
    age = db.Column(db.Integer)
    created_at = db.Column(db.DateTime(timezone=True),
                           server_default=func.now())
    bio = db.Column(db.Text)

    def __repr__(self):
        return f'<Student {self.firstname}>'

@app.route('/')
def index():
    users = User.query.all()
    return render_template('index.html', users=users)