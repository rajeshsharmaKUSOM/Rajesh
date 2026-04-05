# R codes for Project
## install.packages(c("dplyr", "psych", "corrplot", "ggplot2"))

## Load necessary library
library(dplyr)
library(psych)
library(corrplot)
library(ggplot2)
library(tidyr)
library(readxl)

## Load data file
df <- read_excel("Cement_Firms.xlsx")

## Create panel format
panel_info <- df %>%
  group_by(Firm_Name) %>%
  summarise(Year = n()) %>%
  summarise(
    Total_Firms = n(),
    Min_Years = min(Year),
    Max_Years = max(Year),
    Avg_Years = mean(Year)
  )

panel_info ## Get details about unbalanced panel data

# Summary statistics
summary(df)

# Only numeric variables
df_numeric <- df %>% select(where(is.numeric))
describe(df_numeric)

# (i) Descriptive statistics of main variables
desc_clean <- df %>%
  summarise(across(c(Total_Emission, Revenue, Raw_Materials, Energy_Cost),
                   list(
                     Mean   = ~mean(.x, na.rm = TRUE),
                     Median = ~median(.x, na.rm = TRUE),
                     SD     = ~sd(.x, na.rm = TRUE),
                     Min    = ~min(.x, na.rm = TRUE),
                     Max    = ~max(.x, na.rm = TRUE),
                     N      = ~sum(!is.na(.x))
                   ))) %>%
  pivot_longer(
    cols = everything(),
    names_to = c("Variable", "Statistic"),
    names_pattern = "(.+)_(Mean|Median|SD|Min|Max|N)"
  ) %>%
  pivot_wider(
    names_from = Statistic,
    values_from = value
  )

desc_clean ## Descriptive details along with mean, min, max, standard deviation and number of observations 


# (ii) Plot- Total Yearly and Average Yearly tCO2 Emission
library(scales)
scale_y_continuous(labels = scales::comma)

# 1. Compute total emission by all firms/ each Year and average by number of firms/ each year
total_emission_summary <- df %>%
  group_by(Year) %>%
  summarise(
    Total = sum(Total_Emission, na.rm = TRUE),
    Average = mean(Total_Emission, na.rm = TRUE)
  )
total_emission_summary

# 2. Reshape Data
total_emission_long <- total_emission_summary %>%
  pivot_longer(
    cols = c(Total, Average),
    names_to = "Type",
    values_to = "Value"
  )
total_emission_long

# 3. Plot- TOTAL_ Yearly tCO2 emission by Nepalese cement companies (Addition of yearly emission of all firms)
ggplot(total_emission_summary, aes(x = factor(Year), y = Total)) +
  geom_col(fill = "skyblue") +
  geom_text(aes(label = round(Total, 0)), vjust = -0.5) +
  labs(
    title = "Yearly Total Emission (2020-2025)",
    x = "Year",
    y = "Total Emission (tCO2)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# 4. Plot - Average_ Yearly tCO2 emission by Nepalese cement companies (Averaged of yearly emission by number of firms)

ggplot(total_emission_summary, aes(x = factor(Year), y = Average)) +
  geom_col(fill = "orange") +
  geom_text(aes(label = round(Average, 0)), vjust = -0.5) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Yearly Average Emission (2020-2025)",
    x = "Year",
    y = "Average Emission (tCO2)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 5. Plot- Combined both, Total and Average tCO2 emission by Nepalese cement companies

ggplot(total_emission_long, aes(x = factor(Year), y = Value, fill = Type)) +
  geom_col(position = "dodge") +
  labs(
    title = "Yearly Total and Average of Total Emission",
    x = "Year",
    y = "Value",
    fill = "Type"
  ) +
  scale_fill_manual(values = c("Total" = "skyblue", "Average" = "orange")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# (iii) Year on Year Percentage Growth of Total emission- Compute total emission, average emission and Percentage
# 1. Compute total emission
total_emission_summary <- df %>%
  group_by(Year) %>%
  summarise(
    Total = sum(Total_Emission, na.rm = TRUE),
    Average = mean(Total_Emission, na.rm = TRUE),
    Firms = n()  # Number of firms per year
  ) %>%
  mutate(
    Total_Mt = Total / 1e6,  # Convert to MtCO2e for secondary axis
    Pct_Change = (Total / lag(Total) - 1) * 100  # Year-over-year % change
  )

# 2. Reshape for plotting
total_emission_long <- total_emission_summary %>%
  pivot_longer(
    cols = c(Total, Average),
    names_to = "Type",
    values_to = "Value"
  )

# 3. Enhanced plot with dual axes and trend annotation
p1 <- ggplot(total_emission_long, aes(x = factor(Year), y = Value, fill = Type)) +
  geom_col(position = "dodge", alpha = 0.8, width = 0.7) +
  geom_line(
    data = total_emission_summary, 
    aes(x = factor(Year), y = Total_Mt * 1e6, group = 1, color = "Trend"),
    inherit.aes = FALSE, linewidth = 1.2, linetype = "dashed"
  ) +
  geom_text(
    aes(label = comma(round(Value, 0)), y = Value),
    vjust = -0.3, size = 3.2, fontface = "bold"
  ) +
  scale_y_continuous(
    labels = comma,
    name = "Emissions (tCO2e)",
    sec.axis = sec_axis(~ . / 1e6, name = "Total (MtCO2e)")
  ) +
  scale_fill_manual(
    values = c("Total" = "steelblue", "Average" = "darkorange"),
    name = "Metric"
  ) +
  scale_color_manual(values = c("Trend" = "darkred"), name = NULL) +
  labs(
    title = "Nepal Cement Industry: Yearly GHG Emissions (2020-2025)",
    subtitle = paste("Total emissions across", nrow(total_emission_summary), "years |",
                     round(mean(total_emission_summary$Pct_Change, na.rm = TRUE), 1), "% avg YoY growth"),
    x = "Year",
    caption = "Source: Author's Calculation"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11),
    legend.position = "top"
  )

print(p1)
print(total_emission_summary)  # Summary table output

# (iv) Firm- top five emitters
## 1. Emission Calculation
top5_firms <- df %>%
  group_by(Firm_Name) %>%
  summarise(
    Total = sum(Total_Emission, na.rm = TRUE),
    Average = mean(Total_Emission, na.rm = TRUE)
  ) %>%
  arrange(desc(Total)) %>%
  slice(1:5)

## 2. Fix firm order
top5_firms <- top5_firms %>%
  mutate(Firm_Name = factor(Firm_Name, levels = rev(Firm_Name)))

## 3. Reshape ONLY top 5 data
top5_long <- top5_firms %>%
  pivot_longer(
    cols = c(Total, Average),
    names_to = "Type",
    values_to = "Value"
  )

## 4. Plot _Top 5 emitter
ggplot(top5_long, aes(x = Firm_Name, y = Value, fill = Type)) +
  
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  
  coord_flip() +
  
  geom_text(aes(label = comma(round(Value, 0))),
            position = position_dodge(width = 0.8),
            hjust = -0.2,
            size = 3) +
  
  scale_y_continuous(labels = comma) +
  
  scale_fill_manual(
    values = c("Total" = "steelblue", "Average" = "darkorange")
  ) +
  
  labs(
    title = "Top 5 Most Polluting Cement Firms (2020–2025)",
    subtitle = "Total vs Average Emissions",
    x = "Firm",
    y = "Emission",
    fill = "tCO2"
  ) +
  
  theme_minimal(base_size = 12) +
  
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "top"
  )

