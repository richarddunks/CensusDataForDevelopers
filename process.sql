
--commands to generate tables
shp2pgsql -I -s 4326 "manhattan_711_dedup.shp" demographics.manhattan_711 | psql -h localhost -d demographics

shp2pgsql -I -s 4269 "Tract_2010Census_DP1.shp" demographics.dp1 | psql -h localhost -q



--create polys from buffers (unnecessary)
DROP TABLE IF EXISTS demographics.manhattan_711_poly;
CREATE TABLE demographics.manhattan_711_poly AS ( 
  SELECT gid, ST_Buffer(geom::geography,100) geom FROM demographics.manhattan_711
);

WITH intersection AS
(
  SELECT 
  m.gid, 
  dp1.geoid10, 
  ST_Area(ST_Intersection(,dp1.geom))/ST_Area(m.geom) weight
  FROM manhattan_711 m
  INNER JOIN dp1
  ON ST_Intersects(m.geom, dp1.geom)
)

SELECT gid, geoid10


--full query
WITH transform AS
(
  SELECT gid, ST_Transform(geom::geometry, 4269) geom
  FROM demographics.manhattan_711_poly
)

SELECT 
t.gid, 
dp1.geoid10,
ST_Area(ST_Intersection(t.geom,dp1.geom))/ST_Area(t.geom) weight

FROM transform t
INNER JOIN demographics.dp1 
ON ST_Intersects(t.geom, dp1.geom)
ORDER BY gid, geoid10


)


