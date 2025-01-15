# Segregation Analysis with Instrumental Variables

This repository contains the code, data, and materials to create a brief vignette analyzing the relationship between housing permits and racial segregation in U.S. metro areas. The analysis employs novel instrumental variables derived from soil characteristics, including clay content and hydraulic conductivity, to estimate the causal impact of housing development on segregation.

Due to file sizes, this repository does not contain raw Census data and the code used to clean and analyze segregation. Rather, this takes an already cleaned data set and generates tables and figures.

The final report can be viewed [here](https://aferna08.github.io/housing-segregation-analysis/).
------------------------------------------------------------------------

## Repository Structure

-   **`data/`**: Contains cleaned data with metro area characteristics and soil rasters (`.tif` files) managed via [Git LFS](https://git-lfs.github.com/).
-   **`output/`**: Placeholder for generated plots, tables, and other outputs.
-   **`scripts/`**: R scripts for data analysis and visualizations.
    -   "01_analysis.R" creates the IV regressions
    -   "02_seg_change_map.R" creates an interactive visualization of segregation change and building permits
    -   "03_soil_map.R" creates a visualization of clay and hydraulic conductivity for soil across the U.S.
-   **`report.Rmd`**: Markdown file used to compile the main analysis report. Each script is called within the report, so compiling it will generate all tables and figures.

------------------------------------------------------------------------

## How to Use

1.  **Clone the Repository**: Clone the repository, ensuring that Git LFS is installed.
2.  **Install Dependencies**: Scripts in the project use the [pacman](https://cran.r-project.org/web/packages/pacman/index.html) package (`install.packages("pacman")`) to install and load other required packages.
3.  **Reproduce the Report**: Open the markdown file (report.Rmd) in RStudio and compile it to generate the full report.
    -   Alternatively, run the scripts individually to view the raw output.

------------------------------------------------------------------------

## Contact

If you have questions or would like to request the full working paper, please contact [aaronfernandez\@g.harvard.edu](mailto:aaronfernandez@g.harvard.edu)
