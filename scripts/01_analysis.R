pacman::p_load(tidyverse, here, fixest, modelsummary, gt)

# Load Data
iv_data <- read_csv(here("data", "iv_data.csv"))

#### Run IV Models ####
# Clay
one_iv <- feols(
  I(lead_h_change * 100) ~ factor(decade)*scale(pct_ba) + scale(log(decade_pop)) + 
    scale(pct_black) + I(scale(pct_black) ^ 2) + scale(pct_hispanic) + scale(pct_asian) + scale(pct_fb) +
    scale(pct_elderly) + scale(pct_poverty) + scale(pct_military) + scale(muni_pcap) +
    scale(pct_government) + scale(pct_manufacturing) + scale(gdp_pcap) + scale(pct_largehh) + scale(pct_pop_growth) +
    factor(region) | scale(I(units_pcap * 1000)) ~ scale(clay),
  data = iv_data, cluster = "cbsa_code"
)

# Two Characteristics
two_iv <- feols(
  I(lead_h_change * 100) ~ factor(decade)*scale(pct_ba) + scale(log(decade_pop)) + 
    scale(pct_black) + I(scale(pct_black) ^ 2) + scale(pct_hispanic) + scale(pct_asian) + scale(pct_fb) +
    scale(pct_elderly) + scale(pct_poverty) + scale(pct_military) + scale(muni_pcap) +
    scale(pct_government) + scale(pct_manufacturing) + scale(gdp_pcap) + scale(pct_largehh) + scale(pct_pop_growth) +
    factor(region) | scale(I(units_pcap * 1000)) ~ scale(clay) + scale(mean_ksat),
  data = iv_data, cluster = "cbsa_code"
)

# All Characteristics
all_iv <- feols(
  I(lead_h_change * 100) ~ factor(decade)*scale(pct_ba) + scale(log(decade_pop)) + 
    scale(pct_black) + I(scale(pct_black) ^ 2) + scale(pct_hispanic) + scale(pct_asian) + scale(pct_fb) +
    scale(pct_elderly) + scale(pct_poverty) + scale(pct_military) + scale(muni_pcap) +
    scale(pct_government) + scale(pct_manufacturing) + scale(gdp_pcap) + scale(pct_largehh) + scale(pct_pop_growth) +
    factor(region) | scale(I(units_pcap * 1000)) ~ scale(clay) + scale(mean_ksat) + 
    scale(rock_fragments) + scale(restrictive_depth) + scale(bulk_density),
  data = iv_data, cluster = "cbsa_code"
)

#### Table Formatting ####

# create rows of sargan and F-tests to add to model summary
rows <- tribble(
  ~term, ~model1, ~model2, ~model3,
  "First Stage F-Statistic", 
  fitstat(one_iv, "ivf", simplify = TRUE)[[1]],
  fitstat(two_iv, "ivf", simplify = TRUE)[[1]],
  fitstat(all_iv, "ivf", simplify = TRUE)[[1]],
  "Sargan Test", 
  NA,
  fitstat(two_iv, "sargan", simplify = TRUE)[[1]],
  fitstat(all_iv, "sargan", simplify = TRUE)[[1]],
  "Sargan P-Value", 
  NA, 
  fitstat(two_iv, "sargan", simplify = TRUE)[[2]],
  fitstat(all_iv, "sargan", simplify = TRUE)[[2]]
)

# Create coefficient map to clean variable names
cm <- c(
  "(Intercept)" = "Intercept",
  "factor(decade)2000" = "2000s",
  "factor(decade)2010" = "2010s",
  "factor(year)2000" = "2000s",
  "factor(year)2010" = "2010s",
  "scale(I(units_pcap * 1000))" = "Units per 1,000 People",
  "fit_scale(I(units_pcap * 1000))" = "Units per 1,000 People",
  "scale(pct_ba)" = "Bachelor's Degree (%)",
  "factor(decade)2000:scale(pct_ba)" = "2000s x Bachelor's %",
  "factor(decade)2010:scale(pct_ba)" = "2010s x Bachelor's %",
  "factor(year)2000:scale(pct_ba)" = "2000s x Bachelor's %",
  "factor(year)2010:scale(pct_ba)" = "2010s x Bachelor's %",
  "scale(pct_black)" = "Black (%)",
  "I(scale(pct_black)^2)" = "Black (%) Squared",
  "scale(pct_hispanic)" = "Hispanic (%)",
  "scale(pct_asian)" = "Asian (%)",
  "scale(pct_fb)" = "Foreign-Born (%)",
  "scale(pct_elderly)" = "Elderly (%)",
  "scale(pct_poverty)" = "Poverty (%)",
  "scale(gdp_pcap)" = "GDP per Capita",
  "scale(pct_manufacturing)" = "Manufacturing (%)",
  "scale(pct_government)" = "Government (%)",
  "scale(pct_military)" = "Military (%)",
  "scale(pct_largehh)" = "Large Household (%)",
  "scale(muni_pcap)" = "Municipal Fragmentation",
  "scale(pct_pop_growth)" = "Population Growth",
  "scale(log(decade_pop))" = "Population (log)",
  "scale(log(pop))" = "Population (log)",
  "factor(region)Northeast" = "Northeast",
  "factor(region)South" = "South",
  "factor(region)West" = "West",
  "scale(clay)" = "Clay (%)",
  "scale(mean_ksat)" = "Hydraulic Conductivity",
  "scale(rock_fragments)" = "Rock Fragments (%)",
  "scale(restrictive_depth)" = "Restrictive Depth (cm)",
  "scale(bulk_density)" = "Bulk Density"
)

#### Output Table ####

iv_table <- modelsummary(list("Clay Instrument" = one_iv, "Clay & Hydraulic \nConductivity" = two_iv, 
                  "All Soil \nCharacteristics" = all_iv), 
             stars = TRUE,
             coef_map = cm,
             gof_omit = "R2(?! Adj)|AIC|BIC|RMSE|Std.Errors",
             add_rows = rows,
             output = "gt")
iv_table