ALTER TABLE demographics.dp1 RENAME COLUMN DP0010001 TO total_pop;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010002 TO total_under_5;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010003 TO total_5_9;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010004 TO total_10_14;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010005 TO total_15_19;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010006 TO total_20_24;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010007 TO total_25_29;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010008 TO total_30_34;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010009 TO total_35_39;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010010 TO total_40_44;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010011 TO total_45_49;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010012 TO total_50_54;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010013 TO total_55_59;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010014 TO total_60_64;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010015 TO total_65_69;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010016 TO total_70_74;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010017 TO total_75_79;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010018 TO total_80_84;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010019 TO total_85_over;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010020 TO total_male;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010021 TO male_under_5;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010022 TO male_5_9;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010023 TO male_10_14;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010024 TO male_15_19;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010025 TO male_20_24;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010026 TO male_25_29;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010027 TO male_30_34;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010028 TO male_35_39;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010029 TO male_40_44;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010030 TO male_45_49;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010031 TO male_50_54;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010032 TO male_55_59;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010033 TO male_60_64;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010034 TO male_65_69;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010035 TO male_70_74;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010036 TO male_75_79;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010037 TO male_80_84;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010038 TO male_85_over;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010039 TO total_female;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010040 TO female_under_5;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010041 TO female_5_9;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010042 TO female_10_14;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010043 TO female_15_19;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010044 TO female_20_24;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010045 TO female_25_29;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010046 TO female_30_34;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010047 TO female_35_39;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010048 TO female_40_44;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010049 TO female_45_49;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010050 TO female_50_54;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010051 TO female_55_59;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010052 TO female_60_64;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010053 TO female_65_69;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010054 TO female_70_74;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010055 TO female_75_79;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010056 TO female_80_84;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0010057 TO female_85_over;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0020001 TO median_age;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0020002 TO median_age_male;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0020003 TO median_age_female;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0030001 TO total_pop_over_16;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0030002 TO total_male_over_16;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0030003 TO total_female_over_16;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0040001 TO total_pop_over_18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0040002 TO total_male_over_18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0040003 TO total_female_over_18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0050001 TO total_pop_over_21;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0050002 TO total_male_over_21;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0050003 TO total_female_over_21;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0060001 TO total_pop_over_62;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0060002 TO total_male_over_62;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0060003 TO total_female_over_62;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0070001 TO total_pop_over_65;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0070002 TO total_male_over_65;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0070003 TO total_female_over_65;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080001 TO total_pop2;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080002 TO pop_oneRace;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080003 TO pop_oneRace_white;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080004 TO pop_oneRace_aa;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080005 TO pop_oneRace_aian;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080006 TO pop_oneRace_asian;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080007 TO pop_oneRace_asian_asianIndian;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080008 TO pop_oneRace_asian_chinese;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080009 TO pop_oneRace_asian_filipino;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080010 TO pop_oneRace_asian_japanese;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080011 TO pop_oneRace_asian_korean;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080012 TO pop_oneRace_asian_vietnamese;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080013 TO pop_oneRace_asian_other;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080014 TO pop_oneRace_nhopi;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080015 TO pop_oneRace_nhopi_nh;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080016 TO pop_oneRace_nhopi_guam;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080017 TO pop_oneRace_nhopi_samoan;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080018 TO pop_oneRace_nhopi_opi;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080019 TO pop_oneRace_other;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080020 TO pop_twoRaceOrMore;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080021 TO pop_twoRaceOrMore_whiteAian;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080022 TO pop_twoRaceOrMore_whiteAsian;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080023 TO pop_twoRaceOrMore_whiteAA;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0080024 TO pop_twoRaceOrMore_whiteOther;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0090001 TO whiteAloneOrCombo;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0090002 TO aaAloneOrCombo;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0090003 TO aianAloneOrCombo;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0090004 TO asianAloneOrCombo;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0090005 TO nhopiAloneOrCombo;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0090006 TO otherAloneOrCombo;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0100001 TO total_pop3;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0100002 TO total_hispAnyRace;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0100003 TO hispAnyRace_mexican;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0100004 TO hispAnyRace_puertoRican;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0100005 TO hispAnyRace_cuban;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0100006 TO hispAnyRace_otherHisp;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0100007 TO total_nonHisp;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110001 TO total_pop4;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110002 TO total_hisp;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110003 TO hisp_whiteAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110004 TO hisp_aaAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110005 TO hisp_aianAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110006 TO hisp_asianAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110007 TO hisp_nhopiAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110008 TO hisp_otherAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110009 TO hisp_twoOrMore;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110010 TO total_nonHisp2;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110011 TO nonHisp_whiteAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110012 TO nonHisp_aaAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110013 TO nonHisp_aianAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110014 TO nonHisp_asianAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110015 TO nonHisp_nhopiAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110016 TO nonHisp_otherAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0110017 TO nonHisp_twoOrMore;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120001 TO total_pop5;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120002 TO pop_inHH;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120003 TO pop_hh_householder;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120004 TO pop_hh_spouse;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120005 TO pop_hh_child;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120006 TO pop_hh_child_ownChildUnder18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120007 TO pop_hh_otherRelative;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120008 TO pop_hh_otherRelative_under18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120009 TO pop_hh_otherRelative_65over;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120010 TO pop_hh_nonrelatives;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120011 TO pop_hh_nonrelatives_under18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120012 TO pop_hh_nonrelatives_65over;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120013 TO pop_hh_nonrelatives_unmarriedPartner;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120014 TO pop_in_group;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120015 TO pop_group_inst;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120016 TO pop_group_inst_male;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120017 TO pop_group_inst_female;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120018 TO pop_group_noninst;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120019 TO pop_group_noninst_male;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0120020 TO pop_group_noninst_female;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130001 TO total_households;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130002 TO hh_family;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130003 TO hh_family_ownChildrenUnder18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130004 TO hh_husbandWifeFam;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130005 TO hh_husbandWifeFam_ownChildrenUnder18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130006 TO hh_maleNoWifeFam;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130007 TO hh_maleNoWifeFam_ownChildrenUnder18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130008 TO hh_femaleNoHusbandFam;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130009 TO hh_femaleNoHusbandFam_ownChildrenUnder18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130010 TO hh_nonFamily;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130011 TO hh_nonFamily_livingAlone;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130012 TO hh_nonFamily_livingAlone_male;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130013 TO hh_nonFamily_livingAlone_male_65over;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130014 TO hh_nonFamily_livingAlone_female;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0130015 TO hh_nonFamily_livingAlone_female_65over;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0140001 TO hh_withUnder18;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0150001 TO hh_with65over;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0160001 TO avgHouseholdSize;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0170001 TO avgFamilySize;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0180001 TO total_HousingUnits;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0180002 TO housingUnits_occupied;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0180003 TO housingUnits_vacant;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0180004 TO housingUnits_vacant_forRent;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0180005 TO housingUnits_vacant_rentedNotOcc;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0180006 TO housingUnits_vacant_forSaleOnly;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0180007 TO housingUnits_vacant_soldNotOcc;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0180008 TO housingUnits_vacant_occasionalUse;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0180009 TO housingUnits_vacant_otherVacant;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0190001 TO homeownerVacancyRate;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0200001 TO rentalVacancyRate;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0210001 TO total_housingUnits_occupied;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0210002 TO housingUnits_occupied_ownerOccupied;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0210003 TO housingUnits_occupied_renterOccupied;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0220001 TO popInOwnerOccupiedHousingUnits;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0220002 TO popInRenterOccupiedHousingUnits;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0230001 TO avgHouseholdSizeOwnerOccupiedHousingUnits;
ALTER TABLE demographics.dp1 RENAME COLUMN DP0230002 TO avgHouseholdSizeRenterOccupiedHousingUnits;

--create median age function
DROP FUNCTION IF EXISTS demographics.find_median_age(
    total_pop numeric, 
    total_under_5 numeric, 
    total_5_9 numeric,
    total_10_14 numeric,
    total_15_19 numeric,
    total_20_24 numeric,
    total_25_29 numeric,
    total_30_34 numeric,
    total_35_39 numeric,
    total_40_44 numeric,
    total_45_49 numeric,
    total_50_54 numeric,
    total_55_59 numeric,
    total_60_64 numeric,
    total_65_69 numeric,
    total_70_74 numeric,
    total_75_79 numeric,
    total_80_84 numeric
    );

CREATE OR REPLACE FUNCTION demographics.find_median_age(
    total_pop numeric, 
    total_under_5 numeric, 
    total_5_9 numeric,
    total_10_14 numeric,
    total_15_19 numeric,
    total_20_24 numeric,
    total_25_29 numeric,
    total_30_34 numeric,
    total_35_39 numeric,
    total_40_44 numeric,
    total_45_49 numeric,
    total_50_54 numeric,
    total_55_59 numeric,
    total_60_64 numeric,
    total_65_69 numeric,
    total_70_74 numeric,
    total_75_79 numeric,
    total_80_84 numeric
    ) RETURNS numeric AS $$ 
    /*
    A function to find the median age given the total population and the population counts for each age band. The median person
    is found and then located in the appropiate age band in which they reside. Their position is determined relative to the last
    person in the age band (assuming an even distribution throughout the age band) and their age is found by subtracting that
    difference from the upper bound of the age band. 

    This function is intended to take in population counts as reported in the 2010 US Census to return a valid result. A median 
    age of 85.1 indicates the age was over 85 and couldnt be accurately calculated. 

    The function not only takes in values directly from the table, but can accept aggregated values to allow analysis up to and
    including Patch-wide values.  They are expected in the following order:
      total_pop numeric, 
      total_under_5 numeric, 
      total_5_9 numeric,
      total_10_14 numeric,
      total_15_19 numeric,
      total_20_24 numeric,
      total_25_29 numeric,
      total_30_34 numeric,
      total_35_39 numeric,
      total_40_44 numeric,
      total_45_49 numeric,
      total_50_54 numeric,
      total_55_59 numeric,
      total_60_64 numeric,
      total_65_69 numeric,
      total_70_74 numeric,
      total_75_79 numeric,
      total_80_84 numeric
    Otherwise the result will be garbage.
    */

  DECLARE
    median_age numeric;
    median_person numeric := total_pop / 2; --numeric math with division will return round result
    under_5  numeric := total_under_5;
    under_10 numeric := total_under_5 + total_5_9;
    under_15 numeric := total_under_5 + total_5_9 + total_10_14;
    under_20 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19;
    under_25 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24;
    under_30 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29;
    under_35 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34;
    under_40 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34 + total_35_39;
    under_45 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34 + total_35_39 + total_40_44;
    under_50 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34 + total_35_39 + total_40_44 + total_45_49;
    under_55 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34 + total_35_39 + total_40_44 + total_45_49 + total_50_54;
    under_60 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34 + total_35_39 + total_40_44 + total_45_49 + total_50_54 + total_55_59;
    under_65 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34 + total_35_39 + total_40_44 + total_45_49 + total_50_54 + total_55_59 + total_60_64;
    under_70 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34 + total_35_39 + total_40_44 + total_45_49 + total_50_54 + total_55_59 + total_60_64 + total_65_69;
    under_75 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34 + total_35_39 + total_40_44 + total_45_49 + total_50_54 + total_55_59 + total_60_64 + total_65_69 + total_70_74;
    under_80 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34 + total_35_39 + total_40_44 + total_45_49 + total_50_54 + total_55_59 + total_60_64 + total_65_69 + total_70_74 + total_75_79;
    under_85 numeric := total_under_5 + total_5_9 + total_10_14 + total_15_19 + total_20_24 + total_25_29 + total_30_34 + total_35_39 + total_40_44 + total_45_49 + total_50_54 + total_55_59 + total_60_64 + total_65_69 + total_70_74 + total_75_79 + total_80_84;

  BEGIN
    CASE 
      WHEN median_person <= under_5  THEN median_age := ROUND(5  - ((under_5  - median_person) / total_under_5 * 5),2);
      WHEN median_person <= under_10 THEN median_age := ROUND(10 - ((under_10 - median_person) / total_5_9   * 5),2);
      WHEN median_person <= under_15 THEN median_age := ROUND(15 - ((under_15 - median_person) / total_10_14 * 5),2);
      WHEN median_person <= under_20 THEN median_age := ROUND(20 - ((under_20 - median_person) / total_15_19 * 5),2);
      WHEN median_person <= under_25 THEN median_age := ROUND(25 - ((under_25 - median_person) / total_20_24 * 5),2);
      WHEN median_person <= under_30 THEN median_age := ROUND(30 - ((under_30 - median_person) / total_25_29 * 5),2);
      WHEN median_person <= under_35 THEN median_age := ROUND(35 - ((under_35 - median_person) / total_30_34 * 5),2);
      WHEN median_person <= under_40 THEN median_age := ROUND(40 - ((under_40 - median_person) / total_35_39 * 5),2);
      WHEN median_person <= under_45 THEN median_age := ROUND(45 - ((under_45 - median_person) / total_40_44 * 5),2);
      WHEN median_person <= under_50 THEN median_age := ROUND(50 - ((under_50 - median_person) / total_45_49 * 5),2);
      WHEN median_person <= under_55 THEN median_age := ROUND(55 - ((under_55 - median_person) / total_50_54 * 5),2);
      WHEN median_person <= under_60 THEN median_age := ROUND(60 - ((under_60 - median_person) / total_55_59 * 5),2);
      WHEN median_person <= under_65 THEN median_age := ROUND(65 - ((under_65 - median_person) / total_60_64 * 5),2);
      WHEN median_person <= under_70 THEN median_age := ROUND(70 - ((under_70 - median_person) / total_65_69 * 5),2);
      WHEN median_person <= under_75 THEN median_age := ROUND(75 - ((under_75 - median_person) / total_70_74 * 5),2);
      WHEN median_person <= under_80 THEN median_age := ROUND(80 - ((under_80 - median_person) / total_75_79 * 5),2);
      WHEN median_person <= under_85 THEN median_age := ROUND(85 - ((under_85 - median_person) / total_80_84 * 5),2);
      ELSE median_age := 85.1;
    END CASE;
    RETURN median_age;
  END;
