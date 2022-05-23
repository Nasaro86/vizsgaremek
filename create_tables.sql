use vizsgaremek

/*SELECT concat('ALTER TABLE ', Constraint_schema, '.', TABLE_NAME, ' drop constraint ', CONSTRAINT_NAME, ';')
FROM information_schema.key_column_usage 
WHERE CONSTRAINT_NAME like 'FK%' 

SELECT *
FROM information_schema.key_column_usage 
WHERE CONSTRAINT_NAME like 'FK%' 


AND referenced_table_name IS NOT NULL;
ALTER TABLE Area.AreaPairing drop constraint FK_AREAPAIRING;
ALTER TABLE Area.AreaPairing drop constraint FK_DELIVERYMEMBERS;
ALTER TABLE "Order".BeverageOrderLine drop constraint FK_BEVERAGEORDER;
ALTER TABLE "Order".BeverageOrderLine drop constraint FK_BEVORDER;
ALTER TABLE "Order".OrderHeader drop constraint FK_CUSTOMERADDRESS;
ALTER TABLE "Order".OrderHeader drop constraint FK_CUSTOMERS;
ALTER TABLE "Order".FoodOrderLine drop constraint FK_FOODORDER;
ALTER TABLE "Order".FoodOrderLine drop constraint FK_ORDER;
ALTER TABLE Person.CustomerAddress drop constraint FK_AREAS;
ALTER TABLE Person.DeliveryMember drop constraint FK_DELIVERYJOB;
ALTER TABLE Person.Employee drop constraint FK_JOBS;
ALTER TABLE Product.Food drop constraint FK_FOODCATEGORY;
*/
go
drop table if exists Product.FoodCategory
drop table if exists Person.Customer
drop table if exists Product.Food
drop table if exists Product.Beverage
drop table if exists Area.Area
drop table if exists Person.CustomerAddress
drop table if exists "Order".OrderHeader
drop table if exists Person.DeliveryMember
drop table if exists Area.AreaPairing
drop table if exists "Order".FoodOrderLine
drop table if exists "Order".BeverageOrderLine
drop table if exists Person.Job
drop table if exists Person.Employee

/*drop schema if exists Product
drop schema if exists Person
drop schema if exists "Order"
drop schema if exists Area
*/
go
create table Product.FoodCategory(
	FoodCategoryID INT identity(1,1),
	FoodCategory varchar(255),
	constraint PK_FOODCATEGORIES primary key (FoodCategoryID)
)
PRINT 'Table FoodCategory created.'
go
create table Person.Customer(
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
	--constraint CHK_Data check (FirstName is not null AND LastName is not null AND Email is not null),
	constraint UC_CUSTOMEREMAIL unique (Email)
)
PRINT 'Table Customer created.'
go
create table Product.Food(
	FoodID INT identity(1,1),
	Name varchar(255),
	CategoryID int,
	Price money,
	constraint PK_FOODS primary key (FoodID),
	constraint FK_FOODCATEGORY foreign key (CategoryID) references Product.FoodCategory(FoodCategoryID),
	constraint UC_FOODNAME unique (Name)
)
PRINT 'Table Food created.'
go
create table Product.Beverage(
	BeverageID INT identity(1,1),
	Name varchar(255),
	Alcohol BIT,
	Price money,
	Constraint PK_BEVERAGES primary key (BeverageID),
	constraint UC_BEVERAGENAME unique (Name)
)
PRINT 'Table Beverage created.'
go
create table Area.Area(
	AreaID int identity(1,1),
	AreaName varchar(255),
	constraint PK_AREAS primary key (AreaID)
)
PRINT 'Table Area created.'
go
create table Person.CustomerAddress(
	CustomerAddressID int identity(1,1),
	City varchar(255) not null,
	PostalCode int not null,
	Street varchar(255) not null,
	HouseNumber int not null,
	AreaID int not null,
	CustomerID int not null
	constraint PK_CUSTOMERSADDRESS primary key (CustomerAddressID),
	constraint FK_AREAS foreign key (AreaID) references Area.Area(AreaID),
	constraint FK_CUSTOMERID foreign key (CustomerID) references Person.Customer(CustomerID)
)
PRINT 'Table CustomerAddress created.'
go
create table "Order".OrderHeader(
	OrderID INT identity(1,1),
	OrderTime datetime2,
--	CustomerID int,
	CustomerAddressID int,
	constraint PK_ORDER primary key (OrderID),
--	constraint FK_CUSTOMERS foreign key (CustomerID) references Person.Customer(CustomerID),
	constraint FK_CUSTOMERADDRESS foreign key (CustomerAddressID) references Person.CustomerAddress(CustomerAddressID)
)
PRINT 'Table Orderheader created.'
go
create table Person.Job(
	JobID int identity(1,1),
	Job varchar(255),
	Job_description varchar(255),
	constraint PK_JOBS primary key (JobID)
)
PRINT 'Table Job created.'
go
create table Person.DeliveryMember(
	DeliveryMemberID int identity(1,1),
	FirstName varchar(255) not null,
	LastName varchar(255) not null,
	PhoneNumber varchar(255) not null,
	Email varchar(255) CHECK (Email like '%@%' AND len(email)>=5) not null,
	JobID int not null default 6,
	constraint PK_DELIVERYMEMBERS primary key (DeliveryMemberID),
	constraint FK_DELIVERYJOB foreign key (JobID) references Person.Job (JobID)
)
PRINT 'Table DeliveryMember created.'
go
create table Area.AreaPairing(
	AreaID int,
	DeliveryMemberID int,
	constraint FK_AREAPAIRING foreign key (AreaID) references Area.Area(AreaID),
	constraint FK_DELIVERYMEMBERS foreign key (DeliveryMemberID) references Person.DeliveryMember(DeliveryMemberID),
	constraint PK_AREAPAIRING primary key (AreaID,DeliveryMemberID)
)
PRINT 'Table AreaPairing created.'
go
create table "Order".FoodOrderLine(
	FoodOrderLineID int identity(1,1),
	FoodID int,
	FoodQty int,
	OrderID int,
	constraint PK_FOODORDERLINE primary key (FoodOrderLineID),
	constraint FK_FOODORDER foreign key (FoodID) references Product.Food(FoodID),
	constraint FK_ORDER foreign key (OrderID) references "Order".OrderHeader(OrderID)
)
PRINT 'Table FoodOrderLine created.'
go
create table "Order".BeverageOrderLine(
	BeverageOrderLineID int identity(1,1),
	BeverageID int,
	BeverageQty int,
	OrderID int,
	constraint PK_BEVERAGEORDERLINE primary key (BeverageOrderLineID),
	constraint FK_BEVERAGEORDER foreign key (BeverageID) references Product.Beverage(BeverageID),
	constraint FK_BEVORDER foreign key (OrderID) references "Order".OrderHeader(OrderID)
	)
PRINT 'Table BeverageOrderLine created.'
go
create table Person.Employee(
	EmployeeID int identity(1,1),
	FirstName varchar(255) not null,
	LastName varchar(255) not null,
	JobID int not null,
	PhoneNumber varchar(255),
	Email varchar(255) CHECK (Email like '%@%' AND len(email)>=5),
	constraint PK_EMPLOYEES primary key (EmployeeID),
	constraint FK_JOBS foreign key (JobID) references Person.Job(JobID)
)
PRINT 'Table Employee created.'
