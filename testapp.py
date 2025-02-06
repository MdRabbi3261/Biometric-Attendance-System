from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask import Flask, render_template, request, flash, redirect, url_for
import re
import os 
from werkzeug.utils import secure_filename
from passlib.hash import sha256_crypt
from flask_mail import Mail, Message
from itsdangerous import URLSafeTimedSerializer
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
import secrets

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

UPLOAD_FOLDER = 'static/uploads'  
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'} 
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

os.makedirs(UPLOAD_FOLDER, exist_ok=True)

s = URLSafeTimedSerializer(app.secret_key)
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


@app.route('/register')
def register():
    return render_template('register.html')


@app.route('/student_register', methods=['POST', 'GET'])
def student_register():
    if request.method == 'POST':
        roll_number = request.form.get('roll_number')
        name = request.form.get('name')
        email = request.form.get('email')
        mobile_number = request.form.get('mobile_number')
        session_value = request.form.get('Session')
        password = request.form.get('password')
        confirm_password = request.form.get('confirm_password')
        department = request.form.get('department')

        
        if not re.match(r'^01[3-9]\d{8}$', mobile_number):
            flash("Invalid mobile number! It must be 11 digits and start with a valid operator code in Bangladesh.", "error")
            return render_template('student_register.html', roll_number=roll_number, name=name, email=email, 
                                   mobile_number=mobile_number, session_value=session_value, department=department)

        if password != confirm_password:
            flash("Passwords do not match!", "error")
            return render_template('student_register.html', roll_number=roll_number, name=name, email=email, 
                                   mobile_number=mobile_number, session_value=session_value, department=department)

        mycursor = mydb.cursor()

      
        mycursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        if mycursor.fetchone():
            flash("Email is already registered!", "error")
            return render_template('student_register.html', roll_number=roll_number, name=name, email=email, 
                                   mobile_number=mobile_number, session_value=session_value, department=department)

       
        mycursor.execute("SELECT * FROM users WHERE roll_number = %s", (roll_number,))
        if mycursor.fetchone():
            flash("Roll Number is already registered!", "error")
            return render_template('student_register.html', roll_number=roll_number, name=name, email=email, 
                                   mobile_number=mobile_number, session_value=session_value, department=department)

      
        hashed_password = sha256_crypt.encrypt(password)

        mycursor.execute("""
            INSERT INTO users (roll_number, name, email, mobile_number, user_type, session, password, department)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (roll_number, name, email, mobile_number, 'student', session_value, hashed_password, department))
        
        mydb.commit()
        mycursor.close()

        flash("Registration successful!", "success")
        return redirect(url_for('login'))

    return render_template('student_register.html')

        
    
@app.route('/teacher_register', methods=['POST', 'GET'])
def teacher_register():
        
        
     if request.method == 'POST': 
        name = request.form.get('name')
        email = request.form.get('email')
        designation=request.form.get('designation')
        mobile_number = request.form.get('mobile_number')
        password = request.form.get('password')
        confirm_password = request.form.get('confirm_password')
        department = request.form.get('department')
       

        if not re.match(r'^01[3-9]\d{8}$', mobile_number):
            flash("Invalid mobile number! It must be 11 digits and start with a valid operator code in Bangladesh.", "error")
            return render_template('teacher_register.html', name=name, email=email,designation=designation,
                                   mobile_number=mobile_number, department=department)

        if password != confirm_password:
            flash("Passwords do not match!", "error")
            return render_template('teacher_register.html', name=name, email=email,designation=designation,
                                   mobile_number=mobile_number, department=department)

        mycursor = mydb.cursor()
       
        mycursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        if mycursor.fetchone():
            flash("Email is already registered!", "error")
            return render_template('teacher_register.html', name=name, email=email,designation=designation,
                                   mobile_number=mobile_number, department=department)


        hashed_password = sha256_crypt.encrypt(password)

       
         
        mycursor.execute("""
            INSERT INTO users ( name, email, mobile_number, user_type ,password, department, designation)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, ( name, email, mobile_number, 'teacher', hashed_password, department,designation))
        
        mydb.commit()
        mycursor.close()

        flash("Registration successful!", "success")
        return redirect(url_for('login'))

     return render_template('teacher_register.html')
    