# To verify
top5_firms

# (v) Emission percentage by top 5 firms
# 1. Calculate GRAND total across ALL firms and years (baseline for %)
grand_total <- sum(df$Total_Emission, na.rm = TRUE)

# 2. Finding top 5 emitters WITH percentages
top5_firms <- df %>%
  group_by(Firm_Name) %>%
  summarise(
    Total = sum(Total_Emission, na.rm = TRUE),
    Average = mean(Total_Emission, na.rm = TRUE),
    Years = n_distinct(Year)  # Years each firm reported
  ) %>%
  arrange(desc(Total)) %>%
  slice(1:5) %>%
  mutate(
    Percentage = round(Total / grand_total * 100, 1),  # % of ALL emissions
    Share_Total = paste0(Percentage, "%"),             # For labels
    Firm_Name = factor(Firm_Name, levels = rev(Firm_Name))
  )

# 3. Top 5 combined share
cat("Top 5 firms emit", sum(top5_firms$Percentage), "% of ALL Nepal cement emissions\n")

# 4. Reshape for bars (keep % separate for annotation)
top5_long <- top5_firms %>%
  select(Firm_Name, Total, Average) %>%
  pivot_longer(
    cols = c(Total, Average),
    names_to = "Type",
    values_to = "Value"
  ) %>%
  left_join(select(top5_firms, Firm_Name, Percentage), by = "Firm_Name")

# 5. Enhanced plot with % labels
ggplot(top5_long, aes(x = Firm_Name, y = Value, fill = Type)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  coord_flip() +
  
  # Percentage labels ABOVE Total bars
  geom_text(
    data = top5_firms,
    aes(x = Firm_Name, y = Total * 1.05, label = Share_Total),
    inherit.aes = FALSE,
    fontface = "bold", size = 4.5, color = "darkred", hjust = 0
  ) +
  
  # Value labels ON bars
  geom_text(
    aes(label = comma(round(Value, 0))),
    position = position_dodge(width = 0.8),
    hjust = -0.2, size = 3
  ) +
  
  scale_y_continuous(
    labels = comma, 
    expand = expansion(mult = c(0, 0.15))  # Space for % labels
  ) +
  scale_fill_manual(
    values = c("Total" = "steelblue", "Average" = "darkorange"),
    name = "Metric"
  ) +
  labs(
    title = "Top 5 Cement Firms: Nepal GHG Emissions (2020-2025)",
    subtitle = paste("Each firm's % share of", comma(grand_total), "total tCO2e emissions"),
    x = "Firm", 
    y = "Emissions (tCO2e)",
    caption = paste("Top 5 = ", sum(top5_firms$Percentage), "% of total")
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11),
    legend.position = "top",
    plot.caption = element_text(hjust = 0, size = 10)
  )


