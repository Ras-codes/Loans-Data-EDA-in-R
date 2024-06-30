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



# ------------------------------------------------------------------------------


# Data Preparation:

- Data can have different sorts of quality issues. It is essential that you clean and preperate your data to be analyzed.  Therefore, these issues must be addressed before data can be analyzed.

- Data Preparation for Exploratory Data Analysis (EDA) on Loans Data, featuring data cleaning (e.g., replacing '.' with '_' or removing character like %, >, <, etc in column names), datatype conversion (from chr to numeric), and visualization using tidyverse and ggplot2 in R.



# ------------------------------------------------------------------------------


# Handling Missing Values:

Next step is to check for missing values in the dataset. It is very common for a dataset to have missing values.

- `colSums(is.na(data))` is.na() is used for detecting missing values in the dataframe, paired with colSums() will return the number of missing values in each column.
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/28adad49-2f14-4920-a2aa-d0ff251e6bed)
- There are around 3% missing values in the data which needs to be treated (filled with values)
- Creating a UDF which can automate the missing value treatment.
````
miss_value_treat <- function(s) {
  if (is.character(s)) {
    s <- ifelse(is.na(s), mode(s, na.rm = TRUE), s)
  } else if (is.numeric(s)) {
    s <- ifelse(is.na(s), median(s, na.rm = TRUE), s)
  }
  return(s)
}
````
- Applying the miss_value_treat UDF to our data
````
data[] <- lapply(data, miss_value_treat)
````
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/c6726533-56d5-4b70-a385-349388cb986d)
- As we can see, all our missing values has been treated.


# ------------------------------------------------------------------------------


# Data Preprocessing:

### Dividing the dataset into 2 datasets - categorical values and numerical values

**For categorical dataset**
````
categorical <- names(data)[sapply(data, is.character)]
categorical_data <- data[categorical]
````
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/23395119-e49f-437d-bacd-135e488955a6)

**For numerical dataset**
````
numerical <- names(data)[sapply(data, is.numeric)]
numerical_data <- data[numerical]
````
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/e2356a90-50b5-4d37-96fb-047b599d3b84)

**For merge**
- Later for merging if needed, a common column is needed between the 2 datasets, hence adding 'ID' column to categorical dataset
`categorical_data$LoanID <- data$LoanID`
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/abdf04ce-826d-44dc-9a71-1ecedf582642)


# ------------------------------------------------------------------------------


# Outlier Detection

Outliers are data points that deviate significantly from the overall pattern of the dataset and can indicate atypical or rare cases. Outliers in medical data can be indicative of unique cases or anomalies that deviate significantly from the general pattern, and their presence is something to be expected.


- To detect outliers in your dataset, you can use statistical methods or visualizations.
- Visualize the distribution of each numerical feature using box plots.

````
boxplot(numerical_data$Amount_Requested,
main = "Boxplot of Amount Requested",
ylab = "Amount Requested")
````
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/1f65eafd-7d0c-46fb-993a-61eefecd19dc)

- In a box plot, potential outliers are typically represented as individual points that fall outside the whiskers of the plot.
- The whiskers of the box plot extend to the smallest and largest data points within a certain range from the lower and upper quartiles.
- As per observations it seems that there are a few outliers which are very near to the whiskers of the box plot.

````
f_q <- quantile(numerical_data$Amount_Requested, 0.25)
t_q <- quantile(numerical_data$Amount_Requested, 0.75)
iqr <- t_q - f_q
lc <- 6000 - (1.5 * iqr)
uc <- 17000 + (1.5 * iqr)
numerical_data_2$Amount_Requested[numerical_data_2$Amount_Requested < lc] <- lc
numerical_data_2$Amount_Requested[numerical_data_2$Amount_Requested > uc] <- uc
````
- After treating the outliers, let's see the the box plot again
````
boxplot(numerical_data_2$Amount_Requested, main = "Boxplot of Amount Requested", ylab = "Amount Requested")
````
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/532624af-42cb-449d-af0f-770a8a826c3a)
- Similarly, we have treated other variables with outliers


# ------------------------------------------------------------------------------


### Merging the numerical data and categorical data back after treatment 
````
Merged_data_1 <- merge(numerical_data_2, categorical_data, by = "LoanID", all = FALSE)
````


# ------------------------------------------------------------------------------


# One-Hot Encoding 

