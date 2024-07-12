# World Life Expectancy Project (Exploratory Data Analysis)

SELECT * 
FROM world_life_expectancy
;

#Exploring Life Expectancy
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC
;      

#Global Life Expectancy
Select Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

#Correlation between Life Expectancy vs GDP
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP ASC
;

#Insert Categories to investigate the correlation between Life Expectancy vs GDP
SELECT 
SUM(CASE WHEN GDP >=1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >=1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <=1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <=1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

#Correlation between Life Expectancy vs Status
SELECT Status, ROUND(AVG(`Life expectancy`),1)  
FROM world_life_expectancy
GROUP BY Status
;

#Check the amount of Country in Status
SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1) 
FROM world_life_expectancy
GROUP BY Status
;

#Correlation between Life Expectancy VS BMI
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;

#Calculation of adult mortality using rolling total
SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`)OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country Like '%UNITED KINGDOM%'
;