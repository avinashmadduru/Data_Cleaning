-- DATA CLEANING
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank values
-- 4. Remove Any Columns or Rows
CREATE TABLE layoffs
LIKE lay; 

CREATE TABLE layoffs_staging
LIKE layoffs; 

INSERT INTO layoffs_staging
SELECT * 
FROM layoffs;

-- Removing Duplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1;

CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging3;

INSERT INTO layoffs_staging3
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE 
FROM layoffs_staging3
WHERE row_num >1;

SELECT *
FROM layoffs_staging3;

-- Standardizing data
SELECT company, TRIM(company) 
FROM layoffs_staging3;

UPDATE layoffs_staging3
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging3
ORDER BY industry;

SELECT *
FROM layoffs_staging3
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging3
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_staging3
ORDER BY country;

UPDATE layoffs_staging3
SET country = 'United States'
WHERE country LIKE 'United States.';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging3;

UPDATE layoffs_staging3
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging3;

ALTER TABLE layoffs_staging3
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging3;

-- NULLs and Blanks
SELECT * 
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging3
SET industry = NULL 
WHERE industry ='';

SELECT *
FROM layoffs_staging3
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoffs_staging3
WHERE company LIKE 'bally%';

SELECT t1.industry, t2.industry
FROM layoffs_staging3 t1
JOIN layoffs_staging3 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging3 t1
JOIN layoffs_staging3 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL; 

SELECT *
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging3;

-- Remove Columns or Rows
ALTER TABLE layoffs_staging3
DROP COLUMN row_num;