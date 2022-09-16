from flask import Flask, render_template, flash, redirect, url_for, session, request
from flask_mysqldb import MySQL
from passlib.handlers.sha2_crypt import sha256_crypt
from forms import LoginForm, RegistrationForm, PhoneForm, ChangePasswordForm, ChangeEmailForm, BookAppointmentForm
from utils import login_required, check_is_patient
from datetime import datetime

app = Flask(__name__)
app.secret_key = "too_secret_to_reveal"
app.static_folder = 'static'

app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = "root"
app.config["MYSQL_DB"] = "balco"
app.config["MYSQL_CURSORCLASS"] = "DictCursor"

mysql = MySQL(app)


# Login page
@app.route('/', methods=["GET", "POST"])
def index():
    form = LoginForm(request.form)
    if "logged_in" in session:
        return redirect(url_for("member_area"))
    if request.method == "POST":
        email = form.email.data
        password_entered = form.password.data

        cursor = mysql.connection.cursor()
        query = "SELECT * FROM Persons WHERE email = %s"
        result_set = cursor.execute(query, (email,))
        if result_set > 0:
            data = cursor.fetchone()
            real_password = data["password"]
            if sha256_crypt.verify(password_entered, real_password):
                ssn = data["ssn"]
                full_name = data["first_name"] + " " + data["last_name"]

                session["logged_in"] = True
                session["full_name"] = full_name
                session["email"] = email
                session["ssn"] = ssn
                session["is_patient"] = check_is_patient(ssn, mysql)

                flash("You have successfully logged in.", "success")
                return redirect(url_for("member_area"))
            else:
                flash("Your password is wrong.", "danger")
                return redirect(url_for("index"))
        else:
            flash("There is no such email has been registered.", "danger")
            return redirect(url_for("index"))
    return render_template("login.html", form=form)


# Register page
@app.route('/register', methods=["GET", "POST"])
def register():
    form = RegistrationForm(request.form)
    if "logged_in" in session:
        return redirect(url_for("member_area"))
    if request.method == "POST" and form.validate():
        ssn = form.ssn.data
        email = form.email.data
        first_name = form.first_name.data
        last_name = form.last_name.data
        gender = form.gender.data
        birth_date = form.birth_date.data
        password = sha256_crypt.hash(form.password.data)

        cursor = mysql.connection.cursor()

        query = "SELECT * FROM persons WHERE ssn = %s"
        same_ssn = cursor.execute(query, (ssn,)) > 0

        query = "SELECT * FROM persons WHERE email = %s"
        same_email = cursor.execute(query, (email,)) > 0
        if same_ssn:
            flash(message="This Uid has been registered",
                  category="danger")
            cursor.close()
            return redirect(url_for("index"))

        if same_email:
            flash(message="This email has been registered",
                  category="danger")
            cursor.close()
            return redirect(url_for("index"))

        query = "INSERT INTO persons(ssn, email, password, first_name, last_name, gender, birth_date) VALUES(%s, %s, %s, %s, %s, %s, %s)"
        cursor.execute(query, (ssn, email, password, first_name, last_name, gender, birth_date))
        mysql.connection.commit()

        cursor.close()
        flash(message="You have been successfully registered. You may login now.", category="success")
        return redirect(url_for("index"))
    else:
        return render_template("register.html", form=form)


# Member area page
@app.route('/member-area', methods=["GET", "POST"])
@login_required
def member_area():
    return render_template("welcome.html")


# Profile page
@app.route('/profile', methods=["GET", "POST"])
@login_required
def profile():
    cursor = mysql.connection.cursor()
    query = "SELECT * FROM persons WHERE ssn = %s"
    cursor.execute(query, (session["ssn"],))
    person = cursor.fetchone()

    query = "SELECT * FROM person_contact_numbers WHERE contact_ssn = %s"
    is_phone_exist = cursor.execute(query, (session["ssn"],))
    phones = cursor.fetchall()


    if is_phone_exist and not session["is_patient"]:
        query = "INSERT INTO patients(patient_ssn) VALUES (%s)"
        cursor.execute(query, (session["ssn"],))
        mysql.connection.commit()
        session["is_patient"] = True
        cursor.close()
        flash("You have successfully activated your account. Now you can use Balco system.", category="success")
        return render_template("profile.html", person=person,  phones=phones)

    cursor.close()
    return render_template("profile.html", person=person, phones=phones)


