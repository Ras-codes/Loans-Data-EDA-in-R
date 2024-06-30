##### Exploratory Data Analysis ######  -----------------------------------------------



# Installing and Importing Libraries -----------------------------------------------------

# Load necessary packages if not already installed
# install.packages("matrixStats")
# install.packages("tidyverse")
# install.packages("ggplot2")
# install.packages("lubridate")
# install.packages("dplyr")
# install.packages("reshape2")
# install.packages("corrplot")


library(dplyr)        # For data manipulation
library(tidyverse)    # For statistical computing
library(ggplot2)      # For data visualizations
library(lubridate)    # For datetime data
library(reshape2)     # For reshaping data
library(corrplot)     # For visualizing correlation matrices


# Importing Dataset -------------------------------------------------------

data <- read.csv("C:/Users/Rasika/Desktop/Edubridge/R/data/LoansData.csv")


# To see how data is
head(data)

dim(data)

print(data)

# Tabular presentation of data
View(data)

# Print structure of the data frame (column names and types)
str(data)

# Summary statistics for numeric columns
summary(data)


# Naming Convention -------------------------------------------------------

# Always check if the variable names is following the Naming Convention
colnames(data)

# Replacing dots with underscores in column names of the data according to naming convention
colnames(data) <- gsub('\\.', '_', colnames(data))

colnames(data)


# Data Type Conversion ----------------------------------------------------

str(data)

# Removing 'months' and '%' and converting to float in columns
data$Interest_Rate <- as.numeric(sub("%", "", data$Interest_Rate))
data$Loan_Length <- as.numeric(sub(" months", "", data$Loan_Length))
data$Debt_To_Income_Ratio <- as.numeric(sub("%", "", data$Debt_To_Income_Ratio))

str(data)

# Cleaning and converting 'Employment_Length' column
data$Employment_Length <- gsub("[^0-9]+", "", data$Employment_Length)  # Remove all non-numeric characters
data$Employment_Length <- as.numeric(data$Employment_Length)  # Convert to numeric

#FICO_Range column splitting with -
FICO_Range[1:5]

data <- separate(data, FICO_Range, into = c("FICO_Range", "FICO_Max"), sep = "-")

View(data)

# Changing FICO_Range datatype to numeric since it was character
data$FICO_Range <- as.integer(data$FICO_Range)

# Drop the FICO_Max
data <- select(data, -FICO_Max)

View(data)


# Checking the relevant and irrelevant variables --------------------------

# Checking unique column values to get cardinality of each column
sapply(data, function(x) length(unique(x)))


# Data Understanding by Visualization -------------------------------------

# Distribution of customers by their loan lengths.
ggplot(data = data, aes(x = factor(Loan_Length))) +
  geom_bar(fill = "steelblue") +
  labs(title = "Distribution of customers by their loan lengths",
       x = "Loan length",
       y = "No of customers")


# Distribution of customers by their State.
ggplot(data = data, aes(x = State, fill = State)) +
  geom_bar() +
  labs(title = "Distribution of customers by their State",
       x = "States",
       y = "No of customers")

# Distribution of customers by their Loan Purpose
ggplot(data = data, aes(x = Loan_Purpose)) +
  geom_bar(fill = "darkgreen") +
  labs(title = "Distribution of customers by their Loan Purpose",
       x = "Loan Purpose",
       y = "No of customers")

# Distribution of customers by their Home Ownership
ggplot(data = data, aes(x = "", fill = factor(Home_Ownership))) +
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Distribution of customers by their Home Ownership",
       fill = "Home Ownership") +
  theme_void() +
  scale_fill_brewer(palette = "RdYlBu") +
  geom_text(aes(label = paste0(round((..count..) / sum(..count..) * 100, 1), "%")),
            stat = "count", position = position_stack(vjust = 0.5))


# Missing Values Treatment: -----------------------------------------------


sum(is.na(data))

# Columnwise missing data
colSums(is.na(data))

# Creating a UDF which can automate the missing value treatment
miss_value_treat <- function(s) {
  if (is.character(s)) {
    s <- ifelse(is.na(s), mode(s, na.rm = TRUE), s)
  } else if (is.numeric(s)) {
    s <- ifelse(is.na(s), median(s, na.rm = TRUE), s)
  }
  return(s)
}

# Applying the missing value treatment function to our data
data[] <- lapply(data, miss_value_treat)

# Check the missing values after treatment
sum(is.na(data))

colSums(is.na(data))



# Separating numerical and categorical data -------------------------------

# Separating the categorical Variables and Numerical variables into two different datasets for Data Preparations for Data Analysis

str(data)

# Categorical columns
categorical <- names(data)[sapply(data, is.character)]

# Display categorical columns
categorical_data <- data[categorical]

# Numerical columns
numerical <- names(data)[sapply(data, is.numeric)]

# Display numerical columns
numerical_data <- data[numerical]

print(colnames(categorical_data))
print(colnames(numerical_data))

