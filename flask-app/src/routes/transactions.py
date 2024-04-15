from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

transactions = Blueprint('transactions', __name__)

# Retrieve all 
@transactions.route('/transactions/<receipt_id>', methods=['GET'])
def get_transactions(receipt_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM transactions WHERE receipt_id = %s', receipt_id)
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
@transactions.route('/transactions/<receipt_id>', methods=['POST'])
def create_transaction(receipt_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    unit_cost = the_data['unit_cost']
    quantity = the_data['quantity']
    item_name = the_data['item_name']

    # Constructing the query
    query = 'INSERT INTO Transactions (unit_cost, quantity, item_name, user_id) VALUES (%s, %s, %s, %s, %s) '
    values = (unit_cost, quantity, item_name, receipt_id)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Transaction created successfully!', 201

# Retrieve a specific spending goal
@transactions.route('/transactions/<transaction_id>', methods=['GET'])
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

# Update a spending goal
@transactions.route('/transactions/<transaction_id>', methods=['PUT'])
def update_spending_goal(transaction_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    unit_cost = the_data['unit_cost']
    quantity = the_data['quantity']
    item_name = the_data['transaction_id']

    # Constructing the query
    query = 'UPDATE Transaction SET unit_cost = %s, quantity = %s, item_name = %s WHERE transaction_id = %s'
    values = (unit_cost, quantity, transaction_id, transaction_id)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Transaction updated successfully!', 200

# Delete a spending goal
@transactions.route('/transactions/<transaction_id>', methods=['DELETE'])
def delete_spending_goal(transaction_id):
    # Constructing the query
    query = 'DELETE FROM Transaction WHERE transaction_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, transaction_id)
    db.get_db().commit()

    return 'Transaction deleted successfully!', 200
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

spending_goals = Blueprint('spending_goals', __name__)

# Retrieve all spending goals of a user
@spending_goals.route('/spending-goals/<user_id>', methods=['GET'])
def get_spending_goals(user_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Spending_goals WHERE user_id = %s', user_id)
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
@spending_goals.route('/spending-goals/<user_id>', methods=['POST'])
def create_spending_goal(user_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    current_amount = the_data['current_amount']
    target_amount = the_data['target_amount']
    month = the_data['month']

    # Constructing the query
    query = 'INSERT INTO Spending_goals (current_amount, target_amount, Month, user_id) VALUES (%s, %s, %s, %s)'
    values = (current_amount, target_amount, month, user_id)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Spending goal created successfully!', 201

# Retrieve a specific spending goal
@spending_goals.route('/spending-goals/<goal_id>', methods=['GET'])
def get_spending_goal(goal_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Spending_goals WHERE goal_id = %s', goal_id)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchone()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Update a spending goal
@spending_goals.route('/spending-goals/<goal_id>', methods=['PUT'])
def update_spending_goal(goal_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    current_amount = the_data['current_amount']
    target_amount = the_data['target_amount']
    month = the_data['month']

    # Constructing the query
    query = 'UPDATE Spending_goals SET current_amount = %s, target_amount = %s, Month = %s WHERE goal_id = %s'
    values = (current_amount, target_amount, month, goal_id)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Spending goal updated successfully!', 200

# Delete a spending goal
@spending_goals.route('/spending-goals/<goal_id>', methods=['DELETE'])
def delete_spending_goal(goal_id):
    # Constructing the query
    query = 'DELETE FROM Spending_goals WHERE goal_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, goal_id)
    db.get_db().commit()

    return 'Spending goal deleted successfully!', 200