# Profile -> Change Password
@app.route('/change-password', methods=["GET", "POST"])
@login_required
def change_password():
    form = ChangePasswordForm(request.form)
    if request.method == "POST" and form.validate():
        old_password = form.old_password.data
        password = form.password.data
        if old_password == password:
            flash(message="Your old password and new password cannot be the same.", category="danger")
            return render_template("change-password.html", form=form)
        cursor = mysql.connection.cursor()
        query = "SELECT * FROM Persons WHERE ssn = %s"
        cursor.execute(query, (session["ssn"],))
        data = cursor.fetchone()
        real_password = data["password"]
        if sha256_crypt.verify(old_password, real_password):
            query = "UPDATE persons SET password = %s WHERE ssn = %s"
            hashed_password = sha256_crypt.hash(password)
            cursor.execute(query, (hashed_password, session["ssn"]))
            mysql.connection.commit()
            cursor.close()
            flash("Your password has been successfully changed", "success")
            return redirect(url_for("profile"))
        else:
            cursor.close()
            flash("Your password is wrong.", "danger")
            return redirect(url_for("profile"))
    return render_template("change-password.html", form=form)


# Profile -> Change Email
@app.route('/change-email', methods=["GET", "POST"])
@login_required
def change_email():
    form = ChangeEmailForm(request.form)
    if request.method == "POST" and form.validate():
        email = form.email.data
        password = form.password.data
        cursor = mysql.connection.cursor()
        query = "SELECT * FROM Persons WHERE ssn = %s"
        cursor.execute(query, (session["ssn"],))
        data = cursor.fetchone()
        real_password = data["password"]
        if data["email"] == email:
            flash(message="Your old email and new email cannot be the same.", category="danger")
            return render_template("change-email.html", form=form)
        if sha256_crypt.verify(password, real_password):
            query = "UPDATE persons SET email = %s WHERE ssn = %s"
            cursor.execute(query, (email, session["ssn"]))
            mysql.connection.commit()
            session["email"] = email
            cursor.close()
            flash("Your email has been successfully changed", "success")
            return redirect(url_for("profile"))
        else:
            cursor.close()
            flash("Your password is wrong.", "danger")
            return redirect(url_for("profile"))
    return render_template("change-email.html", form=form)


# Profile -> Phones -> Add
@app.route('/add-phone', methods=["GET", "POST"])
@login_required
def add_phone():
    form = PhoneForm(request.form)
    if request.method == "POST" and form.validate():
        phone_number = form.contact_number.data
        cursor = mysql.connection.cursor()
        query = "SELECT * FROM person_contact_numbers WHERE contact_number = %s"
        is_registered = cursor.execute(query, (phone_number,)) > 0
        if is_registered:
            cursor.close()
            flash(message="This phone number has been already registered.", category="danger")
            return render_template("add-phone.html", form=form)
        else:
            query = "INSERT INTO person_contact_numbers(contact_number, contact_ssn) VALUES (%s, %s)"
            cursor.execute(query, (phone_number, session["ssn"]))
            mysql.connection.commit()
            cursor.close()
            flash(message="Phone number has been registered successfully.", category="success")
            return redirect(url_for("profile"))
    return render_template("add-phone.html", form=form)


