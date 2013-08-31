if [ -z $1 ]; then
  DB_HOSTNAME="localhost"
else
  DB_HOSTNAME=$1  
fi

if [ -z $2 ]; then
  DB_USERNAME=$USER
else
  DB_USERNAME=$2
fi

if [ -z $3 ]; then
  DATABASE="postgres"
else
  DATABASE=$3
fi

if [ -z $4 ]; then
  DB_PORT="5432"
else
  DB_PORT=$4
fi

if [ -z $5 ]; then
  DB_SCHEMA="public"
else
  DB_SCHEMA=$5
fi

LOOPFLAG=0
while [ 0 -eq $LOOPFLAG ]; do
  echo "The hostname is $DB_HOSTNAME, the username is $DB_USERNAME, the database name is $DATABASE, the port is $DB_PORT, and the schema name is $DB_SCHEMA"
  echo "Is this correct and do you have the password in your ~/.pgpass file (y/n)? (your life will suck for the next 20 minutes if it's not the right host or you don't have the configuration information in .pgpass so check it now)"
  read response

  if [ $response = "y" ]; then
    LOOPFLAG=1
  else
    echo "Enter hostname"
    read DB_HOSTNAME
    echo "Enter username"
    read DB_USERNAME
    echo "Enter database name"
    read DATABASE
    echo "Enter port number"
    read DB_PORT
    echo "Enter schema name"
    read DB_SCHEMA
  fi

done
#end variable setting process

#create folder for demographic data 
mkdir -m 755 demographics_data/

#enter into folder
cd demographics_data/

echo "Downloading demographic profile table from US Census website"

#Download the 2010 demographic profile file from census website
wget "http://www2.census.gov/geo/tiger/TIGER2010DP1/Tract_2010Census_DP1.zip"

#unzip file
unzip -d ./ Tract_2010Census_DP1.zip

#upload to DATABASE
shp2pgsql -I -s 4269 "Tract_2010Census_DP1.shp" $DB_SCHEMA.dp1 | psql -h $DB_HOSTNAME -U $DB_USERNAME -p $DB_PORT -d $DATABASE -q

echo "Uploaded demographic profile to database"

echo "Reformatting and normalizing the demographic profile table (dp1)"

#add new_dp1 table (create_new_dp1.sql)
psql -h $DB_HOSTNAME -U $DB_USERNAME -p $DB_PORT -d $DATABASE -c "
--Alter existing table to recast geoid type
ALTER TABLE $DB_SCHEMA.dp1 
  ADD geoid_2 bigint;

UPDATE $DB_SCHEMA.dp1
  SET geoid_2 = geoid10::bigint;

ALTER TABLE $DB_SCHEMA.dp1 DROP COLUMN geoid10;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN geoid_2 TO geoid;

