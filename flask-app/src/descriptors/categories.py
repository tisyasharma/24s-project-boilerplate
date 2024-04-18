from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

descriptors = Blueprint('descriptors', __name__)

#get all categories
@descriptors.route('/categories', methods=['GET'])
def get_all_categories():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Categories')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#get specific category
@descriptors.route('/categories/<category_id>', methods=['GET'])
def get_category(category_id):
    cursor = db.get_db().cursor()
    cursor.execute(f"SELECT * FROM Categories WHERE category_id = {category_id}")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# get all user's tags
@descriptors.route('/tags/<user_id>', methods=['GET'])
def get_all_tags(user_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Tags WHERE user_id = %s', user_id)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response



# create new tag
@descriptors.route('/tags/<user_id>', methods=['POST'])
def create_tag(user_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    tag_name = the_data['tag_name']
    

    # Constructing the query
    query = 'INSERT INTO Tags (tag_name, user_id) VALUES (%s, %s)'
    values = (tag_name, user_id)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Tag created successfully!', 201

# Update a spending goal
@descriptors.route('/tags/<tag_id>', methods=['PUT'])
def update_tag(tag_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    tag_name = the_data['tag_name']

    # Constructing the query
    query = 'UPDATE Tags SET tag = %s WHERE tag_id = %s'
    values = (tag_name, tag_id)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Tag updated successfully!', 200

@descriptors.route('/tags-goals/<tag_id>', methods=['DELETE'])
def delete_tag(tag_id):
    # Constructing the query
    query = 'DELETE FROM Tags WHERE tag_id = %s'
    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, tag_id)
    db.get_db().commit()

    return 'Spending tag deleted successfully!', 200
