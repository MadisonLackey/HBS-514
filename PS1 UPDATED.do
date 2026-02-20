*********************************************************************************************************
* HBS 514: PROBLEM SET ONE
* Author: Madison Lackey
* Date: 20 Febrauary 2026
* Sections:
* 0. Reseach Question
* 1. Loading & Cleaning File 1
* 2. Loading & Cleaning File 2
* 3. Merge Files 
*********************************************************************************************************

*********************************************************************************************************
* 0. Reseach Question: Framework and Data Overview 
*********************************************************************************************************

// Define research question & scope: 
* Relative to non-Appalachian counties that had active coal mines in the late 20th century, do Appalachian counties that had active coal mines in the late 20th century have higher poverty levels and lower median incomes today (2023)? 
* Eventually, I would like this project to investigate whether the existence of active coal mines in the Appalachian region in the late 20th century impacts (1) modern social inequality and (2) modern social attitudes. However, I would need GEOID information at the county-level from surveys (like the GSS) that are strictly protected and currently unavailable to me 
* This question is raised because the Appalachian region is the most impoverished region of the US. I have a theoretical assumption that this is caused by a poor transition from extractive coal-based economies relative to other US regions that once dependended on an extractive coal-based economcy. Many coal industries abandoned Appalachian communities after all coal was extracted, and migrated West where the majority of other coal sites were/ are located today. 

// Data Overview 
* This file identifies and explores two datasets that will be used to investigate the negative legacy effects of the coal-based economy in the US Appalachian region 
* File 1: The DOI's Geological Survey (USGA) dataset on active coal mines from 1928-1978 at the county-level
* File 2: The U.S. Department of Commerce's Bureau of the Census's Small Area Income and Poverty Estimates (SAIPE) dataset on county-level poverty and median income in the year of 2023 

*********************************************************************************************************
* 1. Loading & Cleaning File 1
*********************************************************************************************************

// Clear memory to ensure a clean working environment
clear

// Set project directory
cd "/Users/madisonlackey/Desktop/PS.514" // <--- Reviewer change only "/Users/madisonlackey/Desktop/PS.514"

// Import USGA csv file from Google Drive Link 
import delimited "https://drive.google.com/uc?id=1wv-PZQzpZ9I3d09sxdLnA4NkBtOLC4zk&export=download"

// Variable Overview:
describe
* The dataset contains 32,719 observations and 4 variables.
tab year
* Reports dates that a coal mine was active between the years of 1928-1978 
tab state
* Reports 50 state ID's
tab county 
*Reports the county the active coal mine was located in; N= 32,719 (a county can show up multiple times if it's active across multiple years)
tab coalregion
*Reports the region the active coal mine was located in; N= 32,719  

// Remove duplicate observations so that each county only shows up once: 
duplicates report county state 
duplicates drop county state, force 
tab county 
*N= 683 counties 

// Create a binary variable for Appalachian vs Non-Appalachian counties using "coalregions"
gen appalachian=. 
replace appalachian=0 if coalregion!="."
replace appalachian=1 if coalregion=="APPALACHIAN"
tab appalachian
*N= 683, 0= 499, 1= 184 
label define APP_label 0 "Non-Appalachian" 1 "Appalachian" 
label values appalachian APP_label 
tab appalachian
* Of the 683 counties with active coal mines between 1928-1978, approximately 73% are in the Appalachian region, while around 27% are non-Appalachian. 
* This is consistent with historial records, with the Appalachian region dominating coal production in the early to mid 20th century

// Save dataset as a cleaned dta file for merging 
save "USGAcoalmine.dta", replace 

*********************************************************************************************************
* 2. Loading & Cleaning File 2
*********************************************************************************************************

// Clear memory to ensure a clean working environment
clear

// Set project directory
cd "/Users/madisonlackey/Desktop/PS.514" // <--- Reviewer change only "/Users/madisonlackey/Desktop/PS.514"

// Import SAIPE csv file from Google Drive Link 
import delimited "https://drive.google.com/uc?id=1BX3-paIV7EVGSaACIoED0fAel8xb9Cs0&export=download", rowrange(2) varnames(2) 

// Variable Overview:
describe
* The dataset contains 3,196 observations and 5 variables.
rename postalcode state 
tab state
* Reports state ID's 
rename countyfipscode FIPScode
tab FIPScode
* Reports county's federal FIPS code 
rename povertyestimateallages ppl_in_poverty
tab ppl_in_poverty
* Reports the total number of people of all ages in poverty at the county-level in 2023
tab medianhouseholdincome
* Reports median household incomes at the county-level for 2023
tab name 
* Reports all counties + census areas + boroughs + state-level indicators 

// Create a county-level variable using "name" 
keep if word(name, 2)=="County" 
rename name county 

// Make merging possible by the county-level 
replace county=upper(county)
replace county=word(county, 1) if word(county, 2)=="COUNTY" 
* Made merging possible by the county-level  
tab county 
*N=2,838 counties 

// Save dataset as a cleaned dta file for merging 
save "SAIPE2023clean.dta", replace 

*********************************************************************************************************
* 3. Merge Files 1 & 2 at the County-Level 
*********************************************************************************************************

// Clear working environment 
clear 
cd "/Users/madisonlackey/Desktop/PS.514" // <--- Reviewer change only "/Users/madisonlackey/Desktop/PS.514"

// Merge 
use "SAIPE2023clean.dta"
merge 1:1 state county using "USGAcoalmine.dta", force 

// Merge Overview 
tab _merge
* N= 2,875
* Of the 2,875 available counties, 646 were matched. So, of the 683 counties with active coal mines, we have SAIPE data on 646 of them. 
keep if _merge==3

// Clean variables on new merged data set 
drop coalregion 
drop FIPScode 

// Save dataset as a cleaned dta file for use 
save "mergedPS1.dta", replace 
