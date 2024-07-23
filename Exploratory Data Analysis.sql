-- Exploratory Data Analysis

SELECT * FROM layoffs_staging2;

SELECT 
	MAX(total_laid_off) AS highest_layoff, 
	MAX(percentage_laid_off) AS max_per_layoff
FROM
	layoffs_staging2;
    
    
SELECT
	*
FROM
	layoffs_staging2
WHERE
	percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT
	company,
    SUM(total_laid_off) AS total_layoffs
FROM
	layoffs_staging2
GROUP BY
	company
ORDER BY
	total_layoffs DESC;
    
SELECT 
	MIN(`date`) AS first_date,
    MAX(`date`) AS last_date
FROM
	layoffs_staging2;
    
SELECT
	industry,
    SUM(total_laid_off) AS total_layoffs
FROM
	layoffs_staging2
GROUP BY
	industry
ORDER BY
	total_layoffs DESC;
    
SELECT
	country,
    SUM(total_laid_off) AS total_layoffs
FROM
	layoffs_staging2
GROUP BY
	country
ORDER BY
	total_layoffs DESC;

SELECT
	YEAR(`date`) AS year,
    SUM(total_laid_off) AS total_layoffs
FROM
	layoffs_staging2
GROUP BY
	YEAR(`date`)
ORDER BY
	YEAR(`date`) DESC;
    
SELECT
	stage,
    SUM(total_laid_off) AS total_layoffs
FROM
	layoffs_staging2
GROUP BY
	stage
ORDER BY
	total_layoffs DESC;
    
SELECT
	SUBSTRING(`date`, 1, 7) AS `Month`,
    SUM(total_laid_off) AS total_laid_off
FROM
	layoffs_staging2
WHERE
	SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY
	`Month`
ORDER BY
	 `Month`;
 
WITH Rolling_Total AS
(SELECT
	SUBSTRING(`date`, 1, 7) AS `Month`,
    SUM(total_laid_off) AS total_laid_off
FROM
	layoffs_staging2
WHERE
	SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY
	`Month`
ORDER BY
	 `Month`
)
SELECT 
	`Month`,
    total_laid_off,
	SUM(total_laid_off) OVER(ORDER BY `Month`) AS Rolling_total
FROM Rolling_Total;

SELECT
	company,
    YEAR(`date`) AS `yaer`,
    SUM(total_laid_off) AS total_laid_off
FROM
	layoffs_staging2
GROUP BY
	company,
	`yaer`
ORDER BY
	company;
    
WITH Company_year AS
(SELECT
	company,
    YEAR(`date`) AS `yaer`,
    SUM(total_laid_off) AS total_laid_off
FROM
	layoffs_staging2
GROUP BY
	company,
	`yaer`
ORDER BY
	company
),  Company_Year_Rank AS
(SELECT 
	*,
    DENSE_RANK() OVER(PARTITION BY `yaer` ORDER BY total_laid_off DESC) AS Ranking
FROM
	Company_year
WHERE
	`yaer` IS NOT NULL
)
SELECT 
	*
FROM
	Company_Year_Rank
WHERE
	Ranking <= 5;
