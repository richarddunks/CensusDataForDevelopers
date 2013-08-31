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


