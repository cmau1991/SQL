-- Code to create database and tables --
CREATE DATABASE librarysystem;
USE librarysystem;

-- Create Tables
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(50),
    DOB DATE
);

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL
);

CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(150) NOT NULL,
    AuthorID INT,
    CategoryID INT,
    PublishedYear INT,
    ISBN VARCHAR(13) UNIQUE,
    Quantity INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE,
    MembershipType ENUM('Basic', 'Premium', 'VIP') NOT NULL
);

CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    BorrowDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

INSERT INTO Authors (Name, Country, DOB)
VALUES
    ('J.K. Rowling', 'United Kingdom', '1965-07-31'),
    ('George R.R. Martin', 'United States', '1948-09-20'),
    ('Agatha Christie', 'United Kingdom', '1890-09-15'),
    ('Yuval Noah Harari', 'Israel', '1976-02-24'),
    ('Isabel Allende', 'Chile', '1942-08-02');

INSERT INTO Categories (Name)
VALUES
    ('Fiction'),
    ('Non-Fiction'),
    ('Mystery'),
    ('Science Fiction'),
    ('Biography');

INSERT INTO Books (Title, AuthorID, CategoryID, PublishedYear, ISBN, Quantity)
VALUES
    ('Harry Potter and the Philosopher''s Stone', 1, 1, 1997, '9780747532699', 5),
    ('A Song of Ice and Fire', 2, 4, 1996, '9780553103540', 3),
    ('Murder on the Orient Express', 3, 3, 1934, '9780007119318', 4),
    ('Sapiens: A Brief History of Humankind', 4, 2, 2011, '9780099590088', 7),
    ('The House of the Spirits', 5, 1, 1982, '9781501117015', 6);

INSERT INTO Members (Name, Email, JoinDate, MembershipType)
VALUES
    ('Alice Johnson', 'alice.johnson@example.com', '2022-01-15', 'Premium'),
    ('Bob Smith', 'bob.smith@example.com', '2023-03-10', 'Basic'),
    ('Catherine Lee', 'catherine.lee@example.com', '2021-07-22', 'VIP'),
    ('Daniel Brown', 'daniel.brown@example.com', '2020-11-05', 'Premium'),
    ('Emily White', 'emily.white@example.com', '2023-08-19', 'Basic');

INSERT INTO Transactions (BookID, MemberID, BorrowDate, ReturnDate)
VALUES
    (1, 1, '2023-10-01', '2023-10-15'),
    (2, 2, '2023-11-01', NULL),
    (3, 3, '2023-09-20', '2023-10-05'),
    (4, 4, '2023-11-10', NULL),
    (5, 5, '2023-10-25', '2023-11-02');

-- Below are a list of queries relating to the Library database created for this project --
-- Task #1: Using any type of the joins create a view that combines multiple tables in a logical way
-- LibraryTransactionvView combines transactional data with book, 
-- author, and member details, giving a full view of library activities.
USE librarysystem;
CREATE OR REPLACE VIEW LibraryTransactionView AS
SELECT 
    t.TransactionID,
    t.BorrowDate,
    t.ReturnDate,
    b.BookID,
    b.Title AS BookTitle,
    b.PublishedYear,
    b.ISBN,
    b.Quantity AS AvailableQuantity,
    a.AuthorID,
    a.Name AS AuthorName,
    a.Country AS AuthorCountry,
    c.CategoryID,
    c.Name AS CategoryName,
    m.MemberID,
    m.Name AS MemberName,
    m.Email AS MemberEmail,
    m.MembershipType
FROM 
    Transactions t
JOIN 
    Books b ON t.BookID = b.BookID
JOIN 
    Authors a ON b.AuthorID = a.AuthorID
JOIN 
    Categories c ON b.CategoryID = c.CategoryID
JOIN 
    Members m ON t.MemberID = m.MemberID;

SELECT * FROM LibraryTransactionView;

