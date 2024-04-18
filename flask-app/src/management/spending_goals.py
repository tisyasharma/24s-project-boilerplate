from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

management = Blueprint('management', __name__)

# Retrieve all spending goals of a user
@management.route('/spending-goals/<user_id>', methods=['GET'])
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
@management.route('/spending-goals/<user_id>', methods=['POST'])
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
@management.route('/spending-goals/<goal_id>', methods=['GET'])
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
@management.route('/spending-goals/<goal_id>', methods=['PUT'])
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
@management.route('/spending-goals/<goal_id>', methods=['DELETE'])
def delete_spending_goal(goal_id):
    # Constructing the query
    query = 'DELETE FROM Spending_goals WHERE goal_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, goal_id)
    db.get_db().commit()

    return 'Spending goal deleted successfully!', 200

# Retrieve the budget of a category
@management.route('/budgets/<category_id>', methods=['GET'])
def get_budget_of_category(category_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Budgets WHERE category_id = %s', category_id)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Create new budget
@management.route('/budgets/<category_id>', methods=['POST'])
def create_budget(category_id):
    # Extracting data from the request object
    the_data = request.json


    # Extracting variables
    amount = the_data['amount']
    start_date = the_data['start_date']
    end_date = the_data['end_date']
    notification_threshold = the_data['notification_threshold']


    # Constructing the query
    query = 'INSERT INTO Budgets (amount, start_date, end_date, notification_threshold, category_id) VALUES (%s, %s, %s, %s)'
    values = (amount, start_date, end_date, notification_threshold, category_id)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Budget created successfully!', 201


# Update a spending goal
@management.route('/budgets/<budget_id>', methods=['PUT'])
def update_budget(budget_id):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    amount = the_data['amount']
    start_date = the_data['start_date']
    end_date = the_data['end_date']
    notification_threshold = the_data['notification_threshold']

    # Constructing the query
    query = 'UPDATE Budgets SET amount = %s, state_date = %s, end_date = %s, notification_threshold = %s WHERE budget_id = %s'
    values = (amount, start_date, end_date, notification_threshold, budget_id)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Budget updated successfully!', 200

# Delete a spending goal
@management.route('/budget/<budget_id>', methods=['DELETE'])
def delete_budget(budget_id):
    # Constructing the query
    query = 'DELETE FROM Budgets WHERE budget_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, budget_id)
    db.get_db().commit()

    return 'Budget deleted successfully!', 200


# Retrieve all notifications
@management.route('/budgets/notifications', methods=['GET'])
def get_all_notifications():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Notifications')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Retrieve all notifications for a specific user
@management.route('/budgets/notifications/<user_id>', methods=['GET'])
def get_all_notifications_from_user(user_id):
    cursor = db.get_db().cursor()
    cursor.execute(f'SELECT * FROM Notifications WHERE user_id = {user_id}')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
