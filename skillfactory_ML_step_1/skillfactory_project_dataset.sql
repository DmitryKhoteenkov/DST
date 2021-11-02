CREATE TABLE "dataset" (
  "year" int,
  "category" varchar,
  "laureate_id" int,
  "laureate_type" varchar,
  "motivation" varchar,
  "prize_share" varchar,
  "full_name" varchar,
  "sex" varchar,
  /*birth data*/
  "birth_date" date,
  "birth_city" varchar, 
  "former_birth_city_name" varchar,
  "birth_city_population" int,
  "birth_city_latitude" float,
  "birth_city_longitude" float,
  "birth_country" varchar, 
  "former_birth_country_name" varchar,
  "birth_country_region" varchar,
  "birth_country_population" int,
  "birth_country_country_area" int,
  "birth_country_population_density" float,
  "birth_country_coast_area_ratio" float,
  "birth_country_net_migration" float,
  "birth_country_infant_mortality" float,
  "birth_country_gdp" int,
  "birth_country_literacy" float,
  "birth_country_phones" float,
  "birth_country_arable" float,
  "birth_country_crops" float,
  "birth_country_other" float,
  "birth_country_climate" float,
  "birth_country_birth_rate" float,
  "birth_country_death_rate" float,
  "birth_country_agriculture" float,
  "birth_country_industry" float,
  "birth_country_service" float, 
  /*death data*/
  "death_date" date,
  "death_city" varchar, 
  "death_city_population" int,
  "death_city_latitude" float,
  "death_city_longitude" float,
  "death_country" varchar,
  "death_country_region" varchar,
  "death_country_population" int,
  "death_country_country_area" int,
  "death_country_population_density" float,
  "death_country_coast_area_ratio" float,
  "death_country_net_migration" float,
  "death_country_infant_mortality" float,
  "death_country_gdp" int,
  "death_country_literacy" float,
  "death_country_phones" float,
  "death_country_arable" float,
  "death_country_crops" float,
  "death_country_other" float,
  "death_country_climate" float,
  "death_country_birth_rate" float,
  "death_country_death_rate" float,
  "death_country_agriculture" float,
  "death_country_industry" float,
  "death_country_service" float,  
  /*affiliation data*/  
  "organization_name" varchar,
  "organization_city" varchar, 
  "organization_city_population" int,
  "organization_city_latitude" float,
  "organization_city_longitude" float,
  "organization_country" varchar,
  "organization_country_region" varchar,
  "organization_country_population" int,
  "organization_country_area" int,
  "organization_country_population_density" float,
  "organization_country_coast_area_ratio" float,
  "organization_country_net_migration" float,
  "organization_country_infant_mortality" float,
  "organization_country_gdp" int,
  "organization_country_literacy" float,
  "organization_country_phones" float,
  "organization_country_arable" float,
  "organization_country_crops" float,
  "organization_country_other" float,
  "organization_country_climate" float,
  "organization_country_birth_rate" float,
  "organization_country_death_rate" float,
  "organization_country_agriculture" float,
  "organization_country_industry" float,
  "organization_country_service" float, 
  PRIMARY KEY ("year", "category", "laureate_id", "organization_name")  
);
