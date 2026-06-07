# Decoding Customer Value: A SQL-Driven Retention Strategy

A customer analytics project built for a D2C fashion brand operating across the US. The goal was to identify what the brand's most valuable customers look like, measure how much revenue depends on promotions, and build a data-backed retention strategy — using only transactional and behavioral data with no pre-built loyalty scores or churn labels.

---

## Problem Statement

The brand had data on ~3,900 customers but no intelligence built on top of it. It couldn't answer who its loyal customers actually were, whether its discount program was building retention or just attracting one-time buyers, or which geographies and demographics were worth targeting. Every marketing decision was being made on gut feel.

---

## What We Built

**Python — Data Cleaning & Feature Engineering**
- Cleaned raw dataset: removed duplicate columns, standardised frequency labels, imputed missing review ratings
- Engineered 7 customer-level features from scratch:
  - `Frequency Score` — numeric mapping of purchase cadence
  - `Value Score & Tier` — composite of spend and purchase history
  - `Loyalty Score A` — behaviour-based (frequency + purchase history)
  - `Loyalty Score B` — discount-adjusted loyalty (penalises promo reliance)
  - `Loyalty Tier` — High / Mid / Low, traceable to variable thresholds
  - `Promo Dependency Score` — 0 (independent), 1 (opportunistic), 2 (structural)
  - `Satisfaction Flag` — above/below median review rating

Two competing loyalty definitions were built and tested. Loyalty Score B was chosen because it accounts for discount dependency, which is directly relevant to the core business question.

**SQL — Customer Segmentation**
- Loaded engineered dataset into MySQL
- Wrote 5 segmentation queries answering the business questions:
  1. Loyal vs discount-dependent customers by tier
  2. Behavioural patterns that predict high customer value
  3. Geographic opportunity — spend vs promo dependency by state
  4. Promotional restructuring analysis by loyalty segment
  5. Ideal customer profile — High Loyalty + High Value + zero discount history

**Power BI — Founder Dashboard**
- Four-panel dashboard built for a non-technical founding team:
  - Customer Value Pyramid (distribution across Low / Mid / High Value)
  - Promo Dependency by Loyalty Tier (Yes/No discount split per segment)
  - Geographic Opportunity Scatter (avg spend vs avg promo dependency by state)
  - Category Funnel (avg previous purchases by product category)

**Retention Playbook**
- Three-phase promotional sunset plan with segment, trigger behavior, rollout timeline, metric, and trade-off stated for each phase
- Ideal customer profile built from 492 customers who are simultaneously High Loyalty, High Value, and have never used a discount

---

## Key Findings

- 43% of customers received a discount, but discounted customers spend nearly the same ($59.3) as non-discounted ones ($60.1) — discounts are not building value
- 78.5% of High Loyalty customers buy without any discount, making them the safest segment to deprioritise promos for
- Discount usage is entirely gender-gated in this dataset (a data artifact, not brand policy) — flagged and accounted for in all analyses
- Alaska, Arizona, and Tennessee show the highest spend combined with the lowest promo dependency — organic brand pull in untargeted states
- The ideal customer is non-subscribed, aged 31-60, shops fortnightly or weekly, and has never used a promo

---

## Tech Stack

- Python (pandas, numpy, sqlalchemy, matplotlib)
- MySQL / MySQL Workbench
- Power BI Desktop
- Microsoft Word

---

## Project Structure

```
SQL Project/
├── customer_analysis.ipynb       # Data cleaning + feature engineering
├── customer_analysis_clean.csv   # Engineered dataset (28 columns, 3900 rows)
├── segmentation_queries.sql      # 5 commented segmentation queries
├── FourPanel_Dashboard.pbix      # Power BI dashboard
├── Retention_Playbook.docx       # Promo sunset plan + ideal customer profile
└── Executive_Summary.docx        # 1-page summary of findings and recommendations
```

---

## Limitations

- No timestamps in the dataset — recency could not be calculated and customer movement between tiers over time cannot be observed
- No acquisition channel data — cannot trace where high-value customers came from, which limits acquisition targeting recommendations
- Discount usage is gender-gated in this data, which confounds promo behavior analysis with demographic signals

---

## Context

Built as part of Summer Projects '26 — Consulting & Analytics Club, IIT Guwahati.
