DROP TABLE IF EXISTS Sales;

CREATE TABLE IF NOT EXISTS Sales(
	InvoiceNo TEXT NOT NULL,
	StockCode TEXT NOT NULL,
	Description TEXT,
	Quantity INT,
	InvoiceDate TEXT, -- as sqlite doesn't have date/datetime 
	UnitPrice FLOAT,
	CustomerID INT,
	Country TEXT
);


-- Top 10 customers

 	select CustomerID
    from Sales
    where CustomerID is not null
    group by 1
    order by sum(Quantity*UnitPrice) desc
    limit 10;
    
    
-- Most popular products

	select orders.StockCode, orders.Description, count(distinct orders.InvoiceNo) as nbOrders, sum(orders.Quantity*orders.UnitPrice) as Amount
    from Sales orders
    left join Sales cancels
    		on orders.CustomerID = cancels.CustomerID
    		and orders.StockCode = cancels.StockCode
    		and orders.InvoiceDate <= cancels.InvoiceDate
    		and cancels.InvoiceNo like 'C%'
    where orders.InvoiceNo not like 'C%' and cancels.CustomerID is null
    group by 1,2
    order by 3 desc
    limit 25;
    
    
-- Monthly revenue

    select concat(substr(InvoiceDate, INSTR(InvoiceDate, ' ')-4, 4), '-', substr(InvoiceDate, 0, INSTR(InvoiceDate, '/'))) as TimePeriod,
        cast(substr(InvoiceDate, INSTR(InvoiceDate, ' ')-4, 4) as int)*100 + cast(substr(InvoiceDate, 0, INSTR(InvoiceDate, '/')) as int) as TimePeriod_alt,
        sum(Quantity*UnitPrice) as Revenue
    from Sales
    group by 1,2
    order by 2;
    