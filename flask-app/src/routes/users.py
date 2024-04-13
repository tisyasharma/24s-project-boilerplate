from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


users = Blueprint('users', __name__)

# Get all users from the DB
@users.route('/users', methods=['GET'])
def get_users():
    cursor = db.get_db().cursor()
    cursor.execute('select first_name, middle_name, last_name,\
        email from users')
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
@users.route('/users', methods=['POST'])
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
    query = 'INSERT INTO users (group, email, first_name, middle_name, last_name, password) VALUES (%s, %s, %s, %s, %s, %s)'
    values = (group, email, first_name, middle_name, last_name, password)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'User created successfully!', 201

# Update user information
@users.route('/users/<userID>', methods=['PUT'])
def update_user(userID):
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
    query = 'UPDATE users SET group="%s", Email="%s", first_name="%s", middle_name="%s", last_name="%s", password="%s" WHERE id=%s' % (group, Email, first_name, middle_name, last_name, password, id)
    current_app.logger.info(query)

    # Executing and committing the update statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'User info updated successfully!', 200

# Get user detail for user with particular userID
@users.route('/users/<userID>', methods=['GET'])
def get_user(userID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from users where user_id = {0}'.format(userID))
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
@users.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    # Constructing the query
    query = 'DELETE FROM users WHERE id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, (user_id,))
    db.get_db().commit()

    return 'User deleted successfully!', 200