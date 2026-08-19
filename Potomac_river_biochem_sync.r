# Summer Biochemical Synchronization of pH and DO over 3 months, 
# June-August 2021
# Study Site: South Branch Potomac River Near Springfield, WV (USGS-01608500)

# Load the packages

library(dataRetrieval)
library(ggplot2)

# Set Parameters
# 00400 = pH, 00300 = Dissolved Oxygen
# Set the start date as June 1st and the end date as September 1st

site_number <- "01608500"
parameter_codes <- c("00400", "00300") 
start_date <- "2021-06-01"            
end_date <- "2021-09-01"              

# Pull the Data directly via the API

raw_data <- readNWISuv(
  siteNumbers = site_number, 
  parameterCd = parameter_codes, 
  startDate = start_date, 
  endDate = end_date
)

# Filter and Rename Columns for the Plot
# Extract timestamp, pH, and DO column

wv_data <- raw_data[, c("dateTime", "X_00400_00000", "X_00300_00000")]
colnames(wv_data) <- c("Timestamp", "pH", "Dissolved_Oxygen")

# Drop missing values to clean up the scatter graph

wv_data <- subset(wv_data, !is.na(pH) & !is.na(Dissolved_Oxygen))

# Build the Correlation Scatter Plot (With Jitter Fix to better show the density better)

ggplot(data = wv_data, aes(x = pH, y = Dissolved_Oxygen)) +
  geom_jitter(color = "#005F60", alpha = 0.3, size = 1.2, width = 0.02, height = 0) +
  geom_smooth(method = "lm", color = "darkred", size = 1.2, se = TRUE) +
  labs(
    title = "Biochemical Synchronization: Summer Correlation Study",
    subtitle = "Potomac River Near Springfield, WV (USGS-01608500) | June - Aug 2021",
    x = "pH (Standard Units)",
    y = "Dissolved Oxygen (mg/L)"
  ) +
  theme_minimal()

