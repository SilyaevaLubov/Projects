# 💹 Venture Investment Analysis: Startup Funding Patterns

[![Python](https://img.shields.io/badge/Python-3.8+-3776AB?logo=python)]()
[![Pandas](https://img.shields.io/badge/Pandas-%20-150458?logo=pandas)]()

## 🔎 About the Project

A financial company specializing in **venture investments** wants to understand the patterns of startup financing and assess the prospects of entering the market through the acquisition and development of companies.

The project conducts a comprehensive study using **historical data from 2000 to 2014** to identify growth trends and return‑on‑investment patterns across different market segments and funding types.

## 🛠️ Analysis Tools

- 🐍 **Python** — main programming language for data analysis
- 🐼 **Pandas** — data manipulation and analysis
- 📊 **Matplotlib** — basic data visualization
- 🌠 **Seaborn** — advanced statistical data visualization
- 🧪 **SciPy** — statistical analysis and hypothesis testing

## 🎯 Goals and Objectives

**Goal:** Identify market segments with the fastest and most stable growth, and funding types with the most sustainable growth in return rates.

**Objectives:**

- 📊 **Data Exploration:** Analyze data volume, structure, missing values, data types, and key characteristics.
- 🧹 **Data Preprocessing:** Standardize data formats, correct data types, handle missing values and duplicates, create new columns if needed.
- 🕵️ **Comprehensive Data Analysis:** Examine funding patterns, growth trends, and return rates across segments and funding types.
- 💡 **Conclusions & Recommendations:** Summarize findings and provide actionable insights for investment strategy.

## 🗃️ Dataset Overview

### 1. `cb_investments` — Startup Funding Data

Contains information about companies and their funding history.

| Column | Description |
|--------|-------------|
| `name` | Company name |
| `homepage_url` | Company website URL |
| `category_list` | Categories the company operates in (separated by `\|`) |
| `market` | Main market or industry |
| `funding_total_usd` | Total amount of investments raised (USD) |
| `status` | Current company status (e.g., operating, closed) |
| `country_code` | Country code (e.g., USA) |
| `state_code` | State or region code (e.g., CA) |
| `region` | Geographic region (e.g., SF Bay Area) |
| `city` | City where the company is located |
| `funding_rounds` | Total number of funding rounds |
| `participants` | Number of participants in funding rounds |
| `founded_at` | Date the company was founded |
| `founded_month` | Month of founding (YYYY‑MM format) |
| `founded_quarter` | Quarter of founding (YYYY‑QN format) |
| `founded_year` | Year the company was founded |
| `first_funding_at` | Date of first funding round |
| `mid_funding_at` | Date of median funding round |
| `last_funding_at` | Date of last funding round |
| `seed` | Seed stage investment amount |
| `venture` | Venture capital investment amount |
| `equity_crowdfunding` | Equity crowdfunding amount |
| `undisclosed` | Undisclosed funding amount |
| `convertible_note` | Convertible note investment amount |
| `debt_financing` | Debt financing amount |
| `angel` | Angel investment amount |
| `grant` | Grant amount |
| `private_equity` | Private equity investment amount |
| `post_ipo_equity` | Post‑IPO equity funding amount |
| `post_ipo_debt` | Post‑IPO debt financing amount |
| `secondary_market` | Secondary market transaction amount |
| `product_crowdfunding` | Product crowdfunding amount |
| `round_A`–`round_H` | Investment amount in specific funding rounds |

### 2. `cb_returns` — Investment Returns Data

Provides information about return volumes by year and funding type (in millions of USD).

| Column | Description |
|--------|-------------|
| `year` | Year of return |
| `seed` | Returns from seed investments |
| `venture` | Returns from venture capital investments |
| `equity_crowdfunding` | Returns from equity crowdfunding |
| `undisclosed` | Returns from undisclosed funding |
| `convertible_note` | Returns from convertible notes |
| `debt_financing` | Returns from debt financing |
| `angel` | Returns to angel investors |
| `grant` | Returns from grants |
| `private_equity` | Returns from private equity investments |
| `post_ipo_equity` | Returns from post‑IPO equity |
| `post_ipo_debt` | Returns from post‑IPO debt |
| `secondary_market` | Returns from secondary market transactions |
| `product_crowdfunding` | Returns from product crowdfunding |

## 🔬 Key Work Stages

1. 💾 **Data Loading & Initial Exploration:** Load datasets and get familiar with their structure and content.
2. 🔎 **Data Quality Check & Preprocessing:** Identify and fix errors, clean the data, handle missing values and duplicates.
3. 📈 **Funding Pattern Analysis:**
   - 🏢 Examine growth trends by market segment.
   - 📅 Analyze funding patterns over time (2000–2014).
   - 👥 Study the relationship between founding year and funding success.
4. 💵 **Return on Investment Analysis:**
   - 💹 Compare return rates across funding types.
5. 💡 **Conclusions & Strategic Recommendations:** Summarize findings and provide actionable investment strategy recommendations.
