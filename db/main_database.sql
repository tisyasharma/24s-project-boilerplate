-- This file is to bootstrap a database for the CS3200 project.

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith
-- data source creation.
create database IF NOT EXISTS FinanceAppDatabase;

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
    group_name VARCHAR(255) NOT NULL,
    group_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_user_id INT NOT NULL
);

-- User table
CREATE TABLE IF NOT EXISTS Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    group_id INT,
    Email VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    FOREIGN KEY (group_id) REFERENCES `Groups`(group_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Investments table
CREATE TABLE IF NOT EXISTS Investments (
    investment_id INT PRIMARY KEY AUTO_INCREMENT,
    stock_name VARCHAR(100) NOT NULL,
    purchase_date DATE NOT NULL,
    investment_type VARCHAR(50) NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Store table
CREATE TABLE IF NOT EXISTS Stores (
    store_id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(100) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
);

-- Tag table
CREATE TABLE IF NOT EXISTS Tags (
    tag_id INT PRIMARY KEY AUTO_INCREMENT,
    tag_name VARCHAR(50) NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Categories table
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    category_description VARCHAR(255) UNIQUE
);

-- Receipts table
CREATE TABLE IF NOT EXISTS Receipts (
    receipt_id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    user_id INT NOT NULL,
    store_id INT NOT NULL,
    tag_id INT,
    category_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (store_id) REFERENCES Stores(store_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)  ON UPDATE CASCADE ON DELETE CASCADE
);

-- Transactions table
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    unit_cost DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    receipt_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (receipt_id) REFERENCES Receipts(receipt_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Notifications table
CREATE TABLE IF NOT EXISTS Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    `repeat` VARCHAR(50) NOT NULL,
    notification_time TIME NOT NULL,
    notification_date DATE NOT NULL,
    Message VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    budget_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE CASCADE

);
-- Spending goals table
CREATE TABLE IF NOT EXISTS Spending_goals (
    goal_id INT PRIMARY KEY AUTO_INCREMENT,
    current_amount DECIMAL(10,2) NOT NULL,
    target_amount DECIMAL(10,2) NOT NULL,
    Month VARCHAR(10) NOT NULL,
    user_id INT NOT NULL,
    notification_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (notification_id) REFERENCES Notifications(notification_id) ON UPDATE CASCADE
                           ON DELETE CASCADE
);

-- Budget table
CREATE TABLE IF NOT EXISTS Budgets (
    budget_id INT PRIMARY KEY AUTO_INCREMENT,
    Amount DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    notification_threshold DECIMAL(10,2) NOT NULL,
    category_id INT,
    notification_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (notification_id) REFERENCES Notifications(notification_id) ON UPDATE Cascade
                           ON DELETE CASCADE
);

INSERT INTO Categories (category_name, category_description)
VALUES
    ('Groceries', 'Monthly grocery shopping'),
    ('Electronics', 'New laptop'),
    ('Clothing', 'Spring wardrobe update');

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
INSERT INTO Users (group_id, Email, first_name, middle_name, last_name, password)
VALUES
    (1, 'john@example.com', 'John', NULL, 'Doe', 'password123'),
    (1, 'jane@example.com', 'Jane', NULL, 'Smith', 'qwerty'),
    (2, 'bob@example.com', 'Bob', 'A', 'Johnson', 'pass123')
    (2, 'alice.williams@gmail.com', 'Alice', 'B', 'Williams', 'mountainpeak82'),
    (3, 'carlos.martinez@yahoo.com', 'Carlos', NULL, 'Martinez', 'forestwalker99'),
    (3, 'lisa.brown@hotmail.com', 'Lisa', 'C', 'Brown', 'silverlake412'),
    (4, 'mike.wilson@gmail.com', 'Mike', NULL, 'Wilson', 'blueocean202'),
    (4, 'sarah.moore@hotmail.com', 'Sarah', 'D', 'Moore', 'greenmeadow247'),
    (5, 'chris.taylor@yahoo.com', 'Chris', NULL, 'Taylor', 'crimsonsky308'),
    (5, 'pat.anderson@gmail.com', 'Pat', 'E', 'Anderson', 'goldensun531'),
    (6, 'terry.thomas@gmail.com', 'Terry', NULL, 'Thomas', 'whitewave773'),
    (6, 'susan.jackson@hotmail.com', 'Susan', 'F', 'Jackson', 'purplefog224'),
    (7, 'frank.white@yahoo.com', 'Frank', NULL, 'White', 'icybrook359'),
    (7, 'betty.harris@gmail.com', 'Betty', 'G', 'Harris', 'starrynight406'),
    (8, 'joe.martin@hotmail.com', 'Joe', NULL, 'Martin', 'quietstream918'),
    (8, 'emma.thompson@gmail.com', 'Emma', 'H', 'Thompson', 'deepvalley267'),
    (9, 'danny.garcia@yahoo.com', 'Danny', NULL, 'Garcia', 'rockyridge854'),
    (9, 'olivia.martinez@gmail.com', 'Olivia', 'I', 'Martinez', 'smoothstone119'),
    (10, 'nick.robinson@hotmail.com', 'Nick', NULL, 'Robinson', 'clearwater638'),
    (10, 'helen.clark@gmail.com', 'Helen', 'J', 'Clark', 'brightmoon472'),
    (11, 'jim.lewis@hotmail.com', 'Jim', NULL, 'Lewis', 'silentwind290'),
    (11, 'grace.lee@yahoo.com', 'Grace', 'K', 'Lee', 'roaringlion856'),
    (12, 'kevin.walker@gmail.com', 'Kevin', NULL, 'Walker', 'floatingclouds495'),
    (12, 'julia.hall@hotmail.com', 'Julia', 'L', 'Hall', 'glimmeringstar123'),
    (13, 'ed.allen@yahoo.com', 'Ed', NULL, 'Allen', 'fierysunset709'),
    (13, 'meg.young@gmail.com', 'Meg', 'M', 'Young', 'chillwave456'),
    (14, 'don.hernandez@hotmail.com', 'Don', NULL, 'Hernandez', 'glowingdawn537'),
    (14, 'kate.king@gmail.com', 'Kate', 'N', 'King', 'thunderbolt281'),
    (15, 'alex.wright@hotmail.com', 'Alex', NULL, 'Wright', 'quietforest629'),
    (15, 'nina.lopez@yahoo.com', 'Nina', 'O', 'Lopez', 'mysticriver874'),
    (16, 'ron.hill@gmail.com', 'Ron', NULL, 'Hill', 'hiddenmeadow390'),
    (16, 'elsa.scott@hotmail.com', 'Elsa', 'P', 'Scott', 'goldenray532'),
    (17, 'victor.green@yahoo.com', 'Victor', NULL, 'Green', 'stormysea418'),
    (17, 'tina.adams@gmail.com', 'Tina', 'Q', 'Adams', 'peacefulcove207'),
    (18, 'phil.baker@hotmail.com', 'Phil', NULL, 'Baker', 'crispfall264'),
    (18, 'lucy.gonzalez@gmail.com', 'Lucy', 'R', 'Gonzalez', 'lushvalley885'),
    (19, 'ted.nelson@yahoo.com', 'Ted', NULL, 'Nelson', 'rapidstream981'),
    (19, 'rita.carter@gmail.com', 'Rita', 'S', 'Carter', 'sparklinglake143'),
    (20, 'max.mitchell@hotmail.com', 'Max', NULL, 'Mitchell', 'quietmorning634'),
    (20, 'fay.perez@yahoo.com', 'Fay', 'T', 'Perez', 'hazyshade190'),
    (21, 'hank.roberts@gmail.com', 'Hank', NULL, 'Roberts', 'earlydew216'),
    (21, 'dora.evans@hotmail.com', 'Dora', 'U', 'Evans', 'silvermist308'),
    (22, 'jerry.turner@gmail.com', 'Jerry', NULL, 'Turner', 'frozenpeak452'),
    (22, 'gina.torres@yahoo.com', 'Gina', 'V', 'Torres', 'wildwind673'),
    (23, 'kyle.parker@hotmail.com', 'Kyle', NULL, 'Parker', 'serenesnow857'),
    (23, 'lou.collins@gmail.com', 'Lou', 'W', 'Collins', 'dawnchorus924'),
    (24, 'neal.edwards@yahoo.com', 'Neal', NULL, 'Edwards', 'autumnleaf315');

-- Investments table
INSERT INTO Investments (stock_name, purchase_date, investment_type, user_id)
VALUES
    ('Apple Inc.', '2023-01-15', 'Stock', 1),
    ('Tesla Inc.', '2023-02-20', 'Stock', 2),
    ('Amazon.com Inc.', '2023-03-10', 'Stock', 3),
    ('Google LLC', '2023-01-25', 'Stock', 4),
    ('Microsoft Corp.', '2023-02-28', 'Stock', 5),
    ('Netflix Inc.', '2023-03-15', 'Stock', 7),
    ('Facebook Inc.', '2023-01-05', 'Stock', 7),
    ('Adobe Systems Inc.', '2023-02-12', 'Stock', 8),
    ('Intel Corp.', '2023-03-22', 'Stock', 9),
    ('NVIDIA Corp.', '2023-01-18', 'Stock', 10),
    ('Oracle Corp.', '2023-02-23', 'Stock', 11),
    ('Qualcomm Inc.', '2023-03-30', 'Stock', 12),
    ('Advanced Micro Devices', '2023-01-10', 'Stock', 13),
    ('eBay Inc.', '2023-02-15', 'Stock', 14),
    ('Twitter Inc.', '2023-03-19', 'Stock', 15),
    ('Uber Technologies Inc.', '2023-01-20', 'Stock', 16),
    ('Spotify Technology SA', '2023-02-25', 'Stock', 17),
    ('Snap Inc.', '2023-03-05', 'Stock', 18),
    ('Zoom Video Communications', '2023-01-30', 'Stock', 19),
    ('Pfizer Inc.', '2023-02-05', 'Stock', 19),
    ('Johnson & Johnson', '2023-03-25', 'Stock', 21),
    ('Moderna Inc.', '2023-01-08', 'Stock', 22),
    ('Gilead Sciences Inc.', '2023-02-10', 'Stock', 23),
    ('Biogen Inc.', '2023-03-15', 'Stock', 24),
    ('Tesla Inc.', '2023-02-19', 'Bond', 25),
    ('Apple Inc.', '2023-03-17', 'Bond', 26),
    ('Amazon.com Inc.', '2023-01-23', 'Bond', 27),
    ('Google LLC', '2023-02-27', 'Bond', 28),
    ('Microsoft Corp.', '2023-03-12', 'Bond', 29),
    ('Facebook Inc.', '2023-01-15', 'ETF', 30),
    ('Intel Corp.', '2023-02-18', 'ETF', 32),
    ('Oracle Corp.', '2023-03-21', 'ETF', 32),
    ('NVIDIA Corp.', '2023-01-29', 'Bond', 33),
    ('Advanced Micro Devices', '2023-02-16', 'Bond', 34),
    ('Twitter Inc.', '2023-03-14', 'ETF', 35),
    ('Uber Technologies Inc.', '2023-01-22', 'ETF', 36),
    ('Spotify Technology SA', '2023-02-26', 'Bond', 36),
    ('Snap Inc.', '2023-03-09', 'Bond', 38),
    ('Zoom Video Communications', '2023-01-11', 'ETF', 39),
    ('Pfizer Inc.', '2023-02-01', 'ETF', 40),
    ('Johnson & Johnson', '2023-03-18', 'ETF', 41),
    ('Moderna Inc.', '2023-01-14', 'Bond', 41),
    ('Gilead Sciences Inc.', '2023-02-11', 'Bond', 43),
    ('Biogen Inc.', '2023-03-20', 'ETF', 44),
    ('Adobe Systems Inc.', '2023-01-19', 'Bond', 45),
    ('eBay Inc.', '2023-02-24', 'Bond', 47),
    ('Qualcomm Inc.', '2023-03-07', 'ETF', 47);

-- Spending goals table
INSERT INTO Spending_goals (current_amount, target_amount, Month, user_id)
VALUES
    (500.00, 1000.00, 'April', 1),
    (250.00, 500.00, 'April', 2),
    (1000.00, 2000.00, 'April', 3),
    (410.00, 820.00, 'April', 10),
    (500.00, 750.00, 'April', 1),
    (240.00, 480.00, 'April', 15),
    (330.00, 990.00, 'April', 18),
    (150.00, 450.00, 'April', 20),
    (260.00, 780.00, 'April', 22),
    (350.00, 700.00, 'April', 25),
    (220.00, 440.00, 'April', 26),
    (115.00, 345.00, 'April', 30),
    (175.00, 525.00, 'April', 30),
    (420.00, 840.00, 'April', 34),
    (390.00, 780.00, 'April', 35),
    (460.00, 920.00, 'April', 37),
    (510.00, 1020.00, 'April', 2),
    (300.00, 900.00, 'April', 4),
    (600.00, 1200.00, 'April', 5),
    (123.00, 246.00, 'April', 7),
    (234.00, 468.00, 'April', 9),
    (567.00, 1134.00, 'April', 11),
    (789.00, 1578.00, 'April', 12),
    (345.00, 690.00, 'April', 12),
    (456.00, 912.00, 'April', 14),
    (198.00, 396.00, 'April', 16),
    (210.00, 420.00, 'April', 17),
    (250.00, 500.00, 'April', 19),
    (275.00, 550.00, 'April', 21),
    (325.00, 650.00, 'April', 23),
    (375.00, 750.00, 'April', 24),
    (425.00, 850.00, 'April', 27),
    (475.00, 950.00, 'April', 28),
    (108.00, 216.00, 'April', 29),
    (519.00, 1038.00, 'April', 31),
    (603.00, 1206.00, 'April', 32),
    (490.00, 980.00, 'April', 36),
    (580.00, 1160.00, 'April', 38),
    (670.00, 1340.00, 'April', 39),
    (760.00, 1520.00, 'April', 40),
    (850.00, 1700.00, 'April', 41),
    (940.00, 1880.00, 'April', 42),
    (150.00, 300.00, 'April', 43),
    (245.00, 490.00, 'April', 44),
    (350.00, 700.00, 'April', 45),
    (455.00, 910.00, 'April', 45),
    (560.00, 1120.00, 'April', 45),
    (665.00, 1330.00, 'April', 12),
    (770.00, 1540.00, 'April', 11),
    (875.00, 1750.00, 'April', 3),
    (980.00, 1960.00, 'April', 9),
    (190.00, 380.00, 'April', 6),
    (295.00, 590.00, 'April', 14),
    (400.00, 800.00, 'April', 28),
    (505.00, 1010.00, 'April', 23),
    (610.00, 1220.00, 'April', 17),
    (715.00, 1430.00, 'April', 27),
    (820.00, 1640.00, 'April', 25),
    (925.00, 1850.00, 'April', 32);

-- Stores table
INSERT INTO Stores (store_name, zip_code, street_address, city, state)
VALUES
    ('Grocery Outlet', '94102', '123 Market St', 'San Francisco', 'California'),
    ('Whole Foods', '98101', '202 Pike St', 'Seattle', 'Washington'),
    ('Trader Joe\'s', '75201', '303 Elm St', 'Dallas', 'Texas'),
    ('Safeway', '33101', '505 First St', 'Miami', 'Florida'),
    ('Walmart', '10001', '101 Main St', 'New York', 'New York'),
    ('Staples', '02101', '250 Broadway St', 'Boston', 'Massachusetts'),
    ('Office Depot', '60601', '350 Lake St', 'Chicago', 'Illinois'),
    ('Barnes & Noble', '90001', '450 Main St', 'Los Angeles', 'California'),
    ('GameStop', '37201', '550 Church St', 'Nashville', 'Tennessee'),
    ('AMC Theatres', '19101', '600 Market St', 'Philadelphia', 'Pennsylvania'),
    ('Grocery Outlet', '94103', '200 Valencia St', 'San Francisco', 'California'),
    ('Whole Foods', '98105', '404 University St', 'Seattle', 'Washington'),
    ('Trader Joe\'s', '75207', '708 Elm St', 'Dallas', 'Texas'),
    ('Safeway', '33139', '850 Collins Ave', 'Miami Beach', 'Florida'),
    ('Walmart', '10011', '202 5th Ave', 'New York', 'New York'),
    ('Staples', '02210', '177 Seaport Blvd', 'Boston', 'Massachusetts'),
    ('Office Depot', '60614', '1234 Lincoln Ave', 'Chicago', 'Illinois'),
    ('Barnes & Noble', '90015', '765 Figueroa St', 'Los Angeles', 'California'),
    ('GameStop', '37209', '321 Charlotte Ave', 'Nashville', 'Tennessee'),
    ('AMC Theatres', '19103', '2001 Market St', 'Philadelphia', 'Pennsylvania'),
    ('Grocery Outlet', '94110', '1500 Mission St', 'San Francisco', 'California'),
    ('Whole Foods', '98109', '500 Mercer St', 'Seattle', 'Washington'),
    ('Trader Joe\'s', '75219', '4001 Cedar Springs Rd', 'Dallas', 'Texas'),
    ('Safeway', '33140', '4301 Alton Rd', 'Miami Beach', 'Florida'),
    ('Walmart', '10023', '808 Columbus Ave', 'New York', 'New York'),
    ('Staples', '02118', '401 Park Dr', 'Boston', 'Massachusetts'),
    ('Office Depot', '60647', '2740 N Ashland Ave', 'Chicago', 'Illinois'),
    ('Barnes & Noble', '90028', '6801 Hollywood Blvd', 'Los Angeles', 'California'),
    ('GameStop', '37211', '5333 Nolensville Pike', 'Nashville', 'Tennessee'),
    ('AMC Theatres', '19147', '1400 S Christopher Columbus Blvd', 'Philadelphia', 'Pennsylvania'),
    ('Grocery Outlet', '94117', '690 Stanyan St', 'San Francisco', 'California'),
    ('Whole Foods', '98115', '1026 NE 64th St', 'Seattle', 'Washington'),
    ('Trader Joe\'s', '75231', '8687 N Central Expy', 'Dallas', 'Texas'),
    ('Safeway', '33154', '9500 Harding Ave', 'Surfside', 'Florida'),
    ('Walmart', '10002', '400 Grand St', 'New York', 'New York'),
    ('Staples', '02115', '401 Park Dr', 'Boston', 'Massachusetts'),
    ('Office Depot', '60657', '3134 N Clark St', 'Chicago', 'Illinois'),
    ('Barnes & Noble', '90036', '189 The Grove Dr', 'Los Angeles', 'California'),
    ('GameStop', '37221', '7034 Charlotte Pike', 'Nashville', 'Tennessee'),
    ('AMC Theatres', '19123', '1001 N 2nd St', 'Philadelphia', 'Pennsylvania');

-- Receipts table
INSERT INTO Receipts (date, total_amount, user_id, store_id)
VALUES
    ('2023-01-01', 150.00, 1, 1),
    ('2023-01-02', 250.00, 2, 1),
    ('2023-01-03', 75.00, 3, 2),
    ('2023-01-04', 120.00, 4, 2),
    ('2023-01-05', 30.00, 5, 3),
    ('2023-01-06', 45.00, 6, 3),
    ('2023-01-07', 80.00, 7, 4),
    ('2023-01-08', 200.00, 8, 4),
    ('2023-01-09', 95.00, 9, 5),
    ('2023-01-10', 140.00, 10, 5),
    ('2023-01-11', 160.00, 1, 6),
    ('2023-01-12', 90.00, 2, 6),
    ('2023-01-13', 130.00, 3, 7),
    ('2023-01-14', 210.00, 4, 7),
    ('2023-01-15', 50.00, 5, 8),
    ('2023-01-16', 300.00, 6, 8),
    ('2023-01-17', 70.00, 7, 9),
    ('2023-01-18', 115.00, 8, 9),
    ('2023-01-19', 220.00, 9, 10),
    ('2023-01-20', 180.00, 10, 10),
    ('2023-01-21', 260.00, 1, 1),
    ('2023-01-22', 85.00, 2, 1),
    ('2023-01-23', 50.00, 3, 2),
    ('2023-01-24', 190.00, 4, 2),
    ('2023-01-25', 300.00, 5, 3),
    ('2023-01-26', 100.00, 6, 3),
    ('2023-01-27', 150.00, 7, 4),
    ('2023-01-28', 90.00, 8, 4),
    ('2023-01-29', 210.00, 9, 5),
    ('2023-01-30', 60.00, 10, 5),
    ('2023-01-31', 135.00, 1, 6),
    ('2023-02-01', 245.00, 2, 6),
    ('2023-02-02', 175.00, 3, 7),
    ('2023-02-03', 110.00, 4, 7),
    ('2023-02-04', 225.00, 5, 8),
    ('2023-02-05', 310.00, 6, 8),
    ('2023-02-06', 120.00, 7, 9),
    ('2023-02-07', 130.00, 8, 9),
    ('2023-02-08', 210.00, 9, 10),
    ('2023-02-09', 200.00, 10, 10),
    ('2023-02-10', 180.00, 1, 1),
    ('2023-02-11', 160.00, 2, 1),
    ('2023-02-12', 140.00, 3, 2),
    ('2023-02-13', 50.00, 4, 2),
    ('2023-02-14', 260.00, 5, 3),
    ('2023-02-15', 230.00, 6, 3),
    ('2023-02-16', 195.00, 7, 4),
    ('2023-02-17', 85.00, 8, 4),
    ('2023-02-18', 70.00, 9, 5),
    ('2023-02-19', 95.00, 10, 5),
    ('2023-02-20', 220.00, 1, 6),
    ('2023-02-21', 90.00, 2, 6),
    ('2023-02-22', 145.00, 3, 7),
    ('2023-02-23', 105.00, 4, 7),
    ('2023-02-24', 155.00, 5, 8),
    ('2023-02-25', 240.00, 6, 8),
    ('2023-02-26', 190.00, 7, 9),
    ('2023-02-27', 150.00, 8, 9),
    ('2023-02-28', 85.00, 9, 10),
    ('2023-03-01', 200.00, 10, 10);

-- Transactions table
INSERT INTO Transactions (transaction_id, unit_cost, quantity, receipt_id)
VALUES
    (1, 50.00, 3, 1),
    (2, 100.00, 2, 2),
    (3, 50.00, 6, 3);

-- Tag table
INSERT INTO Tag (tag_id, tag_name, transaction_id, user_id)
VALUES
    (1, 'Food', 1, 1),
    (2, 'Electronics', 2,1),
    (3, 'Clothing', 3,2);

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
