# E-Commerce Customer Retention & Churn Analysis

An end-to-end analytics and machine learning solution designed to identify churn-risk customers, project revenue at risk, and deliver actionable retention strategies from a **1M+ transaction dataset**.

---

## 📌 Executive Summary
Customer churn directly impacts revenue growth. This project builds an automated pipeline to extract customer behavior features, compute RFM metrics, train predictive models, and surface real-time actionable insights via an interactive **Power BI Executive Dashboard**.

* **Dataset:** 1M+ raw transaction records
* **Revenue at Risk Identified:** **$2.30M** across **1K high-risk customers**
* **Average Recency Ratio:** **2.57x** above individual baseline repurchase windows

---

## 🛠️ Data Pipeline & Architecture

### 1. Data Cleaning & Preprocessing (SQL / Python)
* Handling missing values, duplicate records, and guest checkouts (`CustomerID LIKE 'Guest%'`).
* Grouping transaction-level data into customer-level analytical features.
* Reference date benchmarking using CTEs for absolute time relative metrics.

### 2. Feature Engineering & RFM Scoring
* RecencyRatio: RecencyDays	/ AvgIPTDays — Flags customers exceeding their normal repeat purchase interval.
* IsAtRisk Flag: Binary indicator triggered when $	ext{RecencyRatio} > 2.0$.
* OrderVolumeTrend: Ratio of recent 60-day spend vs. historical annualized run-rate.
* RFM Segmentation: Quintile scoring (`NTILE(5)`) for **Recency** (DESC), **Frequency** (ASC), and **Monetary** (ASC) to generate `RFM_Cell` segments (e.g., `555` = Champions).

### 3. Model Training & Churn Prediction
* Supervised Machine Learning algorithms trained on engineered features.
* Outputs individual **Churn Probability** scores per customer to prioritize high-value win-back campaigns.
---

## 📊 Dashboard & Actionable Insights

The **Power BI Dashboard** translates complex retention metrics into executive-level visual insights:
* **High-Level Financial Performance:** Generated **$19.10M in total revenue** across **39.24K orders**, averaging **$486.69 per order** with a typical basket size of **275 items**.
* **Seasonal Revenue Growth:** Demonstrated strong year-end revenue momentum, accelerating from a baseline of ~$1.0M–$1.5M per month to a peak of **~$2.8M in November**.
* **Top Product Drivers:** Sales volume was dominated by fast-moving items, led by **World War 2 Gliders** (105.75K units) and **Jumbo Bag Red Retrospot** (96.26K units).
  
* **KPI Cards:** Top-line visibility into **Total Revenue at Risk ($2.30M)**, **At-Risk Customer Count (1K)**, and **Avg Recency Ratio (2.57)**.
* **Revenue at Risk by Tier:** Segmentation breakdown showing **$1.50M** at risk in **Champions**, **$0.75M** in **Loyals**, and **$0.05M** in **Low Spenders**.
* **High-Value At-Risk Table:** Immediate visibility into top spending customers with elevated churn probabilities (e.g., ID `12377` with $3.26K spend and 0.45 churn probability).
* **Low Breadth Analysis:** Pinpointing single-category purchasers (`Distinct Product <= 5`) for targeted cross-sell campaigns.
---

```
## 📂 Project Structure
├── data/                  # Raw & cleaned transaction data
├── sql/                   # SQL feature engineering & RFM scoring pipeline
├── notebooks/             # Data cleaning, EDA, & ML model training
├── dashboard/             # Power BI report (.pbix) & assets
└── README.md              # Project documentation
```