$$ LANGUAGE plpgsql;


CREATE TABLE demographics.m_711_dem_data AS (
SELECT 
w.gid gid, 
ROUND(SUM(dp1.total_pop*w.weight)) total_pop,
ROUND(SUM(dp1.total_under_5 * w.weight)) total_under_5,
ROUND(SUM(dp1.total_5_9 * w.weight)) total_5_9,
ROUND(SUM(dp1.total_10_14 * w.weight)) total_10_14,
ROUND(SUM(dp1.total_15_19 * w.weight)) total_15_19,
ROUND(SUM(dp1.total_20_24 * w.weight)) total_20_24,
ROUND(SUM(dp1.total_25_29 * w.weight)) total_25_29,
ROUND(SUM(dp1.total_30_34 * w.weight)) total_30_34,
ROUND(SUM(dp1.total_35_39 * w.weight)) total_35_39,
ROUND(SUM(dp1.total_40_44 * w.weight)) total_40_44,
ROUND(SUM(dp1.total_45_49 * w.weight)) total_45_49,
ROUND(SUM(dp1.total_50_54 * w.weight)) total_50_54,
ROUND(SUM(dp1.total_55_59 * w.weight)) total_55_59,
ROUND(SUM(dp1.total_60_64 * w.weight)) total_60_64,
ROUND(SUM(dp1.total_65_69 * w.weight)) total_65_69,
ROUND(SUM(dp1.total_70_74 * w.weight)) total_70_74,
ROUND(SUM(dp1.total_75_79 * w.weight)) total_75_79,
ROUND(SUM(dp1.total_80_84 * w.weight)) total_80_84,
ROUND(SUM(dp1.total_85_over * w.weight)) total_85_over,
ROUND(SUM(dp1.total_male * w.weight)) total_male,
ROUND(SUM(dp1.male_under_5 * w.weight)) male_under_5,
ROUND(SUM(dp1.male_5_9 * w.weight)) male_5_9,
ROUND(SUM(dp1.male_10_14 * w.weight)) male_10_14,
ROUND(SUM(dp1.male_15_19 * w.weight)) male_15_19,
ROUND(SUM(dp1.male_20_24 * w.weight)) male_20_24,
ROUND(SUM(dp1.male_25_29 * w.weight)) male_25_29,
ROUND(SUM(dp1.male_30_34 * w.weight)) male_30_34,
ROUND(SUM(dp1.male_35_39 * w.weight)) male_35_39,
ROUND(SUM(dp1.male_40_44 * w.weight)) male_40_44,
ROUND(SUM(dp1.male_45_49 * w.weight)) male_45_49,
ROUND(SUM(dp1.male_50_54 * w.weight)) male_50_54,
ROUND(SUM(dp1.male_55_59 * w.weight)) male_55_59,
ROUND(SUM(dp1.male_60_64 * w.weight)) male_60_64,
ROUND(SUM(dp1.male_65_69 * w.weight)) male_65_69,
ROUND(SUM(dp1.male_70_74 * w.weight)) male_70_74,
ROUND(SUM(dp1.male_75_79 * w.weight)) male_75_79,
ROUND(SUM(dp1.male_80_84 * w.weight)) male_80_84,
ROUND(SUM(dp1.male_85_over * w.weight)) male_85_over,
ROUND(SUM(dp1.total_female * w.weight)) total_female,
ROUND(SUM(dp1.female_under_5 * w.weight)) female_under_5,
ROUND(SUM(dp1.female_5_9 * w.weight)) female_5_9,
ROUND(SUM(dp1.female_10_14 * w.weight)) female_10_14,
ROUND(SUM(dp1.female_15_19 * w.weight)) female_15_19,
ROUND(SUM(dp1.female_20_24 * w.weight)) female_20_24,
ROUND(SUM(dp1.female_25_29 * w.weight)) female_25_29,
ROUND(SUM(dp1.female_30_34 * w.weight)) female_30_34,
ROUND(SUM(dp1.female_35_39 * w.weight)) female_35_39,
ROUND(SUM(dp1.female_40_44 * w.weight)) female_40_44,
ROUND(SUM(dp1.female_45_49 * w.weight)) female_45_49,
ROUND(SUM(dp1.female_50_54 * w.weight)) female_50_54,
ROUND(SUM(dp1.female_55_59 * w.weight)) female_55_59,
ROUND(SUM(dp1.female_60_64 * w.weight)) female_60_64,
ROUND(SUM(dp1.female_65_69 * w.weight)) female_65_69,
ROUND(SUM(dp1.female_70_74 * w.weight)) female_70_74,
ROUND(SUM(dp1.female_75_79 * w.weight)) female_75_79,
ROUND(SUM(dp1.female_80_84 * w.weight)) female_80_84,
ROUND(SUM(dp1.female_85_over * w.weight)) female_85_over,
ROUND(SUM(dp1.median_age * w.weight)) median_age,
ROUND(SUM(dp1.median_age_male * w.weight)) median_age_male,
ROUND(SUM(dp1.median_age_female * w.weight)) median_age_female,
ROUND(SUM(dp1.total_pop_over_16 * w.weight)) total_pop_over_16,
ROUND(SUM(dp1.total_male_over_16 * w.weight)) total_male_over_16,
ROUND(SUM(dp1.total_female_over_16 * w.weight)) total_female_over_16,
ROUND(SUM(dp1.total_pop_over_18 * w.weight)) total_pop_over_18,
ROUND(SUM(dp1.total_male_over_18 * w.weight)) total_male_over_18,
ROUND(SUM(dp1.total_female_over_18 * w.weight)) total_female_over_18,
ROUND(SUM(dp1.total_pop_over_21 * w.weight)) total_pop_over_21,
ROUND(SUM(dp1.total_male_over_21 * w.weight)) total_male_over_21,
ROUND(SUM(dp1.total_female_over_21 * w.weight)) total_female_over_21,
ROUND(SUM(dp1.total_pop_over_62 * w.weight)) total_pop_over_62,
ROUND(SUM(dp1.total_male_over_62 * w.weight)) total_male_over_62,
ROUND(SUM(dp1.total_female_over_62 * w.weight)) total_female_over_62,
ROUND(SUM(dp1.total_pop_over_65 * w.weight)) total_pop_over_65,
ROUND(SUM(dp1.total_male_over_65 * w.weight)) total_male_over_65,
ROUND(SUM(dp1.total_female_over_65 * w.weight)) total_female_over_65,
ROUND(SUM(dp1.total_pop2 * w.weight)) total_pop2,
ROUND(SUM(dp1.pop_oneRace * w.weight)) pop_oneRace,
ROUND(SUM(dp1.pop_oneRace_white * w.weight)) pop_oneRace_white,
ROUND(SUM(dp1.pop_oneRace_aa * w.weight)) pop_oneRace_aa,
ROUND(SUM(dp1.pop_oneRace_aian * w.weight)) pop_oneRace_aian,
ROUND(SUM(dp1.pop_oneRace_asian * w.weight)) pop_oneRace_asian,
ROUND(SUM(dp1.pop_oneRace_asian_asianIndian * w.weight)) pop_oneRace_asian_asianIndian,
ROUND(SUM(dp1.pop_oneRace_asian_chinese * w.weight)) pop_oneRace_asian_chinese,
ROUND(SUM(dp1.pop_oneRace_asian_filipino * w.weight)) pop_oneRace_asian_filipino,
ROUND(SUM(dp1.pop_oneRace_asian_japanese * w.weight)) pop_oneRace_asian_japanese,
ROUND(SUM(dp1.pop_oneRace_asian_korean * w.weight)) pop_oneRace_asian_korean,
ROUND(SUM(dp1.pop_oneRace_asian_vietnamese * w.weight)) pop_oneRace_asian_vietnamese,
ROUND(SUM(dp1.pop_oneRace_asian_other * w.weight)) pop_oneRace_asian_other,
ROUND(SUM(dp1.pop_oneRace_nhopi * w.weight)) pop_oneRace_nhopi,
ROUND(SUM(dp1.pop_oneRace_nhopi_nh * w.weight)) pop_oneRace_nhopi_nh,
ROUND(SUM(dp1.pop_oneRace_nhopi_guam * w.weight)) pop_oneRace_nhopi_guam,
ROUND(SUM(dp1.pop_oneRace_nhopi_samoan * w.weight)) pop_oneRace_nhopi_samoan,
ROUND(SUM(dp1.pop_oneRace_nhopi_opi * w.weight)) pop_oneRace_nhopi_opi,
ROUND(SUM(dp1.pop_oneRace_other * w.weight)) pop_oneRace_other,
ROUND(SUM(dp1.pop_twoRaceOrMore * w.weight)) pop_twoRaceOrMore,
ROUND(SUM(dp1.pop_twoRaceOrMore_whiteAian * w.weight)) pop_twoRaceOrMore_whiteAian,
ROUND(SUM(dp1.pop_twoRaceOrMore_whiteAsian * w.weight)) pop_twoRaceOrMore_whiteAsian,
ROUND(SUM(dp1.pop_twoRaceOrMore_whiteAA * w.weight)) pop_twoRaceOrMore_whiteAA,
ROUND(SUM(dp1.pop_twoRaceOrMore_whiteOther * w.weight)) pop_twoRaceOrMore_whiteOther,
ROUND(SUM(dp1.whiteAloneOrCombo * w.weight)) whiteAloneOrCombo,
ROUND(SUM(dp1.aaAloneOrCombo * w.weight)) aaAloneOrCombo,
ROUND(SUM(dp1.aianAloneOrCombo * w.weight)) aianAloneOrCombo,
ROUND(SUM(dp1.asianAloneOrCombo * w.weight)) asianAloneOrCombo,
ROUND(SUM(dp1.nhopiAloneOrCombo * w.weight)) nhopiAloneOrCombo,
ROUND(SUM(dp1.otherAloneOrCombo * w.weight)) otherAloneOrCombo,
ROUND(SUM(dp1.total_pop3 * w.weight)) total_pop3,
ROUND(SUM(dp1.total_hispAnyRace * w.weight)) total_hispAnyRace,
ROUND(SUM(dp1.hispAnyRace_mexican * w.weight)) hispAnyRace_mexican,
ROUND(SUM(dp1.hispAnyRace_puertoRican * w.weight)) hispAnyRace_puertoRican,
ROUND(SUM(dp1.hispAnyRace_cuban * w.weight)) hispAnyRace_cuban,
ROUND(SUM(dp1.hispAnyRace_otherHisp * w.weight)) hispAnyRace_otherHisp,
ROUND(SUM(dp1.total_nonHisp * w.weight)) total_nonHisp,
ROUND(SUM(dp1.total_pop4 * w.weight)) total_pop4,
ROUND(SUM(dp1.total_hisp * w.weight)) total_hisp,
ROUND(SUM(dp1.hisp_whiteAlone * w.weight)) hisp_whiteAlone,
ROUND(SUM(dp1.hisp_aaAlone * w.weight)) hisp_aaAlone,
ROUND(SUM(dp1.hisp_aianAlone * w.weight)) hisp_aianAlone,
ROUND(SUM(dp1.hisp_asianAlone * w.weight)) hisp_asianAlone,
ROUND(SUM(dp1.hisp_nhopiAlone * w.weight)) hisp_nhopiAlone,
ROUND(SUM(dp1.hisp_otherAlone * w.weight)) hisp_otherAlone,
ROUND(SUM(dp1.hisp_twoOrMore * w.weight)) hisp_twoOrMore,
ROUND(SUM(dp1.total_nonHisp2 * w.weight)) total_nonHisp2,
ROUND(SUM(dp1.nonHisp_whiteAlone * w.weight)) nonHisp_whiteAlone,
ROUND(SUM(dp1.nonHisp_aaAlone * w.weight)) nonHisp_aaAlone,
ROUND(SUM(dp1.nonHisp_aianAlone * w.weight)) nonHisp_aianAlone,
ROUND(SUM(dp1.nonHisp_asianAlone * w.weight)) nonHisp_asianAlone,
ROUND(SUM(dp1.nonHisp_nhopiAlone * w.weight)) nonHisp_nhopiAlone,
ROUND(SUM(dp1.nonHisp_otherAlone * w.weight)) nonHisp_otherAlone,
ROUND(SUM(dp1.nonHisp_twoOrMore * w.weight)) nonHisp_twoOrMore,
ROUND(SUM(dp1.total_pop5 * w.weight)) total_pop5,
ROUND(SUM(dp1.pop_inHH * w.weight)) pop_inHH,
ROUND(SUM(dp1.pop_hh_householder * w.weight)) pop_hh_householder,
ROUND(SUM(dp1.pop_hh_spouse * w.weight)) pop_hh_spouse,
ROUND(SUM(dp1.pop_hh_child * w.weight)) pop_hh_child,
ROUND(SUM(dp1.pop_hh_child_ownChildUnder18 * w.weight)) pop_hh_child_ownChildUnder18,
ROUND(SUM(dp1.pop_hh_otherRelative * w.weight)) pop_hh_otherRelative,
ROUND(SUM(dp1.pop_hh_otherRelative_under18 * w.weight)) pop_hh_otherRelative_under18,
ROUND(SUM(dp1.pop_hh_otherRelative_65over * w.weight)) pop_hh_otherRelative_65over,
ROUND(SUM(dp1.pop_hh_nonrelatives * w.weight)) pop_hh_nonrelatives,
ROUND(SUM(dp1.pop_hh_nonrelatives_under18 * w.weight)) pop_hh_nonrelatives_under18,
ROUND(SUM(dp1.pop_hh_nonrelatives_65over * w.weight)) pop_hh_nonrelatives_65over,
ROUND(SUM(dp1.pop_hh_nonrelatives_unmarriedPartner * w.weight)) pop_hh_nonrelatives_unmarriedPartner,
ROUND(SUM(dp1.pop_in_group * w.weight)) pop_in_group,
ROUND(SUM(dp1.pop_group_inst * w.weight)) pop_group_inst,
ROUND(SUM(dp1.pop_group_inst_male * w.weight)) pop_group_inst_male,
ROUND(SUM(dp1.pop_group_inst_female * w.weight)) pop_group_inst_female,
ROUND(SUM(dp1.pop_group_noninst * w.weight)) pop_group_noninst,
ROUND(SUM(dp1.pop_group_noninst_male * w.weight)) pop_group_noninst_male,
ROUND(SUM(dp1.pop_group_noninst_female * w.weight)) pop_group_noninst_female,
ROUND(SUM(dp1.total_households * w.weight)) total_households,
ROUND(SUM(dp1.hh_family * w.weight)) hh_family,
ROUND(SUM(dp1.hh_family_ownChildrenUnder18 * w.weight)) hh_family_ownChildrenUnder18,
ROUND(SUM(dp1.hh_husbandWifeFam * w.weight)) hh_husbandWifeFam,
ROUND(SUM(dp1.hh_husbandWifeFam_ownChildrenUnder18 * w.weight)) hh_husbandWifeFam_ownChildrenUnder18,
ROUND(SUM(dp1.hh_maleNoWifeFam * w.weight)) hh_maleNoWifeFam,
ROUND(SUM(dp1.hh_maleNoWifeFam_ownChildrenUnder18 * w.weight)) hh_maleNoWifeFam_ownChildrenUnder18,
ROUND(SUM(dp1.hh_femaleNoHusbandFam * w.weight)) hh_femaleNoHusbandFam,
ROUND(SUM(dp1.hh_femaleNoHusbandFam_ownChildrenUnder18 * w.weight)) hh_femaleNoHusbandFam_ownChildrenUnder18,
ROUND(SUM(dp1.hh_nonFamily * w.weight)) hh_nonFamily,
ROUND(SUM(dp1.hh_nonFamily_livingAlone * w.weight)) hh_nonFamily_livingAlone,
ROUND(SUM(dp1.hh_nonFamily_livingAlone_male * w.weight)) hh_nonFamily_livingAlone_male,
ROUND(SUM(dp1.hh_nonFamily_livingAlone_male_65over * w.weight)) hh_nonFamily_livingAlone_male_65over,
ROUND(SUM(dp1.hh_nonFamily_livingAlone_female * w.weight)) hh_nonFamily_livingAlone_female,
ROUND(SUM(dp1.hh_nonFamily_livingAlone_female_65over * w.weight)) hh_nonFamily_livingAlone_female_65over,
ROUND(SUM(dp1.hh_withUnder18 * w.weight)) hh_withUnder18,
ROUND(SUM(dp1.hh_with65over * w.weight)) hh_with65over,
ROUND(SUM(dp1.total_HousingUnits * w.weight)) total_HousingUnits,
ROUND(SUM(dp1.housingUnits_occupied * w.weight)) housingUnits_occupied,
ROUND(SUM(dp1.housingUnits_vacant * w.weight)) housingUnits_vacant,
ROUND(SUM(dp1.housingUnits_vacant_forRent * w.weight)) housingUnits_vacant_forRent,
ROUND(SUM(dp1.housingUnits_vacant_rentedNotOcc * w.weight)) housingUnits_vacant_rentedNotOcc,
ROUND(SUM(dp1.housingUnits_vacant_forSaleOnly * w.weight)) housingUnits_vacant_forSaleOnly,
ROUND(SUM(dp1.housingUnits_vacant_soldNotOcc * w.weight)) housingUnits_vacant_soldNotOcc,
ROUND(SUM(dp1.housingUnits_vacant_occasionalUse * w.weight)) housingUnits_vacant_occasionalUse,
ROUND(SUM(dp1.housingUnits_vacant_otherVacant * w.weight)) housingUnits_vacant_otherVacant,
ROUND(SUM(dp1.total_housingUnits_occupied * w.weight)) total_housingUnits_occupied,
ROUND(SUM(dp1.housingUnits_occupied_ownerOccupied * w.weight)) housingUnits_occupied_ownerOccupied,
ROUND(SUM(dp1.housingUnits_occupied_renterOccupied * w.weight)) housingUnits_occupied_renterOccupied,
ROUND(SUM(dp1.popInOwnerOccupiedHousingUnits * w.weight)) popInOwnerOccupiedHousingUnits,
ROUND(SUM(dp1.popInRenterOccupiedHousingUnits * w.weight)) popInRenterOccupiedHousingUnits
FROM demographics.weight w

INNER JOIN demographics.dp1
ON dp1.geoid10 = w.geoid10
GROUP BY w.gid
ORDER BY w.gid
);