--Alter column names
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010001 TO total_pop;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010002 TO total_under_5;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010003 TO total_5_9;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010004 TO total_10_14;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010005 TO total_15_19;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010006 TO total_20_24;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010007 TO total_25_29;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010008 TO total_30_34;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010009 TO total_35_39;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010010 TO total_40_44;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010011 TO total_45_49;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010012 TO total_50_54;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010013 TO total_55_59;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010014 TO total_60_64;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010015 TO total_65_69;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010016 TO total_70_74;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010017 TO total_75_79;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010018 TO total_80_84;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010019 TO total_85_over;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010020 TO total_male;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010021 TO male_under_5;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010022 TO male_5_9;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010023 TO male_10_14;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010024 TO male_15_19;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010025 TO male_20_24;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010026 TO male_25_29;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010027 TO male_30_34;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010028 TO male_35_39;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010029 TO male_40_44;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010030 TO male_45_49;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010031 TO male_50_54;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010032 TO male_55_59;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010033 TO male_60_64;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010034 TO male_65_69;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010035 TO male_70_74;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010036 TO male_75_79;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010037 TO male_80_84;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010038 TO male_85_over;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010039 TO total_female;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010040 TO female_under_5;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010041 TO female_5_9;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010042 TO female_10_14;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010043 TO female_15_19;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010044 TO female_20_24;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010045 TO female_25_29;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010046 TO female_30_34;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010047 TO female_35_39;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010048 TO female_40_44;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010049 TO female_45_49;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010050 TO female_50_54;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010051 TO female_55_59;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010052 TO female_60_64;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010053 TO female_65_69;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010054 TO female_70_74;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010055 TO female_75_79;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010056 TO female_80_84;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0010057 TO female_85_over;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0020001 TO median_age;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0020002 TO median_age_male;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0020003 TO median_age_female;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0030001 TO total_pop_over_16;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0030002 TO total_male_over_16;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0030003 TO total_female_over_16;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0040001 TO total_pop_over_18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0040002 TO total_male_over_18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0040003 TO total_female_over_18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0050001 TO total_pop_over_21;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0050002 TO total_male_over_21;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0050003 TO total_female_over_21;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0060001 TO total_pop_over_62;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0060002 TO total_male_over_62;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0060003 TO total_female_over_62;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0070001 TO total_pop_over_65;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0070002 TO total_male_over_65;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0070003 TO total_female_over_65;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080001 TO total_pop2;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080002 TO pop_oneRace;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080003 TO pop_oneRace_white;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080004 TO pop_oneRace_aa;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080005 TO pop_oneRace_aian;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080006 TO pop_oneRace_asian;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080007 TO pop_oneRace_asian_asianIndian;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080008 TO pop_oneRace_asian_chinese;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080009 TO pop_oneRace_asian_filipino;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080010 TO pop_oneRace_asian_japanese;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080011 TO pop_oneRace_asian_korean;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080012 TO pop_oneRace_asian_vietnamese;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080013 TO pop_oneRace_asian_other;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080014 TO pop_oneRace_nhopi;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080015 TO pop_oneRace_nhopi_nh;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080016 TO pop_oneRace_nhopi_guam;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080017 TO pop_oneRace_nhopi_samoan;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080018 TO pop_oneRace_nhopi_opi;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080019 TO pop_oneRace_other;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080020 TO pop_twoRaceOrMore;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080021 TO pop_twoRaceOrMore_whiteAian;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080022 TO pop_twoRaceOrMore_whiteAsian;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080023 TO pop_twoRaceOrMore_whiteAA;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0080024 TO pop_twoRaceOrMore_whiteOther;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0090001 TO whiteAloneOrCombo;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0090002 TO aaAloneOrCombo;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0090003 TO aianAloneOrCombo;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0090004 TO asianAloneOrCombo;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0090005 TO nhopiAloneOrCombo;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0090006 TO otherAloneOrCombo;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0100001 TO total_pop3;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0100002 TO total_hispAnyRace;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0100003 TO hispAnyRace_mexican;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0100004 TO hispAnyRace_puertoRican;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0100005 TO hispAnyRace_cuban;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0100006 TO hispAnyRace_otherHisp;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0100007 TO total_nonHisp;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110001 TO total_pop4;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110002 TO total_hisp;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110003 TO hisp_whiteAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110004 TO hisp_aaAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110005 TO hisp_aianAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110006 TO hisp_asianAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110007 TO hisp_nhopiAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110008 TO hisp_otherAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110009 TO hisp_twoOrMore;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110010 TO total_nonHisp2;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110011 TO nonHisp_whiteAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110012 TO nonHisp_aaAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110013 TO nonHisp_aianAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110014 TO nonHisp_asianAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110015 TO nonHisp_nhopiAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110016 TO nonHisp_otherAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0110017 TO nonHisp_twoOrMore;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120001 TO total_pop5;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120002 TO pop_inHH;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120003 TO pop_hh_householder;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120004 TO pop_hh_spouse;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120005 TO pop_hh_child;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120006 TO pop_hh_child_ownChildUnder18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120007 TO pop_hh_otherRelative;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120008 TO pop_hh_otherRelative_under18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120009 TO pop_hh_otherRelative_65over;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120010 TO pop_hh_nonrelatives;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120011 TO pop_hh_nonrelatives_under18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120012 TO pop_hh_nonrelatives_65over;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120013 TO pop_hh_nonrelatives_unmarriedPartner;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120014 TO pop_in_group;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120015 TO pop_group_inst;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120016 TO pop_group_inst_male;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120017 TO pop_group_inst_female;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120018 TO pop_group_noninst;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120019 TO pop_group_noninst_male;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0120020 TO pop_group_noninst_female;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130001 TO total_households;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130002 TO hh_family;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130003 TO hh_family_ownChildrenUnder18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130004 TO hh_husbandWifeFam;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130005 TO hh_husbandWifeFam_ownChildrenUnder18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130006 TO hh_maleNoWifeFam;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130007 TO hh_maleNoWifeFam_ownChildrenUnder18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130008 TO hh_femaleNoHusbandFam;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130009 TO hh_femaleNoHusbandFam_ownChildrenUnder18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130010 TO hh_nonFamily;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130011 TO hh_nonFamily_livingAlone;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130012 TO hh_nonFamily_livingAlone_male;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130013 TO hh_nonFamily_livingAlone_male_65over;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130014 TO hh_nonFamily_livingAlone_female;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0130015 TO hh_nonFamily_livingAlone_female_65over;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0140001 TO hh_withUnder18;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0150001 TO hh_with65over;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0160001 TO avgHouseholdSize;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0170001 TO avgFamilySize;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0180001 TO total_HousingUnits;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0180002 TO housingUnits_occupied;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0180003 TO housingUnits_vacant;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0180004 TO housingUnits_vacant_forRent;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0180005 TO housingUnits_vacant_rentedNotOcc;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0180006 TO housingUnits_vacant_forSaleOnly;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0180007 TO housingUnits_vacant_soldNotOcc;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0180008 TO housingUnits_vacant_occasionalUse;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0180009 TO housingUnits_vacant_otherVacant;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0190001 TO homeownerVacancyRate;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0200001 TO rentalVacancyRate;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0210001 TO total_housingUnits_occupied;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0210002 TO housingUnits_occupied_ownerOccupied;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0210003 TO housingUnits_occupied_renterOccupied;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0220001 TO popInOwnerOccupiedHousingUnits;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0220002 TO popInRenterOccupiedHousingUnits;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0230001 TO avgHouseholdSizeOwnerOccupiedHousingUnits;
ALTER TABLE $DB_SCHEMA.dp1 RENAME COLUMN DP0230002 TO avgHouseholdSizeRenterOccupiedHousingUnits;

