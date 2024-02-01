/*DATA CLEANING*/

/*LOADING THE DATA FROM THE DATABASE*/
SELECT * FROM HousingList

/*DATE FROMATTING*/
SELECT SaleDate FROM HousingList

SELECT SaleDate, CONVERT(Date,SaleDate)
AS DateConvert
From HousingList

/* UPDATING THE TABLE*/
ALTER TABLE HousingList
ADD DateConverted Nvarchar(255);

UPDATE HousingList
SET DateConverted = CONVERT(Date,SaleDate)

/*PROPERTY ADREESS*/
SELECT * FROM HousingList
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

/*JOINING THE A SINGLE TABLE TO ITSELF*/
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM HousingList a
JOIN HousingList b
ON a.ParcelID = b.ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM HousingList a
JOIN HousingList b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
AS NewAdress
FROM HousingList a
JOIN HousingList b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

/*Updating the table to replace the property address with null column with an address*/
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM HousingList a
JOIN HousingList b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

/* SEPERATING THE ADDRESS IN THE ADDRESS COLUMN INTO INDICUDAL COLUMN*/

SELECT PropertyAddress FROM HousingList

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)) AS Address
FROM HousingList

/*TO REMOVE THE COMMA I INSERTED -1)*/
SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) AS Address
FROM HousingList


/*THE ADDRESS FIELD HAS BEEN SEPEREATE INTO CITY AND STATE*/

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS CITY
FROM HousingList

ALTER TABLE HousingList
ADD PropertySplitAddress Nvarchar(255);

UPDATE HousingList
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE HousingList
ADD PropertySplitCity Nvarchar(255);

UPDATE HousingList
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

/*CHANGES HAVE BEEN APPLIED THE TWO COLUMN CAN BE SEEN AT THE END OF THE TABLE*/
SELECT * FROM HousingList

/*WORKING ON THE OWNER ADDRESS COLUMN*/
SELECT OwnerAddress FROM HousingList

/*USING PARSENAME TO SEPAERTAE THE COLUMNS*/
SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS Address,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS City,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS State
FROM HousingList
WHERE OwnerAddress IS  NOT NULL

ALTER TABLE HousingList
ADD SplitAddress Nvarchar(255);

UPDATE HousingList
SET SplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 

ALTER TABLE HousingList
ADD SplitCity Nvarchar(255);

UPDATE HousingList
SET SplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 

ALTER TABLE HousingList
ADD SplitState Nvarchar(255);

UPDATE HousingList
SET SplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 

/*OUTPUT OF THE CHANGES*/
SELECT * FROM HousingList

/*CHANGING YES $ NO TO Y AND N*/
SELECT SoldAsVacant FROM HousingList

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM HousingList
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,

CASE
WHEN SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant
END
AS NewResult
FROM HousingList

/*UPDATING THE CHANGES*/
UPDATE HousingList
SET SoldAsVacant = CASE
WHEN SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant
END

/*REMOVING THE DUPLICATES*/

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY 
			UniqueID)
FROM HousingList

/*USING CTE TO TO QUERY SET OF RESULTS*/
WITH RowNumCTE as(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY 
			UniqueID ) row_num
FROM HousingList
)

SELECT * FROM RowNumCTE
WHERE row_num > 1
order by PropertyAddress

--delete  FROM RowNumCTE
--WHERE row_num > 1
----order by PropertyAddress


/*DROPPING COLUMNS I HAVE CLEANED*/

SELECT * FROM HousingList

ALTER TABLE HousingList
DROP COLUMN OwnerAddress, PropertyAddress

ALTER TABLE HousingList
DROP COLUMN SaleDate