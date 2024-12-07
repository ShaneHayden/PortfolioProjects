Select *
From PortfolioProject.dbo.Housing




------------------------------------------------------------
----Converting Date Colomn into more accesible and analysis friendly format


Select SaleDateConv, CONVERT(date,SaleDate)
from PortfolioProject.dbo.Housing;

Update PortfolioProject.dbo.Housing
Set SaleDate = CONVERT(date,SaleDate)

Alter Table PortfolioProject.dbo.Housing
ADD SaleDateConv Date;

Update PortfolioProject.dbo.Housing
Set SaleDateConv = CONVERT(date,SaleDate)


---------------------------------------------------------------
----Fill missing values in PropertyAddress

Select *
from PortfolioProject.dbo.Housing
--Where PropertyAddress is NULL
order by ParcelID


--From the dataset, propertyAddress is the same for rows using the same ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.Housing a
Join PortfolioProject.dbo.Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.Housing a
Join PortfolioProject.dbo.Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]


-------------------------------------------------------------------------------
----Splitting Property Colomn into individual colomn (Address, City, State)


Select PropertyAddress
from PortfolioProject.dbo.Housing;


Select
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.Housing 

Alter Table PortfolioProject.dbo.Housing
ADD PropertySplitAddress VARCHAR(255);

Update PortfolioProject.dbo.Housing
Set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


Alter Table PortfolioProject.dbo.Housing
ADD PropertySplitCity VARCHAR(255);

Update PortfolioProject.dbo.Housing
Set PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select * 
from PortfolioProject.dbo.Housing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from PortfolioProject.dbo.Housing

Alter Table PortfolioProject.dbo.Housing
ADD OwnerSplitAddress VARCHAR(255);

Update PortfolioProject.dbo.Housing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Alter Table PortfolioProject.dbo.Housing
ADD OwnerSplitCity VARCHAR(255);

Update PortfolioProject.dbo.Housing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Alter Table PortfolioProject.dbo.Housing
ADD OwnerSplitState VARCHAR(255);

Update PortfolioProject.dbo.Housing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
from PortfolioProject.dbo.Housing


--------------------------------------------------------------------------------------------
--Changing Y and N to Yes and No in "Sold as Vacant" Colomn



Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.Housing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
,Case when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant= 'N' then 'No'
	  else SoldAsVacant
	  END
from PortfolioProject.dbo.Housing


Update PortfolioProject.dbo.Housing
Set	SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant= 'N' then 'No'
	  else SoldAsVacant
	  END

--------------------------------------------------------------------
--Removing Duplicate Rows


With RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from PortfolioProject.dbo.Housing
)

Delete 
from RowNumCTE
where row_num >1

------------------------------------------------------------------------------------------------
--Delete Unecessary/Unused Colomns


Select * 
from PortfolioProject.dbo.Housing

Alter table PortfolioProject.dbo.Housing
Drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



