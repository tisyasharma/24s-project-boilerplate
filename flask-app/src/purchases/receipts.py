from flask import Blueprint, jsonify, make_response, request
from src import db

purchases = Blueprint('purchases', __name__)

# Retrieve all receipts of a user
@purchases.route('/receipts/<user_id>', methods=['GET'])
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
@purchases.route('/receipts/<user_id>', methods=['POST'])
def create_receipt(user_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    date = the_data['date']
    total_amount = the_data['total_amount']
    store_id = the_data['store_id']
    category_id = the_data['category_id']
    tag_id = the_data['tag_id']
    


    # Constructing the query
    query = 'INSERT INTO Receipts (date, total_amount, user_id, store_id, tag_id, category_id) VALUES (%s, %s, %s, %s, %s, %s)'
    values = (date, total_amount, user_id, store_id, tag_id, category_id)


    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Receipt created successfully!', 201

# Retrieve a specific receipt
@purchases.route('/receipts/<receipt_id>', methods=['GET'])
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
@purchases.route('/receipts/<receipt_id>', methods=['PUT'])
def update_receipt(receipt_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    total_amount = the_data['total_amount']
    



    # Constructing the query
    query = 'UPDATE Receipts SET total_amount = %s WHERE receipt_id = %s'
    values = ( total_amount, receipt_id)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Receipt updated successfully!', 200

# Delete a receipt
@purchases.route('/receipts/<receipt_id>', methods=['DELETE'])
def delete_receipt(receipt_id):
    # Constructing the query
    query = 'DELETE FROM Receipts WHERE receipt_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, receipt_id)
    db.get_db().commit()

    return 'Receipt deleted successfully!', 200

# Retrieve all 
@purchases.route('/transactions/<receipt_id>', methods=['GET'])
def get_transactions(receipt_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Transactions WHERE receipt_id = %s', receipt_id)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Create a new spending goal
@purchases.route('/transactions/<receipt_id>', methods=['POST'])
def create_transaction(receipt_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    unit_cost = the_data['unit_cost']
    quantity = the_data['quantity']
    item_name = the_data['item_name']

    # Constructing the query
    query = 'INSERT INTO Transactions (unit_cost, quantity, item_name, receipt_id) VALUES (%s, %s, %s, %s) '
    values = (unit_cost, quantity, item_name, receipt_id)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Transaction created successfully!', 201

# Retrieve a specific transaction
@purchases.route('/transactions/<transaction_id>', methods=['GET'])
def get_transaction(transaction_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Transactions WHERE transaction_id = %s', transaction_id)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchone()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Delete a spending goal
@purchases.route('/transactions/<transaction_id>', methods=['DELETE'])
def delete_transaction(transaction_id):
    # Constructing the query
    query = 'DELETE FROM Transactions WHERE transaction_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, transaction_id)
    db.get_db().commit()

    return 'Transaction deleted successfully!', 200

# Retrieve all receipts of a user
@purchases.route('/stores', methods=['GET'])
def get_stores():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Stores')
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
@purchases.route('/stores', methods=['POST'])
def create_store():
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    store_name = the_data['store_name']
    zip_code = the_data['zip_code']
    street_address = the_data['street_address']
    city  = the_data['city']
    state = the_data['state']


    # Constructing the query
    query = 'INSERT INTO Stores (store_name, zip_code, street_address, city, state) VALUES (%s, %s, %s, %s, %s)'
    values = (store_name, zip_code, street_address, city, state)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Store created successfully!', 201

# Retrieve a specific store
@purchases.route('/stores/<store_id>', methods=['GET'])
def get_store(store_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Stores WHERE store_id = %s', store_id)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchone()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Update a store
@purchases.route('/stores/<store_id>', methods=['PUT'])
def update_store(store_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    store_name = the_data['store_name']
    zip_code = the_data['zip_code']
    street_address = the_data['street_address']
    city = the_data['city']
    state = the_data['state']



    # Constructing the query
    query = 'UPDATE Stores SET store_name = %s, zip_code = %s, street_address = %s , city = %s, state = %s WHERE store_id = %s'
    values = (store_name, zip_code, street_address,  city, state, store_id)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Store updated successfully!', 200

# Delete a store
@purchases.route('/store/<store_id>', methods=['DELETE'])
def delete_store(store_id):
    # Constructing the query
    query = 'DELETE FROM Stores WHERE store_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, store_id)
    db.get_db().commit()

    return 'Store deleted successfully!', 200



# retreive all of the user's investments from the DB
@purchases.route('/investments/<user_id>', methods=['GET'])
def get_investments(user_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Investments WHERE investment_id = {0}'.format(user_id))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Create a new investment
@purchases.route('/investments/<user_id>', methods=['POST'])
def create_investment(user_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    stock_name = the_data['stock_name']
    purchase_date = the_data['purchase_date']
    investment_type = the_data['investment_type']

    # Constructing the query
    query = 'INSERT INTO Investments (stock_name, purchase_date, investment_type, user_id) VALUES (%s, %s, %s, %s)'
    values = (stock_name, purchase_date, investment_type, user_id)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Investment created successfully!', 201

# Retrieve a specific investment
@purchases.route('/investments/<investment_id>', methods=['GET'])
def get_investment(investment_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Investments WHERE investment_id = %s', investment_id)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchone()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Update an investment
@purchases.route('/investments/<investment_id>', methods=['PUT'])
def update_investment(investment_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    stock_name = the_data['stock_name']
    purchase_date = the_data['purchase_date']
    investment_type = the_data['investment_type']

    # Constructing the query
    query = 'UPDATE Investments SET stock_name = %s, purchase_date = %s, investment_type = %s WHERE investment_id = %s'
    values = (stock_name, purchase_date, investment_type, investment_id)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Investment updated successfully!', 200

# Delete an investment
@purchases.route('/investments/<investment_id>', methods=['DELETE'])
def delete_investment(investment_id):
    # Constructing the query
    query = 'DELETE FROM Investments WHERE investment_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, investment_id)
    db.get_db().commit()

    return 'Investment deleted successfully!', 200

