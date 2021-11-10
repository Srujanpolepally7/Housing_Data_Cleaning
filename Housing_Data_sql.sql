

select * from master.dbo.Housing_Data

select SaleDate, CONVERT(date, SaleDate) from master.dbo.Housing_Data;

select SaleDate, cast(SaleDate as date) from master.dbo.Housing_Data;

alter table master.dbo.Housing_Data
add SaleDateConverted date;

update master.dbo.Housing_Data set SaleDateConverted = convert(date, SaleDate);

alter table master.dbo.Housing_Data
drop column SaleDate

-------------------------------------------------------------------------------
-- Populate address date

select ParcelID, PropertyAddress from master.dbo.Housing_Data
where PropertyAddress is null

-- ISNULL(expression, value) this returns the specified value if the expression is null--
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(NULL,b.PropertyAddress) as full_address from master.dbo.Housing_Data a
join master.dbo.Housing_Data b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null;

update a set PropertyAddress = isnull (NULL,b.PropertyAddress) 
from master.dbo.Housing_Data a
join master.dbo.Housing_Data b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null;

-----------------------------------------------------------------------------------------------------------


-- split property address breaking into individual address [city, state..]

SELECT 
     REVERSE(PARSENAME(REPLACE(REVERSE(PropertyAddress), ',', '.'), 1)) AS [Street]
   , REVERSE(PARSENAME(REPLACE(REVERSE(PropertyAddress), ',', '.'), 2)) AS [City]
FROM master.dbo.Housing_Data;


alter table master.dbo.Housing_Data 
add PropertySplitAddress nvarchar(255),
	PropertySplitCity nvarchar(255); 
	OwnerAddressState nvarchar(255);

update master.dbo.Housing_Data set PropertySplitAddress = REVERSE(PARSENAME(REPLACE(REVERSE(PropertyAddress), ',', '.'), 1))
update master.dbo.Housing_Data set PropertySplitCity = REVERSE(PARSENAME(REPLACE(REVERSE(PropertyAddress), ',', '.'), 2))
update master.dbo.Housing_Data set OwnerAddressState= REVERSE(PARSENAME(REPLACE(REVERSE(OwnerAddress), ',', '.'), 3));

select REVERSE(parsename(replace(reverse(OwnerAddress), ',', '.'), 3)) as state from master.dbo.Housing_Data;


----------------------------------------------------------------------------------------------------------------

--- change Y and N to yes and no in 'solidasvacant'
update master.dbo.Housing_Data set SoldAsVacant = 'No' where SoldAsVacant = 'N';
update master.dbo.Housing_Data set SoldAsVacant = 'Yes' where SoldAsVacant = 'Y';

select distinct(SoldAsVacant), COUNT(SoldAsVacant) from master.dbo.Housing_Data
GROUP BY SoldAsVacant;

---------------------------------------------------------------------------------------------------------------------

--- remove duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From master.dbo.Housing_Data
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From master.dbo.Housing_Data


-------------------------------------------------------------------------------------------------------------------
---- drop columns
Select *
From  master.dbo.Housing_Data



ALTER TABLE  master.dbo.Housing_Data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate