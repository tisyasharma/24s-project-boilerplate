from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

spending_goals = Blueprint('spending_goals', __name__)

# Retrieve all spending goals of a user
@spending_goals.route('/spending-goals/<userID>', methods=['GET'])
def get_spending_goals(userID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Spending_goals WHERE user_id = %s', userID)
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
@spending_goals.route('/spending-goals/<userID>', methods=['POST'])
def create_spending_goal(userID):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    current_amount = the_data['current_amount']
    target_amount = the_data['target_amount']
    month = the_data['month']

    # Constructing the query
    query = 'INSERT INTO Spending_goals (current_amount, target_amount, Month, user_id) VALUES (%s, %s, %s, %s)'
    values = (current_amount, target_amount, month, userID)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Spending goal created successfully!', 201

# Retrieve a specific spending goal
@spending_goals.route('/spending-goals/<goalID>', methods=['GET'])
def get_spending_goal(goalID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Spending_goals WHERE goal_id = %s', (goalID))
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
@spending_goals.route('/spending-goals/<goalID>', methods=['PUT'])
def update_spending_goal(goalID):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    current_amount = the_data['current_amount']
    target_amount = the_data['target_amount']
    month = the_data['month']

    # Constructing the query
    query = 'UPDATE Spending_goals SET current_amount = %s, target_amount = %s, Month = %s WHERE goal_id = %s'
    values = (current_amount, target_amount, month, goalID)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Spending goal updated successfully!', 200

# Delete a spending goal
@spending_goals.route('/spending-goals/<goalID>', methods=['DELETE'])
def delete_spending_goal(goalID):
    # Constructing the query
    query = 'DELETE FROM Spending_goals WHERE goal_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, goalID)
    db.get_db().commit()

    return 'Spending goal deleted successfully!', 200
