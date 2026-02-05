 //PS1 for HBS 514
//By: MADISON LACKEY
//Edited: 4 February 2026 

//This file identifies and explores two datasets that will be used in a semester-long project on the negative legacy effects of coal mines in the US Appalachian region. I would like to investigate whether Appalachian counties that had active coal mines in the late 20th century have lower socioeconomic indicators in the present day than non-Appalachian counties that had active coal mines in the late 20th century. 
//Eventually, I would like this project to investigate whether the existence of active coal mines in the Appalachian region in the late 20th century impacts (1) modern social inequality and (2) modern social attitudes. However, I would need GEOID information from surveys (like the GSS) that are strictly protected and currently unavailable to me. 

//This file uses: 
*ONE: the DOI's United States Geological Survey (USGA) dataset on active coal mines from 1928-1978 at the county-level. This datafile was difficult to use because there was no FIPS id, so I had to merge based off the county. 
*TWO: the U.S. Department of Commerce, Bureau of the Census's Small Area Income and Poverty Estimates (SAIPE) dataset on county-level poverty in the year of 2023.

//This file is a preliminary step in a much larger semester-long project. I merge the two files to see if 2023 poverty levels are lower in Appalachian counties that had historically very active coal mines relative to non-Appalachian counties that had historically very active coal mines. 
*This question is raised because the Appalachian region is the most impoverished region of the US. I have a theoretical assumption that this is caused by a poor transition from extractive coal-based economies relative to other US regions that once dependended on an extractive coal-based economcy. Many coal industries abandoned Appalachian communities after all coal was extracted, and migrated West where the majority of other coal sites were/ are located today. 

 *----------------------------------------------------------------------------------------*
 
clear

//Set project directory
cd "/Users/madisonlackey/Desktop/PS1.514"

//DATA SET 1

import delimited "https://drive.google.com/uc?id=1HO0aT6XSM0xrxTZXWTKv5pztiB76QUj5&export=download"

//VARIABLE CLEANING
keep state county coalregion year

save "COALMINESCLEAN.dta", replace

tab coalregion
*region of existing coal mines
*used to create binary variable for appalachian vs not appalachian region 

gen appalachian=.
replace appalachian=0 if coalregion!="."
replace appalachian=1 if coalregion=="APPALACHIAN"
tab appalachian

drop coalregion

*remove duplicate observations 
duplicates report year county state 
duplicates drop year county state, force

tab year 
*year that the coal mine was active 
*1928 to 1978

tab state
*50 state ID's 

tab county
*county ID's 
duplicates report county 
duplicates drop county, force

save "coalminemerge.dta", replace 

*----------------------------------------------------------------------------------------*
 
clear

//DATA SET 2

import delimited "https://drive.google.com/uc?id=1ilGVOcz4K8n-YFM-nC9-Sztg0-DwAJz-&export=download"

//VARIABLE CLEANING

keep if attribute=="POVALL_2023"
*POVALL_2023=estimate of people in poverty 
drop attribute
*now we just have the estimate of people of all ages in poverty (2023)

save "POVERTYFIRSTCLEAN.dta", replace

//VARIABLE OVERVIEW 
*renaming 

rename fips_code FIPS
*official county identifiers
drop if FIPS==0

rename stabr state 
*state identifier, ideally this is dropped and just fips code is used but my other data set doesnt have fips codes attached yet 

rename area_name COUNTY 
*county identifier, ideally this is dropped and just fips code is used but my other data set doesnt have fips codes attached yet 
gen county=word(COUNTY, 1)
drop COUNTY
replace county=upper(county)
*made merging possible by the county 

*remove duplicate observations 
duplicates report county 
duplicates drop county, force

rename value individualsinpoverty
rename individualsinpoverty POVERTY 
*number of individuals in poverty (oddly not a percentage)

save "POVERTYCLEANTWO.dta", replace 

*----------------------------------------------------------------------------------------*
//MERGING 

use "coalminemerge.dta"
merge 1:1 county using "POVERTYCLEANTWO.dta", force

save "mergedPS1.dta"

tab _merge

drop if FIPS==.


