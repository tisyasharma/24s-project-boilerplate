-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database FinanceAppDatabase;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on FinanceAppDatabase.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use FinanceAppDatabase;

-- Groups table
CREATE TABLE IF NOT EXISTS `Groups` (
    group_id INT PRIMARY KEY,
    admin_user_id INT NOT NULL

);

-- User table
CREATE TABLE IF NOT EXISTS User (
    user_id INT PRIMARY KEY,
    group_id INT,
    Email VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    FOREIGN KEY (group_id) REFERENCES `Groups`(group_id) ON UPDATE CASCADE ON DELETE Restrict
);

-- Investments table
CREATE TABLE IF NOT EXISTS Investments (
    investment_id INT PRIMARY KEY,
    stock_name VARCHAR(100) NOT NULL,
    purchase_date DATE NOT NULL,
    investment_type VARCHAR(50) NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON UPDATE CASCADE ON DELETE Restrict
);

-- Spending goals table
CREATE TABLE IF NOT EXISTS Spending_goals (
    goal_id INT PRIMARY KEY,
    current_amount DECIMAL(10,2) NOT NULL,
    target_amount DECIMAL(10,2) NOT NULL,
    Month VARCHAR(10) NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON UPDATE CASCADE ON DELETE Restrict
);
-- Store table
CREATE TABLE IF NOT EXISTS Store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
);
-- Receipts table
CREATE TABLE IF NOT EXISTS Receipts (
    receipt_id INT PRIMARY KEY,
    Date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    user_id INT NOT NULL,
    store_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON UPDATE CASCADE ON DELETE Restrict,
    FOREIGN KEY (store_id) REFERENCES Store(store_id) ON UPDATE CASCADE ON DELETE Restrict
);

-- Transactions table
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT PRIMARY KEY,
    unit_cost DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    receipt_id INT NOT NULL,
    FOREIGN KEY (receipt_id) REFERENCES Receipts(receipt_id) ON UPDATE CASCADE ON DELETE Restrict
);

-- Tag table
CREATE TABLE IF NOT EXISTS Tag (
    tag_id INT PRIMARY KEY,
    tag_name VARCHAR(50) NOT NULL,
    transaction_id INT NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id) ON UPDATE CASCADE ON DELETE Restrict
);



-- Categories table
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    category_description VARCHAR(255),
    transaction_id INT NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id) ON UPDATE CASCADE ON DELETE Restrict
);

-- Budget table
CREATE TABLE IF NOT EXISTS Budget (
    budget_id INT PRIMARY KEY,
    Amount DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    notification_threshold DECIMAL(10,2) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON UPDATE CASCADE ON DELETE Restrict
);



-- Notifications table
CREATE TABLE IF NOT EXISTS Notifications (
    notification_id INT PRIMARY KEY,
    `repeat` VARCHAR(50) NOT NULL,
    notification_time TIME NOT NULL,
    notification_date DATE NOT NULL,
    Message VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    budget_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON UPDATE CASCADE ON DELETE Restrict,
    FOREIGN KEY (budget_id) REFERENCES Budget(budget_id) ON UPDATE Cascade
                           ON DELETE RESTRICT
);


-- Groups table
INSERT INTO `Groups` (group_id, admin_user_id)
VALUES
    (1, 1),
    (2, 2);


-- User table
INSERT INTO User (user_id, group_id, Email, first_name, middle_name, last_name, password)
VALUES
    (1, 1, 'john@example.com', 'John', NULL, 'Doe', 'password123'),
    (2, 1, 'jane@example.com', 'Jane', NULL, 'Smith', 'qwerty'),
    (3, 2, 'bob@example.com', 'Bob', 'A', 'Johnson', 'pass123');


-- Investments table
INSERT INTO Investments (investment_id, stock_name, purchase_date, investment_type, user_id)
VALUES
    (1, 'Apple Inc.', '2023-01-15', 'Stock', 1),
    (2, 'Tesla Inc.', '2023-02-20', 'Stock', 2),
    (3, 'Amazon.com Inc.', '2023-03-10', 'Stock', 3);

-- Spending goals table
INSERT INTO Spending_goals (goal_id, current_amount, target_amount, Month, user_id)
VALUES
    (1, 500.00, 1000.00, 'April', 1),
    (2, 250.00, 500.00, 'April', 2),
    (3, 1000.00, 2000.00, 'April', 3);


-- Store table
INSERT INTO Store (store_id, store_name, zip_code, street_address, city, state)
VALUES
    (1, 'Walmart', '12345', '123 Main St', 'Anytown', 'NY'),
    (2, 'Best Buy', '54321', '456 Elm St', 'Sometown', 'CA'),
    (3, 'Amazon', '67890', '789 Oak St', 'Othercity', 'TX');

-- Receipts table
INSERT INTO Receipts (receipt_id, Date, total_amount, user_id, store_id)
VALUES
    (1, '2023-01-20', 150.00, 1, 1),
    (2, '2023-02-25', 200.00, 2, 2),
    (3, '2023-03-12', 300.00, 3, 3);


-- Transactions table
INSERT INTO Transactions (transaction_id, unit_cost, quantity, receipt_id)
VALUES
    (1, 50.00, 3, 1),
    (2, 100.00, 2, 2),
    (3, 50.00, 6, 3);

-- Tag table
INSERT INTO Tag (tag_id, tag_name, transaction_id)
VALUES
    (1, 'Food', 1),
    (2, 'Electronics', 2),
    (3, 'Clothing', 3);

-- Categories table
INSERT INTO Categories (category_id, category_name, category_description, transaction_id)
VALUES
    (1, 'Groceries', 'Monthly grocery shopping', 1),
    (2, 'Electronics', 'New laptop', 2),
    (3, 'Clothing', 'Spring wardrobe update', 3);

-- Budget table
INSERT INTO Budget (budget_id, Amount, start_date, end_date, notification_threshold, category_id)
VALUES
    (1, 500.00, '2023-01-01', '2023-12-31', 100.00, 1),
    (2, 1000.00, '2023-01-01', '2023-12-31', 200.00, 2),
    (3, 200.00, '2023-01-01', '2023-12-31', 50.00, 3);


-- Notifications table
INSERT INTO Notifications (notification_id, `repeat`, notification_time, notification_date, Message, user_id, budget_id)
VALUES
    (1, 'Daily', '08:00:00', '2023-04-01', 'Budget reminder', 1, 1),
    (2, 'Weekly', '12:00:00', '2023-04-05', 'Budget update', 2, 2),
    (3, 'Monthly', '10:00:00', '2023-04-10', 'Budget report', 3, 3);
