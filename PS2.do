*********************************************************************************************************
* HBS 514: PROBLEM SET #2
* Author: Madison Lackey
* Date: 18 Febrauary 2026
* Sections:
* 0. Preliminaries
* 1. Descriptive Statistics for key variables 
* 2. Frequency Tables & Cross-tabulations 
* 3. Visualizations 
* 4. Summary of Analysis 
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
* 1. Descriptive Statistics: appalachian, ppl_in_poverty, medianhouseholdincome
*********************************************************************************************************

// Variable: appalachian 
tab appalachian
*N= 646; Non-Appalachian= 466; Appalachian= 180 
* Of the 683 counties with active coal mines between 1928-1978, approximately 27% are in the Appalachian region, while around 73% are non-Appalachian. 

// Variable: ppl_in_poverty
destring ppl_in_poverty, replace ignore("%, $")
* Converted from string to numerical 
summarize ppl_in_poverty, d
*N= 646; MIN= 96; MAX= 301,255; MEAN= 8,297; MEDIAN= 3,271; SKEW= 8.46
*Interpretation: The average number of people in poverty (2023) across the 646 counties is 8,297. The lowest reported # of people in poverty is 96, while the highest reported # is 301,255. There are significantly more counties with poverty estimates on the lower end of the distribution, likely due to a few counties with extremely high population counts pulling the distribution toward higher values. 

// Variable: medianhouseholdincome 
destring medianhouseholdincome, replace ignore("%, $")
* Converted from string to numerical 
summarize medianhouseholdincome, d
*N= 646; MIN= 35,000; MAX= 144,807; MEAN= 62,719; MEDIAN= 59,839; SKEW= 1.54
*Interpretation: The average median household income (2023) across the 646 counties is $62,719. The lowest reported median household income is $35,000, while the highest reported median household income $144,807. There are significantly more counties with lower median household incomes, with a few counties with high median household incomes pulling the distribution toward higher values. 

*********************************************************************************************************
* 2. Frequency Tables & Cross-tabulations 
*********************************************************************************************************
// Create binary ppl_in_poverty variable for cross-tabulations and visuals: poverty_binary
xtile poverty_binary=ppl_in_poverty, n(2) 
*N= 646; 1= 323; 2= 323 
label define povbin_label 1 "Low Poverty" 2 "High Poverty"
label values poverty_binary povbin_label
tab poverty_binary
*N= 646; Exactly half of the counties have below the median number of people in poverty, while exactly half of the counties have more than the median number of people in poverty. 

// Cross-tabulations: poverty_binary & appalachian 
tab poverty_binary appalachian, column chi2 
* 73% of Appalachian counties are considered high poverty, compared to 41% of non-Appalachian counties. In other words, Appalachian counties that had historically active coal mines are nearly 2x as likely to have high poverty levels relative to non-Appalachian counties that had historically active coal mines. 
* This relationship (with no control variables) is statistically signficant with a pvalue of 0.000. 

*********************************************************************************************************
* 3. Visualizations 
*********************************************************************************************************

// Generate histogram for ppl_in_poverty (excluding extreme outliers)
    histogram ppl_in_poverty if ppl_in_poverty <29187, frequency ///
	xtitle("Total Number of People in Poverty") ///
	ytitle("Number of Counties") ///
	graphregion(color(white)) ///
	plotregion(margin(zero)) ///
	title("Poverty Level Across Counties") ///
	subtitle("Counties by Total People in Poverty (Excluding top 5%)") ///
	note("*Cutoff at 95th percentile (29,187 people)")
*Interpretation: The majority of counties in this dataset have less than 10,000 people in poverty as of 2023. 


// Generate 100% stacked bar chart for poverty_binary & appalachian
graph bar, ///
    over(poverty_binary, label(labsize(small))) ///
    over(appalachian, gap(40)) ///
    stack ///
    asyvars ///
	percent ///
    ytitle("Percent of Counties") ///
    title("Poverty Level by Region") ///
	legend(order(1 "Low Poverty" 2 "High Poverty") ///
           pos(3) ring(0.5)) ///
    graphregion(color(white)) ///
    plotregion(margin(zero))
*Interpretation: Appalachian counties that had historically active coal mines have a much higher % of people living in poverty than non-Appalachian counties that had historically active coal mines. 

*********************************************************************************************************
* 4. Summary of Analysis 
*********************************************************************************************************

// Of the 683 counties with active coal mines between 1928-1978, approximately 27% are in the Appalachian region, while around 73% are non-Appalachian. Across the 646 counties that had active coal mines and that we have SAIPE poverty estimates for, an average number of 8,297 people were living in poverty in 2023; however, the median is much lower, with only around 3,271 people. This extreme right-skew is driven by highly populated counties where around 301,255 people are reported living in poverty. To visualize this distribution more effectively, I generated a histogram that excluded the top 5% of outliers (counties with more than 29,187 people in poverty). The histogram illustrates that coal-mining counties generally have less than 10,000 people in poverty. 
// To analyze the data more effectively, counties were split into low and high poverty categories based on the median number of people in poverty (3,271 people). A cross-tabulation using this binary variable revealed that around 73% of Appalachian counties are considered high poverty, while around 41% of non-Appalachian counties are considered high poverty. This indicates that Appalachian counties that had historically active coal mines are nearly 2x as likely to have high poverty levels relative to non-Appalachian counties that had historically active coal mines. A chi squared test revealed that this relationship is statistically significant (p value=0.000). However, no control variables were included in this analysis. The 100% stacked bar chart illustrates that the "High Poverty" segment makes up the majority of the Appalachian category and the minority of the Non-Appalachian category. 


*********************************************************************************************************
* End of Code 
*********************************************************************************************************
