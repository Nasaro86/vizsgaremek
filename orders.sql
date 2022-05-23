use vizsgaremek
SET XACT_ABORT ON  

BEGIN TRAN
declare @foodid1 int = 2, @foodid2 int = 1, @foodid3 int = 3
declare @foodqty1 int = 4, @foodqty2 int = 2, @foodqty3 int = 1
declare @customer int = 50
declare @customeraddress int = 7
declare @identity int

insert "order".OrderHeader (OrderTime,CustomerID,CustomerAddressID)
values(GETDATE(),@customer,@customeraddress)
set @identity = @@IDENTITY

insert "Order".FoodOrderLine (FoodID,FoodQty,OrderID)
values (@foodid1,@foodqty1,@identity),(@foodid2,@foodqty2,@identity),(@foodid3,@foodqty3,@identity)

/*update FoodOrderLines
set OrderID = @identity
where OrderID is null*/

COMMIT TRAN 


select * from "Order".FoodOrderLine
select * from "order".OrderHeader
/*
select * from @foodorder
create table Orders(
	OrderID INT identity(1,1),
	OrderTime datetime2,
	CustomerID int,
	CustomerAddressID int,*/