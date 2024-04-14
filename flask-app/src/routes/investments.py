from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


investments = Blueprint('investments', __name__)

# retreive all of the user's investments from the DB
@investments.route('/investments/<userID>', methods=['GET'])
def get_investments(userID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Investments WHERE investment_id = {0}'.format(userID))
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
@investments.route('/investments/<userID>', methods=['POST'])
def create_investment(userID):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    stock_name = the_data['stock_name']
    purchase_date = the_data['purchase_date']
    investment_type = the_data['investment_type']

    # Constructing the query
    query = 'INSERT INTO Investments (stock_name, purchase_date, investment_type, user_id) VALUES (%s, %s, %s, %s)'
    values = (stock_name, purchase_date, investment_type, userID)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Investment created successfully!', 201

# Retrieve a specific investment
@investments.route('/investments/<investmentID>', methods=['GET'])
def get_investment(investmentID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Investments WHERE investment_id = %s', (investmentID))
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
@investments.route('/investments/<investmentID>', methods=['PUT'])
def update_investment(investmentID):
    # Extracting data from the request object
    the_data = request.json

    # Extracting variables
    stock_name = the_data['stock_name']
    purchase_date = the_data['purchase_date']
    investment_type = the_data['investment_type']

    # Constructing the query
    query = 'UPDATE Investments SET stock_name = %s, purchase_date = %s, investment_type = %s WHERE investment_id = %s'
    values = (stock_name, purchase_date, investment_type, investmentID)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Investment updated successfully!', 200

# Delete an investment
@investments.route('/investments/<investmentID>', methods=['DELETE'])
def delete_investment(investmentID):
    # Constructing the query
    query = 'DELETE FROM Investments WHERE investment_id = %s'

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, investmentID)
    db.get_db().commit()

    return 'Investment deleted successfully!', 200