CREATE DATABASE E_commerce;

USE E_commerce;

# 1) You are required to create tables for supplier,customer,category,product,productDetails,order,rating to store the data for the E-commerce with the schema definition given below.

CREATE TABLE Supplier ( SUPP_ID int NOT NULL PRIMARY KEY,
						SUPP_NAME varchar(40),
                        SUPP_CITY varchar(20),
                        SUPP_PHONE bigint);

CREATE TABLE Customer ( CUS_ID int NOT NULL PRIMARY KEY,
						CUS_NAME varchar(40),
                        CUS_PHONE bigint,
                        CUS_CITY varchar(20),
                        CUS_GENDER char(1));

CREATE TABLE Category ( CAT_ID int NOT NULL PRIMARY KEY,
						CAT_NAME varchar(20));
                        
CREATE TABLE Product ( PRO_ID int NOT NULL PRIMARY KEY,
					   PRO_NAME varchar(30),
                       PRO_DESC varchar(40),
                       CAT_ID int,
                       FOREIGN KEY (CAT_ID) references Category(CAT_ID));
                       
CREATE TABLE ProductDetails ( PROD_ID int NOT NULL PRIMARY KEY,
							  PRO_ID int,
                              SUPP_ID int,
                              PRICE int,
                              FOREIGN KEY (PRO_ID) references Product(PRO_ID),
                              FOREIGN KEY (SUPP_ID) references Supplier(SUPP_ID));
                              
CREATE TABLE Orders  ( ORD_ID int NOT NULL PRIMARY KEY,
					  ORD_AMOUNT int,
                      ORD_DATE date,
                      CUS_ID int,
                      PROD_ID int,
                      FOREIGN KEY (CUS_ID) references Customer(CUS_ID),
					  FOREIGN KEY (PROD_ID) references ProductDetails(PROD_ID));
                      
CREATE TABLE Rating ( RAT_ID int NOT NULL PRIMARY KEY,
					  CUS_ID int,
                      SUPP_ID int,
                      RAT_RATSTARS int,
                      FOREIGN KEY (CUS_ID) references Customer(CUS_ID),
                      FOREIGN KEY (SUPP_ID) references Supplier(SUPP_ID));
 
# 2) Insert the following data in the table created above

INSERT INTO Supplier VALUES ( 1, "Rajesh Retails", "Delhi", 1234567890); 
INSERT INTO Supplier VALUES ( 2, "Appario Ltd.", "Mumbai", 2589631470); 
INSERT INTO Supplier VALUES ( 3, "Knome products", "Banglore", 9785462315); 
INSERT INTO Supplier VALUES ( 4, "Bansal Retails", "Kochi", 8975463285); 
INSERT INTO Supplier VALUES ( 5, "Mittal Ltd.", "Lucknow", 7898456532); 

INSERT INTO Customer VALUES ( 1, "AAKASH",  9999999999, "DELHI", "M");
INSERT INTO Customer VALUES ( 2, "AMAN",  9785463215, "NOIDA", "M");
INSERT INTO Customer VALUES ( 3, "NEHA",  9999999999, "MUMBAI", "F");
INSERT INTO Customer VALUES ( 4, "MEGHA",  9994562399, "KOLKATA", "F");
INSERT INTO Customer VALUES ( 5, "PULKIT",  7895999999, "LUCKNOW", "M");

INSERT INTO Category VALUES ( 1, "BOOKS");
INSERT INTO Category VALUES ( 2, "GAMES");
INSERT INTO Category VALUES ( 3, "GROCERIES");
INSERT INTO Category VALUES ( 4, "ELECTRONICS");
INSERT INTO Category VALUES ( 5, "CLOTHES");

INSERT INTO Product VALUES ( 1, "GTA V", "DFJDJFDJFDJFDJFJF", 2);
INSERT INTO Product VALUES ( 2, "TSHIRT", "DFDFJDFJDKFD", 5);
INSERT INTO Product VALUES ( 3, "ROG LAPTOP", "DFNTTNTNTERND", 4);
INSERT INTO Product VALUES ( 4, "OATS", "REURENTBTOTH", 3);
INSERT INTO Product VALUES ( 5, "HARRY POTTER", "NBEMCTHTJTH", 1);