--Create new_dp1 table
DROP TABLE IF EXISTS $DB_SCHEMA.new_dp1;

CREATE TABLE $DB_SCHEMA.new_dp1 AS (
  SELECT geoid,
  aland10,
  awater10,
  intptlat10,
  intptlon10,
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
  total_80_84,
  total_85_over,
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
  male_80_84,
  male_85_over,
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
  female_80_84,
  female_85_over,
  median_age,
  median_age_male,
  median_age_female,
  total_pop_over_16,
  total_male_over_16,
  total_female_over_16,
  total_pop_over_18,
  total_male_over_18,
  total_female_over_18,
  total_pop_over_21,
  total_male_over_21,
  total_female_over_21,
  total_pop_over_62,
  total_male_over_62,
  total_female_over_62,
  total_pop_over_65,
  total_male_over_65,
  total_female_over_65,
  total_pop2,
  pop_oneRace,
  pop_oneRace_white,
  pop_oneRace_aa,
  pop_oneRace_aian,
  pop_oneRace_asian,
  pop_oneRace_asian_asianIndian,
  pop_oneRace_asian_chinese,
  pop_oneRace_asian_filipino,
  pop_oneRace_asian_japanese,
  pop_oneRace_asian_korean,
  pop_oneRace_asian_vietnamese,
  pop_oneRace_asian_other,
  pop_oneRace_nhopi,
  pop_oneRace_nhopi_nh,
  pop_oneRace_nhopi_guam,
  pop_oneRace_nhopi_samoan,
  pop_oneRace_nhopi_opi,
  pop_oneRace_other,
  pop_twoRaceOrMore,
  pop_twoRaceOrMore_whiteAian,
  pop_twoRaceOrMore_whiteAsian,
  pop_twoRaceOrMore_whiteAA,
  pop_twoRaceOrMore_whiteOther,
  whiteAloneOrCombo,
  aaAloneOrCombo,
  aianAloneOrCombo,
  asianAloneOrCombo,
  nhopiAloneOrCombo,
  otherAloneOrCombo,
  total_pop3,
  total_hispAnyRace,
  hispAnyRace_mexican,
  hispAnyRace_puertoRican,
  hispAnyRace_cuban,
  hispAnyRace_otherHisp,
  total_nonHisp,
  total_pop4,
  total_hisp,
  hisp_whiteAlone,
  hisp_aaAlone,
  hisp_aianAlone,
  hisp_asianAlone,
  hisp_nhopiAlone,
  hisp_otherAlone,
  hisp_twoOrMore,
  total_nonHisp2,
  nonHisp_whiteAlone,
  nonHisp_aaAlone,
  nonHisp_aianAlone,
  nonHisp_asianAlone,
  nonHisp_nhopiAlone,
  nonHisp_otherAlone,
  nonHisp_twoOrMore,
  total_pop5,
  pop_inHH,
  pop_hh_householder,
  pop_hh_spouse,
  pop_hh_child,
  pop_hh_child_ownChildUnder18,
  pop_hh_otherRelative,
  pop_hh_otherRelative_under18,
  pop_hh_otherRelative_65over,
  pop_hh_nonrelatives,
  pop_hh_nonrelatives_under18,
  pop_hh_nonrelatives_65over,
  pop_hh_nonrelatives_unmarriedPartner,
  pop_in_group,
  pop_group_inst,
  pop_group_inst_male,
  pop_group_inst_female,
  pop_group_noninst,
  pop_group_noninst_male,
  pop_group_noninst_female,
  total_households,
  hh_family,
  hh_family_ownChildrenUnder18,
  hh_husbandWifeFam,
  hh_husbandWifeFam_ownChildrenUnder18,
  hh_maleNoWifeFam,
  hh_maleNoWifeFam_ownChildrenUnder18,
  hh_femaleNoHusbandFam,
  hh_femaleNoHusbandFam_ownChildrenUnder18,
  hh_nonFamily,
  hh_nonFamily_livingAlone,
  hh_nonFamily_livingAlone_male,
  hh_nonFamily_livingAlone_male_65over,
  hh_nonFamily_livingAlone_female,
  hh_nonFamily_livingAlone_female_65over,
  hh_withUnder18,
  hh_with65over,
  avgHouseholdSize,
  avgFamilySize,
  total_HousingUnits,
  housingUnits_occupied,
  housingUnits_vacant,
  housingUnits_vacant_forRent,
  housingUnits_vacant_rentedNotOcc,
  housingUnits_vacant_forSaleOnly,
  housingUnits_vacant_soldNotOcc,
  housingUnits_vacant_occasionalUse,
  housingUnits_vacant_otherVacant,
  homeownerVacancyRate,
  rentalVacancyRate,
  total_housingUnits_occupied,
  housingUnits_occupied_ownerOccupied,
  housingUnits_occupied_renterOccupied,
  popInOwnerOccupiedHousingUnits,
  popInRenterOccupiedHousingUnits,
  avgHouseholdSizeOwnerOccupiedHousingUnits,
  avgHouseholdSizeRenterOccupiedHousingUnits,
   shape_leng,
   shape_area,
   geom
  FROM $DB_SCHEMA.dp1
  ORDER BY geoid
);


