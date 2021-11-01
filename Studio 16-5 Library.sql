#16.5.1.1 The book table
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    author_id INT,
    title VARCHAR(255),
    isbn INT,
    available BOOL,
    genre_id INT
);

#16.5.1.2 The author table
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    birthday DATE,
    deathday DATE
);

#16.5.1.3 the patron table
CREATE TABLE patron (
    patron_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    loan_id INT
);

#16.5.1.4 the reference_books table
CREATE TABLE reference_books (
    reference_id INT AUTO_INCREMENT PRIMARY KEY,
    edition INT,
    book_id INT,
    FOREIGN KEY (book_id)
        REFERENCES book (book_id)
        ON UPDATE SET NULL ON DELETE SET NULL
);
INSERT INTO reference_books (edition, book_id)VALUE (5,32);

#16.5.1.5 the genre table
CREATE TABLE genre (
    genre_id INT PRIMARY KEY,
    genres VARCHAR(100)
);

#16.5.1.6 the loan table
CREATE TABLE loan (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    patron_id INT,
    date_out DATE,
    date_in DATE,
    book_id INT,
    FOREIGN KEY (book_id)
        REFERENCES book (book_id)
        ON UPDATE SET NULL ON DELETE SET NULL
);

#16.5.2 queries
#return the mystery book titles and isbn
SELECT title, isbn FROM book;

#book written by authors living
SELECT title , first_name, last_name FROM book INNER JOIN author ON book.author_id = author.author_id
WHERE author.deathday is NULL;

#16.5.3 loan out a book
SELECT CURDATE() AS today;
UPDATE book SET available=FALSE WHERE book.book_id =20;
INSERT INTO loan (patron_id,date_out, date_in, book_id)VALUE (5,CURDATE(), '2021-12-04',20);
UPDATE patron SET loan_id=3 WHERE patron_id =5;


#16.5.4 check a book back in
UPDATE book SET available=TRUE WHERE book.book_id =2;
UPDATE loan SET date_in='2021-10-27' WHERE loan_id =1;
UPDATE patron SET loan_id=null WHERE patron_id =1;

#Loan out 5 new books to 5 different patrons
UPDATE book SET available=FALSE WHERE book.book_id =17;
INSERT INTO loan (patron_id,date_out, book_id)VALUE (32,CURDATE(),17);
UPDATE patron SET loan_id=4 WHERE patron_id =32;

UPDATE book SET available=FALSE WHERE book.book_id =6;
INSERT INTO loan (patron_id,date_out, book_id)VALUE (11,CURDATE(), 6);
UPDATE patron SET loan_id=5 WHERE patron_id =11;

UPDATE book SET available=FALSE WHERE book.book_id =4;
INSERT INTO loan (patron_id,date_out, book_id)VALUE (23,CURDATE(),4);
UPDATE patron SET loan_id=6 WHERE patron_id =23;

UPDATE book SET available=FALSE WHERE book.book_id =26;
INSERT INTO loan (patron_id,date_out, book_id)VALUE (9,CURDATE(),26);
UPDATE patron SET loan_id=6 WHERE patron_id =9;

UPDATE book SET available=FALSE WHERE book.book_id =33;
INSERT INTO loan (patron_id,date_out, book_id)VALUE (23,CURDATE(),33);
UPDATE patron SET loan_id=7 WHERE patron_id =23;

UPDATE book SET available=FALSE WHERE book.book_id =14;
INSERT INTO loan (patron_id,date_out, book_id)VALUE (23,CURDATE(),14);
UPDATE patron SET loan_id=9 WHERE patron_id =23;

#16.5.5 wrap up query return patron name genre of book checked out
SELECT CONCAT(first_name , ' ', last_name) AS 'Full Name' , genres FROM patron AS A1 INNER JOIN 
(SELECT loan_id, patron_id, t1.book_id, title, genres FROM loan AS t1 INNER JOIN 
(SELECT book_id, title, genres FROM book INNER JOIN genre ON book.genre_id = genre.genre_id) AS t2 
ON t1.book_id = t2.book_id) AS A2
ON A1.loan_id= A2.loan_id; 

#16.5.6  bonus mission
SELECT genres, COUNT(*) FROM book INNER JOIN genre ON book.genre_id = genre.genre_id GROUP BY genres;
