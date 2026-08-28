use ecommerce;

create table if not exists customer_retention_features(
CustomerID varchar(50) primary key ,
RecencyDays int ,
ActiveSpan_days int,
AvgIPTDays decimal(10,2) , -- average interpurchase time
RecencyRatio decimal(10,2) ,
IsAtRisk boolean ,
SpendLast_60d decimal(10,2) ,
OrderVolumeTrend decimal(10,2),   -- spend in 30 days / monthly avg spend in 90 days
ProductBreadthTotal int,
ProductBreadth_60d int,
Frequency int,
Monetary decimal(10,2),
R_Score int,
F_Score int, 
M_Score int,
RFM_Cell varchar(10)
);