@app.route('/chairman_register',methods=['POST', 'GET'])
def chairman_register():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        mobile_number = request.form.get('mobile_number')
        password = request.form.get('password')
        confirm_password = request.form.get('confirm_password')
        department = request.form.get('department')
       

       
        if not re.match(r'^01[3-9]\d{8}$', mobile_number):
            flash("Invalid mobile number! It must be 11 digits and start with a valid operator code in Bangladesh.", "error")
            return render_template('chairman_register.html', name=name, email=email,
                                   mobile_number=mobile_number, department=department)

        if password != confirm_password:
            flash("Passwords do not match!", "error")
            return render_template('chairman_register.html', name=name, email=email,
                                   mobile_number=mobile_number, department=department)

        mycursor = mydb.cursor()
       
        mycursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        if mycursor.fetchone():
            flash("Email is already registered!", "error")
            return render_template('chairman_register.html', name=name, email=email,
                                   mobile_number=mobile_number, department=department)


        hashed_password = sha256_crypt.encrypt(password)
       
       
         
        mycursor.execute("""
            INSERT INTO users ( name, email, mobile_number, user_type ,password, department,designation)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, ( name, email, mobile_number, 'chairman', hashed_password, department,'Chairman'))
        
        mydb.commit()
        mycursor.close()

        flash("Registration successful!", "success")
        return redirect(url_for('login'))
    return render_template('chairman_register.html')



@app.route('/staff_register',methods=['POST', 'GET'])
def staff_register():
    if request.method == 'POST': 
        name = request.form.get('name')
        email = request.form.get('email')
        designation=request.form.get('designation')
        mobile_number = request.form.get('mobile_number')
        password = request.form.get('password')
        confirm_password = request.form.get('confirm_password')
        department = request.form.get('department')
       

        if not re.match(r'^01[3-9]\d{8}$', mobile_number):
            flash("Invalid mobile number! It must be 11 digits and start with a valid operator code in Bangladesh.", "error")
            return render_template('teacher_register.html', name=name, email=email,designation=designation,
                                   mobile_number=mobile_number, department=department)

        if password != confirm_password:
            flash("Passwords do not match!", "error")
            return render_template('teacher_register.html', name=name, email=email,designation=designation,
                                   mobile_number=mobile_number, department=department)

        mycursor = mydb.cursor()
       
        mycursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        if mycursor.fetchone():
            flash("Email is already registered!", "error")
            return render_template('teacher_register.html', name=name, email=email,designation=designation,
                                   mobile_number=mobile_number, department=department)


        hashed_password = sha256_crypt.encrypt(password)

       
         
        mycursor.execute("""
            INSERT INTO users ( name, email, mobile_number, user_type, password, department, designation)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, ( name, email, mobile_number, 'staff', hashed_password, department,designation))
        
        mydb.commit()
        mycursor.close()

        flash("Registration successful!", "success")
        return redirect(url_for('login'))
    return render_template('staff_register.html')
 
 
@app.route('/registration_successfull')
def registration_successful():
    return render_template('registration_successful.html')



@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        query = "SELECT * FROM users WHERE email = %s"
        result = execute_query(query, (username,), fetch=True)
        if result:  
            user = result[0]  
            if sha256_crypt.verify(password, user['password']):            
                session['loggedin'] = True
                session['email'] = user['email']
                session['user_type'] = user['user_type']          
                return redirect(url_for(f"{user['user_type']}_profile"))
            else:
                flash('Invalid password!', 'error')
        else:
            flash('Invalid email!', 'error')

    return render_template('login.html')


