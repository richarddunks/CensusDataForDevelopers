--Create demographic features table from raw table
CREATE TABLE demographics.dem_calc AS (
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
);

SELECT gid, 
  median_age, 
  median_age_male, 
  median_age_female, 
  ROUND(percent_white_nonhispanic,2) AS percent_white_nonhispanic,
  ROUND(percent_black_nonhispanic,2) AS percent_black_nonhispanic,
  ROUND(percent_american_indian_alaskan_native_nonhispanic,2) AS percent_american_indian_alaskan_native_nonhispanic,
  ROUND(percent_asian_nonhispanic,2) AS percent_asian_nonhispanic,
  ROUND(percent_native_hawaiian_other_pacific_islander_nonhispanic,2) AS percent_native_hawaiian_other_pacific_islander_nonhispanic,
  ROUND(percent_hispanic,2) AS percent_hispanic,
  ROUND(percent_owner_occupied_housing,2) AS percent_owner_occupied_housing,
  ROUND(percent_renter_occupied_housing,2) AS percent_renter_occupied_housing
FROM demographics.dem_calc;