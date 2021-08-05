--Cleaning data in SQL queries

Select *
From PortfolioProject..NashvilleHousing


--Standardize Date format

Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing


-----------------------------------------------------------------------------------

--Populate Property Address data

Select *
From PortfolioProject..NashvilleHousing
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


------------------------------------------------------------------------------------------------------------

--Breaking out Address into individual colums (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--Order by ParcelID


Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Varchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))




Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Varchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Varchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerySplitState Varchar(255);

UPDATE NashvilleHousing
SET OwnerySplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


Select *
From PortfolioProject.dbo.NashvilleHousing


-----------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "SoldAsVacant" field

Select DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
GROUP BY(SoldAsVacant)
ORDER BY (SoldAsVacant)


Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 Else SoldAsVacant
	 END
From PortfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
				   When SoldAsVacant = 'N' THEN 'No'
				   Else SoldAsVacant
				   END


-----------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				   UniqueID
				   ) Row_Num
From PortfolioProject.dbo.NashvilleHousing
)
Select * 
From RowNumCTE
Where Row_Num > 1
Order by PropertyAddress

----

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				   UniqueID
				   ) Row_Num
From PortfolioProject.dbo.NashvilleHousing
)
DELETE
From RowNumCTE
Where Row_Num > 1
--Order by PropertyAddress


--------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select * 
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate
