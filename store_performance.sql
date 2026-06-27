-- What are the top 10 best-selling tracks?

SELECT 
 Track.Name, Track.TrackId, 
 SUM(InvoiceLine.Quantity) AS TotalSold 
FROM Track  
JOIN InvoiceLine on Track.TrackId=InvoiceLine.TrackId
GROUP BY Track.Name, Track.TrackId
ORDER BY TotalSold DESC 
LIMIT 10;


-- Which countries generate the most revenue?

SELECT 
  Invoice.BillingCountry as Country, 
  SUM(Invoice.Total) as Revenue
From Invoice
GROUP BY BillingCountry 
ORDER BY Revenue DESC;


-- Which sales rep has generated the most revenue?

WITH SalesRevenue AS (
SELECT 
   Customer.SupportRepId,
   SUM(Invoice.Total) AS Revenue
FROM Invoice
JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.SupportRepId
)
SELECT 
    Employee.FirstName || ' ' || Employee.LastName AS SalesRep,
    SalesRevenue.Revenue
FROM SalesRevenue
JOIN Employee ON Employee.EmployeeId = SalesRevenue.SupportRepId
ORDER BY Revenue DESC;


-- What is the most popular genre by number of tracks sold?

WITH TrackSold AS (
SELECT 
     Track.GenreId,
     COUNT(InvoiceLine.TrackID) AS NumberofTrackSold
FROM Track
JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
Group BY GenreId
)
SELECT Genre.Name, TrackSold.NumberofTrackSold
FROM TrackSold
JOIN Genre ON TrackSold.GenreId = Genre.GenreId 
ORDER BY NumberofTrackSold DESC;


-- What does the monthly revenue trend look like across all time?

-- Calculate MoM Change using LAG() to identify seanonal pattern, rev peaks and declining months
-- Visualize Monthly Revenue trendusing a combo chart with MoM as Trend Line in Excel, added in README.md

SELECT 
  Date, 
  Revenue, 
  Revenue - LAG(Revenue) Over (Order BY Date) AS MoM_Change
FROM (
  SELECT 
     strftime('%Y-%m',InvoiceDate) AS Date,
     SUM(Total) As Revenue
  FROM Invoice
  Group BY Date 
) As MonthlyRevenue
ORDER BY Date ASC;


























