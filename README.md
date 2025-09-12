# 📚 SQL Project: Library Management System

## 📖 Project Overview
This project is a **Library Management System built using SQL**.  
It simulates real-world database operations such as managing books, members, employees, issued/return status, and branch performance.  

The system demonstrates **CRUD operations, Joins, Aggregations, CTAS, Stored Procedures, and Data Analysis queries** to handle end-to-end library workflows.

---

## 🗂️ Database Design
The project consists of multiple interrelated tables:  

- **books** – Stores book details (ISBN, Title, Author, Publisher, Status, Price).  
- **members** – Stores member details and registration info.  
- **employees** – Employee details with branch & manager relationships.  
- **issued_status** – Tracks issued books (who issued, by whom, when).  
- **return_status** – Tracks book returns and condition.  
- **branch** – Stores branch and manager details.  

---

## ✅ Tasks & Queries Implemented

### 🔹 DML (Data Manipulation)
**Task 1.** Create a New Book Record  
```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
````

**Task 2.** Update Member Address

```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```

**Task 3.** Delete Records from Issued Status

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

---

### 🔹 Data Retrieval & Analysis

**Task 4.** Retrieve Books Issued by Specific Employee

```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';
```

**Task 5.** List Members with More Than One Issued Book

```sql
SELECT issued_emp_id, COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1;
```

**Task 6.** Create Book Issued Count Table (CTAS)

```sql
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status AS ist
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
```

**Task 7.** Retrieve Books by Category

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

**Task 8.** Find Total Rental Income by Category

```sql
SELECT b.category, SUM(b.rental_price), COUNT(*)
FROM issued_status AS ist
JOIN books AS b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1;
```

**Task 9.** List Members Registered in Last 180 Days


SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';


**Task 10.** Employee-Branch-Manager Relationship Query


SELECT e1.emp_id, e1.emp_name, e1.position, e1.salary, b.*, e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b ON e1.branch_id = b.branch_id    
JOIN employees AS e2 ON e2.emp_id = b.manager_id;




### 🔹 Advanced SQL

**Task 11.** Create Table of Expensive Books


CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;


**Task 12.** Retrieve Books Not Yet Returned


SELECT * 
FROM issued_status AS ist
LEFT JOIN return_status AS rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;


**Task 13.** Identify Members with Overdue Books (>30 Days)

SELECT ist.issued_member_id, m.member_name, bk.book_title, ist.issued_date,
       CURRENT_DATE - ist.issued_date AS overdue_days
FROM issued_status AS ist
JOIN members AS m ON m.member_id = ist.issued_member_id
JOIN books AS bk ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL
  AND (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;


**Task 14.** Stored Procedure to Update Book Status on Return


CREATE OR REPLACE PROCEDURE add_return_records(
    p_return_id VARCHAR(10), 
    p_issued_id VARCHAR(10), 
    p_book_quality VARCHAR(10)
)

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
BEGIN
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
END;



**Task 15.** Branch Performance Report (Issued, Returned, Revenue)


CREATE TABLE branch_reports AS
SELECT b.branch_id, b.manager_id,
       COUNT(ist.issued_id) AS number_book_issued,
       COUNT(rs.return_id) AS number_of_book_return,
       SUM(bk.rental_price) AS total_revenue
FROM issued_status AS ist
JOIN employees AS e ON e.emp_id = ist.issued_emp_id
JOIN branch AS b ON e.branch_id = b.branch_id
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
JOIN books AS bk ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;


**Task 16.** Create Active Members Table (CTAS)


CREATE TABLE active_members AS
SELECT * FROM members
WHERE member_id IN (
    SELECT DISTINCT issued_member_id
    FROM issued_status
    WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month'
);


**Task 17.** Find Top 3 Employees by Book Issues Processed


SELECT e.emp_name, b.*, COUNT(ist.issued_id) AS no_book_issued
FROM issued_status AS ist
JOIN employees AS e ON e.emp_id = ist.issued_emp_id
JOIN branch AS b ON e.branch_id = b.branch_id
GROUP BY 1, 2
ORDER BY no_book_issued DESC
LIMIT 3;


**Task 18.** Identify Members Issuing Damaged Books Frequently


SELECT m.member_name, bk.book_title, COUNT(*) AS damaged_count
FROM issued_status AS ist
JOIN members AS m ON m.member_id = ist.issued_member_id
JOIN books AS bk ON bk.isbn = ist.issued_book_isbn
WHERE bk.status = 'damaged'
GROUP BY m.member_name, bk.book_title
HAVING COUNT(*) > 2;

**Task 19.** Stored Procedure to Manage Book Availability

CREATE OR REPLACE PROCEDURE issue_book(p_isbn VARCHAR(50))

BEGIN
    IF EXISTS (SELECT 1 FROM books WHERE isbn = p_isbn AND status = 'yes') THEN
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_isbn;
        RAISE NOTICE 'Book with ISBN % has been issued successfully.', p_isbn;
    ELSE
        RAISE EXCEPTION 'Book with ISBN % is currently not available.', p_isbn;
    END IF;
END;


---

## ⚡ Key SQL Concepts Used

* **Joins (INNER, LEFT, Multiple Joins)**
* **Group By & Aggregations**
* **CTAS (Create Table As Select)**
* **Stored Procedures (PL/pgSQL)**
* **Data Analysis Queries**
* **Subqueries & Filtering**

---

## 🚀 How to Use

1. Clone the repository

   
   git clone https://github.com/your-username/Library-Management-SQL.git
   cd Library-Management-SQL
   
2. Import the schema & data into your SQL environment (PostgreSQL/MySQL).
3. Run queries from this README to test functionalities.

---

## 🧑‍💻 Author

**Manish Singh**
🔗 [LinkedIn](https://www.linkedin.com/in/manishsingh22/) | 🌐 [Portfolio](https://manish-singh.framer.website) | 💻 [GitHub](https://github.com/your-username)

---

## 📌 License

This project is open-source and available under the [MIT License](LICENSE).



