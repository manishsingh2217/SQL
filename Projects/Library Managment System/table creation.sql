-- Library manangment projects

CREATE DATABASE libraryP2;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
    branch_id VARCHAR(100) PRIMARY KEY,
    manager_id VARCHAR(100),
    branch_address VARCHAR(50),
    contact_no VARCHAR(10)
);

DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(25),
    position VARCHAR(15),
    salary INT,
    branch_id VARCHAR(15) 
);

DROP TABLE IF EXISTS books;
CREATE TABLE books (
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(60),
    category VARCHAR(20),
    rental_price FLOAT,
    status VARCHAR(5),
    author VARCHAR(25),
    publisher VARCHAR(30)
);

DROP TABLE IF EXISTS issue;
CREATE TABLE issue (
    issued_id VARCHAR(5) PRIMARY KEY,
    issued_member_id VARCHAR(5),
    issued_book_name VARCHAR(55),
    issued_date DATE,
    issued_book_isbn VARCHAR(20),
    issued_emp_id VARCHAR(5)
);

DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(25),
    member_address VARCHAR(75),
    reg_date DATE
);

DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
    return_id VARCHAR(10),
    issued_id VARCHAR(10) PRIMARY KEY,
    return_book_name VARCHAR(60),
    return_date DATE,
    return_book_isbn VARCHAR(20)
);