-- Filter view to show books borrowed by "VIP" members
SELECT 
    TransactionID, BookTitle, MemberName, BorrowDate
FROM 
    LibraryTransactionView
WHERE 
    MembershipType = 'VIP';

-- Filter view to show books that are currently in the "borrowed" status
SELECT 
    BookTitle, MemberName, BorrowDate
FROM 
    LibraryTransactionView
WHERE 
    ReturnDate IS NULL;

-- Task #2: Create a stored function that can be applied to a query in your DB
USE librarysystem;
DELIMITER //
CREATE FUNCTION CalculateOverdueDays(
    BorrowDate DATE,
    ReturnDate DATE
) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE OverdueDays INT;
    -- Assume a 14-day borrowing period
    IF ReturnDate IS NOT NULL THEN
        SET OverdueDays = DATEDIFF(ReturnDate, BorrowDate) - 14;
    ELSE
        SET OverdueDays = DATEDIFF(CURDATE(), BorrowDate) - 14;
    END IF;
    -- If the book is not overdue, return 0
    IF OverdueDays < 0 THEN
        SET OverdueDays = 0;
    END IF;
    RETURN OverdueDays;
END //
DELIMITER ;

-- return info from function
USE librarysystem;
SELECT 
    t.TransactionID,
    m.Name AS MemberName,
    b.Title AS BookTitle,
    t.BorrowDate,
    t.ReturnDate,
    CalculateOverdueDays(t.BorrowDate, t.ReturnDate) AS OverdueDays
FROM 
    Transactions t
JOIN 
    Members m ON t.MemberID = m.MemberID
JOIN 
    Books b ON t.BookID = b.BookID
WHERE 
    CalculateOverdueDays(t.BorrowDate, t.ReturnDate) > 0;

-- Task #3: Prepare an example query with a subquery to demonstrate how to extract data from your DB for analysis
-- Query Aim: insights into active library members based on borrowing activity, 
-- which can be useful for engagement or reward programs. 
USE librarysystem;
SELECT 
    m.MemberID,
    m.Name AS MemberName,
    m.Email AS MemberEmail,
    m.MembershipType,
    (SELECT COUNT(*) 
     FROM Transactions t 
     WHERE t.MemberID = m.MemberID 
       AND t.BorrowDate >= DATE_SUB(CURDATE(), INTERVAL 18 MONTH)) AS BooksBorrowedLast18Months
FROM 
    Members m
WHERE 
    (SELECT COUNT(*) 
     FROM Transactions t 
     WHERE t.MemberID = m.MemberID 
       AND t.BorrowDate >= DATE_SUB(CURDATE(), INTERVAL 18 MONTH)) > 0;

-- Task #4: Create DB diagram where all table relations are shown
-- Separate image file created for this & included in slide deck


-- ADVANCED
-- Advanced Task #1: In your database, create a stored procedure and demonstrate how it runs
USE librarysystem;
DELIMITER //
CREATE PROCEDURE GetBorrowedBooksByMember(
    IN MemberID INT,
    IN StartDate DATE,
    IN EndDate DATE
)
BEGIN
    SELECT 
        t.TransactionID,
        b.Title AS BookTitle,
        b.ISBN,
        t.BorrowDate,
        t.ReturnDate
    FROM 
        Transactions t
    JOIN 
        Books b ON t.BookID = b.BookID
    WHERE 
        t.MemberID = MemberID
        AND t.BorrowDate BETWEEN StartDate AND EndDate;
END //
DELIMITER ;

-- Run the stored procedure - it provides a means of easy filtering of transaction records for 
-- specific members and timeframes, handy to generate reports/auditing borrowing history.
CALL GetBorrowedBooksByMember(1, '2023-10-01', '2023-11-15');

