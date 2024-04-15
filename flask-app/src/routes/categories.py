from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

descriptor = Blueprint('descriptor', __name__)

#get all categories
@descriptor.route('/categories/', methods=['GET'])
def get_all_categories():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT category_name, category_description FROM categories')
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
@descriptor.route('/categories/<categoryid>', methods=['GET'])
def get_all_categories(category_id):
    cursor = db.get_db().cursor()
    cursor.execute(f"SELECT category_name, category_description FROM categories WHERE category_id = {category_id}")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


#Remove category from receipt
@descriptor.route('/categories/<receipt_id>', methods=['PUT'])
def remove_category_in_receipt(receipt_id):
    # Constructing the query
    query = 'UPDATE Receipt SET category_id = NULL WHERE receipt_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, receipt_id)
    db.get_db().commit()

    return 'Removed category from receipt successfully!', 200

# add category to receipt
@descriptor.route('/categories/<receipt_id>/<category_id>', methods=['PUT'])
def add_category_to_receipt(receipt_id, category_id):
    # Constructing the query
    query = 'UPDATE Receipt SET category_id = %s WHERE receipt_id = %s'
    values = (category_id, receipt_id)
    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()
    return 'Added category to receipt successfully!', 201

# add tag to receipt
@descriptor.route('/tags/<receipt_id>/<tag_id>', methods=['PUT'])
def add_tag_to_receipt(receipt_id, tag_id):
    # Constructing the query
    query = 'UPDATE Receipt SET tag_id = %s WHERE receipt_id = %s'
    values = (tag_id, receipt_id)
    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()


    return 'Added tag to receipt successfully!', 201

# remove tag to receipt
@descriptor.route('/tags/<receipt_id>', methods=['PUT'])
def remove_tag_from_receipt(receipt_id):
    # Constructing the query
    query = 'UPDATE Receipt SET tag_id = NULL WHERE receipt_id = %s'
    values = (receipt_id)

    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()
    return 'Removed tag from receipt successfully!', 201


# get all user's tags
@descriptor.route('/tags/<user_id>', methods=['GET'])
def get_all_tags(user_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM tags WHERE user_id = %s', user_id)
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
@descriptor.route('/tags/<user_id>', methods=['POST'])
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

    return 'Receipt created successfully!', 201