summary(categorical_data)
summary(numerical_data)

# Add LoanID to categorical_data so that later both datasets can be joined back
categorical_data$LoanID <- data$LoanID

View(categorical_data)
View(numerical_data)



# Outlier Treatment -------------------------------------------------------

numerical_data_2 <- numerical_data

# Minimum amount requested
min_Amt <- min(numerical_data$Amount_Requested)
print(min_Amt)

# Maximum amount requested
max_Amt <- max(numerical_data$Amount_Requested)
print(max_Amt)

# Median of amount requested
median <- median(numerical_data$Amount_Requested)
print(median)

# Calculate quantiles
f_q <- quantile(numerical_data$Amount_Requested, 0.25)
t_q <- quantile(numerical_data$Amount_Requested, 0.75)
p_1 <- quantile(numerical_data$Amount_Requested, 0.01)
p_99 <- quantile(numerical_data$Amount_Requested, 0.99)

print(paste("First quartile:", f_q))
print(paste("Third quartile:", t_q))
print(paste("Bottom 1%ile cutoff:", p_1))
print(paste("Top 1%ile cutoff:", p_99))

# Calculate the Interquartile Range (IQR)
iqr <- 17000 - 6000

cat("IQR =", iqr, "\n")

# Calculate lower and upper bounds
lc <- 6000 - (1.5 * iqr)
uc <- 17000 + (1.5 * iqr)

cat("Lower Bound =", lc, "\n")
cat("Upper Bound =", uc, "\n")

boxplot(numerical_data$Amount_Requested, main = "Boxplot of Amount Requested", ylab = "Amount Requested")

# Replacing the Outliers with LC or UC respectively
numerical_data_2$Amount_Requested[numerical_data_2$Amount_Requested < lc] <- lc
numerical_data_2$Amount_Requested[numerical_data_2$Amount_Requested > uc] <- uc

# With Outliers box plot
boxplot(numerical_data$Amount_Requested, main = "Boxplot of Amount Requested", ylab = "Amount Requested")

# After treating Outliers box plot
boxplot(numerical_data_2$Amount_Requested, main = "Boxplot of Amount Requested", ylab = "Amount Requested")

# outlier_IQR function 
outlier_IQR <- function(s) {
  m <- median(s, na.rm = TRUE)
  q1 <- quantile(s, 0.25, na.rm = TRUE)
  q3 <- quantile(s, 0.75, na.rm = TRUE)
  q_1p <- quantile(s, 0.01, na.rm = TRUE)
  q_99p <- quantile(s, 0.99, na.rm = TRUE)
  iqr <- IQR(s, na.rm = TRUE)
  lc <- q1 - 1.5 * iqr
  uc <- q3 + 1.5 * iqr
  result <- c(m, q1, q3, q_1p, q_99p, iqr, lc, uc)
  names(result) <- c('median', 'first_quartile', 'third_quartile', 'pc_1', 'pc_99', 'iqr', 'lower_cutoff', 'upper_cutoff')
  return(result)
}

print(apply(numerical_data_2, 2, outlier_IQR))

# Outliertreat_IQR function
outliertreat_IQR <- function(d) {
  m <- median(d, na.rm = TRUE)
  q1 <- quantile(d, 0.25, na.rm = TRUE)
  q3 <- quantile(d, 0.75, na.rm = TRUE)
  iqr <- IQR(d, na.rm = TRUE)
  lc <- q1 - 1.5 * iqr
  uc <- q3 + 1.5 * iqr
  return(list(lower_cutoff = lc, upper_cutoff = uc))
}

print(sapply(numerical_data, outliertreat_IQR))

print(sapply(numerical_data_2, outlier_IQR))


# Treating Amount_Funded_By_Investors column for outliers
# Before treating Outliers box plot
boxplot(numerical_data$Amount_Funded_By_Investors, main = "Boxplot of Amount Funded By Investors", ylab = "Amount Funded By Investors")

numerical_data_2$Amount_Funded_By_Investors[numerical_data_2$Amount_Funded_By_Investors < -9000] <- -9000
numerical_data_2$Amount_Funded_By_Investors[numerical_data_2$Amount_Funded_By_Investors > 31000] <- 31000

# After treating Outliers box plot
boxplot(numerical_data_2$Amount_Funded_By_Investors, main = "Boxplot of Amount Funded By Investors", ylab = "Amount Funded By Investors")


# Treating Interest_Rate column for outliers
# Before treating Outliers box plot
boxplot(numerical_data$Amount_Funded_By_Investors, main = "Boxplot of Interest Rate", ylab = "Interest Rate")

numerical_data_2$Interest_Rate[numerical_data_2$Interest_Rate < 1.70] <- 1.70
numerical_data_2$Interest_Rate[numerical_data_2$Interest_Rate > 24.26] <- 24.26

# After treating Outliers box plot
boxplot(numerical_data_2$Amount_Funded_By_Investors, main = "Boxplot of Interest Rate", ylab = "Interest Rate")