@app.route('/forgot_password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form['email']
        query = "SELECT * FROM users WHERE email = %s"
        result = execute_query(query, (email,), fetch=True)
        if result:  
            token = s.dumps(email, salt='password-reset-salt')
            link = url_for('reset_password', token=token, _external=True)
            msg = Message(
                'Password Reset Request',
                sender=app.config['MAIL_USERNAME'],
                recipients=[email]
            )
            msg.body = f"Please click the following link to reset your password: {link}"
            mail.send(msg)
            
            flash("A password reset link has been sent to your email.", "info")
        else:
            flash("This email is not associated with any account.", "danger")
        
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
        confirm_password = request.form['confirm_password']

       
        if new_password != confirm_password:
            flash("Passwords do not match. Please try again.", "danger")
            return redirect(url_for('reset_password', token=token))  

     
        hashed_password = sha256_crypt.encrypt(new_password)

        
        query = "UPDATE users SET password = %s WHERE email = %s"
        execute_query(query, (hashed_password, email))

        flash("Your password has been reset successfully. You can now log in.", "success")
        return redirect(url_for('login'))
    
    return render_template('reset_password.html', token=token)


@app.route('/student_profile', methods=['GET', 'POST'])
def student_profile():
    if 'loggedin' in session and session['user_type'] == 'student':
        email = session['email']
        profile = execute_query("SELECT * FROM users WHERE email = %s", (email,), fetch=True)[0]

        if request.method == 'POST':
            if 'password' in request.form and 'confirm_password' in request.form:
                password = request.form['password']
                confirm_password = request.form['confirm_password']
                if password == confirm_password:
                    hashed_password = sha256_crypt.encrypt(password)
                    execute_query("UPDATE users SET password = %s WHERE email = %s", (hashed_password , email))
                    flash("Password updated successfully!", "success")
                else:
                    flash("Passwords do not match.", "error")
                return redirect(url_for('student_profile'))

            name = request.form['name']
            reg_no = request.form['reg_no']
            roll_number = request.form['roll_number']
            department = request.form['department']
            father_name = request.form['father_name']
            mother_name = request.form['mother_name']
            present_address = request.form['present_address']
            permanent_address = request.form['permanent_address']
            dob = request.form['dob']
            mobile_number = request.form['mobile_number']
            execute_query(
                """
                UPDATE users
                SET reg_no=%s, name=%s, roll_number=%s, department=%s, father_name=%s, mother_name=%s,
                    present_address=%s, permanent_address=%s, dob=%s, mobile_number=%s
                WHERE email=%s
                """,
                (reg_no, name, roll_number, department, father_name, mother_name, present_address, permanent_address, dob, mobile_number, email)
            )
            flash("Profile updated successfully!", "success")
            return redirect(url_for('student_profile'))

        return render_template('student_profile.html', profile=profile)

    flash("Unauthorized access.", "error")
    return redirect(url_for('login'))



@app.route('/teacher_profile', methods=['GET', 'POST'])
def teacher_profile():
    if 'loggedin' in session and session['user_type'] == 'teacher':
        email = session['email']

        profile = execute_query("SELECT * FROM users WHERE email = %s", (email,), fetch=True)[0]

        if request.method == 'POST':
            if 'password' in request.form and 'confirm_password' in request.form:
                password = request.form['password']
                confirm_password = request.form['confirm_password']
                if password == confirm_password:
                    hashed_password = sha256_crypt.encrypt(password)
                    execute_query("UPDATE users SET password = %s WHERE email = %s", (hashed_password , email))
                    flash("Password updated successfully!", "success")
                else:
                    flash("Passwords do not match.", "error")
                return redirect(url_for('teacher_profile'))
            name=request.form['name']
            designation=request.form['designation']
            department = request.form['department']
            present_address = request.form['present_address']
            permanent_address = request.form['permanent_address']
            dob = request.form['dob']
            mobile_number = request.form['mobile_number']
            password=request.form['password']
            confirm_password=request.form['confirm_password']
            if password != confirm_password:
               flash("do not match confrim password ")
               return redirect(url_for('teacher_profile'))
            hashed_password = sha256_crypt.encrypt(password)
            execute_query(
                """
                UPDATE users
                SET name=%s,designation=%s,department=%s,password=%s,present_address=%s, permanent_address=%s, dob=%s, 
                    mobile_number=%s
                WHERE email=%s
                """,
                ( name,designation,department,hashed_password,present_address, permanent_address, dob, mobile_number, email)
            )
            flash("Profile updated successfully!", "success")
            return redirect(url_for('teacher_profile'))

        return render_template('teacher_profile.html', profile=profile)



@app.route('/chairman_profile', methods=['GET', 'POST'])
def chairman_profile():
    if 'loggedin' in session and session['user_type'] == 'chairman':
        email = session['email']

        profile = execute_query("SELECT * FROM users WHERE email = %s", (email,), fetch=True)[0]

        if request.method == 'POST':
            if 'password' in request.form and 'confirm_password' in request.form:
                password = request.form['password']
                confirm_password = request.form['confirm_password']
                if password == confirm_password:
                    hashed_password = sha256_crypt.encrypt(password)
                    execute_query("UPDATE users SET password = %s WHERE email = %s", (hashed_password , email))
                    flash("Password updated successfully!", "success")
                else:
                    flash("Passwords do not match.", "error")
                return redirect(url_for('chairman_profile'))
            name=request.form['name']
            designation=request.form['designation']
            department = request.form['department']
            present_address = request.form['present_address']
            permanent_address = request.form['permanent_address']
            dob = request.form['dob']
            mobile_number = request.form['mobile_number']
            password=request.form['password']
            confirm_password=request.form['confirm_password']
            if password != confirm_password:
               flash("do not match confrim password ")
               return redirect(url_for('chairman_profile'))
            hashed_password = sha256_crypt.encrypt(password)
            execute_query(
                """
                UPDATE users
                SET name=%s,designation=%s,department=%s,password=%s,present_address=%s, permanent_address=%s, dob=%s, 
                    mobile_number=%s
                WHERE email=%s
                """,
                ( name,designation,department,hashed_password,present_address, permanent_address, dob, mobile_number, email)
            )
            flash("Profile updated successfully!", "success")
            return redirect(url_for('chairman_profile'))

        return render_template('chairman_profile.html', profile=profile)



@app.route('/staff_profile', methods=['GET', 'POST'])
def staff_profile():
    if 'loggedin' in session and session['user_type'] == 'staff':
        email = session['email']

        profile = execute_query("SELECT * FROM users WHERE email = %s", (email,), fetch=True)[0]

    return render_template('staff_profile.html', profile=profile)

   



@app.route('/upload_photo', methods=['POST'])
def upload_photo():
    if 'loggedin' in session:
        email = session['email']
        user_type = session['user_type']

        if 'profile-photo' not in request.files:
            flash("No file part", "danger")
            return redirect(url_for(f'{user_type}_profile'))

        file = request.files['profile-photo']
        if file.filename == '':
            flash("No selected file", "danger")
            return redirect(url_for(f'{user_type}_profile'))

        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename).replace("\\", "/")
            file.save(file_path)

            
            execute_query("UPDATE users SET photo=%s WHERE email=%s", (filename, email))
            flash("Profile photo updated successfully!", "success")
            return redirect(url_for(f'{user_type}_profile'))
        else:
            flash("Invalid file type!", "danger")
            return redirect(url_for(f'{user_type}_profile'))
    flash("Unauthorized access! Please log in first.", "danger")
    return redirect(url_for('login'))
  
        
   


