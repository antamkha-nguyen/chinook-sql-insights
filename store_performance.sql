
-- What are the top 10 best-selling tracks by units sold?
-- Identifies highest demand tracks for playlist and catalog strategy

SELECT 
 Track.Name, 
 Track.TrackId, 
 SUM(InvoiceLine.Quantity) AS TotalSold 
FROM Track  
JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Track.Name, Track.TrackId
ORDER BY TotalSold DESC 
LIMIT 10;


-- Which countries generate the most revenue?
-- USA leads at $523, followed by Canada and France
-- Useful for geographic marketing and regional pricing decisions

SELECT 
  Invoice.BillingCountry AS Country, 
  SUM(Invoice.Total) AS Revenue
FROM Invoice
GROUP BY BillingCountry 
ORDER BY Revenue DESC;


-- Which sales rep has generated the most revenue?
-- Jane Peacock leads with $833, followed by Margaret Park and Steve Johnson

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
-- Rock dominates at 835 units sold, doubles the next genre (Latin at 386)

WITH TrackSold AS (
SELECT 
     Track.GenreId,
     COUNT(InvoiceLine.TrackID) AS NumberofTrackSold
FROM Track
JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY GenreId
)
SELECT Genre.Name, TrackSold.NumberofTrackSold
FROM TrackSold
JOIN Genre ON TrackSold.GenreId = Genre.GenreId 
ORDER BY NumberofTrackSold DESC;


-- What does the monthly revenue trend look like across all time? (2009-2013)
-- Used to identify seasonal patterns, revenue peaks and declining months
-- Visualized as a combo chart in Excel (see README for screenshot)

SELECT 
  Date, 
  Revenue, 
  Revenue - LAG(Revenue) OVER (ORDER BY Date) AS MoM_Change
FROM (
  SELECT 
     strftime('%Y-%m', InvoiceDate) AS Date,
     SUM(Total) AS Revenue
  FROM Invoice
  GROUP BY Date 
) AS MonthlyRevenue
ORDER BY Date ASC;