DROP TABLE $DB_SCHEMA.dp1;
ALTER TABLE $DB_SCHEMA.new_dp1 RENAME TO dp1;

--Change data type
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_under_5 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_5_9 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_10_14 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_15_19 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_20_24 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_25_29 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_30_34 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_35_39 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_40_44 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_45_49 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_50_54 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_55_59 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_60_64 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_65_69 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_70_74 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_75_79 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_80_84 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_85_over TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_under_5 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_5_9 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_10_14 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_15_19 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_20_24 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_25_29 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_30_34 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_35_39 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_40_44 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_45_49 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_50_54 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_55_59 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_60_64 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_65_69 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_70_74 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_75_79 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_80_84 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_85_over TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_under_5 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_5_9 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_10_14 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_15_19 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_20_24 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_25_29 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_30_34 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_35_39 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_40_44 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_45_49 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_50_54 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_55_59 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_60_64 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_65_69 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_70_74 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_75_79 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_80_84 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_85_over TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop_over_16 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male_over_16 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female_over_16 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop_over_18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male_over_18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female_over_18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop_over_21 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male_over_21 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female_over_21 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop_over_62 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male_over_62 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female_over_62 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop_over_65 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male_over_65 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female_over_65 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_white TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_aa TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_aian TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_asian TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_asian_asianindian TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_asian_chinese TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_asian_filipino TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_asian_japanese TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_asian_korean TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_asian_vietnamese TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_asian_other TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_nhopi TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_nhopi_nh TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_nhopi_guam TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_nhopi_samoan TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_nhopi_opi TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_onerace_other TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_tworaceormore TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_tworaceormore_whiteaian TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_tworaceormore_whiteasian TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_tworaceormore_whiteaa TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_tworaceormore_whiteother TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN whitealoneorcombo TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN aaaloneorcombo TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN aianaloneorcombo TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN asianaloneorcombo TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nhopialoneorcombo TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN otheraloneorcombo TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_hispanyrace TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hispanyrace_mexican TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hispanyrace_puertorican TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hispanyrace_cuban TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hispanyrace_otherhisp TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_nonhisp TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_hisp TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_whitealone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_aaalone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_aianalone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_asianalone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_nhopialone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_otheralone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_twoormore TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonhisp_whitealone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonhisp_aaalone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonhisp_aianalone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonhisp_asianalone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonhisp_nhopialone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonhisp_otheralone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonhisp_twoormore TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_inhh TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_householder TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_spouse TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_child TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_child_ownchildunder18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_otherrelative TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_otherrelative_under18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_otherrelative_65over TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_nonrelatives TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_nonrelatives_under18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_nonrelatives_65over TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_nonrelatives_unmarriedpartner TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_in_group TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_inst TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_inst_male TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_inst_female TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_noninst TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_noninst_male TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_noninst_female TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_households TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_family TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_family_ownchildrenunder18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_husbandwifefam TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_husbandwifefam_ownchildrenunder18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_malenowifefam TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_malenowifefam_ownchildrenunder18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_femalenohusbandfam TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_femalenohusbandfam_ownchildrenunder18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonfamily TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonfamily_livingalone TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonfamily_livingalone_male TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonfamily_livingalone_male_65over TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonfamily_livingalone_female TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonfamily_livingalone_female_65over TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_withunder18 TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_with65over TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_housingunits TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingunits_occupied TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingunits_vacant TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingunits_vacant_forrent TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingunits_vacant_rentednotocc TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingunits_vacant_forsaleonly TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingunits_vacant_soldnotocc TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingunits_vacant_occasionaluse TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingunits_vacant_othervacant TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_housingunits_occupied TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingunits_occupied_owneroccupied TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingunits_occupied_renteroccupied TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN popinowneroccupiedhousingunits TYPE numeric;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN popinrenteroccupiedhousingunits TYPE numeric;