# Profile -> Phones -> Delete
@app.route('/delete-phone/<string:contact_number>')
@login_required
def delete_phone(contact_number):
    cursor = mysql.connection.cursor()
    query = "SELECT * FROM person_contact_numbers WHERE contact_ssn = %s"
    result = cursor.execute(query, (session["ssn"],))
    if result > 1:
        query = "SELECT * FROM person_contact_numbers WHERE contact_ssn = %s and contact_number = %s"
        result = cursor.execute(query, (session["ssn"], contact_number))
        if result > 0:
            query = "DELETE FROM person_contact_numbers WHERE contact_number = %s"
            cursor.execute(query, (contact_number,))
            cursor.close()
            mysql.connection.commit()
            flash(message="Phone number information has been deleted from your profile successfully.",
                  category="success")
            return redirect(url_for("profile"))
        else:
            cursor.close()
            flash(message="There's not such phone number stored in your profile.", category="danger")
            return redirect(url_for("profile"))
    if result == 1:
        flash(message="You have to provide at least one phone number. Maybe you may edit the existing one.",
              category="danger")
        return redirect(url_for("profile"))
    else:
        flash(message="There's not such phone number stored in your profile.", category="danger")
        return redirect(url_for("profile"))


# Profile -> Phones -> Modify
@app.route('/modify-phone/<string:number>', methods=["GET", "POST"])
@login_required
def modify_phone(number):
    if request.method == "GET":
        form = PhoneForm()
        cursor = mysql.connection.cursor()
        query = "SELECT * FROM person_contact_numbers WHERE contact_ssn = %s and contact_number = %s"
        result = cursor.execute(query, (session["ssn"], number))
        if result == 0:
            cursor.close()
            flash(message="There's not such phone number stored in your profile.", category="danger")
            return redirect(url_for("profile"))
        else:
            cursor.close()
            form.contact_number.data = number
            return render_template("modify-phone.html", form=form)
    else:
        form = PhoneForm(request.form)
        if request.method == "POST" and form.validate():
            cursor = mysql.connection.cursor()
            phone_number = form.contact_number.data
            query = "SELECT * FROM person_contact_numbers WHERE contact_number %s"
            cursor.close()
            if cursor.execute(query, (phone_number,)):
                flash(message="This phone number has been already registered.", category="danger")
                return render_template("modify-phone.html", form=form)
            else:
                query = "UPDATE person_contact_numbers SET contact_number = %s WHERE contact_number = %s"
                cursor.execute(query, (phone_number, number))
                mysql.connection.commit()
                flash(message="Phone number has been modified successfully.", category="success")
                return redirect(url_for("profile"))
        else:
            flash(message="Please re-correct your phone number.", category="danger")
            return render_template("modify-phone.html", form=form)


# Appointments -> My Appointments
@app.route('/appointments')
@login_required
def my_appointments():
    if not session["is_patient"]:
        flash("You are not authorized!", "danger")
        return redirect(url_for("index"))
    cursor = mysql.connection.cursor()
    query = "SELECT * FROM patients WHERE patient_ssn = %s"
    cursor.execute(query, (session["ssn"],))
    person = cursor.fetchone()
    patient_id = person["patient_id"]

    month = datetime.today().month
    day = datetime.today().day
    year = datetime.today().year

    query = """ SELECT * FROM appointments
                LEFT OUTER JOIN doctors
                ON appointments.d_id = doctors.doctor_id
                LEFT OUTER JOIN persons
                ON persons.ssn = doctors.doctor_ssn
                WHERE (p_id = %s AND `month` = %s AND `day` <= %s AND `year` = %s)
                OR (p_id = %s AND `month` < %s AND `year` = %s)
                OR (p_id = %s AND `year` < %s)"""
    cursor.execute(query, (patient_id, month, day, year, patient_id, month, year, patient_id, year))
    past_appointments = cursor.fetchall()

    query = """ SELECT * FROM appointments
                LEFT OUTER JOIN doctors
                ON appointments.d_id = doctors.doctor_id
                LEFT OUTER JOIN persons
                ON persons.ssn = doctors.doctor_ssn
                WHERE (p_id = %s AND `month` = %s AND `day` > %s AND `year` = %s)
                OR (p_id = %s AND `month` > %s AND `year` = %s)
                OR (p_id = %s AND `year` > %s)"""
    cursor.execute(query, (patient_id, month, day, year, patient_id, month, year, patient_id, year))
    upcoming_appointments = cursor.fetchall()

    cursor.close()
    return render_template("appointments.html", past_appointments=past_appointments,
                           upcoming_appointments=upcoming_appointments)


