CREATE DATABASE gravity_books
GO


CREATE TABLE gravity_books.dbo.author (
    author_id INT,
    author_name NVARCHAR(MAX),
    CONSTRAINT pk_author PRIMARY KEY (author_id)
);

CREATE TABLE gravity_books.dbo.publisher (
    publisher_id INT,
    publisher_name NVARCHAR(MAX),
    CONSTRAINT pk_publisher PRIMARY KEY (publisher_id)
);

CREATE TABLE gravity_books.dbo.book_language (
    language_id INT,
    language_code NVARCHAR(MAX),
    language_name NVARCHAR(MAX),
    CONSTRAINT pk_language PRIMARY KEY (language_id)
);

CREATE TABLE gravity_books.dbo.book (
    book_id INT,
    title NVARCHAR(MAX),
    isbn13 NVARCHAR(MAX),
    language_id INT,
    num_pages INT,
    publication_date DATE,
    publisher_id INT,
    CONSTRAINT pk_book PRIMARY KEY (book_id),
    CONSTRAINT fk_book_lang FOREIGN KEY (language_id) REFERENCES book_language (language_id),
    CONSTRAINT fk_book_pub FOREIGN KEY (publisher_id) REFERENCES publisher (publisher_id)
);

CREATE TABLE gravity_books.dbo.book_author (
    book_id INT,
    author_id INT,
    CONSTRAINT pk_bookauthor PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_ba_book FOREIGN KEY (book_id) REFERENCES book (book_id),
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES author (author_id)
);

CREATE TABLE gravity_books.dbo.address_status (
    status_id INT,
    address_status NVARCHAR(MAX),
    CONSTRAINT pk_addr_status PRIMARY KEY (status_id)
);

CREATE TABLE gravity_books.dbo.country (
    country_id INT,
    country_name NVARCHAR(MAX),
    CONSTRAINT pk_country PRIMARY KEY (country_id)
);

CREATE TABLE gravity_books.dbo.address (
    address_id INT,
    street_number NVARCHAR(MAX),
    street_name NVARCHAR(MAX),
    city NVARCHAR(MAX),
    country_id INT,
    CONSTRAINT pk_address PRIMARY KEY (address_id),
    CONSTRAINT fk_addr_ctry FOREIGN KEY (country_id) REFERENCES country (country_id)
);

CREATE TABLE gravity_books.dbo.customer (
    customer_id INT,
    first_name NVARCHAR(MAX),
    last_name NVARCHAR(MAX),
    email NVARCHAR(MAX),
    CONSTRAINT pk_customer PRIMARY KEY (customer_id)
);

CREATE TABLE gravity_books.dbo.customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    CONSTRAINT pk_custaddr PRIMARY KEY (customer_id, address_id),
    CONSTRAINT fk_ca_cust FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
    CONSTRAINT fk_ca_addr FOREIGN KEY (address_id) REFERENCES address (address_id)
);

CREATE TABLE gravity_books.dbo.shipping_method (
    method_id INT,
    method_name NVARCHAR(MAX),
    cost DECIMAL(6, 2),
    CONSTRAINT pk_shipmethod PRIMARY KEY (method_id)
);



CREATE TABLE gravity_books.dbo.cust_order (
    order_id INT IDENTITY,
    order_date DATETIME,
    customer_id INT,
    shipping_method_id INT,
    dest_address_id INT,
    CONSTRAINT pk_custorder PRIMARY KEY (order_id),
    CONSTRAINT fk_order_cust FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
    CONSTRAINT fk_order_ship FOREIGN KEY (shipping_method_id) REFERENCES shipping_method (method_id),
    CONSTRAINT fk_order_addr FOREIGN KEY (dest_address_id) REFERENCES address (address_id)
);

CREATE TABLE gravity_books.dbo.order_status (
    status_id INT,
    status_value NVARCHAR(MAX),
    CONSTRAINT pk_orderstatus PRIMARY KEY (status_id)
);


CREATE TABLE gravity_books.dbo.order_line (
    line_id INT IDENTITY,
    order_id INT,
    book_id INT,
    price DECIMAL(5, 2),
    CONSTRAINT pk_orderline PRIMARY KEY (line_id),
    CONSTRAINT fk_ol_order FOREIGN KEY (order_id) REFERENCES cust_order (order_id),
    CONSTRAINT fk_ol_book FOREIGN KEY (book_id) REFERENCES book (book_id)
);

CREATE TABLE gravity_books.dbo.order_history (
    history_id INT IDENTITY,
    order_id INT,
    status_id INT,
    status_date DATETIME,
    CONSTRAINT pk_orderhist PRIMARY KEY (history_id),
    CONSTRAINT fk_oh_order FOREIGN KEY (order_id) REFERENCES cust_order (order_id),
    CONSTRAINT fk_oh_status FOREIGN KEY (status_id) REFERENCES order_status (status_id)
);
