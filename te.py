from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask import Flask, render_template, request, flash, redirect, url_for
import re 
import os 
from werkzeug.utils import secure_filename
from passlib.hash import sha256_crypt
from flask_mail import Mail, Message
from itsdangerous import URLSafeTimedSerializer
import mysql.connector
import secrets
import time 
from fast import execute_query

app = Flask(__name__)
app.secret_key = secrets.token_hex(16)
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USERNAME'] = 'fafo1612@gmail.com'
app.config['MAIL_PASSWORD'] = 'njryxxemnjekosiy'
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False
mail = Mail(app)




mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="app1"
)

s = URLSafeTimedSerializer(app.secret_key)

import mysql.connector


def execute_query(query, params=(), fetch=False):
    cursor = mydb.cursor(dictionary=True)
    cursor.execute(query, params)
    if fetch:
        result = cursor.fetchall()
        cursor.close()
        return result
    mydb.commit()
    cursor.close()







if __name__ == '__main__':
    app.run(debug=True)
