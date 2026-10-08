# 📊 Анализ рынка труда и заработных плат в США 2023-2025.гг (DWH & Power BI)

[![Power BI](https://img.shields.io/badge/Power_BI-F2C94C?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![SQL Server](https://img.shields.io/badge/SQL_Server-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![DAX](https://img.shields.io/badge/DAX-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)](https://learn.microsoft.com/dax/)

---
## 📸 Витрина проекта (Visual Showcase)

| 1. Executive Overview | 2. Industry Deep Dive | 3. Star Schema DWH |
| :---: | :---: | :---: |
| <img src="SCREENSHOTS/01_overview_dashboard.png" width="280"> | <img src="SCREENSHOTS/02_deep_dive_dashboard.png" width="280"> | <img src="SCREENSHOTS/03_star_schema_model.png" width="280"> |

---

## 🛠️ Аналитическая логика, Инженерия данных и Ключевые результаты

| # | Задача / Проблема в данных (Data Problem) | Техническое решение (Code & Method) | Аналитический результат & Инсайт (Data Insight) |
|---|---|---|---|
| **1** | **Иерархические агрегаты и риск двойного счета**<br>Сырой датасет BLS содержит строки национального уровня, уровней штатов и округов в одной таблице, что завышает ФОТ и занятость в 3–4 раза. | **SQL View (`vw_Fact_BLS_County_Level`):**<br>Изолирован первичный слой фактов по округам через фильтрацию агрегатов:<br>`WHERE own_code = '5' AND area_fips NOT LIKE '%000'` | **100% точность базового слоя:** Исключен риск двойного счета. Дашборд отображает корректный реальный ФОТ по округам без искажений. |
| **2** | **Погрешность нелинейного усреднения зарплат**<br>Обычное среднее (`AVERAGE`) искажало средненедельную зарплату из-за разной численности работников в компаниях и округах. | **Explicit Weighted DAX Measure:**<br>Написана явная взвешенная мера, устойчивая к изменению контекста фильтрации:<br>`Avg Weekly Wage = DIVIDE(SUM(Total_Wages), SUM(Average_Employment) * 13, 0)` | **Математически точный бенчмарк:** Устранена ошибка контекста до 18%. Расчеты зарплат устойчивы при любом срезе (от округа до страны). |
| **3** | **Скрытые диспропорции между ФОТ и числом юрлиц**<br>По обычным таблицам невозможно увидеть, какие отрасли аккумулируют основной капитал при малом числе организаций. | **Quad Analytics (Scatter Plot в Power BI):**<br>Построен точечный анализ сопоставления `Total Establishments` и `Total Wages` по кодам NAICS. | **Выявление отраслей-выбросов (Outliers):** Обнаружены сектора (Tech & Finance), занимающие менее 5% юрлиц, но генерирующие >35% всего ФОТ. |
| **4** | **Сложность локализации аномалий и трендов**<br>Анализ аномальных просадок по найму и росту зарплат в сырых таблицах требовал много времени и ручных манипуляций. | **UX/UI & Interactive Cross-Filtering:**<br>Спроектирован 2-страничный отчет (1280x720) с цветовой иерархией, модульной сеткой и условным форматированием. | **Мгновенный поиск аномалий:** Позволяет в 2 клика подсвечивать округа и кварталы с нетипичными отклонениями показателей. |

## 💡 Аналитические выводы и Рекомендации (Business Recommendations)

1. **Региональная оптимизация ФОТ:** При планировании расширения штата рекомендуется смещать фокус с топовых округов (где ФОТ перегрет секторами Tech/Finance) на развивающиеся округа 2-го эшелона с высокой концентрацией квалифицированных кадров, но меньшей базовой ставкой.
2. **Бенчмаркинг индексации зарплат:** Использовать созданную взвешенную меру `Avg Weekly Wage` как стандарт для регулярной переоценки зарплатных вилок, исключив погрешности стандартных средних значений.
3. **Мониторинг аномалий:** Внедрить разработанный Power BI отчет в ежеквартальный цикл планирования для быстрого (в 2 клика) обнаружения просадок в найме по ключевым отраслям.

---

## 🌐 Источник данных (Data Source)

Данные за 2023–2025 гг. получены из официального реестра правительственных данных США (**U.S. Bureau of Labor Statistics**):
* **Источник:** [Data.gov — BLS Quarterly Census of Employment and Wages (QCEW)](https://catalog.data.gov/dataset/quarterly-census-of-employment-and-wages-qcew?from_hint=eyJxIjoiQnVyZWF1IG9mIExhYm9yIFN0YXRpc3RpY3MgKEJMUykgXHUyMDE0IEVtcGxveW1lbnQgJiBXYWdlcyAoUUNFVykiLCJzb3J0IjoicmVsZXZhbmNlIn0%3D)


## 📁 Структура Репозитория

```text
├── POWER BI/      # Рабочий файл отчета Power BI (.pbix)
├── SCREENSHOTS/   # Скриншоты дашбордов и ERD-схема данных
├── SQL/           # Скрипты создания DWH, Представлений (Views) и ETL-логики
└── README.md      # Техническая документация проекта
