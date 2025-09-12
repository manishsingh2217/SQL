-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
SELECT * FROM books;
INSERT INTO books (isbn , book_title , category , rental_price , status , author , publisher) 
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address.
SELECT * FROM members;
UPDATE members
SET member_address = '123 noida'
WHERE member_id = 'C101';

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
SELECT * FROM issue ;
DELETE FROM issue
WHERE issued_id='IS121';

-- Task 4 Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT issued_book_name FROM issue
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT issued_emp_id, COUNT(issued_id) AS Book_Issued
FROM issue
GROUP BY 1
HAVING COUNT(issued_id) > 1;

--  Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE book_issu_cnt AS SELECT b.isbn, b.book_title, b.author, COUNT(ist.issued_id) FROM
    issue ist
        JOIN
    books b ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn , b.book_title;
RENAME TABLE book_issu_cnt TO book_issue_cnt;

--  Retrieve All Books in a Specific Category:
SELECT * FROM books WHERE category = 'Classic';

-- Task 8: Find Total Rental Income by Category:
SELECT  b.category ,COUNT(ist.issued_id) AS book_issued, SUM(b.rental_price) AS rental
FROM issue ist JOIN
books b ON ist.issued_book_isbn = b.isbn 
GROUP BY b.category;

-- Task 9 List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date>= CURRENT_DATE - INTERVAL 180 DAY;

-- TASK 10 List Employees with Their Branch Manager's Name and their branch details:

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employee as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employee as e2
ON e2.emp_id = b.manager_id;

--  Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE exp_books AS
SELECT book_title , category ,rental_price AS rent, author , status 
FROM books WHERE rental_price > 3;


-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT ist.issued_book_name AS Not_returned_books , ist.issued_date
FROM issue ist
LEFT JOIN return_status r ON ist.issued_id = r.issued_id;

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    -- rs.return_date,
    CURRENT_DATE - ist.issued_date as over_dues_days
FROM issued_status as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;