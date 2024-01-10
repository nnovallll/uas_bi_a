# E-commerce Monthly Sales Analysis Dashboard

## Introduction

This repository contains an interactive dashboard created using R Shiny to analyze the factors influencing monthly sales volume for an e-commerce company operating across Southeast Asian countries. The dashboard allows users to input predictor data, such as the number of website visitors, monthly transactions, items per transaction, customer satisfaction rating, and the number of online advertisements, to receive an estimate for monthly sales.

## Data

The data used for this analysis includes the following variables:

- `y`: Monthly sales volume (in thousands of USD)
- `x1`: Number of website visitors per month
- `x2`: Number of monthly transactions
- `x3`: Average number of items per transaction
- `x4`: Customer satisfaction rating (scale 1-10)
- `x5`: Number of online advertisements run per month

The data from the last twelve months is provided in a tabular format.

## Dashboard Structure

The dashboard is organized into three tabs:

1. **Tabel Data**: Displays the raw data in a tabular format.

2. **Model Regresi**: Estimation of a multiple linear regression equation to predict monthly sales volume based on the provided variables. The tab also includes interpretation of the model and visualizations like boxplot and regression plot.

3. **Prediksi**: Allows users to input predictor data and receive an estimate for monthly sales. The tab includes a prediction plot displaying the predicted sales volume.

## Methodology

### Multiple Linear Regression

The multiple linear regression equation is estimated using the formula: `y ~ x1 + x2 + x3 + x4 + x5`. The significance of coefficients is tested, and a summary table is provided. The R-squared values indicate the goodness of fit.

### Model Evaluation

Methodology for evaluating the regression model includes tests for assumptions such as linearity, normality of residuals, homoscedasticity, and independence of errors. Significance testing of coefficients helps understand the impact of each predictor on sales.

## Practical Applications

The results from this model can be used to improve marketing strategy and increase sales by identifying the most influential factors. Additionally, the dashboard provides a user-friendly interface for quick analysis and decision-making.

## Additional Questions

a. **Variable to Focus On**: To increase sales, the company should focus on improving the variable that has the most significant positive impact on sales based on the model coefficients.

b. **Interaction Effects**: To check for a significant interaction between the number of website visitors and the number of ads run affecting sales, further analysis, such as interaction terms in the regression model, can be explored.

Feel free to explore the dashboard and leverage the interactive features to gain insights into the factors impacting monthly sales volume.

---

*Note: Ensure that you have the required R packages installed before running the Shiny app, as specified in the script.*

