use vizsgaremek

go

create or alter function "order".TotalPrice(@price money, @qty int) returns money
as
BEGIN
declare @total money
set @total = COALESCE((@price * @qty),0)
return @total
END

go
create or alter procedure "order".OrdersForADay(@day date)
as
set nocount on
select CONVERT(date,oh.OrderTime) "Day",
-- Using UDF for calculating the total price fixing "null" problem
sum("order".TotalPrice(f.price,fol.Foodqty) + "order".TotalPrice(b.price,bol.beverageqty)) "Total Sum of Orders"
from "order".OrderHeader oh
left join "order".BeverageOrderLine bol on oh.OrderID = bol.OrderID
left join "order".FoodOrderLine fol on oh.OrderID = fol.OrderID
left join Product.Food f on fol.FoodID = f.FoodID
left join Product.Beverage b on bol.BeverageID = b.BeverageID 
where CONVERT(date,oh.OrderTime) = @day
group by CONVERT(date,oh.OrderTime)

-- exec "order".OrdersForADay '2022-04-10'

go

create or alter procedure Person.AddDeliveryMember(
@FirstName varchar(30),
@LastName varchar(30),
@PhoneNumber varchar(20),
@Email varchar(50),
@AreaID int
)
as

SET NOCOUNT ON


declare @identity int
BEGIN TRY
BEGIN TRAN
insert into Person.DeliveryMember (FirstName,LastName,PhoneNumber,Email) values
(@FirstName,@LastName,@PhoneNumber,@Email)

set @identity = @@IDENTITY

insert into Area.AreaPairing values
(@AreaID,@identity)
COMMIT TRAN
END TRY
BEGIN CATCH
		SELECT ERROR_NUMBER(), ERROR_MESSAGE()
		IF XACT_STATE() <> 0 ROLLBACK TRAN 
END CATCH


select * from person.deliverymember
select * from Area.AreaPairing

go

exec Person.AddDeliveryMember
@FirstName='Tibike',
@LastName='Neusch',
@PhoneNumber='5959-878',
@Email='fdsfdsf@dsfds',
@AreaID=2

select * from person.deliverymember
select * from Area.AreaPairing

go

create or alter procedure Person.DeleteDeliveryMember
@MemberID int,
@FirstName varchar(255),
@LastName varchar(255)
as

SET NOCOUNT ON

BEGIN TRY
BEGIN TRAN

declare @rowcount varchar(3)

delete from Area.AreaPairing
where DeliveryMemberID = @MemberID

delete from Person.DeliveryMember 
where DeliveryMemberID = @MemberID AND FirstName = @FirstName AND LastName = @LastName

if @@ROWCOUNT = 0
BEGIN
set @rowcount = @@ROWCOUNT
print @rowcount + ' record deleted. Please check the ID or the Name!'
END
ELSE
BEGIN
print '1 record deleted.'
END
COMMIT TRAN
END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE()
IF XACT_STATE() <> 0 ROLLBACK TRAN
END CATCH

exec Person.DeleteDeliveryMember
@MemberID = 2,
@FirstName = 'Jack',
@LastName = 'Roberts'

select * from person.deliverymember
select * from Area.AreaPairing
