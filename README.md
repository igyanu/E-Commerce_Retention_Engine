# E-Commerce Customer Retention & Churn Analysis

An end-to-end analytics and machine learning solution designed to identify churn-risk customers, project revenue at risk, and deliver actionable retention strategies from a **1M+ transaction dataset**.

---

## 📌 Actionable Summary
Customer churn directly impacts revenue growth. This project builds an automated pipeline to extract customer behavior features, compute RFM metrics, train predictive models, and surface real-time actionable insights via an interactive **Power BI Executive Dashboard**.

* **Dataset:** 1M+ raw transaction records
* **Revenue at Risk Identified:** **$2.30M** across **1.15K high-risk customers**
* **Average Recency Ratio:** **2.57x** above individual baseline repurchase windows

---

## 🛠️ Data Pipeline & Architecture

### 1. Data Cleaning & Preprocessing (SQL / Python)
* Handling missing values, duplicate records, and guest checkouts (`CustomerID LIKE 'Guest%'`).
* Grouping transaction-level data into customer-level analytical features.
* Reference date benchmarking using CTEs for absolute time relative metrics.

### 2. Feature Engineering & RFM Scoring
* RecencyRatio: RecencyDays	/ AvgIPTDays — Flags customers exceeding their normal repeat purchase interval.
* IsAtRisk Flag: Binary indicator triggered when RecencyRatio > 2.0.
* OrderVolumeTrend: Ratio of recent 60-day spend vs. historical 60day purchase-rate.
* RFM Segmentation: Quintile scoring (`NTILE(5)`) for **Recency** (DESC), **Frequency** (ASC), and **Monetary** (ASC) to generate `M_Score` segments (e.g., `5` = Champions).

## 📈 Model Performance

Model: XGBoost Classifier, trained with early stopping (validation logloss)
Train/Validation/Test split: 80/10/10, stratified via random_state

**Held-out Test Set Results:**

| Metric              | Class 0 (Retained) | Class 1 (Churned) |
|---------------------|---------------------|--------------------|
| Precision           | 0.98                | 0.85               |
| Recall              | 0.98                | 0.86               |
| F1-score            | 0.98                | 0.86               |

- **ROC-AUC:** 0.986
- **Overall Accuracy:** 96% (874 held-out customers)
- **Decision threshold:** 0.20 (lowered from default 0.5) — deliberately biased toward
  catching more true churners (higher recall) since the cost of missing an at-risk
  high-value customer outweighs the cost of a slightly wasted retention offer.
- **Class imbalance handling:** `scale_pos_weight=0.25` applied to account for
  the minority churn class.

Note: the model was retrained on the full dataset (using the optimal number of
boosting rounds found via early stopping) before being deployed for scoring —
this is standard practice for maximizing training data usage in production, but
the metrics above (from the held-out test set) are the only numbers used to
evaluate real-world performance.


## 📊 Dashboard & Actionable Insights

The **Power BI Dashboard** translates complex retention metrics into executive-level visual insights:
* **High-Level Financial Performance:** Generated **$19.10M in total revenue** across **39.24K orders**, averaging **$486.69 per order** with a typical basket size of **275 items**.
* **Seasonal Revenue Growth:** Demonstrated strong year-end revenue momentum, accelerating from a baseline of $1.0M–$1.5M per month to a peak of **$2.8M in November**.
* **Top Product Drivers:** Sales volume was dominated by fast-moving items, led by **World War 2 Gliders** (105.75K units) and **Jumbo Bag Red Retrospot** (96.26K units).
  <img width="788" height="446" alt="image" src="https://github.com/user-attachments/assets/62cb5042-2b06-419b-9153-a3fb15fd5415" />

  
* **KPI Cards:** Top-line visibility into **Total Revenue at Risk ($2.30M)**, **At-Risk Customer Count (1K)**, and **Avg Recency Ratio (2.57)**.
* **Revenue at Risk by Tier:** Segmentation breakdown showing **$1.50M** at risk in **Champions**, **$0.75M** in **Loyals**, and **$0.05M** in **Low Spenders**.
* **High-Value At-Risk Table:** Immediate visibility into top spending customers( `M_Score >= 4 | F_Score > 4) with estimated churn probabilities`) (e.g., ID `12377` with $3.26K spend and 0.45 churn probability).
* **Low Breadth Analysis:** Pinpointing single-category purchasers (`Distinct Product <= 5 and F_Score > 1 and Recency Ratio < 3`) for targeted cross-sell campaigns.
* <img width="782" height="448" alt="Actionable Insights" src="https://github.com/user-attachments/assets/d385faa9-70a8-456b-a655-405d85f6ce70" />

---

```
## 📂 Project Structure
├── data/                  # Raw & cleaned transaction data
├── sql/                   # SQL feature engineering & RFM scoring pipeline
├── notebooks/             # Data cleaning, EDA, & ML model training
├── dashboard/             # Power BI report (.pbix) & assets
└── README.md              # Project documentation
```
