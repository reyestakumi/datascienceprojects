-- Tableau visualization available at https://public.tableau.com/views/TheEnvironmentalFootprintofFoodProduction/TheEnvironmentalFootprintofFoodProduction?:language=en-US&:display_count=n&:origin=viz_share_link

-- GLOBAL GHG EMISSIONS

--Global greenhouse gas emissions by sector
Select sector,sum(ghg_share) as sector_ghg_emissions
From FoodProductionImpact.dbo.GlobalGHG
Group by sector
Order by sector_ghg_emissions desc

-- Greenhouse gas emissions sub-sectors
Select sub_sector, ghg_share, ghg_amount
From FoodProductionImpact..GlobalGHG

-- Greenhouse gas emissions from AFOLU
Select sub_sector, (ghg_share/18.4)*100 as ghg_share, ghg_amount
From FoodProductionImpact..GlobalGHG
Where sector like '%AFOLU%'
Order by ghg_share desc



-- GREENHOUSE GAS EMISSIONS FROM FOOD PRODUCTION

-- Greenhouse gas emissions in the supply chain (in kg of CO2-eq)
Select * 
From FoodProductionImpact..SupplyChainGHG
Order by total_ghg_emissions desc

-- Greenhouse gas emmissions per kilogram of each food product (in kg of CO2-eg)
Select food, ghg_emissions_per_kg
From FoodProductionImpact..Emissions
Where ghg_emissions_per_kg is not null
Order by 2 desc

-- Share of methane in GHG emissions
Select food, ghg_emissions_per_kg, (methane_emissions_per_kg/ghg_emissions_per_kg)*100 as methane_percentage
From FoodProductionImpact..Emissions
Where ghg_emissions_per_kg is not null
Order by ghg_emissions_per_kg desc


-- LAND USE

-- Habitable vs non-habitable land
Select land_type, sum(land_cover) as land_mass
From FoodProductionImpact..LandCover
Group by land_type

-- Land cover
Select type, land_type, land_cover
From FoodProductionImpact..LandCover
Order by land_cover desc

-- Habitable land use
Select type, (land_cover/71)*100 as land_cover
From FoodProductionImpact..LandCover
Where land_type= 'Habitable'

-- Land use per kilogram of food product (in meters squared)
Select food, land_use_per_kg
From FoodProductionImpact..LandAndWater
Where land_use_per_kg is not null
Order by 2 desc


-- WATER USE

-- Freswater and scarcity weighted water use per kilogram of food product (in liters)
Select food, freshwater_withdrawals_per_kg, scarcity_weighted_water_per_kg
From FoodProductionImpact..LandAndWater
Where freshwater_withdrawals_per_kg is not null


-- EUTROPHICATION

-- Eutrophying emissions per kilogram of food product
Select food, eutrophying_emissions_per_kg
From FoodProductionImpact..Emissions
Where eutrophying_emissions_per_kg is not null
Order by 2 desc


-- WHAT DO WE EAT?

-- Environmental impact of protein-rich food
Select em.food, em.ghg_emissions_per_100g_protein, em.eutrophying_emissions_per_100g_protein,
	lw.land_use_per_100g_protein, lw.freshwater_withdrawals_per_100g_protein, lw.scarcity_weighted_water_per_100g_protein
From FoodProductionImpact..Emissions as em
Join FoodProductionImpact..LandAndWater as lw
On em.food = lw.food
	And em.nutritional_role = lw.nutritional_role
Where em.nutritional_role= 'Protein-Rich'

-- Environtmental impact of starch-rich food
Select em.food, em.ghg_emissions_per_1000kcal, em.eutrophying_emissions__per_1000kcal,
	lw.land_use_per_1000kcal, lw.freshwater_withdrawals_per_1000kcal, lw.scarcity_weighted_water_per_1000kcal
From FoodProductionImpact..Emissions as em
Join FoodProductionImpact..LandAndWater as lw
On em.food = lw.food
	And em.nutritional_role = lw.nutritional_role
Where em.nutritional_role= 'Starch-Rich'
	And lw.freshwater_withdrawals_per_1000kcal is not null

-- Dairy based milk vs plant based milk
Select type, ghg_emissions, land_use, water_use, eutrophication
From FoodProductionImpact..MilkFootprint




