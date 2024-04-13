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
    (1, 1), (2, 2),(3, 3), (4, 4), (5, 5), (6, 6), 
    (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), 
    (12, 12), (13, 13), (14, 14), (15, 15),
    (16, 16), (17, 17), (18, 18), (19, 19), (20, 20),
    (21, 21), (22, 22), (23, 23), (24, 24), (25, 25), 
    (26, 26), (27, 27), (28, 28), (29, 29), (30, 30),
    (31, 31), (32, 32), (33, 33), (34, 34), (35, 35),
    (36, 36), (37, 37), (38, 38), (39, 39), (40, 40),
    (41, 41), (42, 42), (43, 43), (44, 44), (45, 45),
    (46, 46), (47, 47);


-- User table
INSERT INTO User (user_id, group_id, Email, first_name, middle_name, last_name, password)
VALUES
    (1, 1, 'john@example.com', 'John', NULL, 'Doe', 'password123'),
    (2, 1, 'jane@example.com', 'Jane', NULL, 'Smith', 'qwerty'),
    (3, 2, 'bob@example.com', 'Bob', 'A', 'Johnson', 'pass123')
    (4, 2, 'alice.williams@gmail.com', 'Alice', 'B', 'Williams', 'mountainpeak82'),
    (5, 3, 'carlos.martinez@yahoo.com', 'Carlos', NULL, 'Martinez', 'forestwalker99'),
    (6, 3, 'lisa.brown@hotmail.com', 'Lisa', 'C', 'Brown', 'silverlake412'),
    (7, 4, 'mike.wilson@gmail.com', 'Mike', NULL, 'Wilson', 'blueocean202'),
    (8, 4, 'sarah.moore@hotmail.com', 'Sarah', 'D', 'Moore', 'greenmeadow247'),
    (9, 5, 'chris.taylor@yahoo.com', 'Chris', NULL, 'Taylor', 'crimsonsky308'),
    (10, 5, 'pat.anderson@gmail.com', 'Pat', 'E', 'Anderson', 'goldensun531'),
    (11, 6, 'terry.thomas@gmail.com', 'Terry', NULL, 'Thomas', 'whitewave773'),
    (12, 6, 'susan.jackson@hotmail.com', 'Susan', 'F', 'Jackson', 'purplefog224'),
    (13, 7, 'frank.white@yahoo.com', 'Frank', NULL, 'White', 'icybrook359'),
    (14, 7, 'betty.harris@gmail.com', 'Betty', 'G', 'Harris', 'starrynight406'),
    (15, 8, 'joe.martin@hotmail.com', 'Joe', NULL, 'Martin', 'quietstream918'),
    (16, 8, 'emma.thompson@gmail.com', 'Emma', 'H', 'Thompson', 'deepvalley267'),
    (17, 9, 'danny.garcia@yahoo.com', 'Danny', NULL, 'Garcia', 'rockyridge854'),
    (18, 9, 'olivia.martinez@gmail.com', 'Olivia', 'I', 'Martinez', 'smoothstone119'),
    (19, 10, 'nick.robinson@hotmail.com', 'Nick', NULL, 'Robinson', 'clearwater638'),
    (20, 10, 'helen.clark@gmail.com', 'Helen', 'J', 'Clark', 'brightmoon472'),
    (21, 11, 'jim.lewis@hotmail.com', 'Jim', NULL, 'Lewis', 'silentwind290'),
    (22, 11, 'grace.lee@yahoo.com', 'Grace', 'K', 'Lee', 'roaringlion856'),
    (23, 12, 'kevin.walker@gmail.com', 'Kevin', NULL, 'Walker', 'floatingclouds495'),
    (24, 12, 'julia.hall@hotmail.com', 'Julia', 'L', 'Hall', 'glimmeringstar123'),
    (25, 13, 'ed.allen@yahoo.com', 'Ed', NULL, 'Allen', 'fierysunset709'),
    (26, 13, 'meg.young@gmail.com', 'Meg', 'M', 'Young', 'chillwave456'),
    (27, 14, 'don.hernandez@hotmail.com', 'Don', NULL, 'Hernandez', 'glowingdawn537'),
    (28, 14, 'kate.king@gmail.com', 'Kate', 'N', 'King', 'thunderbolt281'),
    (29, 15, 'alex.wright@hotmail.com', 'Alex', NULL, 'Wright', 'quietforest629'),
    (30, 15, 'nina.lopez@yahoo.com', 'Nina', 'O', 'Lopez', 'mysticriver874'),
    (31, 16, 'ron.hill@gmail.com', 'Ron', NULL, 'Hill', 'hiddenmeadow390'),
    (32, 16, 'elsa.scott@hotmail.com', 'Elsa', 'P', 'Scott', 'goldenray532'),
    (33, 17, 'victor.green@yahoo.com', 'Victor', NULL, 'Green', 'stormysea418'),
    (34, 17, 'tina.adams@gmail.com', 'Tina', 'Q', 'Adams', 'peacefulcove207'),
    (35, 18, 'phil.baker@hotmail.com', 'Phil', NULL, 'Baker', 'crispfall264'),
    (36, 18, 'lucy.gonzalez@gmail.com', 'Lucy', 'R', 'Gonzalez', 'lushvalley885'),
    (37, 19, 'ted.nelson@yahoo.com', 'Ted', NULL, 'Nelson', 'rapidstream981'),
    (38, 19, 'rita.carter@gmail.com', 'Rita', 'S', 'Carter', 'sparklinglake143'),
    (39, 20, 'max.mitchell@hotmail.com', 'Max', NULL, 'Mitchell', 'quietmorning634'),
    (40, 20, 'fay.perez@yahoo.com', 'Fay', 'T', 'Perez', 'hazyshade190'),
    (41, 21, 'hank.roberts@gmail.com', 'Hank', NULL, 'Roberts', 'earlydew216'),
    (42, 21, 'dora.evans@hotmail.com', 'Dora', 'U', 'Evans', 'silvermist308'),
    (43, 22, 'jerry.turner@gmail.com', 'Jerry', NULL, 'Turner', 'frozenpeak452'),
    (44, 22, 'gina.torres@yahoo.com', 'Gina', 'V', 'Torres', 'wildwind673'),
    (45, 23, 'kyle.parker@hotmail.com', 'Kyle', NULL, 'Parker', 'serenesnow857'),
    (46, 23, 'lou.collins@gmail.com', 'Lou', 'W', 'Collins', 'dawnchorus924'),
    (47, 24, 'neal.edwards@yahoo.com', 'Neal', NULL, 'Edwards', 'autumnleaf315');


