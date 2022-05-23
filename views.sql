use vizsgaremek
go
create view PersonToArea as
 select concat(FirstName,' ',LastName) as "Delivery Member Name",string_agg(AreaName,', ') as Area from Person.DeliveryMember join Area.Areapairing on Person.DeliveryMember.DeliveryMemberID=Area.Areapairing.DeliveryMemberID join Area.Area on Area.AreaID=Areapairing.AreaID
group by FirstName,LastName
go
create view NicholasGordonWhatToEat as
select CONCAT(c.FirstName,' ',c.LastName) as Customer,string_agg(f.Name,', ') as "What is he Eating?"
	from Person.CustomerAddress ca
	join "Order".OrderHeader oh on ca.CustomerAddressID=oh.CustomerAddressID 
	join "Order".FoodOrderLine fol on oh.OrderID=fol.OrderID 
	join Product.Food f on fol.FoodID=f.FoodID
	join Person.Customer c on c.CustomerID = ca.CustomerID
	group by CONCAT(c.FirstName,' ',c.LastName)
go
create view HungarianPizzaEaters as
select CONCAT(CONCAT(c.FirstName,' ',c.LastName),' ','eats Hungarian Pizza') as Customer  
	from person.Customer c
	join Person.CustomerAddress	ca on c.CustomerID=ca.CustomerID
	join "order".OrderHeader oh on ca.CustomerAddressID = oh.CustomerAddressID
	join "Order".FoodOrderLine fol on fol.OrderID=oh.OrderID
	join Product.Food f on fol.FoodID=f.FoodID
	where f.Name='Hungarian Pizza'
go
create view Top5Spenders as
select TOP 5 CONCAT(c.FirstName,' ',c.LastName) as Customer ,SUM(f.Price * fol.FoodQty + b.Price * bol.BeverageQty) as TotalSpent
	from Person.CustomerAddress ca
	join "Order".OrderHeader oh on ca.CustomerAddressID=oh.CustomerAddressID
	left join "Order".FoodOrderLine fol on oh.OrderID=fol.OrderID
	left join "Order".BeverageOrderLine bol on oh.OrderID=bol.OrderID
	join Product.Food f on fol.FoodID=f.FoodID
	join Product.Beverage b on bol.BeverageID=b.BeverageID
	join "Person".Customer c on ca.CustomerID = c.CustomerID
	group by CONCAT(c.FirstName,' ',c.LastName)
	order by TotalSpent desc
	go

	/*select *
	from Customers
	join Orders on Customers.CustomerID=Orders.CustomerID
	full join FoodOrderLines on FoodOrderLines.OrderID=Orders.OrderID
	full join BeverageOrderLines on BeverageOrderLines.OrderID=Orders.OrderID
	full join Foods on Foods.FoodID=FoodOrderLines.FoodID
	full join Beverages on Beverages.BeverageID=BeverageOrderLines.BeverageID
	where CONCAT(customers.FirstName,' ',customers.LastName)='Danny Savage'*/