## (vi) Plot emission of all Nepalese cement companies (Ordered according to their emission)
# 1. Compute total and average emission per firm
firm_emission_summary <- df %>%
  group_by(Firm_Name) %>%
  summarise(
    Total = sum(Total_Emission, na.rm = TRUE),
    Average = mean(Total_Emission, na.rm = TRUE)
  )

# 2. Order firms by Total (highest first)
firm_emission_summary <- firm_emission_summary %>%
  arrange(Total) %>%                   # ascending for coord_flip
  mutate(Firm_Name = factor(Firm_Name, levels = Firm_Name))

# 3. Reshape data for plotting
firm_emission_long <- firm_emission_summary %>%
  pivot_longer(
    cols = c(Total, Average),
    names_to = "Type",
    values_to = "Value"
  )

# 4. Plot with highest emitter on top
ggplot(firm_emission_long, aes(x = Firm_Name, y = Value, fill = Type)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  coord_flip() +
  geom_text(aes(label = comma(round(Value, 0))),
            position = position_dodge(width = 0.8),
            hjust = -0.2,
            size = 3) +
  scale_y_continuous(labels = comma) +
  scale_fill_manual(
    values = c("Total" = "steelblue", "Average" = "darkorange")
  ) +
  labs(
    title = "Firm-wise Total and Average Emissions (2020–2025)",
    subtitle = "All Cement Firms (Highest Emitter on Top)",
    x = "Firm",
    y = "Emission (tCO2)",
    fill = "Emission Type"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "top",
    axis.text.y = element_text(size = 8)  # adjust for many firms
  )

########## Finding Eco- Efficient Firms #############
## (vii) DEA Process - To find the eco- efficient firms
options(rgl.useNULL = TRUE)
library(deaR)
#library(writexl)

df <- read_excel("Cement_Firms.xlsx") %>%
  mutate(
    Raw_Materials  = Raw_Materials  / 1e6,
    Labor_Cost     = Labor_Cost     / 1e6,
    Capital_Total  = Capital_Total  / 1e6,
    Energy_Cost    = Energy_Cost        / 1e6,
    Revenue        = Revenue        / 1e6,
    CO2_ton   = CO2_ton / 1e3,
    Total_Emission = Total_Emission / 1e3
  )

inputs  <- c("Raw_Materials")
outputs <- c("Revenue", "CO2_ton")

run_sbm <- function(data, label = "pooled") {
  data <- data %>%
    filter(complete.cases(across(all_of(c(inputs, outputs))))) %>%
    mutate(dmu_id = paste0(Firm_Name, "_", Year))
  
  dea_data <- make_deadata(
    datadea    = data,
    dmus       = "dmu_id",
    inputs     = inputs,
    outputs    = outputs,
    ud_outputs = 2
  )
  
  model <- model_sbmeff(dea_data, orientation = "no", rts = "crs")
  
  data.frame(
    dmu_id = names(efficiencies(model)),
    eff    = as.numeric(efficiencies(model)),
    label  = label
  ) %>%
    mutate(
      Firm_Name = sub("_[0-9]{4}$", "", dmu_id),
      Year      = as.numeric(sub(".*_", "", dmu_id))
    )
}

# Pooled
pooled_res <- run_sbm(df, label = "pooled")

# Summaries
cat("\nPooled Summary:\n")
pooled_res %>%
  summarise(n = n(), mean = round(mean(eff), 4), sd = round(sd(eff), 4),
            min = round(min(eff), 4), median = round(median(eff), 4),
            max = round(max(eff), 4), pct_frontier = round(mean(eff >= 1) * 100, 1)) %>%
  print()

# Merge coloumn with data file
final_df <- df %>%
  left_join(pooled_res %>% select(Firm_Name, Year, pooled_eff = eff),
            by = c("Firm_Name", "Year"))

summary(final_df)
names(final_df)

## (Viii) Statistical test: Use eco-efficiency score (pooled_eff) with respect to technology category for t-test 
## Already categorized for technology based on the score (i.e., "Low" and "High")
## Eco- Efficiency score from DEA method (pooled_eff)

table(final_df$Technology_Group)
t.test(pooled_eff ~ Technology_Group, data = final_df)

# The results of the Welch two-sample t-test indicate that firms with high technology 
# exhibit significantly higher efficiency scores compared to low-technology firms. 
# The mean efficiency for high-technology firms (0.754) exceeds that of low-technology firms (0.732), 
# and the difference is statistically significant at the 5% level (p = 0.039). 
# The 95% confidence interval [0.001, 0.042] further confirms that the difference is positive.”

######## Economic interpretation:
# Technology adoption → improves resource utilization
# Leads to higher DEA efficiency

##### These finding supports broader research on:
  # sustainability
  # operational efficiency
  # firm performance (Eco- Efficiency)
