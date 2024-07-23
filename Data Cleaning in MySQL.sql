-- Data Cleaning 


SELECT * 
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standarize the Data 
-- 3. Null values or Blank ones
-- 4. Remove any Columns

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging
SELECT * FROM 
layoffs;

DELETE FROM layoffs_staging;

SELECT * FROM layoffs_staging;

-- Removing Duplicates 

SELECT *,
	ROW_NUMBER() OVER ( 
    PARTITION BY company, location, industry,total_laid_off,percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_numn
FROM 
	layoffs_staging;

WITH Duplicate_cte AS
(SELECT *,
	ROW_NUMBER() OVER ( 
    PARTITION BY company, location, industry,total_laid_off,percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_numn
FROM 
	layoffs_staging
)
SELECT * FROM Duplicate_cte
WHERE row_numn > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';


CREATE TABLE layoffs_staging2
LIKE  layoffs_staging;

SELECT * FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
ADD COLUMN row_num INT;

DELETE FROM layoffs_staging2;

SELECT * from layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
	ROW_NUMBER() OVER ( 
    PARTITION BY company, location, industry,total_laid_off,percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_numn
FROM 
	layoffs_staging;
    
SELECT * FROM layoffs_staging2
WHERE row_num > 1;

DELETE FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2
WHERE row_num > 1;

SELECT row_num FROM layoffs_staging2;

SELECT DISTINCT * FROM layoffs_staging2;

-- Standarizing Data

SELECT * FROM layoffs_staging2;

SELECT company, TRIM(company) FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry FROM layoffs_staging2;

SELECT industry FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country FROM layoffs_staging2;

SELECT * FROM layoffs_staging2
WHERE country = 'United States.';

SELECT DISTINCT country, TRIM( TRAILING '.' FROM country)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET country = TRIM( TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Null values or Blank ones

SELECT * 
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''; 

SELECT *
FROM layoffs_staging2 T1
JOIN layoffs_staging2 T2
	ON T1.company = T2.company
WHERE (T1.industry IS NULL OR T1.industry = '') 
AND T2.industry IS NOT NULL;

UPDATE layoffs_staging2 T1
JOIN layoffs_staging2 T2
	ON T1.company = T2.company
SET T1.industry = T2.industry
WHERE T1.industry IS NULL  
AND T2.industry IS NOT NULL;

SELECT * 
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;