--Add column constraints
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN aland10 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN awater10 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN intptlat10 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN intptlon10 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_under_5 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_5_9 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_10_14 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_15_19 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_20_24 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_25_29 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_30_34 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_35_39 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_40_44 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_45_49 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_50_54 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_55_59 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_60_64 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_65_69 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_70_74 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_75_79 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_80_84 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_85_over SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_under_5 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_5_9 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_10_14 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_15_19 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_20_24 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_25_29 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_30_34 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_35_39 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_40_44 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_45_49 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_50_54 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_55_59 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_60_64 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_65_69 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_70_74 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_75_79 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_80_84 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN male_85_over SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_under_5 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_5_9 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_10_14 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_15_19 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_20_24 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_25_29 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_30_34 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_35_39 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_40_44 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_45_49 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_50_54 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_55_59 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_60_64 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_65_69 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_70_74 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_75_79 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_80_84 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN female_85_over SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN median_age SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN median_age_male SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN median_age_female SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop_over_16 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male_over_16 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female_over_16 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop_over_18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male_over_18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female_over_18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop_over_21 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male_over_21 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female_over_21 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop_over_62 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male_over_62 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female_over_62 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop_over_65 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_male_over_65 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_female_over_65 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop2 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_white SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_aa SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_aian SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_asian SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_asian_asianIndian SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_asian_chinese SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_asian_filipino SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_asian_japanese SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_asian_korean SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_asian_vietnamese SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_asian_other SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_nhopi SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_nhopi_nh SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_nhopi_guam SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_nhopi_samoan SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_nhopi_opi SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_oneRace_other SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_twoRaceOrMore SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_twoRaceOrMore_whiteAian SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_twoRaceOrMore_whiteAsian SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_twoRaceOrMore_whiteAA SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_twoRaceOrMore_whiteOther SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN whiteAloneOrCombo SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN aaAloneOrCombo SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN aianAloneOrCombo SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN asianAloneOrCombo SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nhopiAloneOrCombo SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN otherAloneOrCombo SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop3 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_hispAnyRace SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hispAnyRace_mexican SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hispAnyRace_puertoRican SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hispAnyRace_cuban SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hispAnyRace_otherHisp SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_nonHisp SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop4 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_hisp SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_whiteAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_aaAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_aianAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_asianAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_nhopiAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_otherAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hisp_twoOrMore SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_nonHisp2 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonHisp_whiteAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonHisp_aaAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonHisp_aianAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonHisp_asianAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonHisp_nhopiAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonHisp_otherAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN nonHisp_twoOrMore SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_pop5 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_inHH SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_householder SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_spouse SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_child SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_child_ownChildUnder18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_otherRelative SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_otherRelative_under18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_otherRelative_65over SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_nonrelatives SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_nonrelatives_under18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_nonrelatives_65over SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_hh_nonrelatives_unmarriedPartner SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_in_group SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_inst SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_inst_male SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_inst_female SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_noninst SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_noninst_male SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN pop_group_noninst_female SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_households SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_family SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_family_ownChildrenUnder18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_husbandWifeFam SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_husbandWifeFam_ownChildrenUnder18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_maleNoWifeFam SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_maleNoWifeFam_ownChildrenUnder18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_femaleNoHusbandFam SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_femaleNoHusbandFam_ownChildrenUnder18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonFamily SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonFamily_livingAlone SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonFamily_livingAlone_male SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonFamily_livingAlone_male_65over SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonFamily_livingAlone_female SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_nonFamily_livingAlone_female_65over SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_withUnder18 SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN hh_with65over SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN avgHouseholdSize SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN avgFamilySize SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_HousingUnits SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingUnits_occupied SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingUnits_vacant SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingUnits_vacant_forRent SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingUnits_vacant_rentedNotOcc SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingUnits_vacant_forSaleOnly SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingUnits_vacant_soldNotOcc SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingUnits_vacant_occasionalUse SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingUnits_vacant_otherVacant SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN homeownerVacancyRate SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN rentalVacancyRate SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN total_housingUnits_occupied SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingUnits_occupied_ownerOccupied SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN housingUnits_occupied_renterOccupied SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN popInOwnerOccupiedHousingUnits SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN popInRenterOccupiedHousingUnits SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN avgHouseholdSizeOwnerOccupiedHousingUnits SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN avgHouseholdSizeRenterOccupiedHousingUnits SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN shape_area SET NOT NULL;
ALTER TABLE $DB_SCHEMA.dp1 ALTER COLUMN shape_leng SET NOT NULL;

--Add primary key constraints
ALTER TABLE $DB_SCHEMA.dp1 DROP CONSTRAINT IF EXISTS new_dp1_pkey;
ALTER TABLE $DB_SCHEMA.dp1 DROP CONSTRAINT IF EXISTS dp1_pkey;
ALTER TABLE $DB_SCHEMA.dp1 ADD PRIMARY KEY (geoid);

