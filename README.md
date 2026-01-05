# Airbnb End-to-End Data Engineering Project (dbt + Snowflake)

## 📌 Project Overview

This project demonstrates an **end-to-end analytics engineering pipeline** built using **Snowflake** and **dbt**, following modern **lakehouse-style layered modeling (Bronze → Silver → Gold)**.

The goal of the project is to ingest raw Airbnb data from **Amazon S3**, stage it in Snowflake, and build **analytics-ready, scalable, and maintainable models** using dbt with incremental loading, upserts, metadata-driven design, and dimensional modeling (SCD Type 2).

---

## 🏗️ Architecture

**Source → Snowflake → dbt Transformations → Analytics Models**

```
S3 Bucket
   ↓ (External Stage + Storage Integration)
Snowflake Staging Schema
   ↓
Bronze Layer (Raw, Incremental)
   ↓
Silver Layer (Cleaned, Upserted, Enriched)
   ↓
Gold Layer
   ├── One Big Table (OBT – metadata-driven)
   └── Star Schema (Facts + SCD Type 2 Dimensions)
```

---

## 🔌 Data Ingestion (S3 → Snowflake)

* Airbnb data is stored in an **Amazon S3 bucket**
* A **Snowflake Storage Integration** and **External Stage** are created
* Data is loaded into Snowflake **staging schema** using Snowflake-managed access
* dbt references these staged tables as sources

This approach ensures:

* Secure access using IAM roles
* No hard-coded credentials
* Scalable ingestion pattern

---

## 🥉 Bronze Layer (Raw Incremental Models)

The **Bronze layer** represents raw, lightly processed data loaded incrementally from Snowflake sources.

### Models

* `bronze_bookings.sql`
* `bronze_listings.sql`
* `bronze_hosts.sql`

### Key Characteristics

* Incremental models using `materialized='incremental'`
* Source-aligned schemas
* Minimal transformations
* Primary keys used for deduplication

Purpose:

> Preserve raw data while enabling efficient incremental ingestion.

---

## 🥈 Silver Layer (Cleaned & Enriched Data)

The **Silver layer** applies business logic, data quality improvements, and upsert logic.

### Models

* `silver_bookings.sql`
* `silver_listings.sql`
* `silver_hosts.sql`

### Key Features

* **Upserts using incremental + unique_key**
* Column-level transformations
* Business-derived fields

### Example Transformation

In `silver_bookings.sql`, a new column is derived:

* `total_booking_amount` = base price + service fee + cleaning fee

Similar enrichment logic is applied across listings and hosts.

Purpose:

> Produce clean, trusted, and analytics-ready datasets.

---

## 🥇 Gold Layer – Analytics Models

The **Gold layer** contains business-consumable models optimized for analytics and reporting.

### 1️⃣ One Big Table (OBT)

* Implemented in `obt.sql`
* Built using a **metadata-driven approach**

#### Why metadata-driven?

* Avoids hard-coded joins
* Easily extensible when new tables are introduced
* Only configuration changes required to add new datasets

#### Approach

* Table, column selection, aliases, and join conditions are stored in a Jinja config structure
* dbt dynamically generates the SELECT and JOIN logic

This enables scalable, maintainable modeling without rewriting SQL.

---

### 2️⃣ Star Schema with SCD Type 2

This layer supports historical analysis and dimensional modeling.

#### Steps

1. **Ephemeral Models**

   * Created from the OBT
   * Select only required columns for each dimension
   * Improves reuse and reduces duplication

2. **Dimension Tables**

   * Built using dbt **snapshots**
   * Implement **Slowly Changing Dimension (SCD) Type 2**
   * Track historical changes for listings and hosts

3. **Fact Table**

   * Built using a **metadata-driven join approach**
   * Joins fact data with dimension tables

Purpose:

> Enable time-travel analysis, historical tracking, and BI-friendly schemas.

---

## 🧪 Data Quality & Testing

dbt tests are implemented to ensure reliability:

* `not_null`
* `unique`
* Referential integrity checks


---

## 🧰 dbt Macros

Reusable macros were created to standardize transformations:

* **Multiply macro** – supports precision-based calculations
* **Tag macro** – categorizes values into business-friendly buckets
* **Trimmer macro** – cleans string columns consistently

Macros improve:

* Reusability
* Readability
* Consistency across models

---

## 🛠️ Tools & Technologies

* **Snowflake** – Cloud data warehouse
* **dbt Core** – Transformations & modeling
* **Amazon S3** – Raw data storage
* **SQL & Jinja** – Transformations and templating
* **Git & GitHub** – Version control

---

## 🚀 Key Highlights

* End-to-end ELT pipeline
* Incremental loading & upserts
* Metadata-driven modeling
* Dimensional modeling with SCD Type 2
* Production-grade dbt practices

---

## 📈 Future Enhancements

* Add dbt exposures for BI tools
* Automate runs using Airflow or GitHub Actions
* Introduce data freshness checks
* Expand metrics layer

---

## 📄 Notes

* `profiles.yml` is intentionally excluded for security reasons
* Secrets are managed using environment variables

---

✅ This project reflects real-world analytics engineering practices using dbt and Snowflake.