-- Investments table
INSERT INTO Investments (investment_id, stock_name, purchase_date, investment_type, user_id)
VALUES
    (1, 'Apple Inc.', '2023-01-15', 'Stock', 1),
    (2, 'Tesla Inc.', '2023-02-20', 'Stock', 2),
    (3, 'Amazon.com Inc.', '2023-03-10', 'Stock', 3)
    (4, 'Google LLC', '2023-01-25', 'Stock', 4),
    (5, 'Microsoft Corp.', '2023-02-28', 'Stock', 5),
    (6, 'Netflix Inc.', '2023-03-15', 'Stock', 7),
    (7, 'Facebook Inc.', '2023-01-05', 'Stock', 7),
    (8, 'Adobe Systems Inc.', '2023-02-12', 'Stock', 8),
    (9, 'Intel Corp.', '2023-03-22', 'Stock', 9),
    (10, 'NVIDIA Corp.', '2023-01-18', 'Stock', 10),
    (11, 'Oracle Corp.', '2023-02-23', 'Stock', 11),
    (12, 'Qualcomm Inc.', '2023-03-30', 'Stock', 12),
    (13, 'Advanced Micro Devices', '2023-01-10', 'Stock', 13),
    (14, 'eBay Inc.', '2023-02-15', 'Stock', 14),
    (15, 'Twitter Inc.', '2023-03-19', 'Stock', 15),
    (16, 'Uber Technologies Inc.', '2023-01-20', 'Stock', 16),
    (17, 'Spotify Technology SA', '2023-02-25', 'Stock', 17),
    (18, 'Snap Inc.', '2023-03-05', 'Stock', 18),
    (19, 'Zoom Video Communications', '2023-01-30', 'Stock', 19),
    (20, 'Pfizer Inc.', '2023-02-05', 'Stock', 19),
    (21, 'Johnson & Johnson', '2023-03-25', 'Stock', 21),
    (22, 'Moderna Inc.', '2023-01-08', 'Stock', 22),
    (23, 'Gilead Sciences Inc.', '2023-02-10', 'Stock', 23),
    (24, 'Biogen Inc.', '2023-03-15', 'Stock', 24),
    (25, 'Tesla Inc.', '2023-02-19', 'Bond', 25),
    (26, 'Apple Inc.', '2023-03-17', 'Bond', 26),
    (27, 'Amazon.com Inc.', '2023-01-23', 'Bond', 27),
    (28, 'Google LLC', '2023-02-27', 'Bond', 28),
    (29, 'Microsoft Corp.', '2023-03-12', 'Bond', 29),
    (30, 'Facebook Inc.', '2023-01-15', 'ETF', 30),
    (31, 'Intel Corp.', '2023-02-18', 'ETF', 32),
    (32, 'Oracle Corp.', '2023-03-21', 'ETF', 32),
    (33, 'NVIDIA Corp.', '2023-01-29', 'Bond', 33),
    (34, 'Advanced Micro Devices', '2023-02-16', 'Bond', 34),
    (35, 'Twitter Inc.', '2023-03-14', 'ETF', 35),
    (36, 'Uber Technologies Inc.', '2023-01-22', 'ETF', 36),
    (37, 'Spotify Technology SA', '2023-02-26', 'Bond', 36),
    (38, 'Snap Inc.', '2023-03-09', 'Bond', 38),
    (39, 'Zoom Video Communications', '2023-01-11', 'ETF', 39),
    (40, 'Pfizer Inc.', '2023-02-01', 'ETF', 40),
    (41, 'Johnson & Johnson', '2023-03-18', 'ETF', 41),
    (42, 'Moderna Inc.', '2023-01-14', 'Bond', 41),
    (43, 'Gilead Sciences Inc.', '2023-02-11', 'Bond', 43),
    (44, 'Biogen Inc.', '2023-03-20', 'ETF', 44),
    (45, 'Adobe Systems Inc.', '2023-01-19', 'Bond', 45),
    (46, 'eBay Inc.', '2023-02-24', 'Bond', 47),
    (47, 'Qualcomm Inc.', '2023-03-07', 'ETF', 47);

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
