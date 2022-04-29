use vizsgaremek

/*SELECT concat('ALTER TABLE ', TABLE_NAME, ' drop constraint ', CONSTRAINT_NAME, ';')
FROM information_schema.key_column_usage 
WHERE CONSTRAINT_NAME like 'FK%' 
AND referenced_table_name IS NOT NULL;*/
ALTER TABLE AreaPairing drop constraint FK_AREAPAIRING;
ALTER TABLE CustomerAddress drop constraint FK_AREAS;
ALTER TABLE BeverageOrderLines drop constraint FK_BEVERAGEORDER;
ALTER TABLE BeverageOrderLines drop constraint FK_BEVORDER;
ALTER TABLE Orders drop constraint FK_CUSTOMERADDRESS;
ALTER TABLE Orders drop constraint FK_CUSTOMERS;
ALTER TABLE DeliveryMembers drop constraint FK_DELIVERYJOB;
ALTER TABLE AreaPairing drop constraint FK_DELIVERYMEMBERS;
ALTER TABLE Foods drop constraint FK_FOODCATEGORY;
ALTER TABLE FoodOrderLines drop constraint FK_FOODORDER;
ALTER TABLE Employees drop constraint FK_JOBS;
ALTER TABLE FoodOrderLines drop constraint FK_ORDER;
go
drop table if exists FoodCategories
drop table if exists Customers
drop table if exists Foods
drop table if exists Beverages
drop table if exists Areas
drop table if exists CustomerAddress
drop table if exists Orders
drop table if exists DeliveryMembers
drop table if exists AreaPairing
drop table if exists FoodOrderLines
drop table if exists BeverageOrderLines
drop table if exists Jobs
drop table if exists Employees
go
create table FoodCategories(
	FoodCategoryID INT identity(1,1),
	FoodCategory varchar(255),
	constraint PK_FOODCATEGORIES primary key (FoodCategoryID)
)
PRINT 'Table FoodCategories created.'
go
create table Customers(
	CustomerID int identity(1,1),
	FirstName varchar(255) not null,
	LastName varchar(255) not null,
	Age int,
	RegistrationDate date,
	PhoneNumber varchar(255),
	Email varchar(255) not null,
	constraint PK_CUSTOMERS primary key (CustomerID),
	constraint CHK_PersonAge check (age>=18),
	constraint CHK_Email check (email like '%@%' AND len(email)>=5),
	constraint CHK_Data check (FirstName is not null AND LastName is not null AND Email is not null),
	constraint UC_CUSTOMEREMAIL unique (Email)
)
PRINT 'Table Customers created.'
go
create table Foods(
	FoodID INT identity(1,1),
	Name varchar(255),
	Category int,
	Price money,
	constraint PK_FOODS primary key (FoodID),
	constraint FK_FOODCATEGORY foreign key (Category) references FoodCategories(FoodCategoryID),
	constraint UC_FOODNAME unique (Name)
)
PRINT 'Table Foods created.'
go
create table Beverages(
	BeverageID INT identity(1,1),
	Name varchar(255),
	Alcohol BIT,
	Price money,
	Constraint PK_BEVERAGES primary key (BeverageID),
	constraint UC_BEVERAGENAME unique (Name)
)
PRINT 'Table Beverages created.'
go
create table Areas(
	AreaID int identity(1,1),
	AreaName varchar(255),
	constraint PK_AREAS primary key (AreaID)
)
PRINT 'Table Areas created.'
go
create table CustomerAddress(
	CustomerAddressID int identity(1,1),
	City varchar(255) not null,
	PostalCode int not null,
	Street varchar(255) not null,
	HouseNumber int not null,
	AreaID int,
	constraint PK_CUSTOMERSADDRESS primary key (CustomerAddressID),
	constraint FK_AREAS foreign key (AreaID) references Areas(AreaID),
)
PRINT 'Table CustomerAddress created.'
go
create table Orders(
	OrderID INT identity(1,1),
	OrderTime datetime2,
	CustomerID int,
	CustomerAddressID int,
	constraint PK_ORDER primary key (OrderID),
	constraint FK_CUSTOMERS foreign key (CustomerID) references Customers(CustomerID),
	constraint FK_CUSTOMERADDRESS foreign key (CustomerAddressID) references CustomerAddress(CustomerAddressID)
)
PRINT 'Table Orders created.'
go
create table Jobs(
	JobID int identity(1,1),
	Job varchar(255),
	Job_description varchar(255),
	constraint PK_JOBS primary key (JobID)
)
PRINT 'Table Jobs created.'
go
create table DeliveryMembers(
	DeliveryMemberID int identity(1,1),
	FirstName varchar(255) not null,
	LastName varchar(255) not null,
	PhoneNumber varchar(255) not null,
	Email varchar(255) not null,
	JobID int not null,
	constraint PK_DELIVERYMEMBERS primary key (DeliveryMemberID),
	constraint FK_DELIVERYJOB foreign key (JobID) references Jobs (JobID)
)
PRINT 'Table DeliveryMembers created.'
go
create table AreaPairing(
	AreaID int,
	DeliveryMemberID int,
	constraint FK_AREAPAIRING foreign key (AreaID) references Areas(AreaID),
	constraint FK_DELIVERYMEMBERS foreign key (DeliveryMemberID) references DeliveryMembers(DeliveryMemberID),
	constraint PK_AREAPAIRING primary key (AreaID,DeliveryMemberID)
)
PRINT 'Table AreaPairing created.'
go
create table FoodOrderLines(
	FoodOrderLineID int identity(1,1),
	FoodID int,
	FoodQty int,
	OrderID int,
	constraint PK_FOODORDERLINE primary key (FoodOrderLineID),
	constraint FK_FOODORDER foreign key (FoodID) references Foods(FoodID),
	constraint FK_ORDER foreign key (OrderID) references Orders(OrderID)
)
PRINT 'Table FoodOrderLines created.'
go
create table BeverageOrderLines(
	BeverageOrderLineID int identity(1,1),
	BeverageID int,
	BeverageQty int,
	OrderID int,
	constraint PK_BEVERAGEORDERLINE primary key (BeverageOrderLineID),
	constraint FK_BEVERAGEORDER foreign key (BeverageID) references Beverages(BeverageID),
	constraint FK_BEVORDER foreign key (OrderID) references Orders(OrderID)
	)
PRINT 'Table BeverageOrderLines created.'
go
create table Employees(
	EmployeeID int identity(1,1),
	FirstName varchar(255) not null,
	LastName varchar(255) not null,
	JobID int not null,
	PhoneNumber varchar(255),
	Email varchar(255),
	constraint PK_EMPLOYEES primary key (EmployeeID),
	constraint FK_JOBS foreign key (JobID) references Jobs(JobID)
)
PRINT 'Table Employees created.'
