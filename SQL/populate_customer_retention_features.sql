use ecommerce ;

truncate table customer_retention_features;

INSERT INTO customer_retention_features (
    CustomerID,
    RecencyDays,
    ActiveSpanDays,
    AvgIPTDays,
    RecencyRatio,
    IsAtRisk,
    SpendLast_60d,
    OrderVolumeTrend,
    ProductBreadthTotal,
    ProductBreadth_60d,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    RFM_Cell
)
WITH reference_date AS (
    SELECT MAX(InvoiceDate) AS LastDate 
    FROM fact_transactions
),
customer_aggregates AS (
    SELECT 
        f.CustomerID,
        DATEDIFF(r.LastDate, MAX(f.InvoiceDate)) AS RecencyDays,
        DATEDIFF(MAX(f.InvoiceDate), MIN(f.InvoiceDate)) AS ActiveSpanDays,
        COUNT(DISTINCT f.Invoice) AS TotalOrders,
        SUM(f.Quantity * f.Price) AS TotalOrderVolume,
        COUNT(DISTINCT f.StockCode) AS TotalBreadth,
        CASE 
            WHEN COUNT(DISTINCT f.Invoice) > 1 
            THEN DATEDIFF(MAX(f.InvoiceDate), MIN(f.InvoiceDate)) / (COUNT(DISTINCT f.Invoice) - 1.0)
            ELSE DATEDIFF(r.LastDate, MIN(f.InvoiceDate))   
        END AS AvgIPTDays
    FROM fact_transactions f
    CROSS JOIN reference_date r
    GROUP BY f.CustomerID, r.LastDate
),
recent_60_days AS (
    SELECT 
        f.CustomerID,
        SUM(f.Quantity * f.Price) AS SpendLast_60d,
        COUNT(DISTINCT f.StockCode) AS BreadthLast_60d
    FROM fact_transactions f
    CROSS JOIN reference_date r
    WHERE f.InvoiceDate >= DATE_SUB(r.LastDate, INTERVAL 60 DAY)
    GROUP BY f.CustomerID
),
feature_engineering AS (
    SELECT 
        ca.CustomerID,
        ca.RecencyDays,
        ca.ActiveSpanDays,
        ca.AvgIPTDays,
        ROUND(
            CASE 
                WHEN ca.AvgIPTDays IS NULL OR ca.AvgIPTDays = 0 THEN 0.0 
                ELSE ca.RecencyDays / ca.AvgIPTDays 
            END, 2
        ) AS RecencyRatio,
        CASE 
            WHEN ca.AvgIPTDays > 0 AND (ca.RecencyDays / ca.AvgIPTDays) > 2.0 THEN 1 
            ELSE 0 
        END AS IsAtRisk,
        COALESCE(r60.SpendLast_60d, 0) AS SpendLast_60d,
        ROUND(
            CASE 
                WHEN ca.ActiveSpanDays = 0 OR ca.TotalOrderVolume = 0 THEN 0.0
                ELSE COALESCE(r60.SpendLast_60d, 0) / (ca.TotalOrderVolume * 60.0 / ca.ActiveSpanDays)
            END, 2
        ) AS OrderVolumeTrend,
        ca.TotalBreadth,
        COALESCE(r60.BreadthLast_60d, 0) AS BreadthLast_60d,
        ca.TotalOrders,
        ca.TotalOrderVolume
    FROM customer_aggregates ca
    LEFT JOIN recent_60_days r60 ON ca.CustomerID = r60.CustomerID
),
rfm_scores AS (
    SELECT 
        *,
        NTILE(5) OVER(ORDER BY RecencyDays DESC) AS R_Score,  -- ASC so 5 is most recent
        NTILE(5) OVER(ORDER BY TotalOrders ASC) AS F_Score,
        NTILE(5) OVER(ORDER BY TotalOrderVolume ASC) AS M_Score
    FROM feature_engineering
)
SELECT 
    CustomerID,
    RecencyDays,
    ActiveSpanDays,
    AvgIPTDays,
    RecencyRatio,
    IsAtRisk,
    SpendLast_60d,
    OrderVolumeTrend,      
    TotalBreadth,          
    BreadthLast_60d,
    TotalOrders,            
    TotalOrderVolume,       
    R_Score,
    F_Score,
    M_Score,
    CONCAT(CAST(R_Score AS CHAR), CAST(F_Score AS CHAR), CAST(M_Score AS CHAR)) AS RFM_Cell
FROM rfm_scores;