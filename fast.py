from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask import Flask, render_template, request, flash, redirect, url_for
import re
from flask_mail import Mail, Message
from itsdangerous import URLSafeTimedSerializer
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
import secrets

app = Flask(__name__)
app.secret_key = secrets.token_hex(16)
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USERNAME'] = 'fafo1612@gmail.com'
app.config['MAIL_PASSWORD'] = 'njryxxemnjekosiy'
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False
mail = Mail(app)


s = URLSafeTimedSerializer(app.secret_key)

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="app"
)



def execute_query(query, params=(), fetch=False):
    cursor = mydb.cursor(dictionary=True)
    cursor.execute(query, params)
    if fetch:
        result = cursor.fetchall()
        cursor.close()
        return result
    mydb.commit()
    cursor.close()

@app.route('/')
def home():
    return render_template('index.html') 


@app.route('/student_register', methods=['POST', 'GET'])
def student_register():
    if request.method == 'POST':
        
        form_data = {
            'roll_number': request.form.get('roll_number'),
            'name': request.form.get('name'),
            'email': request.form.get('email'),
            'mobile_number': request.form.get('mobile_number'),
            'session_value': request.form.get('Session'),
            'password': request.form.get('password'),
            'confirm_password': request.form.get('confirm_password'),
            'department': request.form.get('department')
        }

        # Validate mobile number for Bangladesh
        if not re.match(r'^01[3-9]\d{8}$', form_data['mobile_number']):
            flash("Invalid mobile number! It must be 11 digits and start with a valid operator code in Bangladesh.", "error")
            return render_template('student_register.html', **form_data)

        # Check if passwords match
        if form_data['password'] != form_data['confirm_password']:
            flash("Passwords do not match!", "error")
            return render_template('student_register.html', **form_data)

        # Check if email or roll number already exists in the database
        mycursor = mydb.cursor()

        # Check for duplicate email
        mycursor.execute("SELECT * FROM student_registration WHERE email = %s", (form_data['email'],))
        if mycursor.fetchone():
            flash("Email is already registered!", "error")
            return render_template('student_register.html', **form_data)

        # Check for duplicate roll number
        mycursor.execute("SELECT * FROM student_registration WHERE roll_number = %s", (form_data['roll_number'],))
        if mycursor.fetchone():
            flash("Roll Number is already registered!", "error")
            return render_template('student_register.html', **form_data)

        # Save data to the database
        hashed_password = generate_password_hash(form_data['password'])
        mycursor.execute("""
            INSERT INTO student_registration (roll_number, name, email, mobile_number, session, password, department)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (form_data['roll_number'], form_data['name'], form_data['email'], form_data['mobile_number'], 
              form_data['session_value'], hashed_password, form_data['department']))
        
        mydb.commit()
        mycursor.close()

        flash("Registration successful!", "success")
        return redirect(url_for('student_register'))

    return render_template('student_register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    msg = ''
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        user_type = None
        user = None

        
        tables = {
            'student': 'student_registration',
            'teacher': 'teacher_registration',
            'chairman': 'chairman_registration'
        }

        for role, table in tables.items():
            query = f"SELECT * FROM {table} WHERE email=%s"
            result = execute_query(query, (username,), fetch=True)
            if result and check_password_hash(result[0]['password'], password):
                user_type = role
                user = result[0]
                break

        if user_type:
            
            session['loggedin'] = True
            session['email'] = user['email']
            session['user_type'] = user_type
            return redirect(url_for(f"{user_type}_dashboard"))
        else:
            msg = 'Invalid email or password!'
    return render_template('login.html', msg=msg)


@app.route('/student_dashboard')
def student_dashboard():
    if 'loggedin' in session and session['user_type'] == 'student':
        email = session['email']
        
       
        profile = execute_query(
            "SELECT * FROM student_registration WHERE email=%s", (email,), fetch=True
        )[0]
        
        
        attendance = execute_query(
            "SELECT * FROM attendance WHERE roll_number=%s", (profile['roll_number'],), fetch=True
        )
        ct_marks = execute_query(
            "SELECT * FROM ct_marks WHERE roll_number=%s", (profile['roll_number'],), fetch=True
        )
        
        return render_template(
            'student_dashboard.html', profile=profile, attendance=attendance, ct_marks=ct_marks
        )
    flash("Unauthorized access! Please log in as a student.", "danger")
    return redirect(url_for('login'))

@app.route('/attendance')
def attendance_page():
    if 'loggedin' in session and session['user_type'] == 'student':
        email = session['email']
        profile = execute_query(
            "SELECT roll_number FROM student_registration WHERE email=%s", (email,), fetch=True
        )[0]
        roll_number = profile['roll_number']  
        
        courses = execute_query(
            "SELECT DISTINCT course_name FROM attendance WHERE roll_number=%s", (roll_number,), fetch=True
        )
        return render_template('attendance_courses.html', courses=courses)
    flash("Unauthorized access! Please log in as a student.", "danger")
    return redirect(url_for('login'))

@app.route('/ct_marks')
def ct_marks_page():
    if 'loggedin' in session and session['user_type'] == 'student':
        email = session['email']
        profile = execute_query(
            "SELECT roll_number FROM student_registration WHERE email=%s", (email,), fetch=True
        )[0]
        roll_number = profile['roll_number']  
        
        courses = execute_query(
            "SELECT DISTINCT course_name FROM ct_marks WHERE roll_number=%s", (roll_number,), fetch=True
        )
        return render_template('ct_marks_courses.html', courses=courses)
    flash("Unauthorized access! Please log in as a student.", "danger")
    return redirect(url_for('login'))


@app.route('/attendance/<course_name>')
def course_attendance(course_name):
    if 'loggedin' in session and session['user_type'] == 'student':
        email = session['email']
        profile = execute_query(
            "SELECT roll_number FROM student_registration WHERE email=%s", (email,), fetch=True
        )[0]
        roll_number = profile['roll_number'] 
        
        attendance = execute_query(
            "SELECT * FROM attendance WHERE roll_number=%s AND course_name=%s",
            (roll_number, course_name), fetch=True
        )
        return render_template('course_attendance.html', course_name=course_name, attendance=attendance)
    flash("Unauthorized access! Please log in as a student.", "danger")
    return redirect(url_for('login'))

@app.route('/ct_marks/<course_name>')
def course_ct_marks(course_name):
    if 'loggedin' in session and session['user_type'] == 'student':
        email = session['email']
        profile = execute_query(
            "SELECT roll_number FROM student_registration WHERE email=%s", (email,), fetch=True
        )[0]
        roll_number = profile['roll_number']  
        
        ct_marks = execute_query(
            "SELECT * FROM ct_marks WHERE roll_number=%s AND course_name=%s",
            (roll_number, course_name), fetch=True
        )
        return render_template('course_ct_marks.html', course_name=course_name, ct_marks=ct_marks)
    flash("Unauthorized access! Please log in as a student.", "danger")
    return redirect(url_for('login'))


@app.route('/teacher_dashboard')
def teacher_dashboard():
    if 'loggedin' in session and session['user_type'] == 'teacher':
        email = session['email']
        profile = execute_query(
            "SELECT * FROM teacher_registration WHERE email=%s", (email,), fetch=True
        )[0]
        return render_template('teacher_dashboard.html', profile=profile)
    flash("Unauthorized access! Please log in as a teacher.", "danger")
    return redirect(url_for('login'))

@app.route('/chairman_dashboard')
def chairman_dashboard():
    if 'loggedin' in session and session['user_type'] == 'chairman':
        email = session['email']
        profile = execute_query(
            "SELECT * FROM chairman_registration WHERE email=%s", (email,), fetch=True
        )[0]
        return render_template('chairman_dashboard.html', profile=profile)
    flash("Unauthorized access! Please log in as a chairman.", "danger")
    return redirect(url_for('login'))

@app.route('/register')
def register():
    return render_template('register.html')

@app.route('/teacher_register', methods=['POST', 'GET'])
def teacher_register():
    if request.method == 'POST':
        mycursor = mydb.cursor()

        result = request.form.to_dict()
        name = result['name']
        email = result['email']
        designation = result['designation']  
        mobile_number = result['mobile_number']
        password = generate_password_hash(result['password'])
        department = result['department']
        
        
        mycursor.execute("""
            INSERT INTO teacher_registration (name, email, designation, mobile_number, password, department)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (name, email, designation, mobile_number, password, department))

        mydb.commit()
        mycursor.close()

        return render_template('registration_successful.html')

    return render_template('teacher_register.html')