INSERT INTO ProductDetails VALUES ( 1, 1, 2, 1500);
INSERT INTO ProductDetails VALUES ( 2, 3, 5, 30000);
INSERT INTO ProductDetails VALUES ( 3, 5, 1, 3000);
INSERT INTO ProductDetails VALUES ( 4, 2, 3, 2500);
INSERT INTO ProductDetails VALUES ( 5, 4, 1, 1000);

INSERT INTO Orders VALUES ( 20, 1500, "2021-10-12", 3, 5);
INSERT INTO Orders VALUES ( 25, 30500, "2021-09-16", 5, 2);
INSERT INTO Orders VALUES ( 26, 2000, "2021-10-05", 1, 1);
INSERT INTO Orders VALUES ( 30, 3500, "2021-08-16", 4, 3);
INSERT INTO Orders VALUES ( 50, 2000, "2021-10-06", 2, 1);

INSERT INTO Rating VALUES ( 1, 2, 2, 4);
INSERT INTO Rating VALUES ( 2, 3, 4, 3);
INSERT INTO Rating VALUES ( 3, 5, 1, 5);
INSERT INTO Rating VALUES ( 4, 1, 3, 2);
INSERT INTO Rating VALUES ( 5, 4, 5, 4);

# 3) Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.

SELECT count(CUS_GENDER) FROM Customer JOIN Orders ON Customer.CUS_ID = Orders.CUS_ID WHERE ORD_AMOUNT>=3000 GROUP BY CUS_GENDER;

# 4) Display all the orders along with the product name ordered by a customer having Customer_Id=2.

SELECT ORD_ID, ORD_AMOUNT, ORD_DATE, p2.PRO_ID, PRO_NAME FROM Orders o
JOIN ProductDetails p1 ON o.PROD_ID = p1.PROD_ID JOIN Product p2 ON p1.PRO_ID = p2.PRO_ID WHERE o.CUS_ID = 2;

# 5) Display the Supplier details who can supply more than one product.

SELECT s.* FROM Supplier s JOIN ProductDetails p ON s.SUPP_ID = p.SUPP_ID
GROUP BY p.SUPP_ID HAVING count(p.SUPP_ID) > 1;

# 6) Find the category of the product whose order amount is minimum.

SELECT category.* FROM `Orders` INNER JOIN ProductDetails ON `Orders`.PROD_ID = ProductDetails.PROD_ID 
INNER JOIN Product ON Product.PRO_ID = ProductDetails.PRO_ID INNER JOIN Category ON 
Category.CAT_ID = Product.CAT_ID HAVING min(`Orders`.ORD_AMOUNT);

# 7) Display the Id and Name of the Product ordered after “2021-10-05”.

SELECT p.PRO_ID, PRO_NAME FROM Product p JOIN ProductDetails p1 ON p.PRO_ID = p1.PRO_ID JOIN
Orders o ON p1.PROD_ID = o.PROD_ID WHERE ORD_DATE > "2021-10-05";

# 8) Print the top 3 supplier name and id and their rating on the basis of their rating along with the customer name who has given the rating.

SELECT s.SUPP_ID, SUPP_NAME, CUS_NAME, RAT_RATSTARS FROM Supplier s JOIN Rating r ON s.SUPP_ID = r.SUPP_ID JOIN
Customer c ON r.CUS_ID = c.CUS_ID ORDER BY RAT_RATSTARS DESC limit 3;

# 9) Display customer name and gender whose names start or end with character 'A'.

SELECT CUS_NAME, CUS_GENDER FROM Customer WHERE CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';

# 10) Display the total order amount of the male customers.

SELECT sum(ORD_AMOUNT) FROM Orders o JOIN Customer c ON o.CUS_ID = c.CUS_ID AND CUS_GENDER = "M";

# 11) Display all the Customers left outer join with the orders.

SELECT * FROM Customer c LEFT JOIN Orders o ON c.CUS_ID = o.CUS_ID;

# 12) Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.

delimiter &&
CREATE PROCEDURE displayRating()
BEGIN
SELECT s.SUPP_ID, SUPP_NAME, RAT_RATSTARS, 
CASE
WHEN RAT_RATSTARS > 4 THEN 'Genuine Suuplier'
WHEN RAT_RATSTARS > 2 THEN 'Average Supplier'
ELSE 'Supplier should not be considered'
END AS Verdict
FROM Supplier s JOIN Rating r ON s.SUPP_ID = r.SUPP_ID;
END &&
CALL displayRating();