from flask import Flask, render_template, session, redirect, url_for, flash, request

@app.route('/view_results')
def view_results():
   
    if 'loggedin' not in session:
        return redirect(url_for('login'))  
    user_type = session.get('user_type')

    
    return render_template('view_results.html', user_type=user_type)

  
@app.route('/view_attendance')
def view_attendance():
    if 'loggedin' not in session:
        return redirect(url_for('login')) 
    user_type = session.get('user_type')

   
    return render_template('view_attendance.html', user_type=user_type)


@app.route('/change_password', methods=['GET', 'POST'])
def change_password():
    if 'loggedin' not in session:
        flash("Please log in first.", "error")
        return redirect(url_for('login'))  

    email = session.get('email') 
    user_type = session.get('user_type')  

   
    if request.method == 'GET':
        return render_template('change_password.html', user_type=user_type)

    if request.method == 'POST':
        old_password = request.form['old_password']
        new_password = request.form['new_password']
        confirm_password = request.form['confirm_password']

        try:
       
            user = execute_query("SELECT password FROM users WHERE email = %s", (email,), fetch=True)[0]
            current_password_hash = user['password']

          
            if not sha256_crypt.verify(old_password, current_password_hash):
                flash("Old password is incorrect.", "error")
                return redirect(url_for('change_password'))

          
            if new_password != confirm_password:
                flash("New password and confirm password do not match.", "error")
                return redirect(url_for('change_password'))

      
            new_password_hash = sha256_crypt.encrypt(new_password)

           
            execute_query(
                "UPDATE users SET password = %s WHERE email = %s", 
                (new_password_hash, email)
            )

            flash("Password updated successfully.", "success")
            return redirect(url_for('profile'))  
        except Exception as e:
            flash(f"An error occurred: {str(e)}", "error")
            return redirect(url_for('change_password'))





@app.route('/notice_board')
def notice_board():
    if 'loggedin' not in session:
        return redirect(url_for('login'))  
 
    user_type = session.get('user_type')

    return render_template('notice_board.html', user_type=user_type)


@app.route('/add_results') 
def add_results():
    return render_template('add_results.html')


@app.route('/add_notice') 
def add_notice():
    return render_template('add_notice.html')

 
@app.route('/logout')
def logout():
    session.clear()  
    flash("You have been logged out successfully.", "info")
    return redirect(url_for('login'))

from passlib.hash import sha256_crypt

