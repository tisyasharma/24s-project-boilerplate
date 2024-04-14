from flask import Blueprint, jsonify, make_response, request
from src import db

receipts = Blueprint('receipts', __name__)

# Retrieve all receipts of a user
@receipts.route('/receipts/<user_id>', methods=['GET'])
def get_user_receipts(user_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Receipts WHERE user_id = %s', user_id)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Create a new receipt
@receipts.route('/receipts/<user_id>', methods=['POST'])
def create_receipt(user_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    date = the_data['date']
    total_amount = the_data['total_amount']
    store_id = the_data['store_id']

    # Constructing the query
    query = 'INSERT INTO Receipts (Date, total_amount, user_id, store_id) VALUES (%s, %s, %s, %s)'
    values = (date, total_amount, user_id, store_id)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Receipt created successfully!', 201

# Retrieve a specific receipt
@receipts.route('/receipts/<receipt_id>', methods=['GET'])
def get_receipt(receipt_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Receipts WHERE receipt_id = %s', receipt_id)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchone()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Update a receipt
@receipts.route('/receipts/receipt_id>', methods=['PUT'])
def update_receipt(receipt_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    date = the_data['date']
    total_amount = the_data['total_amount']
    store_id = the_data['store_id']

    # Constructing the query
    query = 'UPDATE Receipts SET Date = %s, total_amount = %s, store_id = %s WHERE receipt_id = %s'
    values = (date, total_amount, store_id, receipt_id)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Receipt updated successfully!', 200

# Delete a receipt
@receipts.route('/receipts/<receipt_id>', methods=['DELETE'])
def delete_receipt(receipt_id):
    # Constructing the query
    query = 'DELETE FROM Receipts WHERE receipt_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, receipt_id)
    db.get_db().commit()

    return 'Receipt deleted successfully!', 200
