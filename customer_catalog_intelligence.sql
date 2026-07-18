-- How many tracks does each album have and who is the artist?
-- Establishes catalog depth, useful for identifying content-heavy artists

WITH TrackCounts AS (
SELECT
     Track.AlbumId,
     COUNT(Track.TrackId) AS NumberofTracks
FROM Track
GROUP BY Track.AlbumId
)
SELECT
    Album.Title,
    Artist.Name AS ArtistName,
    TrackCounts.NumberofTracks
FROM TrackCounts
JOIN Album ON Album.AlbumId = TrackCounts.AlbumId
JOIN Artist ON Artist.ArtistId = Album.ArtistId
ORDER BY NumberofTracks DESC;


-- Which employee manages the most people?
-- Nancy Edwards manages the most direct reports (3)

SELECT 
   mgr.FirstName || ' ' || mgr.LastName AS EmployeeFullName,
   COUNT(emp.EmployeeID) AS TotalEmployeeManaged
FROM Employee emp
JOIN Employee mgr ON emp.ReportsTo = mgr.EmployeeId
GROUP BY EmployeeFullName 
ORDER BY TotalEmployeeManaged DESC;


-- Which customers have spent above the average customer spend?
-- Identifies high value customers for loyalty or upsell targeting

WITH SpendPerCustomer AS (
    SELECT CustomerId, SUM(Total) AS CustomerTotal
    FROM Invoice
    GROUP BY CustomerId
),
AvgSpend AS (
    SELECT AVG(CustomerTotal) AS AverageSpent
    FROM SpendPerCustomer
)
SELECT 
    Customer.FirstName || ' ' || Customer.LastName AS CustomerName,
    SUM(Invoice.Total) AS CustomerSpending
FROM Customer
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
CROSS JOIN AvgSpend
GROUP BY CustomerName
HAVING CustomerSpending > AvgSpend.AverageSpent
ORDER BY CustomerSpending DESC;


-- How are artists ranked by total revenue generated?
-- Surfaces top earning artists for licensing and catalog investment decisions

WITH ArtistRevenue AS (
    SELECT
        Artist.ArtistId,
        Artist.Name AS ArtistName,
        SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS TotalRevenue
    FROM InvoiceLine
    JOIN Track ON Track.TrackId = InvoiceLine.TrackId
    JOIN Album ON Album.AlbumId = Track.AlbumId
    JOIN Artist ON Artist.ArtistId = Album.ArtistId
    GROUP BY Artist.ArtistId, Artist.Name
)
SELECT
    ArtistName,
    TotalRevenue,
    RANK() OVER (ORDER BY TotalRevenue DESC) AS Rank
FROM ArtistRevenue
ORDER BY Rank;


--  Which genres generate the most revenue per track sold? Are premium genres being underutilized?
--  Non-music content (TV Shows, Drama, Comedy, Sci Fi) commands a $1.99 price point vs $0.99 for all music genres
--  Suggests a pricing strategy opportunity for the music catalog

WITH RevenueByGenre AS (
SELECT 
    Genre.Name AS Genre_name,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS TotalRev,
    COUNT(InvoiceLine.TrackId) AS TotalTrackSold
FROM InvoiceLine
JOIN Track ON Track.TrackId = InvoiceLine.TrackId
JOIN Genre ON Genre.GenreId = Track.GenreId
GROUP BY Genre_name
)
SELECT
    Genre_name,
    TotalRev / TotalTrackSold AS RevPerTrack
FROM RevenueByGenre
ORDER BY RevPerTrack DESC;