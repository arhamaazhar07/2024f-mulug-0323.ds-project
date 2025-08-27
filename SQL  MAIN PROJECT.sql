
IF DB_ID('BookRecDB') IS NULL
BEGIN
    CREATE DATABASE BookRecDB;
END;
GO

USE BookRecDB;
GO

IF OBJECT_ID('Recommendations', 'U') IS NOT NULL DROP TABLE Recommendations;
IF OBJECT_ID('Books', 'U') IS NOT NULL DROP TABLE Books;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
GO

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE
);
GO

CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(100) NOT NULL,
    Author NVARCHAR(100),
    Genre NVARCHAR(50),
    PublicationYear INT
);
GO

CREATE TABLE Recommendations (
    RecID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    BookID INT,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    RecommendedOn DATE DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON DELETE CASCADE ON UPDATE CASCADE,

    FOREIGN KEY (BookID) REFERENCES Books(BookID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

INSERT INTO Users (FirstName, LastName, Email)
VALUES 
('Ali', 'Khan', 'ali.khan@example.com'),
('Sara', 'Malik', 'sara.malik@example.com'),
('Ahmed', 'Raza', 'ahmed.raza@example.com'),
('Fatima', 'Noor', 'fatima.noor@example.com'),
('Zainab', 'Iqbal', 'zainab.iqbal@example.com');
GO

INSERT INTO Books (Title, Author, Genre, PublicationYear)
VALUES 
('The Silent Patient', 'Alex Michaelides', 'Thriller', 2019),
('Atomic Habits', 'James Clear', 'Self-Help', 2018),
('Digital Fortress', 'Dan Brown', 'Tech Thriller', 1998),
('Sapiens', 'Yuval Noah Harari', 'History', 2011),
('The Alchemist', 'Paulo Coelho', 'Fiction', 1988),
('1984', 'George Orwell', 'Dystopian', 1949),
('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 'Fantasy', 1997),
('The Power of Now', 'Eckhart Tolle', 'Spirituality', 1997),
('The Subtle Art of Not Giving a F*ck', 'Mark Manson', 'Self-Help', 2016);
GO

INSERT INTO Recommendations (UserID, BookID, Rating)
VALUES 
(1, 1, 5),
(1, 3, 4),
(1, 5, 5),
(2, 2, 4),
(2, 1, 5),
(2, 7, 5),
(3, 3, 3),
(3, 5, 2),
(4, 4, 5),
(5, 5, 4),
(5, 6, 5);
GO

SELECT * FROM Users;
SELECT * FROM Books;
SELECT * FROM Recommendations;


SELECT Title, Author, Genre, PublicationYear
FROM Books
WHERE Genre = 'Self-Help';


SELECT Title, Genre, PublicationYear
FROM Books
WHERE Author = 'Dan Brown';


SELECT Title, Author, AVG(Rating) AS AvgRating
FROM Books b
JOIN Recommendations r ON b.BookID = r.BookID
GROUP BY Title, Author
HAVING AVG(Rating) >= 4
ORDER BY AvgRating DESC;


SELECT u.FirstName, u.LastName, b.Title, b.Author, r.Rating
FROM Recommendations r
JOIN Users u ON u.UserID = r.UserID
JOIN Books b ON b.BookID = r.BookID
WHERE u.FirstName = 'Sara' AND u.LastName = 'Malik';