@app.route('/chairman_register', methods=['POST', 'GET'])
def chairman_register():
    if request.method == 'POST':
        mycursor = mydb.cursor()

        result = request.form.to_dict()
        name = result['name']
        email = result['email']
        mobile_number = result['mobile_number']
        password = generate_password_hash(result['password'])
        department = result['department']

        mycursor.execute("""
            INSERT INTO chairman_registration (name, email, mobile_number, password, department)
            VALUES (%s, %s, %s, %s, %s)
        """, (name, email, mobile_number, password, department))

        mydb.commit()
        mycursor.close()

        return render_template('registration_successful.html')

    return render_template('chairman_register.html')

@app.route('/forgot_password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form['email']
        mycursor = mydb.cursor()
        tables = ["student_registration", "teacher_registration", "chairman_registration"]
        email_found = False
        for table in tables:
            mycursor.execute(f"SELECT * FROM {table} WHERE email = %s", (email,))
            if mycursor.fetchone():
                email_found = True
                break

        if email_found:
           
            token = s.dumps(email, salt='password-reset-salt')
            
            
            link = url_for('reset_password', token=token, _external=True)
            msg = Message('Password Reset Request', sender=app.config['MAIL_USERNAME'], recipients=[email])
            msg.body = f"Please click the link to reset your password: {link}"
            mail.send(msg)
            
            flash("A password reset link has been sent to your email.", "info")
        else:
            flash("This email is not associated with any account.", "danger")
        
        mycursor.close()
        return redirect(url_for('login'))
    
    return render_template('forgot_password.html')  


@app.route('/reset_password/<token>', methods=['GET', 'POST'])
def reset_password(token):
    try:
      
        email = s.loads(token, salt='password-reset-salt', max_age=3600)  
    except:
        flash("The password reset link is invalid or has expired.", "warning")
        return redirect(url_for('forgot_password'))
    
    if request.method == 'POST':
        new_password = request.form['password']  
        hashed_password = generate_password_hash(new_password)
        mycursor = mydb.cursor()
        updated = False
        tables = ["student_registration", "teacher_registration", "chairman_registration"]

        for table in tables:
           
            mycursor.execute(f"UPDATE {table} SET password = %s WHERE email = %s", (hashed_password, email))
            if mycursor.rowcount > 0: 
                updated = True
                break

        mydb.commit() 
        mycursor.close()

        if updated:
            flash("Your password has been reset successfully. You can now log in.", "success")
            return redirect(url_for('login')) 
        else:
            flash("An error occurred. Please try again.", "danger")

    
    return render_template('reset_password.html', token=token)

@app.route('/staff_register')
def staff_register():
    return render_template('staff_register.html')

    



if __name__ == "__main__":
    app.run(debug=True)