--Add table comments
COMMENT ON TABLE $DB_SCHEMA.dp1 IS 'Demographic data by US Census Tract from Demographic Profile Table 1 availabe at http://www2.census.gov/geo/tiger/TIGER2010DP1/Tract_2010Census_DP1.zip';
COMMENT ON COLUMN $DB_SCHEMA.dp1.geoid IS 'Census tract identifier; a concatenation of 2010 Census state FIPS code, county FIPS code, and census tract code; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.aland10 IS '2010 Census land area (square meters); Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.awater10 IS '2010 Census water area (square meters); Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.intptlat10 IS '2010 Census latitude of the internal point; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.intptlon10 IS '2010 Census longitude of the internal point; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_pop IS 'Total population in tract; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_under_5 IS 'Total population in tract under 5 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_5_9 IS 'Total population in tract between the ages of 5 and 9; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_10_14 IS 'Total population in tract between the ages of 10 and 14; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_15_19 IS 'Total population in tract between the ages of 15 and 19; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_20_24 IS 'Total population in tract between the ages of 20 and 24; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_25_29 IS 'Total population in tract between the ages of 25 and 29; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_30_34 IS 'Total population in tract between the ages of 30 and 34; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_35_39 IS 'Total population in tract between the ages of 35 and 39; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_40_44 IS 'Total population in tract between the ages of 40 and 44; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_45_49 IS 'Total population in tract between the ages of 45 and 49; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_50_54 IS 'Total population in tract between the ages of 50 and 54; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_55_59 IS 'Total population in tract between the ages of 55 and 59; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_60_64 IS 'Total population in tract between the ages of 60 and 64; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_65_69 IS 'Total population in tract between the ages of 65 and 69; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_70_74 IS 'Total population in tract between the ages of 70 and 74; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_75_79 IS 'Total population in tract between the ages of 75 and 79; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_80_84 IS 'Total population in tract between the ages of 80 and 84; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_85_over IS 'Total population in the tract 85 years of age or over; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_male IS 'Total population of males in tract; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_under_5 IS 'Total population of males in tract under 5 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_5_9 IS 'Total population of males in tract between the ages of 5 and 9; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_10_14 IS 'Total population of males in tract between the ages of 10 and 14; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_15_19 IS 'Total population of males in tract between the ages of 15 and 19; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_20_24 IS 'Total population of males in tract between the ages of 20 and 24; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_25_29 IS 'Total population of males in tract between the ages of 25 and 29; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_30_34 IS 'Total population of males in tract between the ages of 30 and 34; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_35_39 IS 'Total population of males in tract between the ages of 35 and 39; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_40_44 IS 'Total population of males in tract between the ages of 40 and 44; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_45_49 IS 'Total population of males in tract between the ages of 45 and 49; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_50_54 IS 'Total population of males in tract between the ages of 50 and 54; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_55_59 IS 'Total population of males in tract between the ages of 55 and 59; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_60_64 IS 'Total population of males in tract between the ages of 60 and 64; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_65_69 IS 'Total population of males in tract between the ages of 65 and 69; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_70_74 IS 'Total population of males in tract between the ages of 70 and 74; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_75_79 IS 'Total population of males in tract between the ages of 75 and 79; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_80_84 IS 'Total population of males in tract between the ages of 80 and 84; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.male_85_over IS 'Total population of males in tract 85 years of age and over; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_female IS 'Total population of females in tract; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_under_5 IS 'Total population of females in tract under 5 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_5_9 IS 'Total population of females in tract between the ages of 5 and 9; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_10_14 IS 'Total population of females in tract between the ages of 10 and 14; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_15_19 IS 'Total population of females in tract between the ages of 15 and 19; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_20_24 IS 'Total population of females in tract between the ages of 20 and 24; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_25_29 IS 'Total population of females in tract between the ages of 25 and 29; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_30_34 IS 'Total population of females in tract between the ages of 30 and 34; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_35_39 IS 'Total population of females in tract between the ages of 35 and 39; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_40_44 IS 'Total population of females in tract between the ages of 40 and 44; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_45_49 IS 'Total population of females in tract between the ages of 45 and 49; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_50_54 IS 'Total population of females in tract between the ages of 50 and 54; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_55_59 IS 'Total population of females in tract between the ages of 55 and 59; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_60_64 IS 'Total population of females in tract between the ages of 60 and 64; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_65_69 IS 'Total population of females in tract between the ages of 65 and 69; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_70_74 IS 'Total population of females in tract between the ages of 70 and 74; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_75_79 IS 'Total population of females in tract between the ages of 75 and 79; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_80_84 IS 'Total population of females in tract between the ages of 80 and 84; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.female_85_over IS 'Total population of females in tract 85 years of age and over; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.median_age IS 'Median age of population in tract; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.median_age_male IS 'Median age of male population in tract ; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.median_age_female IS 'Median age of female population in tract; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_pop_over_16 IS 'Total population in tract over 16 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_male_over_16 IS 'Total population of males in tract over 16 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_female_over_16 IS 'Total population of females in tract over 16 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_pop_over_18 IS 'Total population in tract over 18 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_male_over_18 IS 'Total population of males in tract over 18 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_female_over_18 IS 'Total population of females in tract over 18 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_pop_over_21 IS 'Total population in tract over 21 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_male_over_21 IS 'Total population of males in tract over 21 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_female_over_21 IS 'Total population of females in tract over 21 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_pop_over_62 IS 'Total population in tract over 62 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_male_over_62 IS 'Total population of males in tract over 62 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_female_over_62 IS 'Total population of females in tract over 62 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_pop_over_65 IS 'Total population in tract over 65 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_male_over_65 IS 'Total population of males in tract over 65 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_female_over_65 IS 'Total population of females in tract over 65 years of age; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_pop2 IS 'Total population in tract; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace IS 'Total population in tract reporting one race; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_white IS 'Total population in tract reporting one race as white; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_aa IS 'Total population in tract reporting one race as black/African-American; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_aian IS 'Total population in tract reporting one race as American Indian/Alaska Native (aian); Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_asian IS 'Total population in tract reporting one race as asian; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_asian_asianindian IS 'Total population in tract reporting one race as asian, asian-indian; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_asian_chinese IS 'Total population in tract reporting one race as asian, chinese; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_asian_filipino IS 'Total population in tract reporting one race as asian, filipino; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_asian_japanese IS 'Total population in tract reporting one race as asian, japanese; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_asian_korean IS 'Total population in tract reporting one race as asian, korean; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_asian_vietnamese IS 'Total population in tract reporting one race as asian, vietnamese; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_asian_other IS 'Total population in tract reporting one race as asian, other; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_nhopi IS 'Total population in tract reporting one race as Native Hawaiian or other Pacific Islander (nhopi); Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_nhopi_nh IS 'Total population in tract reporting one race as nhopi, native Hawaiian; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_nhopi_guam IS 'Total population in tract reporting one race as nhopi, guam; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_nhopi_samoan IS 'Total population in tract reporting one race as nhopi, samoan; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_nhopi_opi IS 'Total population in tract reporting one race as nhopi, other Pacific Islander; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_onerace_other IS 'Total population in tract reporting one race as other; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_tworaceormore IS 'Total population in tract reporting two races or more; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_tworaceormore_whiteaian IS 'Total population in tract reporting two races or more as white and American Indian/Alaska Native; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_tworaceormore_whiteasian IS 'Total population in tract reporting two races or more as white and asian; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_tworaceormore_whiteaa IS 'Total population in tract reporting two races or more as white and black or African-American; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_tworaceormore_whiteother IS 'Total population in tract reporting two races or more as white and some other race; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.whitealoneorcombo IS 'Total population in tract reporting white alone or in combination with one or more other races; Universe: Races tallied';
COMMENT ON COLUMN $DB_SCHEMA.dp1.aaaloneorcombo IS 'Total population in tract reporting black or African American alone or in combination with one or more other races; Universe: Races tallied';
COMMENT ON COLUMN $DB_SCHEMA.dp1.aianaloneorcombo IS 'Total population in tract reporting American Indian and Alaska Native alone or in combination with one or more other races; Universe: Races tallied';
COMMENT ON COLUMN $DB_SCHEMA.dp1.asianaloneorcombo IS 'Total population in tract reporting Asian alone or in combination with one or more other races; Universe: Races tallied';
COMMENT ON COLUMN $DB_SCHEMA.dp1.nhopialoneorcombo IS 'Total population in tract reporting Native Hawaiian and Other Pacific Islander alone or in combination with one or more other races; Universe: Races tallied';
COMMENT ON COLUMN $DB_SCHEMA.dp1.otheraloneorcombo IS 'Some Other Race alone or in combination with one or more other races; Universe: Races tallied';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_pop3 IS 'Total population in tract; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_hispanyrace IS 'Total population in tract reporting hispanic of any race; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hispanyrace_mexican IS 'Total population in tract reporting hispanic of any race as Mexican; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hispanyrace_puertorican IS 'Total population in tract reporting hispanic of any race as Puerto Rican; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hispanyrace_cuban IS 'Total population in tract reporting hispanic of any race Cuban; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hispanyrace_otherhisp IS 'Total population in tract reporting hispanic of any race other Hispanic; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_nonhisp IS 'Total population in tract reporting as non-Hispanic; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_pop4 IS 'Total population in tract; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_hisp IS 'Total population in tract reporting as Hispanic; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hisp_whitealone IS 'Total population in community reporting as Hispanic and white alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hisp_aaalone IS 'Total population in community reporting as Hispanic and black/African-American alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hisp_aianalone IS 'Total population in community reporting as Hispanic and American Indian/Alaskan Native alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hisp_asianalone IS 'Total population in community reporting as Hispanic and asian alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hisp_nhopialone IS 'Total population in community reporting as Hispanic and Native Hawaiian or other Pacific Islander alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hisp_otheralone IS 'Total population in community reporting as Hispanic and other race alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hisp_twoormore IS 'Total population in community reporting as Hispanic and two or more races; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_nonhisp2 IS 'Total population in tract reporting as non-Hispanic; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.nonhisp_whitealone IS 'Total population in community reporting as non-Hispanic and white alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.nonhisp_aaalone IS 'Total population in community reporting as non-Hispanic and black/African-American alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.nonhisp_aianalone IS 'Total population in community reporting as non-Hispanic and American Indian/Alaskan Native alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.nonhisp_asianalone IS 'Total population in community reporting as non-Hispanic and asian alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.nonhisp_nhopialone IS 'Total population in community reporting as non-Hispanic and Native Hawaiian or other Pacific Islander alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.nonhisp_otheralone IS 'Total population in community reporting as non-Hispanic and other race alone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.nonhisp_twoormore IS 'Total population in community reporting as non-Hispanic and two or more races; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_pop5 IS 'Total population in tract; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_inhh IS 'Total population in tract in households; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_householder IS 'Total population in community in households who are a aaalone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_spouse IS 'Total population in community in households who are a aianalone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_child IS 'Total population in community in households who are a asianalone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_child_ownchildunder18 IS 'Total population in tract in households who are an own child under 18 ; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_otherrelative IS 'Total population in community in households who are an otheralone; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_otherrelative_under18 IS 'Total population in tract in households who are an otherrelative under the age of 18; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_otherrelative_65over IS 'Total population in tract in households who are an otherrelative 65 years of age or older; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_nonrelatives IS 'Total population in tract in households who are nonrelatives; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_nonrelatives_under18 IS 'Total population in tract in households who are nonrelatives under 18; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_nonrelatives_65over IS 'Total population in tract in households who are nonrelatives 65 or over; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_hh_nonrelatives_unmarriedpartner IS 'Total population in tract in households who are nonrelatives and an unmarried partner; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_in_group IS 'Total population in tract in group quarters; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_group_inst IS 'Total population in tract in group quarters who are institutionalized; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_group_inst_male IS 'Total population in tract in group quarters who are institutionalized who are male; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_group_inst_female IS 'Total population in tract in group quarters who are institutionalized who are female; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_group_noninst IS 'Total population in tract in group quarters who are not institutionalized; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_group_noninst_male IS 'Total population in tract in group quarters who are not institutionalized who are male; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.pop_group_noninst_female IS 'Total population in tract in group quarters who are not institutionalized who are female; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_households IS 'Total households in tract; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_family IS 'Total households in tract with family; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_family_ownchildrenunder18 IS 'Total households in tract with family with own children under 18; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_husbandwifefam IS 'Total households in tract with husband-wife family; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_husbandwifefam_ownchildrenunder18 IS 'Total households in tract with husband-wife family and own children under 18 years; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_malenowifefam IS 'Total households in tract with male, no-female family; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_malenowifefam_ownchildrenunder18 IS 'Total households in tract with male, no-female family with own children under 18 years; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_femalenohusbandfam IS 'Total households in tract with female, no male family; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_femalenohusbandfam_ownchildrenunder18 IS 'Total households in tract with female, no male family with own children under 18 years; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_nonfamily IS 'Total households in tract, non-family households; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_nonfamily_livingalone IS 'Total households in tract, non-family households, living alone; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_nonfamily_livingalone_male IS 'Total households in tract, non-family households, living alone, male; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_nonfamily_livingalone_male_65over IS 'Total households in tract, non-family households, living alone, male, 65 or over; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_nonfamily_livingalone_female IS 'Total households in tract , non-family households, living alone, female; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_nonfamily_livingalone_female_65over IS 'Total households in tract , non-family households, living alone, female, 65 or over; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_withunder18 IS 'Total households with individuals under 18 years of age; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.hh_with65over IS 'Total households with individuals 65 years of age or over; Universe: total_households';
COMMENT ON COLUMN $DB_SCHEMA.dp1.avghouseholdsize IS 'Average household size in tract; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.avgfamilysize IS 'Average family size in tract; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_housingunits IS 'Total housing units in tract; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.housingunits_occupied IS 'Total housing units in tract occupied ; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.housingunits_vacant IS 'Total housing units in tract vacant; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.housingunits_vacant_forrent IS 'Total housing units in tract vacant, for rent; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.housingunits_vacant_rentednotocc IS 'Total housing units in tract vacant, rented not occupied; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.housingunits_vacant_forsaleonly IS 'Total housing units in tract vacant, for sale only; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.housingunits_vacant_soldnotocc IS 'Total housing units in tract vacant, sold not occupied; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.housingunits_vacant_occasionaluse IS 'Total housing units in tract vacant, occasional use; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.housingunits_vacant_othervacant IS 'Total housing units in tract vacant, all other vacants; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.homeownervacancyrate IS 'Homeowner vacancy rate; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.rentalvacancyrate IS 'rental vacancy rate; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.total_housingunits_occupied IS 'Total housing units in tract occupied; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.housingunits_occupied_owneroccupied IS 'Total housing units in tract owner occupied; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.housingunits_occupied_renteroccupied IS 'Total housing units in tract renter occupied; Universe: total_housingunits';
COMMENT ON COLUMN $DB_SCHEMA.dp1.popinowneroccupiedhousingunits IS 'Total population in owner occupied housing units; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.popinrenteroccupiedhousingunits IS 'Total population in renter occupied housing units; Universe: total_pop';
COMMENT ON COLUMN $DB_SCHEMA.dp1.avghouseholdsizeowneroccupiedhousingunits IS 'Average household size in owner occupied housing units; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.avghouseholdsizerenteroccupiedhousingunits IS 'Average household size in renter occupied housing units; Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.shape_leng IS 'Census tract shape length (Census Bureau calculation); Universe: NA';
COMMENT ON COLUMN $DB_SCHEMA.dp1.shape_area IS 'Census tract shape area (Census Bureau calculation); Universe: NA';
"

psql -h $DB_HOSTNAME -U $DB_USERNAME -p $DB_PORT -d $DATABASE -c "
--create median age function
DROP FUNCTION IF EXISTS $DB_SCHEMA.find_median_age(
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

CREATE OR REPLACE FUNCTION $DB_SCHEMA.find_median_age(
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
    ) RETURNS numeric AS \$\$ 
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
\$\$ LANGUAGE plpgsql;
"
echo "Done creating median age function"
