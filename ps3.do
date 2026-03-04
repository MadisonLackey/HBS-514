*********************************************************************************************************
* HBS 514: PROBLEM SET #3
* Author: Madison Lackey
* Date: 3 March 2026

* Sections:
* 0. Preliminaries
* 1. Specify Regression Model
* 2. Visualize Relationships
* 3. Visualize Predicted Values
* 4. Export Regression Table
* 5. Reflection 
*********************************************************************************************************

/*
DATASET OVERVIEW 

Dataset 1: The DOI's United States Geological Survey (USGA) on active coal mines from 1928-1978 at the county-level

Dataset 1: The Department of Commerce's Bureau of the Census's Small Area Income and Poverty Estimates (SAIPE) at county-level (2023)

Merged by county in PS1 
*/

*********************************************************************************************************
* 0. Preliminaries: Set working directory & load data
*********************************************************************************************************

// Clear memory to ensure a clean working environment
clear

// Set project directory
cd "/Users/madisonlackey/Desktop/PS.514" // <--- Reviewer change only "/Users/madisonlackey/Desktop/PS.514"

// Use merged dta file from PS1 
use "https://drive.google.com/uc?id=1V_x41vs5EXinLY-H-Hy_gYxKcppYA6vY&export=download"

// For variable overview:
describe
* The dataset contains 646 observations and 7 variables.

*********************************************************************************************************
* 1. Specify Regression Model
*********************************************************************************************************

* DV: ppl_in_poverty 
* IV: appalachian
* Hypothesis: Appalachian counties that had active coal mines in the late 20th century will have a significantly higher number of people living in poverty compared to non-Appalachian counties that had active coal mines in the late 20th century. 

// Fix poverty variable for regression 
destring ppl_in_poverty, replace ignore(",")

// Run Regression
regress ppl_in_poverty appalachian
* Interpretation: On average, Appalachian counties that had active coal mines in the late 20th century have 1,848 more people in poverty relative to non--Appalachian counties that had active coal mines in the late 20th century. However, this relationship is not statistically significant with a p-value of 0.275. 

*********************************************************************************************************
* 2. Visualize Relationships
*********************************************************************************************************

// Generate a scatterplot with a fitted regression line 
twoway (scatter ppl_in_poverty appalachian, mcolor(blue%30)) ///
       (lfit ppl_in_poverty appalachian, lcolor(red)), ///
       title("Comparing Poverty Estimates in Appalachian vs. Non-Appalachian Coal Counties") ///
       subtitle("Bivariate Regression using Raw Poverty Counts (2023)") ///
       xtitle("County Region (0 = Non-Appalachian, 1 = Appalachian)") ///
       ytitle("Number of People in Poverty") ///
       xlabel(0 "Non-Appalachian" 1 "Appalachian")

*********************************************************************************************************
* 3. Visualize Predicted Values
*********************************************************************************************************

// Generate a margins plot to display predictions 
regress ppl_in_poverty i.appalachian
margins, at(appalachian=(0 1))
marginsplot, ///
    title("Comparing Poverty Estimates in Appalachian vs. Non-Appalachian Coal Counties") ///
    ytitle("Predicted Number of People in Poverty") ///
    xtitle("County Region") ///
    legend(order(0 "Non-Appalachian" 1 "Appalachian") pos(6) ring(0)) ///
    graphregion(color(white)) plotregion(color(white))
	
* Interpretation in policy terms: While these results fail to meet statistical significance, the trend provides some policy insight. The high constant coefficient (_cons= 7,781) tells us that poverty levels are substantial across all counties that had active coal mines in the late 20th century. This suggests that the historic coal industry created a baseline of economic distress in regions across the US. From this specific model, policymakers (likely at the federal level) cannot assume that counties in the appalachian region transitioned from coal-based economies in a manner that created poverty conditions that are worse than those in non-appalachian regions. As such, federal poverty assistance programs should focus on poverty rates rather than geographic boundaries. 

*********************************************************************************************************
* 4. Export Regression Table
*********************************************************************************************************

// Ensure that regression table package is installed: 
ssc install estout, replace

// Run regression and store it 
regress ppl_in_poverty appalachian
eststo model1

// Export & save the regression table 
esttab model1 using "Poverty_Results.rtf", replace ///
    b(%9.3f) se(%9.3f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, labels("N" "R-squared")) ///
    title("Comparing Poverty Estimates in Appalachian vs. Non-Appalachian Coal Counties") ///
    label

// Check output for coefficients, standard errors, and significance markers: 
* appalachian coefficient: Appalachian counties have, on average, 1,848 more people in poverty than non-Appalachian coal counties.
* constant coefficient: Non-Appalachian coal counties average 7,781 people in poverty. The three stars mean this baseline is a very reliable statistical estimate (p < 0.01).
* standard error (SE): The large SE coefficient (1,848) means that we cannot be sure the difference isn't just due to random chance.
* significance markers: There are no stars (*) next to the Appalachian coefficient; the relationship is not statistically significant.

*********************************************************************************************************
* 5. Reflection 
*********************************************************************************************************

// Regression Results Interpretation: 
* On average, Appalachian counties that had active coal mines in the late 20th century have 1,848 more people in poverty relative to non-Appalachian counties that had active coal mines in the late 20th century. However, this relationship is not statistically significant with a p-value of 0.275. 

// Role of Visualizations: 
* The marginsplot and scatterplot challenged the prevailing, simple "Appalachian is poorer than" narrative.
* The massive vertical "spread" of dots in the scatterplot shows that some non-Appalachian coal counties actually have more people in poverty than many Appalachian ones.
* The overlapping confidence intervals in the margins plot explains why the p-value was so high: when those bars overlap, we can't be certain the two groups are truly different.

// Next Steps: 
* I likely need to switch from raw poverty counts to a percentage-based poverty rate for the counties. When selecting raw counts over a percentage rate, I failed to realize that raw counts are biased by the total population of a county, while a percentage provides a more "fair" comparison. 
* After re-running all of these models with the percentage rate, I would still need to add control variables and run a multivariate regression. This would allow me to see the "Appalachian effect" while holding confounding variables (e.g., average race and education level) constant. 
