One-hot encoding is a technique used to convert categorical variables into a binary matrix representation. Each category is transformed into a separate binary column, where a value of 1 indicates the presence of the category, and 0 indicates its absence. This approach allows categorical data to be used effectively in machine learning models.
````
M_data1$Home_Ownership <- as.factor(M_data1$Home_Ownership)
M_data1$Loan_Purpose <- as.factor(M_data1$Loan_Purpose)
M_data1_encoded <- cbind(M_data1, model.matrix(~ Home_Ownership + Loan_Purpose - 1, data = M_data1))
````
- ![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/17298897-9922-4b7c-93a8-50ffdbf7e4c8)


# ------------------------------------------------------------------------------


# Visualizing Data:

## Univariate analysis:
Univariate analysis helps in understanding the distribution and characteristics of a single variable, which helps in pattern recognition. The chosen visualization method depends on the nature of the data — bar charts for discrete (numerical) data, histograms for continuous (numerical) data, and pie charts for categorical data.


### Distribution of customers by their loan lengths-

````
ggplot(data = data, aes(x = factor(Loan_Length))) +
  geom_bar(fill = "steelblue") +
  labs(title = "Distribution of customers by their loan lengths",
       x = "Loan length",
       y = "No of customers")
````
![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/dfd1a975-e029-45d4-b7a0-287a212afefc)


### Distribution of customers by their State-

````
ggplot(data = data, aes(x = State, fill = State)) +
  geom_bar() +
  labs(title = "Distribution of customers by their State",
       x = "States",
       y = "No of customers")
````
![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/f61f23ef-c8e8-4de8-94ca-69c5e4b2380c)


### Distribution of customers by their Loan Purpose-

````
ggplot(data = data, aes(x = Loan_Purpose)) +
  geom_bar(fill = "darkgreen") +
  labs(title = "Distribution of customers by their Loan Purpose",
       x = "Loan Purpose",
       y = "No of customers")
````
![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/3b62d044-b51c-4218-a8ed-17eb699c97e1)


### Distribution of customers by their Home Ownership-

````
ggplot(data = data, aes(x = "", fill = factor(Home_Ownership))) +
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Distribution of customers by their Home Ownership",
       fill = "Home Ownership") +
  theme_void() +
  scale_fill_brewer(palette = "RdYlBu") +
  geom_text(aes(label = paste0(round((..count..) / sum(..count..) * 100, 1), "%")),
            stat = "count", position = position_stack(vjust = 0.5))
````
![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/04927928-e146-420a-a4a2-77f4aa5558ea)



## Bivariate analysis:

Bivariate analysis examines relationships between pairs of variables using scatter plots, line charts for trends, box plots for distribution, and heatmaps for correlations. These visualizations are crucial for uncovering connections and dependencies in the dataset. Box plots provide a summary of key statistical measures, including the minimum value, maximum value, median, and quartiles. Pair plots helps to explore relationships between multiple variables simultaneously. This visualization technique creates a grid of plots, each revealing the connection between two variables.

### Distribution of Interest Rate and Amount Requested with Scatter Plot 
````
ggplot(data = M_data1_encoded, aes(x = Amount_Requested, y = Interest_Rate)) +
  geom_point() +
  facet_wrap(~ Loan_Purpose, scales = "free") +  # Facet by Loan_Purpose with free scales
  labs(title = "Scatterplot of Amount Requested vs Interest Rate (by Loan Purpose)",
       x = "Amount Requested", y = "Interest Rate")
````
![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/b85f8c6e-eb34-4a9b-8c67-36203f245fd8)
- As we can see majority of borrowers opt for debt consolidation. This indicates that many borrowers are choosing to consolidate their debts into a single manageable loan, highlighting a practical approach to financial management.


## Multivariate analysis:

Multivariate analysis involves examining multiple variables simultaneously to understand their relationships and interactions. It helps identify patterns, correlations, and trends within the data, providing deeper insights into complex datasets. Techniques such as scatter plots, correlation matrices, and heatmaps are commonly used to visualize these relationships.

### Heatmap to display correlation between all variables
````
dev.new()
corrplot(cor_matrix, method = "color", type = "full", order = "hclust", 
         tl.col = "black", tl.srt = 90, addrect = 3, rect.col = "red", 
         number.cex = 0.2, title = "Correlation Heatmap of Numeric Variables", 
         title.cex = 0.8)
````
![image](https://github.com/Ras-codes/Loans-Data-EDA-in-R/assets/164164852/2fe4cf0b-3ab6-451f-8929-27d339fe8379)
- Amount_Requested and Amount_Funded_By_Investors have a strong positive correlation, suggesting that as one increases, the other does as well.
- Loan_Length shows a moderate positive correlation with Amount_Funded_By_Investors, Amount_Requested, and Interest_Rate, indicating these variables tend to increase together.
