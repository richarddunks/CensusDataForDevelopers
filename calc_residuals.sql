SELECT 
  gid as store_num,
  percent_male_pop - 0.47 as manhattan_residual_percent_male_pop ,
  percent_female_pop - 0.53 as manhattan_residual_percent_female_pop ,
  median_age - 36.51 as manhattan_residual_median_age ,
  median_age_male - 36.09 as manhattan_residual_median_age_male ,
  median_age_female - 36.94 as manhattan_residual_median_age_female ,
  percent_white_nonhispanic - 0.48 as manhattan_residual_percent_white_nonhispanic ,
  percent_black_nonhispanic - 0.13 as manhattan_residual_percent_black_nonhispanic ,
  percent_american_indian_alaskan_native_nonhispanic - 0.00 as manhattan_residual_percent_american_indian_alaskan_native_nonhispanic ,
  percent_asian_nonhispanic - 0.11 as manhattan_residual_percent_asian_nonhispanic ,
  percent_native_hawaiian_other_pacific_islander_nonhispanic - 0.00 as manhattan_residual_percent_native_hawaiian_other_pacific_islander_nonhispanic ,
  percent_other_race_nonhispanic - 0.00 as manhattan_residual_percent_other_race_nonhispanic ,
  percent_hispanic - 0.25 as manhattan_residual_percent_hispanic ,
  percent_owner_occupied_housing - 0.22 as manhattan_residual_percent_owner_occupied_housing ,
  percent_renter_occupied_housing - 0.74 as manhattan_residual_percent_renter_occupied_housing
FROM demographics.demographic_data_by_711;  