# Appointments -> Book An Appointment
@app.route('/book-an-appointment', methods=["GET", "POST"])
@login_required
def book_an_appointment():
    if not session["is_patient"]:
        flash("You are not authorized!", "danger")
        return redirect(url_for("index"))
    if request.method == "GET":
        form = BookAppointmentForm(request.form)
        cursor = mysql.connection.cursor()
        query = "SELECT * FROM patients WHERE patient_ssn = %s"
        cursor.execute(query, (session["ssn"],))
        person = cursor.fetchone()
        patient_id = person["patient_id"]

        month = datetime.today().month
        day = datetime.today().day
        year = datetime.today().year


        query = """
        SELECT doctors.doctor_id, doctors.charge, persons.first_name, persons.last_name
        FROM doctors
        LEFT OUTER JOIN persons
        ON persons.ssn = doctors.doctor_ssn
        """
        cursor.execute(query)
        doctors = cursor.fetchall()

        form.doctor.choices = [(doctor["doctor_id"], doctor["first_name"] + " " + doctor["last_name"]) for doctor
                                in
                                doctors]
        form.hour.choices = [(8, 8), (9, 9), (10, 10), (11, 11), (12, 12), (15, 15), (16, 16)]

        return render_template("book-an-appointment.html", form=form)
    else:
        form = BookAppointmentForm(request.form)
        if request.method == "POST":
            cursor = mysql.connection.cursor()
            doctor_id = form.doctor.data
            date = form.date.data
            hour = form.hour.data
            today = datetime.today()
            if today.year != date.year or today.month != date.month or today.day > date.day:
                flash(message="You only can get an appointment for this month.", category="danger")
                return redirect(url_for("book_an_appointment"))
            if today.year == date.year and today.month == date.month and today.day == date.day and datetime.now().hour > int(
                    hour):
                flash(message="You cannot get an appointment for a past time.", category="danger")
                return redirect(url_for("book_an_appointment"))

            query = """
                    SELECT doctors.doctor_id, doctors.charge, persons.first_name, persons.last_name
                    FROM doctors
                    LEFT OUTER JOIN persons
                    ON persons.ssn = doctors.doctor_ssn
                    WHERE doctors.doctor_id = %s
                    """
            cursor.execute(query, (doctor_id,))
            doctor = cursor.fetchone()
            doctor_name = doctor["first_name"] + " " + doctor["last_name"]

            query = "SELECT * FROM holiday_dates WHERE resting_id = %s and rest_date = %s"
            result = cursor.execute(query, (doctor_id, date))
            if result:
                flash(
                    message=doctor_name + " is going to be on vacation on that date, please select another date to book an appointment",
                    category="warning")
                return redirect(url_for("my_appointments"))
            query = "SELECT * FROM appointments WHERE d_id = %s and `year` = %s and `month` = %s and `day` = %s and `hour` = %s"
            result = cursor.execute(query, (doctor_id, date.year, date.month, date.day, hour))
            if result:
                flash(message=doctor_name + " has already an appointment on " + str(date.day) + "/" + str(
                    date.month) + "/" + str(date.year) + " at " + hour,
                      category="danger")
                return redirect(url_for("my_appointments"))
            query = "SELECT * FROM doctors WHERE doctor_id = %s"
            cursor.execute(query, (doctor_id,))
            doctor = cursor.fetchone()
            charge = doctor["charge"]
            query = "SELECT * FROM patients WHERE patient_ssn = %s"
            cursor.execute(query, (session["ssn"],))
            patient = cursor.fetchone()
            patient_id = patient["patient_id"]
            query = "INSERT INTO appointments(d_id, p_id, charge, `hour`, `month`, `day`, `year`) VALUES(%s, %s, %s, %s, %s, %s, %s)"
            cursor.execute(query, (doctor_id, patient_id, charge, hour, date.month, date.day, date.year))
            mysql.connection.commit()
            cursor.close()
            flash(message="Your appointment has been successfully booked", category="success")
            return redirect(url_for("my_appointments"))
        else:
            flash(message="Please fulfill the form", category="danger")
            return redirect(url_for("my_appointments"))


# Logout
@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("index"))


if __name__ == '__main__':
    app.run()
