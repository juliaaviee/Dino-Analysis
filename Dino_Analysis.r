# Install necessary packages
install.packages(c("dplyr", "tidyr", "ggplot2", "scales", "lubridate", "stringr", "data.table", "skimr", "maps"))

# Load data
data <- read.csv("dinosaur.csv")

# Explore data
head(data)
str(data)
summary(data)

# Check unique values and missing data
unique(data$Period)
unique(data$Diet)
unique(data$Country)
colSums(is.na(data))

# Clean and standardize 'Period' column
data$Period <- trimws(data$Period)
data$Period <- tolower(data$Period)
data$Period <- gsub("\\s+", " ", data$Period)
data$Period <- ifelse(grepl("cretaceous", data$Period), "cretaceous", data$Period)

# Verify cleaned Period values
unique(data$Period)
table(data$Period)

# Check Diet proportions
prop.table(table(data$Diet))

# Check Country counts
table(data$Country)

# Plot number of dinosaurs by period
library(ggplot2)
ggplot(data, aes(x = Period)) +
  geom_bar(fill = "lightblue") +
  labs(title = "Number of Dinosaurs by Period", x = "Period", y = "Count") +
  theme_minimal()

# Create Period-Diet contingency table
period_diet_table <- table(data$Period, data$Diet)
print(period_diet_table)

# Heatmap visualization of Period-Diet relationship
ggplot(as.data.frame(period_diet_table), aes(x = Var1, y = Var2, fill = Freq)) +
  geom_tile() +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  labs(title = "Relationship Between Period and Diet", x = "Period", y = "Diet") +
  theme_minimal()

# Subset for unknown or mixed periods
subset(data, Period == "unknown" | Period == "triassic-jurassic")

# Bar plot for Diet across Periods
ggplot(data, aes(x = Diet, fill = Period)) +
  geom_bar(position = "dodge") +
  labs(title = "Dinosaur Diets Across Periods", x = "Diet", y = "Count") +
  theme_minimal()

# Map visualization
library(maps)
world_map <- map_data("world")
country_counts <- as.data.frame(table(data$Country))
