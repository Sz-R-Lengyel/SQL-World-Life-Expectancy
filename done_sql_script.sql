# World Life Expectancy Project (Data Cleaning)


SELECT * 
FROM world_life_expectancy
;

#Here we aim to ensure that there are no duplicates in the data


# Identifying duplicates
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
Group BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

SELECT *
FROM(
     SELECT Row_ID,
     CONCAT(Country, Year),
     ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
     FROM world_life_expectancy
     ) as Row_table
WHERE Row_Num > 1     
;

DELETE FROM world_life_expectancy
WHERE 
	 Row_ID IN (
     SELECT Row_ID
FROM(
     SELECT Row_ID,
     CONCAT(Country, Year),
     ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
     FROM world_life_expectancy
     ) as Row_table
WHERE Row_Num > 1  
)     
;

# Hnadling Missing Values - Status
  



SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <>''
;

SELECT DISTINCT (Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

UPDATE world_life_expectancy t1
JOIN  world_life_expectancy t2
     ON t1.Country = t2.Country
SET t1.Status = 'Developing'     
WHERE t1.Status = '' 
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	USING (Country)
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed';

# Handling Missing Values - Life expectancy

SELECT * 
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;


#Here we can consider utilizing the median value between the preceding and succeding life expectancy vavlues.

SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
       t2.Country, t2.Year, t2.`Life expectancy`,
	   t3.Country, t3.Year, t3.`Life expectancy`,
       ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
     ON t1.Country = t2.Country
     AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
     ON t1.Country = t3.Country
     AND t1.Year = t3.Year + 1
WHERE  t1.`Life expectancy` = ''
;     

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
     ON t1.Country = t2.Country
     AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
     ON t1.Country = t3.Country
     AND t1.Year = t3.Year + 1
SET t1.`Life expectancy`  =   ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = ''
;


