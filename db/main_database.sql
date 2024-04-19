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
    email VARCHAR(255) NOT NULL,
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
    notification_time VARCHAR(255) NOT NULL,
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
    amount DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    notification_threshold DECIMAL(10,2),
    category_id INT,
    notification_id INT,
    user_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (notification_id) REFERENCES Notifications(notification_id) ON UPDATE CASCADE
                           ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users( user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Seed data generation for the database

-- Insert 50 rows into Groups table
INSERT INTO `Groups` (group_name, admin_user_id)
VALUES
('Family', 1),
('Friends', 2),
('Work', 3),
('Gym Buddies', 4),
('College Mates', 5),
('Neighborhood', 6),
('Book Club', 7),
('Music Band', 8),
('Art Society', 9),
('Volunteers', 10),
('Travelers', 11),
('Hikers', 12),
('Food Lovers', 13),
('Investors', 14),
('Fitness Enthusiasts', 15),
('Pet Owners', 16),
('Tech Enthusiasts', 17),
('Car Club', 18),
('Gaming Group', 19),
('Adventure Seekers', 20),
('Photographers', 21),
('Crafters', 22),
('Fashionistas', 23),
('Bloggers', 24),
('Meditation Group', 25),
('Entrepreneurs', 26),
('Gardening Club', 27),
('Motorcycle Club', 28),
('Dancers', 29),
('Sports Fans', 30),
('Yogis', 31),
('Movie Buffs', 32),
('Wine Tasters', 33),
('Cycling Club', 34),
('Outdoor Enthusiasts', 35),
('Readers', 36),
('Writers', 37),
('Home Chefs', 38),
('Ski Club', 39),
('Snowboarders', 40),
('Fitness Trainers', 41),
('Beach Lovers', 42),
('Horse Riders', 43),
('Fishermen', 44),
('Bird Watchers', 45),
('Martial Arts Club', 46),
('Chess Players', 47),
('Golfers', 48),
('Collectors', 49),
('Green Thumbs', 50);

-- Insert 50 rows into Users table
INSERT INTO Users (group_id, email, first_name, middle_name, last_name, password)
VALUES
(1, 'user1@example.com', 'John', 'A.', 'Smith', 'password123'),
(2, 'user2@example.com', 'Mary', 'B.', 'Johnson', 'password123'),
(3, 'user3@example.com', 'James', 'C.', 'Brown', 'password123'),
(4, 'user4@example.com', 'Emma', 'D.', 'Jones', 'password123'),
(5, 'user5@example.com', 'Robert', 'E.', 'Miller', 'password123'),
(6, 'user6@example.com', 'Olivia', 'F.', 'Davis', 'password123'),
(7, 'user7@example.com', 'William', 'G.', 'Garcia', 'password123'),
(8, 'user8@example.com', 'Sophia', 'H.', 'Rodriguez', 'password123'),
(9, 'user9@example.com', 'Benjamin', 'I.', 'Martinez', 'password123'),
(10, 'user10@example.com', 'Charlotte', 'J.', 'Lopez', 'password123'),
(11, 'user11@example.com', 'Daniel', 'K.', 'Wilson', 'password123'),
(12, 'user12@example.com', 'Amelia', 'L.', 'Moore', 'password123'),
(13, 'user13@example.com', 'Logan', 'M.', 'Taylor', 'password123'),
(14, 'user14@example.com', 'Mia', 'N.', 'Anderson', 'password123'),
(15, 'user15@example.com', 'Michael', 'O.', 'Thomas', 'password123'),
(16, 'user16@example.com', 'Harper', 'P.', 'Hernandez', 'password123'),
(17, 'user17@example.com', 'David', 'Q.', 'King', 'password123'),
(18, 'user18@example.com', 'Isabella', 'R.', 'Wright', 'password123'),
(19, 'user19@example.com', 'Matthew', 'S.', 'Hill', 'password123'),
(20, 'user20@example.com', 'Ella', 'T.', 'Scott', 'password123'),
(21, 'user21@example.com', 'Owen', 'U.', 'Green', 'password123'),
(22, 'user22@example.com', 'Grace', 'V.', 'Adams', 'password123'),
(23, 'user23@example.com', 'Jackson', 'W.', 'Baker', 'password123'),
(24, 'user24@example.com', 'Abigail', 'X.', 'Nelson', 'password123'),
(25, 'user25@example.com', 'Aiden', 'Y.', 'Carter', 'password123'),
(26, 'user26@example.com', 'Ava', 'Z.', 'Mitchell', 'password123'),
(27, 'user27@example.com', 'Ethan', 'AA.', 'Perez', 'password123'),
(28, 'user28@example.com', 'Emily', 'AB.', 'Roberts', 'password123'),
(29, 'user29@example.com', 'Alexander', 'AC.', 'Turner', 'password123'),
(30, 'user30@example.com', 'Samantha', 'AD.', 'Phillips', 'password123'),
(31, 'user31@example.com', 'Mason', 'AE.', 'Campbell', 'password123'),
(32, 'user32@example.com', 'Hannah', 'AF.', 'Parker', 'password123'),
(33, 'user33@example.com', 'Jameson', 'AG.', 'Evans', 'password123'),
(34, 'user34@example.com', 'Madison', 'AH.', 'Edwards', 'password123'),
(35, 'user35@example.com', 'Noah', 'AI.', 'Collins', 'password123'),
(36, 'user36@example.com', 'Evelyn', 'AJ.', 'Stewart', 'password123'),
(37, 'user37@example.com', 'Liam', 'AK.', 'Sanchez', 'password123'),
(38, 'user38@example.com', 'Chloe', 'AL.', 'Morris', 'password123'),
(39, 'user39@example.com', 'Carter', 'AM.', 'Rogers', 'password123'),
(40, 'user40@example.com', 'Avery', 'AN.', 'Reed', 'password123'),
(41, 'user41@example.com', 'Wyatt', 'AO.', 'Cook', 'password123'),
(42, 'user42@example.com', 'Zoe', 'AP.', 'Morgan', 'password123'),
(43, 'user43@example.com', 'Jackson', 'AQ.', 'Bell', 'password123'),
(44, 'user44@example.com', 'Leah', 'AR.', 'Murphy', 'password123'),
(45, 'user45@example.com', 'Jayden', 'AS.', 'Bailey', 'password123'),
(46, 'user46@example.com', 'Ella', 'AT.', 'Rivera', 'password123'),
(47, 'user47@example.com', 'Elijah', 'AU.', 'Cooper', 'password123'),
(48, 'user48@example.com', 'Camila', 'AV.', 'Richardson', 'password123'),
(49, 'user49@example.com', 'Lincoln', 'AW.', 'Cox', 'password123'),
(50, 'user50@example.com', 'Sophia', 'AX.', 'James', 'password123');


-- Insert 50 rows into Investments table
INSERT INTO Investments (stock_name, purchase_date, investment_type, user_id)
VALUES
('AAPL', '2023-01-01', 'Stock', 1),
('GOOG', '2023-02-15', 'Stock', 2),
('MSFT', '2023-03-10', 'Stock', 3),
('AMZN', '2023-01-20', 'Stock', 4),
('TSLA', '2023-02-05', 'Stock', 5),
('FB', '2023-03-25', 'Stock', 6),
('NFLX', '2023-01-10', 'Stock', 7),
('NVDA', '2023-02-20', 'Stock', 8),
('ORCL', '2023-03-30', 'Stock', 9),
('CSCO', '2023-01-05', 'Stock', 10),
('BABA', '2023-02-10', 'Stock', 11),
('JPM', '2023-03-20', 'Stock', 12),
('BAC', '2023-01-15', 'Stock', 13),
('C', '2023-02-25', 'Stock', 14),
('WFC', '2023-03-05', 'Stock', 15),
('GE', '2023-01-08', 'Stock', 16),
('INTC', '2023-02-18', 'Stock', 17),
('IBM', '2023-03-28', 'Stock', 18),
('ADBE', '2023-01-13', 'Stock', 19),
('GOOGL', '2023-02-23', 'Stock', 20),
('AMZN', '2023-01-28', 'Stock', 21),
('FB', '2023-02-12', 'Stock', 22),
('MSFT', '2023-03-17', 'Stock', 23),
('TSLA', '2023-01-05', 'Stock', 24),
('AAPL', '2023-02-15', 'Stock', 25),
('GOOG', '2023-03-10', 'Stock', 26),
('BABA', '2023-01-20', 'Stock', 27),
('JPM', '2023-02-05', 'Stock', 28),
('BAC', '2023-03-25', 'Stock', 29),
('C', '2023-01-10', 'Stock', 30),
('WFC', '2023-02-20', 'Stock', 31),
('GE', '2023-03-30', 'Stock', 32),
('INTC', '2023-01-05', 'Stock', 33),
('IBM', '2023-02-10', 'Stock', 34),
('ADBE', '2023-03-20', 'Stock', 35),
('ORCL', '2023-01-15', 'Stock', 36),
('CSCO', '2023-02-25', 'Stock', 37),
('BABA', '2023-03-05', 'Stock', 38),
('JPM', '2023-01-08', 'Stock', 39),
('BAC', '2023-02-18', 'Stock', 40),
('C', '2023-03-28', 'Stock', 41),
('WFC', '2023-01-13', 'Stock', 42),
('GE', '2023-02-23', 'Stock', 43),
('INTC', '2023-03-08', 'Stock', 44),
('IBM', '2023-01-28', 'Stock', 45),
('ADBE', '2023-02-12', 'Stock', 46),
('ORCL', '2023-03-17', 'Stock', 47),
('CSCO', '2023-01-05', 'Stock', 48),
('AAPL', '2023-02-15', 'Stock', 49),
('GOOGL', '2023-03-10', 'Stock', 50);



-- Insert 50 rows into Stores table
INSERT INTO Stores (store_name, zip_code, street_address, city, state)
VALUES
('Green Grocer', '10001', '123 Main St', 'New York', 'NY'),
('Tech Hub', '94016', '456 Market St', 'San Francisco', 'CA'),
('Gadget World', '60606', '789 State St', 'Chicago', 'IL'),
('Home Essentials', '77002', '321 Elm St', 'Houston', 'TX'),
('Super Mart', '90001', '654 Grand Ave', 'Los Angeles', 'CA'),
('Healthy Harvest', '20001', '987 Cedar St', 'Washington', 'DC'),
('Fashion Fusion', '30301', '111 Pine St', 'Atlanta', 'GA'),
('Sports Depot', '30303', '222 Oak St', 'Atlanta', 'GA'),
('Book Haven', '90210', '333 Maple St', 'Beverly Hills', 'CA'),
('Electro Town', '94102', '444 Spruce St', 'San Francisco', 'CA'),
('Daily Deals', '75201', '555 Birch St', 'Dallas', 'TX'),
('Auto World', '33602', '666 Cypress St', 'Tampa', 'FL'),
('Pet Palace', '90292', '777 Redwood St', 'Marina Del Rey', 'CA'),
('Gourmet Pantry', '80202', '888 Fir St', 'Denver', 'CO'),
('Garden Goods', '33301', '999 Palm St', 'Fort Lauderdale', 'FL'),
('Quick Shop', '02109', '1010 Vine St', 'Boston', 'MA'),
('Music Magic', '77006', '1111 Maplewood St', 'Houston', 'TX'),
('Style Center', '63101', '1212 River St', 'St. Louis', 'MO'),
('Fresh Fare', '30303', '1313 Aspen St', 'Atlanta', 'GA'),
('Design Studio', '10017', '1414 Pine St', 'New York', 'NY'),
('Auto Hub', '60601', '1515 Walnut St', 'Chicago', 'IL'),
('Beauty Bliss', '94109', '1616 Chestnut St', 'San Francisco', 'CA'),
('Gadget Galaxy', '94102', '1717 Redwood St', 'San Francisco', 'CA'),
('Outdoor Oasis', '85251', '1818 Palm Tree St', 'Scottsdale', 'AZ'),
('Pet Paradise', '94105', '1919 Birchwood St', 'San Francisco', 'CA'),
('Style Central', '30305', '2020 Cypress St', 'Atlanta', 'GA'),
('Gourmet Deli', '20002', '2121 Maple Ave', 'Washington', 'DC'),
('Auto Parts Depot', '75202', '2222 Elmwood St', 'Dallas', 'TX'),
('Daily Delights', '02115', '2323 Chestnut Ave', 'Boston', 'MA'),
('Healthy Haven', '77019', '2424 Willow St', 'Houston', 'TX'),
('Fashion Factory', '02116', '2525 Chestnut St', 'Boston', 'MA'),
('Quick Stop', '75204', '2626 Cedar Ave', 'Dallas', 'TX'),
('Tech Trend', '94103', '2727 Willow St', 'San Francisco', 'CA'),
('Garden Galleria', '20003', '2828 Maple St', 'Washington', 'DC'),
('Music Masters', '10022', '2929 Oak Ave', 'New York', 'NY'),
('The Spice Route', '60611', '3030 Palm Ave', 'Chicago', 'IL'),
('Farm Fresh', '30339', '3131 Pinewood St', 'Atlanta', 'GA'),
('The General Store', '94108', '3232 Chestnut St', 'San Francisco', 'CA'),
('Fresh & Fit', '02108', '3333 Vine Ave', 'Boston', 'MA'),
('The Garden Spot', '33101', '3434 Pine Tree Ave', 'Miami', 'FL'),
('Home Harmony', '33139', '3535 Cedar Ave', 'Miami Beach', 'FL'),
('Gourmet Bites', '10023', '3636 Redwood St', 'New York', 'NY'),
('Tech Tools', '60616', '3737 Willow Ave', 'Chicago', 'IL'),
('Gadget Gadgets', '30312', '3838 Elm St', 'Atlanta', 'GA'),
('The Bookworm', '75215', '3939 Maplewood Ave', 'Dallas', 'TX'),
('Style Sphere', '20036', '4040 Oak Ave', 'Washington', 'DC'),
('Auto Zone', '33606', '4141 Cypress St', 'Tampa', 'FL'),
('Healthy Choice', '94111', '4242 Palm St', 'San Francisco', 'CA'),
('Fashion Flair', '30328', '4343 Redwood St', 'Atlanta', 'GA'),
('Daily Market', '02120', '4444 Cedar St', 'Boston', 'MA');



-- Insert 50 rows into Tags table
INSERT INTO Tags (tag_name, user_id)
VALUES
('Groceries', 1),
('Rent', 2),
('Utilities', 3),
('Entertainment', 4),
('Transportation', 5),
('Dining Out', 6),
('Shopping', 7),
('Health', 8),
('Education', 9),
('Travel', 10),
('Fitness', 11),
('Home Improvement', 12),
('Insurance', 13),
('Personal Care', 14),
('Childcare', 15),
('Gifts', 16),
('Savings', 17),
('Taxes', 18),
('Subscriptions', 19),
('Investments', 20),
('Car Maintenance', 21),
('Hobbies', 22),
('Phone Bill', 23),
('Pet Care', 24),
('Clothing', 25),
('Electronics', 26),
('Mortgage', 27),
('Charity', 28),
('Office Supplies', 29),
('Cleaning', 30),
('Credit Card Payments', 31),
('Car Payments', 32),
('Household Supplies', 33),
('Medical Expenses', 34),
('Tuition', 35),
('Memberships', 36),
('Vacation', 37),
('Professional Development', 38),
('Work-Related Expenses', 39),
('Grocery Shopping', 40),
('Pet Supplies', 41),
('Books', 42),
('Online Shopping', 43),
('Subscription Services', 44),
('Music and Entertainment', 45),
('Crafts', 46),
('Lawn Care', 47),
('Real Estate', 48),
('Mortgage Insurance', 49),
('Wedding Expenses', 50);


INSERT INTO Categories (category_name, category_description)
VALUES
('Groceries', 'Expenses related to purchasing food and other household items'),
('Rent', 'Expenses related to housing rental payments'),
('Utilities', 'Expenses related to utility bills such as electricity, water, gas, and internet'),
('Entertainment', 'Expenses for leisure activities such as movies, concerts, and subscriptions'),
('Transportation', 'Expenses related to commuting and travel, such as gas and public transportation fees'),
('Dining Out', 'Expenses related to eating out at restaurants or cafes'),
('Shopping', 'Expenses related to buying clothes, electronics, and other personal items'),
('Health', 'Expenses related to medical bills, prescriptions, and healthcare'),
('Education', 'Expenses related to tuition, school supplies, and other educational needs'),
('Travel', 'Expenses related to vacations and trips, including transportation and accommodations'),
('Fitness', 'Expenses for gym memberships, sports equipment, and fitness classes'),
('Home Improvement', 'Expenses related to renovating or upgrading home areas and appliances'),
('Insurance', 'Expenses related to various types of insurance such as health, car, and home insurance'),
('Personal Care', 'Expenses related to beauty and grooming products and services'),
('Childcare', 'Expenses related to taking care of children, including daycare and school fees'),
('Gifts', 'Expenses for gifts given to others for occasions such as birthdays or holidays'),
('Savings', 'Money set aside for future use, such as emergency funds and savings accounts'),
('Taxes', 'Expenses related to paying income or property taxes'),
('Subscriptions', 'Expenses related to subscription services such as streaming or magazines'),
('Investments', 'Money invested in stocks, bonds, and other assets'),
('Car Maintenance', 'Expenses related to maintaining and servicing cars'),
('Hobbies', 'Expenses related to leisure activities such as crafts and DIY projects'),
('Phone Bill', 'Expenses related to monthly phone service bills'),
('Pet Care', 'Expenses related to taking care of pets, including food and vet bills'),
('Clothing', 'Expenses related to purchasing clothes and accessories'),
('Electronics', 'Expenses related to purchasing electronic devices such as phones and laptops'),
('Mortgage', 'Expenses related to paying mortgage installments'),
('Charity', 'Expenses for donations to charitable organizations'),
('Office Supplies', 'Expenses for purchasing office supplies such as paper and ink'),
('Cleaning', 'Expenses related to cleaning supplies and services'),
('Credit Card Payments', 'Expenses related to paying off credit card balances'),
('Car Payments', 'Expenses related to monthly car payments'),
('Household Supplies', 'Expenses related to purchasing household items such as cleaning products'),
('Medical Expenses', 'Expenses for medical care, prescriptions, and health-related services'),
('Tuition', 'Expenses related to paying tuition for educational courses'),
('Memberships', 'Expenses for membership fees such as clubs and associations'),
('Vacation', 'Expenses related to planning and enjoying vacations'),
('Professional Development', 'Expenses for career-building activities such as workshops and seminars'),
('Work-Related Expenses', 'Expenses for work-related activities such as travel and training'),
('Grocery Shopping', 'Expenses for grocery items and essentials'),
('Pet Supplies', 'Expenses related to purchasing pet supplies such as food and toys'),
('Books', 'Expenses for purchasing books and educational materials'),
('Online Shopping', 'Expenses related to shopping online for various items'),
('Subscription Services', 'Expenses for subscribing to online services and platforms'),
('Music and Entertainment', 'Expenses for music streaming and other entertainment'),
('Crafts', 'Expenses for purchasing crafting supplies and materials'),
('Lawn Care', 'Expenses for lawn maintenance and care'),
('Real Estate', 'Expenses related to buying or maintaining real estate properties'),
('Mortgage Insurance', 'Expenses for mortgage insurance payments'),
('Wedding Expenses', 'Expenses related to planning and hosting weddings');


INSERT INTO Receipts (date, total_amount, user_id, store_id, tag_id, category_id)
VALUES
('2023-01-05', 123.45, 1, 1, 1, 1),
('2023-01-10', 200.75, 2, 2, 2, 2),
('2023-01-15', 85.60, 3, 3, 3, 3),
('2023-01-20', 150.20, 4, 4, 4, 4),
('2023-01-25', 75.30, 5, 5, 5, 5),
('2023-01-30', 300.15, 6, 6, 6, 6),
('2023-02-05', 50.00, 7, 7, 7, 7),
('2023-02-10', 180.50, 8, 8, 8, 8),
('2023-02-15', 210.30, 9, 9, 9, 9),
('2023-02-20', 95.25, 10, 10, 10, 10),
('2023-02-25', 125.75, 11, 11, 11, 11),
('2023-03-01', 275.60, 12, 12, 12, 12),
('2023-03-05', 400.40, 13, 13, 13, 13),
('2023-03-10', 90.80, 14, 14, 14, 14),
('2023-03-15', 315.10, 15, 15, 15, 15),
('2023-03-20', 60.50, 16, 16, 16, 16),
('2023-03-25', 285.20, 17, 17, 17, 17),
('2023-03-30', 70.90, 18, 18, 18, 18),
('2023-04-05', 260.40, 19, 19, 19, 19),
('2023-04-10', 300.75, 20, 20, 20, 20),
('2023-04-15', 65.00, 21, 21, 21, 21),
('2023-04-20', 110.25, 22, 22, 22, 22),
('2023-04-25', 285.90, 23, 23, 23, 23),
('2023-04-30', 145.50, 24, 24, 24, 24),
('2023-05-05', 175.20, 25, 25, 25, 25),
('2023-05-10', 230.90, 26, 26, 26, 26),
('2023-05-15', 105.35, 27, 27, 27, 27),
('2023-05-20', 195.20, 28, 28, 28, 28),
('2023-05-25', 320.45, 29, 29, 29, 29),
('2023-05-30', 120.00, 30, 30, 30, 30),
('2023-06-05', 90.70, 31, 31, 31, 31),
('2023-06-10', 350.60, 32, 32, 32, 32),
('2023-06-15', 145.80, 33, 33, 33, 33),
('2023-06-20', 240.35, 34, 34, 34, 34),
('2023-06-25', 275.25, 35, 35, 35, 35),
('2023-06-30', 175.80, 36, 36, 36, 36),
('2023-07-05', 230.15, 37, 37, 37, 37),
('2023-07-10', 140.40, 38, 38, 38, 38),
('2023-07-15', 310.25, 39, 39, 39, 39),
('2023-07-20', 95.50, 40, 40, 40, 40),
('2023-07-25', 275.30, 41, 41, 41, 41),
('2023-07-30', 110.90, 42, 42, 42, 42),
('2023-08-05', 85.15, 43, 43, 43, 43),
('2023-08-10', 250.80, 44, 44, 44, 44),
('2023-08-15', 150.40, 45, 45, 45, 45),
('2023-08-20', 305.30, 46, 46, 46, 46),
('2023-08-25', 130.00, 47, 47, 47, 47),
('2023-08-30', 100.50, 48, 48, 48, 48),
('2023-09-05', 235.40, 49, 49, 49, 49),
('2023-09-10', 75.80, 50, 50, 50, 50);

INSERT INTO Transactions (unit_cost, quantity, receipt_id, item_name)
VALUES
(15.99, 2, 1, 'Milk'),
(2.49, 4, 1, 'Bread'),
(6.50, 1, 1, 'Eggs'),
(20.00, 1, 2, 'Groceries'),
(5.99, 2, 2, 'Cheese'),
(3.99, 3, 2, 'Butter'),
(12.99, 1, 3, 'Toothpaste'),
(10.00, 1, 3, 'Mouthwash'),
(5.49, 1, 3, 'Shampoo'),
(30.00, 1, 4, 'Clothing'),
(50.00, 1, 4, 'Shoes'),
(15.00, 1, 4, 'Socks'),
(25.99, 2, 5, 'T-Shirts'),
(19.99, 1, 5, 'Jeans'),
(29.99, 1, 5, 'Jacket'),
(9.99, 2, 6, 'Books'),
(19.99, 1, 6, 'Notebook'),
(2.99, 5, 6, 'Pens'),
(150.00, 1, 7, 'Flight Ticket'),
(200.00, 1, 7, 'Hotel Stay'),
(50.00, 1, 7, 'Transportation'),
(60.00, 1, 8, 'Dinner'),
(25.00, 1, 8, 'Lunch'),
(15.00, 2, 8, 'Drinks'),
(75.00, 1, 9, 'Gym Membership'),
(30.00, 1, 9, 'Fitness Class'),
(20.00, 1, 9, 'Protein Powder'),
(35.00, 1, 10, 'Pet Food'),
(12.50, 3, 10, 'Pet Treats'),
(9.99, 1, 10, 'Pet Toy'),
(75.00, 1, 11, 'Concert Ticket'),
(45.00, 1, 11, 'Movie Ticket'),
(12.50, 3, 11, 'Popcorn'),
(120.00, 1, 12, 'Furniture'),
(50.00, 2, 12, 'Decor'),
(30.00, 1, 12, 'Plants'),
(5.00, 10, 13, 'Snacks'),
(10.00, 5, 13, 'Drinks'),
(15.00, 3, 13, 'Candy'),
(200.00, 1, 14, 'New Phone'),
(20.00, 1, 14, 'Phone Case'),
(30.00, 1, 14, 'Screen Protector'),
(2.00, 20, 15, 'Grocery Bags'),
(25.00, 2, 15, 'Cleaning Supplies'),
(7.00, 10, 15, 'Batteries'),
(350.00, 1, 16, 'Laptop'),
(50.00, 1, 16, 'Mouse'),
(15.00, 2, 16, 'USB Drives'),
(45.00, 2, 17, 'Speakers'),
(25.00, 1, 17, 'Headphones'),
(100.00, 1, 17, 'Keyboard');

INSERT INTO Notifications (`repeat`, notification_time, notification_date, message, user_id, budget_id)
VALUES
('Daily', '08:00:00', '2024-01-01', 'Start your day with a positive mindset!', 1, 1),
('Weekly', '09:00:00', '2024-01-05', 'Review your spending for the week.', 2, 2),
('Monthly', '10:00:00', '2024-01-10', 'Check your monthly budget progress.', 3, 3),
('Yearly', '12:00:00', '2024-01-15', 'Happy New Year! Reflect on your finances.', 4, 4),
('Daily', '08:30:00', '2024-01-02', 'Take a moment to be grateful.', 5, 5),
('Weekly', '09:30:00', '2024-01-06', 'Plan your grocery shopping for the week.', 6, 6),
('Monthly', '10:30:00', '2024-01-11', 'Review your subscription services.', 7, 7),
('Yearly', '12:30:00', '2024-01-16', 'Plan your financial goals for the year.', 8, 8),
('Daily', '08:45:00', '2024-01-03', 'Remember to exercise today.', 9, 9),
('Weekly', '09:45:00', '2024-01-07', 'Check your bank balance.', 10, 10),
('Monthly', '10:45:00', '2024-01-12', 'Update your password security.', 11, 11),
('Yearly', '12:45:00', '2024-01-17', 'Schedule an annual health checkup.', 12, 12),
('Daily', '09:00:00', '2024-01-04', 'Spend time with loved ones.', 13, 13),
('Weekly', '10:00:00', '2024-01-08', 'Review your eating habits.', 14, 14),
('Monthly', '11:00:00', '2024-01-13', 'Organize your digital files.', 15, 15),
('Yearly', '13:00:00', '2024-01-18', 'Take a break and relax.', 16, 16),
('Daily', '09:15:00', '2024-01-05', 'Practice meditation.', 17, 17),
('Weekly', '10:15:00', '2024-01-09', 'Check your investments.', 18, 18),
('Monthly', '11:15:00', '2024-01-14', 'Plan your travel budget.', 19, 19),
('Yearly', '13:15:00', '2024-01-19', 'Reflect on your career goals.', 20, 20),
('Daily', '09:30:00', '2024-01-06', 'Take time for self-care.', 21, 21),
('Weekly', '10:30:00', '2024-01-10', 'Plan your meals for the week.', 22, 22),
('Monthly', '11:30:00', '2024-01-15', 'Review your utilities bills.', 23, 23),
('Yearly', '13:30:00', '2024-01-20', 'Check your insurance policies.', 24, 24),
('Daily', '09:45:00', '2024-01-07', 'Get some fresh air.', 25, 25),
('Weekly', '10:45:00', '2024-01-11', 'Check your subscriptions.', 26, 26),
('Monthly', '11:45:00', '2024-01-16', 'Organize your wardrobe.', 27, 27),
('Yearly', '13:45:00', '2024-01-21', 'Assess your professional development.', 28, 28),
('Daily', '10:00:00', '2024-01-08', 'Take a break from screens.', 29, 29),
('Weekly', '11:00:00', '2024-01-12', 'Review your car maintenance schedule.', 30, 30),
('Monthly', '12:00:00', '2024-01-17', 'Reflect on your goals.', 31, 31),
('Yearly', '14:00:00', '2024-01-22', 'Plan your retirement contributions.', 32, 32),
('Daily', '10:15:00', '2024-01-09', 'Stay hydrated.', 33, 33),
('Weekly', '11:15:00', '2024-01-13', 'Check your budget for the month.', 34, 34),
('Monthly', '12:15:00', '2024-01-18', 'Review your investments.', 35, 35),
('Yearly', '14:15:00', '2024-01-23', 'Plan your estate.', 36, 36),
('Daily', '10:30:00', '2024-01-10', 'Practice gratitude journaling.', 37, 37),
('Weekly', '11:30:00', '2024-01-14', 'Check your social media usage.', 38, 38),
('Monthly', '12:30:00', '2024-01-19', 'Plan your savings goals.', 39, 39),
('Yearly', '14:30:00', '2024-01-24', 'Review your employment benefits.', 40, 40),
('Daily', '10:45:00', '2024-01-11', 'Listen to music for relaxation.', 41, 41),
('Weekly', '11:45:00', '2024-01-15', 'Schedule a budget review.', 42, 42),
('Monthly', '12:45:00', '2024-01-20', 'Evaluate your financial goals.', 43, 43),
('Yearly', '14:45:00', '2024-01-25', 'Set goals for the next year.', 44, 44),
('Daily', '11:00:00', '2024-01-12', 'Take a walk in nature.', 45, 45),
('Weekly', '12:00:00', '2024-01-16', 'Plan your grocery shopping list.', 46, 46),
('Monthly', '13:00:00', '2024-01-21', 'Check your health insurance coverage.', 47, 47),
('Yearly', '15:00:00', '2024-01-26', 'Assess your health and fitness goals.', 48, 48),
('Daily', '11:15:00', '2024-01-13', 'Take a few minutes to stretch.', 49, 49),
('Weekly', '12:15:00', '2024-01-17', 'Review your spending for the month.', 50, 50);


INSERT INTO Spending_goals (current_amount, target_amount, Month, user_id, notification_id)
VALUES
(50.00, 200.00, 'January', 1, 1),
(100.00, 300.00, 'February', 2, 2),
(75.00, 250.00, 'March', 3, 3),
(60.00, 220.00, 'April', 4, 4),
(80.00, 300.00, 'May', 5, 5),
(45.00, 200.00, 'June', 6, 6),
(90.00, 350.00, 'July', 7, 7),
(55.00, 220.00, 'August', 8, 8),
(70.00, 280.00, 'September', 9, 9),
(65.00, 260.00, 'October', 10, 10),
(75.00, 300.00, 'November', 11, 11),
(85.00, 320.00, 'December', 12, 12),
(55.00, 200.00, 'January', 13, 13),
(95.00, 350.00, 'February', 14, 14),
(80.00, 300.00, 'March', 15, 15),
(70.00, 250.00, 'April', 16, 16),
(65.00, 240.00, 'May', 17, 17),
(85.00, 300.00, 'June', 18, 18),
(60.00, 200.00, 'July', 19, 19),
(50.00, 190.00, 'August', 20, 20),
(90.00, 350.00, 'September', 21, 21),
(75.00, 300.00, 'October', 22, 22),
(65.00, 250.00, 'November', 23, 23),
(55.00, 200.00, 'December', 24, 24),
(85.00, 320.00, 'January', 25, 25),
(95.00, 350.00, 'February', 26, 26),
(100.00, 400.00, 'March', 27, 27),
(70.00, 280.00, 'April', 28, 28),
(60.00, 230.00, 'May', 29, 29),
(75.00, 300.00, 'June', 30, 30),
(55.00, 200.00, 'July', 31, 31),
(80.00, 310.00, 'August', 32, 32),
(90.00, 350.00, 'September', 33, 33),
(60.00, 240.00, 'October', 34, 34),
(65.00, 260.00, 'November', 35, 35),
(75.00, 300.00, 'December', 36, 36),
(50.00, 200.00, 'January', 37, 37),
(85.00, 310.00, 'February', 38, 38),
(70.00, 280.00, 'March', 39, 39),
(65.00, 250.00, 'April', 40, 40),
(55.00, 210.00, 'May', 41, 41),
(80.00, 320.00, 'June', 42, 42),
(60.00, 230.00, 'July', 43, 43),
(50.00, 200.00, 'August', 44, 44),
(85.00, 310.00, 'September', 45, 45),
(70.00, 280.00, 'October', 46, 46),
(60.00, 250.00, 'November', 47, 47),
(75.00, 300.00, 'December', 48, 48),
(90.00, 360.00, 'January', 49, 49),
(55.00, 210.00, 'February', 50, 50);


INSERT INTO Budgets (Amount, start_date, end_date, notification_threshold, category_id, notification_id, admin_user_id)
VALUES
(500.00, '2024-01-01', '2024-01-31', 450.00, 1, 1, 1),
(450.00, '2024-02-01', '2024-02-29', 400.00, 2, 2, 2),
(600.00, '2024-03-01', '2024-03-31', 550.00, 3, 3, 3),
(700.00, '2024-04-01', '2024-04-30', 650.00, 4, 4, 4),
(800.00, '2024-05-01', '2024-05-31', 750.00, 5, 5, 5),
(400.00, '2024-06-01', '2024-06-30', 350.00, 6, 6, 6),
(550.00, '2024-07-01', '2024-07-31', 500.00, 7, 7, 7),
(650.00, '2024-08-01', '2024-08-31', 600.00, 8, 8, 8),
(500.00, '2024-09-01', '2024-09-30', 450.00, 9, 9, 9),
(750.00, '2024-10-01', '2024-10-31', 700.00, 10, 10, 10),
(850.00, '2024-11-01', '2024-11-30', 800.00, 11, 11, 11),
(950.00, '2024-12-01', '2024-12-31', 900.00, 12, 12, 12),
(600.00, '2024-01-01', '2024-01-31', 550.00, 13, 13, 13),
(700.00, '2024-02-01', '2024-02-29', 650.00, 14, 14, 14),
(800.00, '2024-03-01', '2024-03-31', 750.00, 15, 15, 15),
(550.00, '2024-04-01', '2024-04-30', 500.00, 16, 16, 16),
(450.00, '2024-05-01', '2024-05-31', 400.00, 17, 17, 17),
(500.00, '2024-06-01', '2024-06-30', 450.00, 18, 18, 18),
(600.00, '2024-07-01', '2024-07-31', 550.00, 19, 19, 19),
(700.00, '2024-08-01', '2024-08-31', 650.00, 20, 20, 20),
(800.00, '2024-09-01', '2024-09-30', 750.00, 21, 21, 21),
(900.00, '2024-10-01', '2024-10-31', 850.00, 22, 22, 22),
(1000.00, '2024-11-01', '2024-11-30', 950.00, 23, 23, 23),
(1100.00, '2024-12-01', '2024-12-31', 1050.00, 24, 24, 24),
(700.00, '2024-01-01', '2024-01-31', 650.00, 25, 25, 25),
(800.00, '2024-02-01', '2024-02-29', 750.00, 26, 26, 26),
(900.00, '2024-03-01', '2024-03-31', 850.00, 27, 27, 27),
(1000.00, '2024-04-01', '2024-04-30', 950.00, 28, 28, 28),
(1100.00, '2024-05-01', '2024-05-31', 1050.00, 29, 29, 29),
(1200.00, '2024-06-01', '2024-06-30', 1150.00, 30, 30, 30),
(1300.00, '2024-07-01', '2024-07-31', 1250.00, 31, 31, 31),
(1400.00, '2024-08-01', '2024-08-31', 1350.00, 32, 32, 32),
(1500.00, '2024-09-01', '2024-09-30', 1450.00, 33, 33, 33),
(1600.00, '2024-10-01', '2024-10-31', 1550.00, 34, 34, 34),
(1700.00, '2024-11-01', '2024-11-30', 1650.00, 35, 35, 35),
(1800.00, '2024-12-01', '2024-12-31', 1750.00, 36, 36, 36),
(900.00, '2024-01-01', '2024-01-31', 850.00, 37, 37, 37),
(1000.00, '2024-02-01', '2024-02-29', 950.00, 38, 38, 38),
(1100.00, '2024-03-01', '2024-03-31', 1050.00, 39, 39, 39),
(1200.00, '2024-04-01', '2024-04-30', 1150.00, 40, 40, 40),
(1300.00, '2024-05-01', '2024-05-31', 1250.00, 41, 41, 41),
(1400.00, '2024-06-01', '2024-06-30', 1350.00, 42, 42, 42),
(1500.00, '2024-07-01', '2024-07-31', 1450.00, 43, 43, 43),
(1600.00, '2024-08-01', '2024-08-31', 1550.00, 44, 44, 44),
(1700.00, '2024-09-01', '2024-09-30', 1650.00, 45, 45, 45),
(1800.00, '2024-10-01', '2024-10-31', 1750.00, 46, 46, 46),
(1900.00, '2024-11-01', '2024-11-30', 1850.00, 47, 47, 47),
(2000.00, '2024-12-01', '2024-12-31', 1950.00, 48, 48. 48),
(1000.00, '2024-01-01', '2024-01-31', 950.00, 49, 49, 49),
(1100.00, '2024-02-01', '2024-02-29', 1050.00, 50, 50, 50);

-- User Persona 1: Busy Professional Sophia

INSERT INTO Users (group_id, email, first_name, middle_name, last_name, password)
VALUES (NULL, 'sophia@example.com', 'Sophia', 'M', 'Smith', 'sophia_password');

INSERT INTO Stores (store_name, zip_code, street_address, city, state)
VALUES 
('Whole Foods Market', '94103', '399 4th Street', 'San Francisco', 'CA'),
('Uber', '94103', 'N/A', 'San Francisco', 'CA');

INSERT INTO Tags (tag_name, user_id)
VALUES 
('Groceries and toiletries', 51),
('Personal', 51);

INSERT INTO Receipts (date, total_amount, user_id, store_id, tag_id, category_id)
VALUES ('2024-04-15', 120.00, 51, 51, 51, 1),
       ('2024-04-15', 18.60, 51, 52, 52, 5);

INSERT INTO Transactions (unit_cost, quantity, receipt_id, item_name)
VALUES (3.75, 2, 51, 'Organic Avocados'),
       (3.50, 1, 51, 'Onions'),
       (3.00, 3, 51, 'Tomatoes'),
       (1.00, 4, 51, 'Limes'),
       (18.50, 1, 51, 'Toilet Paper'),
       (9.00, 1, 51, 'Hand Soap'),
       (7.50, 4, 51, 'Chickpea Pasta'),
       (14.50, 1, 51, 'Method Body Wash'),
       (16.00, 1, 51, 'Charcuterie Board'),
       (8.00, 1, 51, 'Strawberries'),
       (18.60, 1, 52, 'UberX Ride');

INSERT INTO Investments (stock_name, purchase_date, investment_type, user_id)
VALUES ('AAPL', '2024-01-01', 'Stocks', 51);

INSERT INTO Notifications (`repeat`, notification_time, notification_date, Message, user_id, budget_id)
VALUES ('Daily', '09:00', '2024-04-20', 'You are nearing your Grocery budget limit.', 51, 51);

INSERT INTO Spending_goals (current_amount, target_amount, Month, user_id)
VALUES (100.00, 500.00, 'April', 51);

INSERT INTO Budgets (amount, start_date, end_date, notification_threshold, category_id, user_id)
VALUES (500.00, '2024-04-01', '2024-04-30', 450.00, 1, 51);

-- User Persona 2: Conscious College Student - David

INSERT INTO Users (group_id, email, first_name, middle_name, last_name, password)
VALUES (NULL, 'david@example.edu', 'David', NULL, 'Johnson', 'david_password');

INSERT INTO Stores (store_name, zip_code, street_address, city, state)
VALUES 
('Campus Bookstore', '90210', '123 College St', 'Beverly Hills', 'CA'),
('Trader Joes', '90210', '321 Market St', 'Beverly Hills', 'CA');

INSERT INTO Tags (tag_name, user_id)
VALUES 
('School Supplies', 52),
('Daily Groceries', 52);

INSERT INTO Receipts (date, total_amount, user_id, store_id, tag_id, category_id)
VALUES 
('2024-04-10', 85.00, 52, 53, 53, 1),  -- Trader Joe's groceries
('2024-04-12', 120.00, 52, 54, 54, 9); -- Campus Bookstore textbooks

INSERT INTO Transactions (unit_cost, quantity, receipt_id, item_name)
VALUES
(85.00, 1, 53, 'Bread'),
(120.00, 1, 54, 'Data Structures Textbook');

INSERT INTO Investments (stock_name, purchase_date, investment_type, user_id)
VALUES ('MSFT', '2024-01-15', 'Stocks', 52);

INSERT INTO Notifications (`repeat`, notification_time, notification_date, Message, user_id, budget_id)
VALUES ('Daily', '18:00', '2024-04-15', 'You are nearing your Groceries budget limit.', 52, 52);

INSERT INTO Spending_goals (current_amount, target_amount, Month, user_id)
VALUES (50.00, 80.00, 'April', 2);

INSERT INTO Budgets (amount, start_date, end_date, notification_threshold, category_id, user_id)
VALUES (100.00, '2024-04-01', '2024-04-30', 90.00, 1, 52);  -- Groceries

