# ✈️ Airline Flight Delay Analytics

An end-to-end data analytics project analyzing airline flight delays, cancellation patterns, airline performance, and route efficiency using Python, SQL, and Tableau.

![Python](https://img.shields.io/badge/Python-3.10+-blue)
![Pandas](https://img.shields.io/badge/Pandas-2.0+-green)
![Tableau](https://img.shields.io/badge/Tableau-2023+-orange)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 📑 Table of Contents

- [📌 Project Overview](#-project-overview)
- [📂 Project Structure](#-project-structure)
- [🛠️ Tools & Technologies](#️-tools--technologies)
- [📊 Key Business Insights](#-key-business-insights)
- [🚀 Getting Started](#-getting-started)
- [📈 Tableau Dashboards](#-tableau-dashboards)
- [📄 Business Report](#-business-report)
- [👤 Author](#-author)
- [📜 License](#-license)

---

## 📌 Project Overview

This project performs comprehensive business analysis on an airline flight delay dataset. The analysis uncovers insights related to flight delays, cancellations, airline performance, airport efficiency, and route popularity. The project answers key business questions using Python for data cleaning and EDA, SQL for querying, and Tableau for interactive dashboards.

---

## 📂 Project Structure

```
Airlines project final intern/
│
├── data/
│ ├── cleaned_data/ # Cleaned datasets (CSV)
│ └── raw_data/ # Raw datasets (CSV)
│
├── final report/ # Business report documents
│
├── notebooks/ # Jupyter Notebooks
│ ├── python_numpy.ipynb
│ ├── pandas_data_cleaning.ipynb
│ ├── matplotlib_seaborn_EDA.ipynb
│ └── business_questions.ipynb
│
├── Sql/ # SQL scripts
│ └── airline_flight_analysis_corrected.sql
│
├── tableau/ # Tableau dashboards
│ ├── Dashboard-1.png
│ ├── Dashboard-2.png
│ ├── Dashboard-3.png
│ └── Dashboard-4.png
│
├── .gitattributes
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```

---

## 🛠️ Tools & Technologies

| Category | Tools |
|---|---|
| **Programming** | Python 3.10+ |
| **Data Manipulation** | Pandas, NumPy |
| **Visualization** | Matplotlib, Seaborn |
| **Database** | MySQL / SQLite |
| **BI Tool** | Tableau |
| **Environment** | Jupyter Notebook |
| **Version Control** | Git, GitHub |

---

## 📊 Key Business Insights

| # | Insight |
|---|---|
| 1 | Identified the **top 5 airlines** with the highest delay rates |
| 2 | **Weather conditions** account for the majority of flight delays |
| 3 | **Peak travel hours** (evening) show highest delay frequency |
| 4 | Certain **routes** consistently experience delays |
| 5 | **Cancellation patterns** correlate with specific months |
| 6 | **Average delay time** varies significantly by airline |
| 7 | **Weekend flights** have lower on-time performance |
| 8 | **Major hub airports** handle highest traffic but also delays |
| 9 | **Short-haul flights** tend to have lower delay times |
| 10 | Identified **most reliable airlines** based on on-time performance |

---

## 🚀 Getting Started

### **1. Clone the Repository**

```bash
git clone https://github.com/shraban50/Airline-Flight-Delay-Analytics.git
cd Airline-Flight-Delay-Analytics
```
### **2. Create Virtual Environment**

```bash
# Windows
python -m venv venv
venv\Scripts\activate

# macOS / Linux
python3 -m venv venv
source venv/bin/activate
```

### **3. Install Dependencies**

```bash
pip install -r requirements.txt
```

### **4. Run Jupyter Notebooks**

```bash
jupyter notebook
```
Open the notebooks in order:

1. `python_numpy.ipynb`

2. `pandas_data_cleaning.ipynb`

3. `matplotlib_seaborn_EDA.ipynb`

4. `business_questions.ipynb`

---

## 📈 Tableau Dashboards

Interactive Airline Analytics Dashboard covering executive KPIs, delay analysis, airline performance, and route insights.

### Dashboard 1 — Executive Overview

**KPIs:** Total Flights · Total Delays · Total Cancellations · Avg Delay Time · On-Time Percentage

![Dashboard 1](https://raw.githubusercontent.com/shraban50/Airline-Flight-Delay-Analytics/main/tableau/Dashboard-1.png)

### Dashboard 2 — Airline Performance

Airline-wise delay comparison · On-time performance · Cancellation rates · Average delay duration by airline.

![Dashboard 2](https://raw.githubusercontent.com/shraban50/Airline-Flight-Delay-Analytics/main/tableau/Dashboard-2.png)

### Dashboard 3 — Delay Analysis

Delay reasons · Delay by time of day · Delay by month · Delay by route · Weather impact analysis.

![Dashboard 3](https://raw.githubusercontent.com/shraban50/Airline-Flight-Delay-Analytics/main/tableau/Dashboard-3.png)

### Dashboard 4 — Route & Airport Insights

Top routes · Busiest airports · Route efficiency · Airport-wise delay patterns.

![Dashboard 4](https://raw.githubusercontent.com/shraban50/Airline-Flight-Delay-Analytics/main/tableau/Dashboard-4.png)

---

## 📄 Business Report

A comprehensive business report is available in the final report/ folder.

---

## 👤 Author

**Shraban Chaudhary**

- Organization: **Sipalaya InfoTech**

- GitHub: [@shraban50](https://github.com/shraban50)

- Email: **shrabanchy50@gmail.com**

---

## 📜 License
This project is licensed under the MIT License — see the LICENSE file for details.

---

⭐ If you find this project useful, please give it a star!