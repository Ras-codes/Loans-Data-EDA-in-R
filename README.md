<div align="center">
  <h1>Exploratory Data Analysis on Loans Data of banking variables for a Private Financial firm</h1>
</div>


<div align="center">
Performing Exploratory Data Analysis on Loans Data aiming to uncover insights and patterns regarding loan attributes and borrower demographics.
</div>



<div align="center">
  <img src="https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/63e4995d-4583-4438-958d-90c0b72e2f9f">
</div>


## Tools

- **Programming Language**: Python 🐍
- **IDE**: RStudio 📓
- **Data Manipulation and Analysis**:
  - dplyr 💡
  - tidyr 💡
- **Data Visualization**:
  - ggplot2 📊
  - corrplot 📈
- **Date and Time Handling**: lubridate ⏰



## Dataset Description: 

### Table- Loans Data


### Variables-

| Column Name                   | Data Type | Description                                             |
|-------------------------------|-----------|---------------------------------------------------------|
| LoanID                        | integer   | Unique identifier for each loan                         |
| Amount_Requested              | integer   | Requested loan amount by the borrower                   |
| Amount_Funded_By_Investors    | numeric   | Amount funded by investors for the loan                 |
| Interest_Rate                 | numeric   | Interest rate charged on the loan                       |
| Loan_Length                   | numeric   | Length of the loan in months                            |
| Loan_Purpose                  | character | Purpose for which the loan was requested                |
| Debt_To_Income_Ratio          | numeric   | Ratio of debt payments to income                        |
| State                         | character | State of residence of the borrower                      |
| Home_Ownership                | character | Ownership status of the borrower's home                 |
| Monthly_Income                | numeric   | Monthly income of the borrower                          |
| FICO_Range                    | integer   | FICO credit score range of the borrower                 |
| Open_CREDIT_Lines             | integer   | Number of open credit lines in the borrower's credit profile |
| Revolving_CREDIT_Balance      | integer   | Total revolving credit balance of the borrower          |
| Inquiries_in_the_Last_6_Months| integer   | Number of credit inquiries in the last 6 months         |
| Employment_Length             | numeric   | Length of employment in years                           |



# ------------------------------------------------------------------------------


# Exploratory Data Analysis

This repository contains code and resources for Exploratory Data Analysis (EDA) on Loans Data. The project showcases data manipulation techniques using the R programming language. It covers essential operations such as data loading, cleaning, handling missing values, outliers detection, transformation, analysis, and data visualization using popular libraries like dplyr, tidyr, ggplot2, and corrplot. The repository includes scripts and notebooks with detailed explanations, datasets for practice, and examples illustrating various data manipulation tasks and visualizations.


# ------------------------------------------------------------------------------


# Insights from the Dataset

- After importing the dataset, our first step is to check if the data is imported properly, we can use `dim(data)` to check the number of observations (rows) and features (columns) in the dataset
- Output will be : ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/f49d0c87-dbf5-4454-8e87-8fe8e6f25278)
- which means that the dataset contains 2500 records and 15 variables.
- We will now use `head(data)` to display the top 6 observations of the dataset
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/4fecd073-0207-40f4-abe0-0d0001ddbc80)
- To check the structure of the data, their data types, sample values, we use `str(data)`
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/35a2f06c-9d13-44c6-8414-e5760c31de41)
- Checking cardinality / uniqueness of data with `sapply(data, function(x) length(unique(x)))`
- Count of distinct values in each column
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/0da32818-fabb-4341-8e99-cbecae4ac462)












































