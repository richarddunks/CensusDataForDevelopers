SELECT 
    b.boroname,
    SUM(total_pop) as total_pop,
    ROUND(SUM(total_male::numeric)/SUM(total_pop::numeric), 2) as percent_total_male,
    ROUND(SUM(total_female::numeric)/SUM(total_pop::numeric),2) as percent_total_female,
    --median age
    demographics.find_median_age(
      SUM(total_pop),
      SUM(total_under_5),
      SUM(total_5_9),
      SUM(total_10_14),
      SUM(total_15_19),
      SUM(total_20_24),
      SUM(total_25_29),
      SUM(total_30_34),
      SUM(total_35_39),
      SUM(total_40_44),
      SUM(total_45_49),
      SUM(total_50_54),
      SUM(total_55_59),
      SUM(total_60_64),
      SUM(total_65_69),
      SUM(total_70_74),
      SUM(total_75_79),
      SUM(total_80_84)
      ) as median_age,
    --median age male
    demographics.find_median_age(
      SUM(total_male),
      SUM(male_under_5),
      SUM(male_5_9),
      SUM(male_10_14),
      SUM(male_15_19),
      SUM(male_20_24),
      SUM(male_25_29),
      SUM(male_30_34),
      SUM(male_35_39),
      SUM(male_40_44),
      SUM(male_45_49),
      SUM(male_50_54),
      SUM(male_55_59),
      SUM(male_60_64),
      SUM(male_65_69),
      SUM(male_70_74),
      SUM(male_75_79),
      SUM(male_80_84)
      ) as median_age_male,
    --median age female
    demographics.find_median_age(
      SUM(total_female),
      SUM(female_under_5),
      SUM(female_5_9),
      SUM(female_10_14),
      SUM(female_15_19),
      SUM(female_20_24),
      SUM(female_25_29),
      SUM(female_30_34),
      SUM(female_35_39),
      SUM(female_40_44),
      SUM(female_45_49),
      SUM(female_50_54),
      SUM(female_55_59),
      SUM(female_60_64),
      SUM(female_65_69),
      SUM(female_70_74),
      SUM(female_75_79),
      SUM(female_80_84)
      ) as median_age_female,
    --race stats
    ROUND(SUM(nonHisp_whiteAlone::numeric)/SUM(total_pop::numeric),2) as percent_white_nonhispanic,
    ROUND(SUM(nonHisp_aaAlone::numeric)/SUM(total_pop::numeric),2) as percent_black_nonhispanic,
    ROUND(SUM(nonHisp_aianAlone::numeric)/SUM(total_pop::numeric),2) as percent_american_indian_alaskan_native_nonhispanic,
    ROUND(SUM(nonHisp_asianAlone::numeric)/SUM(total_pop::numeric),2) as percent_asian_nonhispanic,
    ROUND(SUM(nonHisp_nhopiAlone::numeric)/SUM(total_pop::numeric),2) as percent_native_hawaiian_other_pacific_islander_nonhispanic,
    ROUND(SUM(nonHisp_otherAlone::numeric)/SUM(total_pop::numeric),2) as percent_other_race_nonhispanic,
    ROUND(SUM(total_hisp::numeric)/SUM(total_pop::numeric),2) as percent_hispanic,
    --pop in owner occupied housing
    ROUND(SUM(popInOwnerOccupiedHousingUnits::numeric)/SUM(total_pop::numeric),2) as percent_owner_occupied_housing,
    --pop in renter occupied housing
    ROUND(SUM(popInRenterOccupiedHousingUnits::numeric)/SUM(total_pop::numeric),2) as percent_renter_occupied_housing
  FROM demographics.dp1
  INNER JOIN demographics.nyc_boro b
  ON ST_Intersects(dp1.geom, b.geom)
  GROUP BY b.boroname;