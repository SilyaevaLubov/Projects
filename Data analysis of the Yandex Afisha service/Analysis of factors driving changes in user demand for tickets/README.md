# 🎟️ Yandex Afisha: Ticket Demand Analysis

[![Python](https://img.shields.io/badge/Python-3.8+-3776AB?logo=python)]()
[![Pandas](https://img.shields.io/badge/Pandas-%20-150458?logo=pandas)]()

## 🔎 About the Project

**Yandex Afisha** is a service that helps users discover events in different cities and purchase tickets for them. The platform collaborates with partners — event organizers and ticketing operators — who provide event information and list tickets for sale.

To plan promotions effectively, we need to **identify the reasons behind changes in ticket demand**. This project uses data from **June to November 2024** to conduct a comprehensive analysis.

## 🛠️ Analysis Tools

- 🐍 **Python** — main programming language
- 🐼 **Pandas** — data manipulation and analysis
- 📊 **Matplotlib** — data visualization
- 🌠 **Seaborn** — advanced data visualization
- 🧪 **SciPy** — statistical analysis

## 🎯 Goals and Objectives

**Goal:** Identify the factors driving changes in user demand for tickets.

**Objectives:**

- 📊 **Data Exploration:** Analyze data volume, structure, missing values, data types, and other key characteristics.
- 🧹 **Data Preprocessing:** Standardize data formats, correct data types, handle missing values and duplicates, and create new columns if needed.
- 🕵️ **Exploratory Data Analysis (EDA):** Uncover patterns, trends, and insights from the data.
- 📈 **Statistical Analysis:** Apply statistical methods to validate findings and quantify relationships.
- 💡 **Conclusions & Recommendations:** Summarize results and provide actionable recommendations for the business.

## 🗃️ Dataset Overview

### 1. `final_tickets_orders_df` — Ticket Orders Data

Contains information about all ticket orders made via mobile and desktop devices.

| Column | Description |
|--------|-------------|
| `order_id` | Unique order identifier |
| `user_id` | Unique user identifier |
| `created_dt_msk` | Order creation date (Moscow time) |
| `created_ts_msk` | Order creation timestamp (Moscow time) |
| `event_id` | Event identifier (linked to the `events` table) |
| `cinema_circuit` | Cinema chain (if applicable; otherwise `'нет'`) |
| `age_limit` | Age restriction for the event |
| `currency_code` | Payment currency (e.g., `rub` for Russian rubles) |
| `device_type_canonical` | Device type used to place the order |
| `revenue` | Revenue from the order |
| `service_name` | Name of the ticketing operator |
| `tickets_count` | Number of tickets purchased |
| `total` | Total order amount |
| `days_since_prev` | Days since the user’s previous purchase (missing if no prior purchase) |

### 2. `final_tickets_events_df` — Event Information

Provides details about events, including location and venue information.

| Column | Description |
|--------|-------------|
| `event_id` | Unique event identifier |
| `event_name` | Event name |
| `event_type_description` | Description of the event type |
| `event_type_main` | Main event category |
| `organizers` | Event organizers |
| `region_name` | Region name |
| `city_name` | City name |
| `venue_id` | Unique venue identifier |
| `venue_name` | Venue name |
| `venue_address` | Venue address |

### 3. `final_tickets_tenge_df` — Tenge to Ruble Exchange Rate (2024)

Currency data for 2024, with values in rubles for 100 tenge.

| Column | Description |
|--------|-------------|
| `nominal` | Nominal value (100 tenge) |
| `data` | Date |
| `curs` | Tenge-to-Ruble exchange rate |
| `cdx` | Currency code (`kzt`) |

## 🔬 Key Work Stages

1. 💾 **Data Loading & Initial Exploration:** Load datasets and get familiar with their structure and content.
2. 🔎 **Data Quality Check & Preprocessing:** Identify and fix errors, clean the data, handle missing values and duplicates.
3. 🕵️ **Exploratory Data Analysis:**
   - 📊 Analyze order distribution across segments and seasonal changes.
   - 🍂 Examine user activity during autumn months.
   - 🌟 Identify popular events and key partners.
4. 📊 **Statistical Analysis:** Apply appropriate statistical tests and models to validate hypotheses.
5. 💡 **Conclusions & Recommendations:** Summarize findings and provide actionable business recommendations.