from passlib.hash import sha256_crypt  
from passlib.hash import sha256_crypt  
@app.route('/edit_profile', methods=['GET', 'POST'])
def edit_profile():
    if 'loggedin' not in session:
        flash("Please log in to access your profile.", "error")
        return redirect(url_for('login'))

    email = session.get('email')  # Get logged-in user's email
    user_type = session.get('user_type')  # Get the logged-in user's type

    # Fetch user profile
    try:
        profile = execute_query("SELECT * FROM users WHERE email = %s", (email,), fetch=True)[0]
    except IndexError:
        flash("Profile not found.", "error")
        return redirect(url_for('logout'))

    if request.method == 'POST':
        # Get the current password entered by the user
        current_password = request.form.get('current_password')

        # Debugging: print current password and stored password for debugging purposes
      
        # print("Stored Password in DB:", profile['password'])

        # Check if the current password entered matches the stored password
        if not sha256_crypt.verify(current_password, profile['password']):
            print("Password does not match!")  # Debugging line
            flash("Incorrect current password. Please try again.", "error")
            return redirect(url_for('edit_profile'))
        else:
            print("Password matched!")  # Debugging line

        try:
            # Common fields for all users
            name = request.form.get('name')
            mobile_number = request.form.get('mobile_number')
            present_address = request.form.get('present_address')
            permanent_address = request.form.get('permanent_address')

            # Role-specific fields
            if user_type == 'student':
                reg_no = request.form.get('reg_no')
                roll_number = request.form.get('roll_number')
                department = request.form.get('department')
                father_name = request.form.get('father_name')
                mother_name = request.form.get('mother_name')
                dob = request.form.get('dob')

                execute_query(
                    """
                    UPDATE users
                    SET name=%s, mobile_number=%s, present_address=%s, permanent_address=%s,
                        reg_no=%s, roll_number=%s, department=%s, father_name=%s, mother_name=%s, dob=%s
                    WHERE email=%s
                    """,
                    (name, mobile_number, present_address, permanent_address,
                     reg_no, roll_number, department, father_name, mother_name, dob, email)
                )
                flash("Profile updated successfully!", "success")
                return redirect(url_for('edit_profile'))

            elif user_type == 'teacher':
                designation = request.form.get('designation')
                department = request.form.get('department')
                qualification = request.form.get('qualification')

                execute_query(
                    """
                    UPDATE users
                    SET name=%s, mobile_number=%s, present_address=%s, permanent_address=%s,
                        designation=%s, department=%s, qualification=%s
                    WHERE email=%s
                    """,
                    (name, mobile_number, present_address, permanent_address,
                     designation, department, qualification, email)
                )
                flash("Profile updated successfully!", "success")
                return redirect(url_for('edit_profile'))

            elif user_type == 'chairman':
                office_location = request.form.get('office_location')
                department = request.form.get('department')

                execute_query(
                    """
                    UPDATE users
                    SET name=%s, mobile_number=%s, present_address=%s, permanent_address=%s,
                        office_location=%s, department=%s
                    WHERE email=%s
                    """,
                    (name, mobile_number, present_address, permanent_address,
                     office_location, department, email)
                )
                flash("Profile updated successfully!", "success")
                return redirect(url_for('edit_profile'))

            elif user_type == 'staff':
                designation = request.form.get('designation')
                department = request.form.get('department')
                qualification = request.form.get('qualification')

                execute_query(
                    """
                    UPDATE users
                    SET name=%s, mobile_number=%s, present_address=%s, permanent_address=%s,
                        designation=%s, department=%s, qualification=%s
                    WHERE email=%s
                    """,
                    (name, mobile_number, present_address, permanent_address,
                     designation, department, qualification, email)
                )
                flash("Profile updated successfully!", "success")
                return redirect(url_for('edit_profile'))

            else:
                flash("Unknown user type.", "error")
                return redirect(url_for('edit_profile'))

        except KeyError as e:
            flash(f"Missing field: {str(e)}", "error")
        except Exception as e:
            flash(f"An error occurred: {str(e)}", "error")

        return redirect(url_for('edit_profile'))

    # Render the appropriate profile edit form based on user type
    if user_type == 'student':
        return render_template('studentedit_profile.html', profile=profile, user_type=user_type)
    elif user_type == 'teacher':
        return render_template('teacheredit_profile.html', profile=profile, user_type=user_type)
    elif user_type == 'chairman':
        return render_template('chairmanedit_profile.html', profile=profile, user_type=user_type)
    elif user_type == 'staff':
        return render_template('staffedit_profile.html', profile=profile, user_type=user_type)
    else:
        flash("Unknown user type.", "error")
        return redirect(url_for('logout'))


if__name__='__main__'
app.run(debug=True)
