use vizsgaremek

create view PersonToArea as
 select concat(FirstName,' ',LastName) as "Delivery Member Name",string_agg(AreaName,', ') as Area from DeliveryMembers join Areapairing on DeliveryMembers.DeliveryMemberID=Areapairing.DeliveryMemberID join Areas on Areas.AreaID=Areapairing.AreaID
group by FirstName,LastName
go
create view NicholasGordonWhatToEat as
select CONCAT(customers.FirstName,' ',customers.LastName) as Customer,string_agg(Foods.Name,', ') as "What is he Eating?"
	from Customers 
	join Orders on Orders.CustomerID=Customers.CustomerID 
	join FoodOrderLines on FoodOrderLines.OrderID=Orders.OrderID 
	join Foods on Foods.FoodID=FoodOrderLines.FoodID
	where customers.customerid=16
	group by CONCAT(customers.FirstName,' ',customers.LastName)
go
create view HungarianPizzaEaters as
select CONCAT(CONCAT(customers.FirstName,' ',customers.LastName),' ','eats Hungarian Pizza') as Customer  
	from Customers
	join Orders	on Customers.CustomerID=Orders.CustomerID
	join FoodOrderLines	on FoodOrderLines.OrderID=Orders.OrderID
	join Foods on Foods.FoodID=FoodOrderLines.FoodID
	where Foods.Name='Hungarian Pizza'
go
create view Top5Spenders as
select TOP 5 CONCAT(customers.FirstName,' ',customers.LastName) as Customer ,SUM(Foods.Price * FoodOrderLines.FoodQty + Beverages.Price * BeverageOrderLines.BeverageQty) as TotalSpent
	from Customers
	join Orders on Customers.CustomerID=Orders.CustomerID
	left join FoodOrderLines on FoodOrderLines.OrderID=Orders.OrderID
	left join BeverageOrderLines on BeverageOrderLines.OrderID=Orders.OrderID
	join Foods on Foods.FoodID=FoodOrderLines.FoodID
	join Beverages on Beverages.BeverageID=BeverageOrderLines.BeverageID
	group by CONCAT(customers.FirstName,' ',customers.LastName)
	order by TotalSpent desc
	go
	create view Top5Spenders as
	select TOP 5 customers.FirstName + ' ' + customers.LastName + ' ' + 'is among the 5 top spenders in our shop.' + ' ' + 'He spent' + ' ' + CAST(SUM(Foods.Price * FoodOrderLines.FoodQty + Beverages.Price * BeverageOrderLines.BeverageQty) as VARCHAR(255))  + '€' as "                                                 Our TOP spenders"
	from Customers
	join Orders on Customers.CustomerID=Orders.CustomerID
	left join FoodOrderLines on FoodOrderLines.OrderID=Orders.OrderID
	left join BeverageOrderLines on BeverageOrderLines.OrderID=Orders.OrderID
	join Foods on Foods.FoodID=FoodOrderLines.FoodID
	join Beverages on Beverages.BeverageID=BeverageOrderLines.BeverageID
	group by customers.FirstName + ' ' + customers.LastName
	order by SUM(Foods.Price * FoodOrderLines.FoodQty + Beverages.Price * BeverageOrderLines.BeverageQty) desc

	/*select *
	from Customers
	join Orders on Customers.CustomerID=Orders.CustomerID
	full join FoodOrderLines on FoodOrderLines.OrderID=Orders.OrderID
	full join BeverageOrderLines on BeverageOrderLines.OrderID=Orders.OrderID
	full join Foods on Foods.FoodID=FoodOrderLines.FoodID
	full join Beverages on Beverages.BeverageID=BeverageOrderLines.BeverageID
	where CONCAT(customers.FirstName,' ',customers.LastName)='Danny Savage'*/