# Treating FICO_Range column for outliers
# Before treating Outliers box plot
boxplot(numerical_data$FICO_Range, main = "Boxplot of FICO Range", ylab = "FICO Range")

numerical_data_2$FICO_Range[numerical_data_2$FICO_Range < 612.5] <- 612.5
numerical_data_2$FICO_Range[numerical_data_2$FICO_Range > 792.5] <- 792.5

# After treating Outliers box plot
boxplot(numerical_data_2$FICO_Range, main = "Boxplot of FICO Range", ylab = "FICO Range")


# Treating Open_CREDIT_Lines column for outliers
# Before treating Outliers box plot
boxplot(numerical_data$Open_CREDIT_Lines, main = "Boxplot of Open CREDIT Lines", ylab = "Open CREDIT Lines")

numerical_data_2$Open_CREDIT_Lines[numerical_data_2$Open_CREDIT_Lines < -2.0] <- -2.0
numerical_data_2$Open_CREDIT_Lines[numerical_data_2$Open_CREDIT_Lines > 22.0] <- 22.0

# After treating Outliers box plot
boxplot(numerical_data_2$Open_CREDIT_Lines, main = "Boxplot ofOpen CREDIT Lines", ylab = "Open CREDIT Lines")


# Treating Inquiries_in_the_Last_6_Months column for outliers
# Before treating Outliers box plot
boxplot(numerical_data$Inquiries_in_the_Last_6_Months, main = "Boxplot of Inquiries in the Last 6 Months", ylab = "Inquiries in the Last 6 Months")

numerical_data_2$Inquiries_in_the_Last_6_Months[numerical_data_2$Inquiries_in_the_Last_6_Months < -1.5] <- -1.5
numerical_data_2$Inquiries_in_the_Last_6_Months[numerical_data_2$Inquiries_in_the_Last_6_Months > 2.5] <- 2.5

# After treating Outliers box plot
boxplot(numerical_data_2$Inquiries_in_the_Last_6_Months, main = "Boxplot of Inquiries in the Last 6 Months", ylab = "Inquiries in the Last 6 Months")



# Merging the treated numerical and categorical data ----------------------

Merged_data_1 <- merge(numerical_data_2, categorical_data, by = "LoanID", all = FALSE)

colnames(Merged_data_1)

M_data1 <- Merged_data_1

# One-Hot Encoding: Conversion of categorical variables to continuous variables --------

str(M_data1)

M_data1$Home_Ownership <- as.factor(M_data1$Home_Ownership)
M_data1$Loan_Purpose <- as.factor(M_data1$Loan_Purpose)

M_data1_encoded <- cbind(M_data1, model.matrix(~ Home_Ownership + Loan_Purpose - 1, data = M_data1))

View(M_data1_encoded)

colnames(M_data1_encoded)

M_data1_encoded <- M_data1_encoded[, !duplicated(colnames(M_data1_encoded))]



### Data Visualization ------------------------------------------------------


# Bivariate Analysis ------------------------------------------------------

# Scatter plot of Amount Requested vs Interest Rate (by Loan Purpose)
dev.new()
ggplot(data = M_data1_encoded, aes(x = Amount_Requested, y = Interest_Rate)) +
  geom_point() +
  facet_wrap(~ Loan_Purpose, scales = "free") +  # Facet by Loan_Purpose with free scales
  labs(title = "Scatterplot of Amount Requested vs Interest Rate (by Loan Purpose)",
       x = "Amount Requested", y = "Interest Rate")

# As we can see majority of borrowers opt for debt consolidation. This indicates that many borrowers are choosing to consolidate their debts into a single manageable loan, highlighting a practical approach to financial management.



# Multivariate Analysis ---------------------------------------------------

# Heatmap of correlations using ggplot2
numeric_data_cor <- M_data1_encoded %>% select_if(is.numeric)

cor_matrix <- cor(numeric_data_cor, use = "pairwise.complete.obs")

dev.new()
corrplot(cor_matrix, method = "color", type = "full", order = "hclust", 
         tl.col = "black", tl.srt = 90, addrect = 3, rect.col = "red", 
         number.cex = 0.2, title = "Correlation Heatmap of Numeric Variables", 
         title.cex = 0.8)

# To check correlation between the variables with strong relation
cor_matrix_pair <- cor(M_data1_encoded[, c("Loan_Length", "Amount_Funded_By_Investors", "Amount_Requested", "Interest_Rate")])
dev.new()
corrplot(cor_matrix_pair, method = "color", type = "full", order = "hclust", 
         tl.col = "black", tl.srt = 45, addrect = 3, rect.col = "red", 
         number.cex = 0.7, title = "Correlation Heatmap of Numeric Variables")

# Amount_Requested and Amount_Funded_By_Investors have a strong positive correlation, suggesting that as one increases, the other does as well.
# Loan_Length shows a moderate positive correlation with Amount_Funded_By_Investors, Amount_Requested, and Interest_Rate, indicating these variables tend to increase together.
