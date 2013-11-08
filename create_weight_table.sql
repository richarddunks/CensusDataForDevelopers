CREATE TABLE demographics.demographic_data_by_711 AS (
WITH buffer AS (
  --create buffer shapes around points
  SELECT 
  gid, 
  ST_Buffer(geom::geography,100) geom 
  FROM demographics.manhattan_711
), transform AS (
  --convert the buffer from geography to geometry
  SELECT gid, ST_Transform(geom::geometry, 4269) geom
  FROM buffer
), weight AS (
  --create the weighting based on the intersection area
  SELECT 
  t.gid, 
  dp1.geoid10,
  ST_Area(ST_Intersection(t.geom,dp1.geom))/ST_Area(t.geom) weight
  FROM transform t
  INNER JOIN demographics.dp1 
  ON ST_Intersects(t.geom, dp1.geom)
  ORDER BY gid, geoid10
), --Create demographic features table from raw table

  SELECT 
    gid,
    total_pop,
    --median age
    demographics.find_median_age(
      total_pop,
      total_under_5,
      total_5_9,
      total_10_14,
      total_15_19,
      total_20_24,
      total_25_29,
      total_30_34,
      total_35_39,
      total_40_44,
      total_45_49,
      total_50_54,
      total_55_59,
      total_60_64,
      total_65_69,
      total_70_74,
      total_75_79,
      total_80_84
      ) as median_age,
    --median age male
    demographics.find_median_age(
      total_male,
      male_under_5,
      male_5_9,
      male_10_14,
      male_15_19,
      male_20_24,
      male_25_29,
      male_30_34,
      male_35_39,
      male_40_44,
      male_45_49,
      male_50_54,
      male_55_59,
      male_60_64,
      male_65_69,
      male_70_74,
      male_75_79,
      male_80_84
      ) as median_age_male,
    --median age female
    demographics.find_median_age(
      total_female,
      female_under_5,
      female_5_9,
      female_10_14,
      female_15_19,
      female_20_24,
      female_25_29,
      female_30_34,
      female_35_39,
      female_40_44,
      female_45_49,
      female_50_54,
      female_55_59,
      female_60_64,
      female_65_69,
      female_70_74,
      female_75_79,
      female_80_84
      ) as median_age_female,
    --race stats
    nonHisp_whiteAlone/total_pop as percent_white_nonhispanic,
    nonHisp_aaAlone/total_pop as percent_black_nonhispanic,
    nonHisp_aianAlone/total_pop as percent_american_indian_alaskan_native_nonhispanic,
    nonHisp_asianAlone/total_pop as percent_asian_nonhispanic,
    nonHisp_nhopiAlone/total_pop as percent_native_hawaiian_other_pacific_islander_nonhispanic,
    nonHisp_otherAlone/total_pop as percent_other_race_nonhispanic,
    total_hisp/total_pop as percent_hispanic,
    --pop in owner occupied housing
    popInOwnerOccupiedHousingUnits/total_pop as percent_owner_occupied_housing,
    --pop in renter occupied housing
    popInRenterOccupiedHousingUnits/total_pop as percent_renter_occupied_housing
  FROM demographics.m_711_dem_data
)


);