-- Advanced Task #2: In your database, create a trigger and demonstrate how it runs
USE librarysystem;
-- Inserting a borrow-event to the library system
DELIMITER //
CREATE TRIGGER AfterTransactionInsert
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    UPDATE Books
    SET Quantity = Quantity - 1
    WHERE BookID = NEW.BookID;
END //
DELIMITER ;
-- Updating the library system to return a book
DELIMITER //
CREATE TRIGGER AfterTransactionDelete
AFTER DELETE ON Transactions
FOR EACH ROW
BEGIN
    UPDATE Books
    SET Quantity = Quantity + 1
    WHERE BookID = OLD.BookID;
END //
DELIMITER ;

-- Command to add a borrowed book
SELECT * FROM Books WHERE BookID = 1;
INSERT INTO Transactions (BookID, MemberID, BorrowDate, ReturnDate)
VALUES (1, 1, '2024-11-01', NULL);
SELECT * FROM Books;
-- Command to return a book
DELETE FROM Transactions
WHERE TransactionID = 1;
SELECT * FROM Books;

-- Advanced Task #3: In your database, create an event and demonstrate how it runs
-- Cadence: event is scheduled to run automatically, once a day starting from the current time.
-- Logical basis: Updates the Overdue column in the Transactions table to TRUE for books that:
-- have not been returned / were borrowed more than 14 days ago
USE librarysystem;
DELIMITER //
CREATE EVENT MarkOverdueBooks
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE Transactions
    SET Overdue = TRUE
    WHERE ReturnDate IS NULL 
      AND BorrowDate < DATE_SUB(CURDATE(), INTERVAL 14 DAY);
END //
DELIMITER ;

-- Executing the event
SELECT * FROM Transactions;
SET GLOBAL event_scheduler = ON;
CALL mysql.rds_run_event_now('MarkOverdueBooks');
SELECT * FROM Transactions;

-- Advanced Task #4: Create a view that uses at least 3-4 base tables; prepare and demonstrate
-- a query that uses the view to produce a logically arranged result set for analysis.
USE librarysystem;
CREATE OR REPLACE VIEW BorrowingSummary AS
SELECT 
    t.TransactionID,
    m.MemberID,
    m.Name AS MemberName,
    m.Email AS MemberEmail,
    b.BookID,
    b.Title AS BookTitle,
    b.ISBN,
    a.Name AS AuthorName,
    t.BorrowDate,
    t.ReturnDate,
    CASE
        WHEN t.ReturnDate IS NULL THEN 'Not Returned'
        WHEN t.ReturnDate <= DATE_ADD(t.BorrowDate, INTERVAL 14 DAY) THEN 'Returned On Time'
        ELSE 'Overdue'
    END AS Status
FROM 
    Transactions t
JOIN 
    Members m ON t.MemberID = m.MemberID
JOIN 
    Books b ON t.BookID = b.BookID
JOIN 
    Authors a ON b.AuthorID = a.AuthorID;

-- pull info about borrowing activity at the library
-- Query aim: identifies overdue books, allowing staff to contact the relevant members with a reminder notification. 
USE librarysystem;
SELECT 
    MemberName,
    BookTitle,
    AuthorName,
    BorrowDate,
    ReturnDate,
    Status
FROM 
    BorrowingSummary
WHERE 
    Status = 'Overdue'
ORDER BY 
    BorrowDate DESC;

-- Advanced Task #5: Prepare an example query with group by and having to demonstrate how to extract data from your DB for analysis
-- Query aim: identifies authors with multiple number of books still available in the library. 
-- This can be useful for: inventory management & decision-making (for example, order more copies of popular books).
USE librarysystem;
SELECT
    a.Name AS AuthorName,
    count(b.BookID) AS TotalBooksAvailable
FROM 
    Books b
JOIN 
    Authors a ON b.AuthorID = a.AuthorID
WHERE 
    b.Quantity > 3
GROUP BY 
    a.AuthorID
HAVING
	COUNT(b.BookID)>0
ORDER BY 
    TotalBooksAvailable DESC;