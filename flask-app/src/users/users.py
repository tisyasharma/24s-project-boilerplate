from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


users = Blueprint('users', __name__)

# Get all users from the DB
@users.route('', methods=['GET'])
def get_users():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT first_name, middle_name, last_name, email FROM Users')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Create a new user
@users.route('', methods=['POST'])
def create_user():
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    group = the_data['group']
    email = the_data['email']
    first_name = the_data['first_name']
    middle_name = the_data['middle_name']
    last_name = the_data['last_name']
    password = the_data['password']

    # Constructing the query
    query = 'INSERT INTO Users (group, email, first_name, middle_name, last_name, password) \
        VALUES (%s, %s, %s, %s, %s, %s)'
    values = (group, email, first_name, middle_name, last_name, password)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'User created successfully!', 201

# Update user information
@users.route('/<user_id>', methods=['PUT'])
def update_user(user_id):
    # collecting data from the request object 
    the_data = request.json

    # extracting the variable
    group = the_data['group']
    Email = the_data['last_name']
    first_name = the_data['first_name']
    middle_name = the_data['job_title']
    last_name = the_data['business_phone']
    password = the_data['password']

    # Constructing the query
    query = 'UPDATE Users SET group="%s", Email="%s", first_name="%s", middle_name="%s", last_name="%s", password="%s" \
        WHERE user_id=%s' % (group, Email, first_name, middle_name, last_name, password, user_id)
    current_app.logger.info(query)

    # Executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'User info updated successfully!', 200

# Get user detail for user with particular user_id
@users.route('/<user_id>', methods=['GET'])
def get_user(user_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Users WHERE user_id = {0}'.format(user_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchone()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Delete a specific user
@users.route('/<user_id>', methods=['DELETE'])
def delete_user(user_id):
    # Constructing the query
    query = 'DELETE FROM Users WHERE user_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, user_id)
    db.get_db().commit()

    return 'User deleted successfully!', 200

# Update group information
@users.route('/group/<group_id>', methods=['PUT'])
def update_group(group_id):
    # collecting data from the request object 
    the_data = request.json

    # extracting the variable
    group_name = the_data['group_name']
    admin_user_id = the_data['admin_user_id']
    

    # Constructing the query
    query = 'UPDATE Groups SET group_name= %s, admin_user_id= %s WHERE user_id=%s' % (group_name, admin_user_id)
    current_app.logger.info(query)

    # Executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Group info updated successfully!', 200
# Create a new user
@users.route('/group/<admin_user_id>', methods=['POST'])
def create_group(admin_user_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    group_name = the_data['group_name']

    # Constructing the query
    query = 'INSERT INTO Users (group_name, admin_user_id) \
        VALUES (%s, %s)'
    values = (group_name, admin_user_id)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Group created successfully!', 201