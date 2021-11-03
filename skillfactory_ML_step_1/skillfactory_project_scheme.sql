CREATE TABLE "countries" (
  "country_code" varchar PRIMARY KEY,
  "country_name" varchar,
  "currency_code" varchar,
  "iso3" varchar,
  "continent_code" varchar,
  "phone" varchar
);

CREATE TABLE "world_countries" (
  "country_name" varchar PRIMARY KEY,
  "region" varchar,
  "population" int,
  "area" int,
  "population_density" float,
  "coast_area_ratio" float,
  "net_migration" float,
  "infant_mortality" float,
  "gdp" int,
  "literacy" float,
  "phones" float,
  "arable" float,
  "crops" float,
  "other" float,
  "climate" float,
  "birth_rate" float,
  "death_rate" float,
  "agriculture" float,
  "industry" float,
  "service" float
);

ALTER TABLE "world_countries" ADD FOREIGN KEY ("country_name") REFERENCES "countries" ("country_name");

CREATE TABLE "world_cities" (
  "city" varchar PRIMARY KEY,
  "country_code" varchar,
  "accent_city" varchar,
  "region" int,
  "population" int,
  "latitude" float,
  "longitude" float
);

ALTER TABLE "world_cities" ADD FOREIGN KEY ("country_code") REFERENCES "countries" ("country_code");

CREATE TABLE "prize_assignments" ( 
  /*data from "nobel-laureates" dataset*/
  "laureate_id" int,
  "prize_name" varchar,
  "motivation" varchar,
  "prize_share" varchar,
  PRIMARY KEY ("laureate_id", "prize_name")
);

CREATE TABLE "nobel_prizes" (
  /*data from "nobel-laureates" dataset*/
  "prize_name" varchar PRIMARY KEY,
  "year" int,
  "category" varchar
);

ALTER TABLE "nobel_prizes" ADD FOREIGN KEY ("prize_name") REFERENCES "prize_assignments" ("prize_name");

CREATE TABLE "nobel_laureates" (
  /*data from "nobel-laureates" dataset*/
  "laureate_id" int PRIMARY KEY,
  "laureate_type" varchar, /* the value 'organiztaion' for nobel peace prizes in 1973,1979,1989,1991 is wrong
   and should be changed to 'individual'*/
  "full_name" varchar,
  "sex" varchar,
  "birth_date" date,
  "birth_city" varchar, /*transform the column from "nobel-laureates" dataset extracting only the nowadays names*/
  "birth_country" varchar, /*transform the column from "nobel-laureates" dataset extracting only the nowadays names*/
  "death_date" date,
  "death_city" varchar, /*transform the column from "nobel-laureates" dataset extracting only the nowadays names*/
  "death_country" varchar /*transform the column from "nobel-laureates" dataset extracting only the nowadays names*/
);

ALTER TABLE "nobel_laureates" ADD FOREIGN KEY ("laureate_id") REFERENCES "prize_assignments" ("laureate_id");

ALTER TABLE "nobel_laureates" ADD FOREIGN KEY ("birth_city") REFERENCES "world_cities" ("accent_city");

ALTER TABLE "nobel_laureates" ADD FOREIGN KEY ("birth_country") REFERENCES "countries" ("country_name");

ALTER TABLE "nobel_laureates" ADD FOREIGN KEY ("death_city") REFERENCES "world_cities" ("accent_city");

ALTER TABLE "nobel_laureates" ADD FOREIGN KEY ("death_country") REFERENCES "countries" ("country_name");

CREATE TABLE "laureate_affiliations" (
  /*data from "nobel-laureates" dataset
  this is a reference table to get affiliation organisations*/
  "laureate_id" int,
  "prize_name" varchar,
  "organization_name" varchar,
  "organization_city" varchar, 
  "organization_country" varchar,
  PRIMARY KEY ("laureate_id", "prize_name", "organization_name")
);

ALTER TABLE "laureate_affiliations" ADD FOREIGN KEY ("laureate_id") REFERENCES "prize_assignments" ("laureate_id");

ALTER TABLE "laureate_affiliations" ADD FOREIGN KEY ("prize_name") REFERENCES "prize_assignments" ("prize_name");

ALTER TABLE "laureate_affiliations" ADD FOREIGN KEY ("organization_city") REFERENCES "world_cities" ("accent_city");

ALTER TABLE "laureate_affiliations" ADD FOREIGN KEY ("organization_country") REFERENCES "countries" ("country_name");


CREATE TABLE "former_city_names" (
  /*this is a reference table to get former city names*/
  "year" int,
  "now_city_name" varchar,
  "country_code" varchar,
  "former_city_name" varchar,
  PRIMARY KEY ("year", "now_city_name", "country_code")
);

ALTER TABLE "former_city_names" ADD FOREIGN KEY ("year") REFERENCES "nobel_prizes" ("year");

ALTER TABLE "former_city_names" ADD FOREIGN KEY ("now_city_name") REFERENCES "world_cities" ("accent_city");

ALTER TABLE "former_city_names" ADD FOREIGN KEY ("country_code") REFERENCES "world_cities" ("country_code");

CREATE TABLE "former_country_names" (
  /*this is a reference table to get former country names*/
  "year" int,
  "now_country_name" varchar,
  "former_country_name" varchar,
  PRIMARY KEY ("year", "now_country_name")
);

ALTER TABLE "former_country_names" ADD FOREIGN KEY ("year") REFERENCES "nobel_prizes" ("year");

ALTER TABLE "former_country_names" ADD FOREIGN KEY ("now_country_name") REFERENCES "countries" ("country_name");

