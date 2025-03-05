/* Dim + Fact Countries and Fact GDP */

ALTER TABLE B4A_PHY_COUNTRY_GAPMNDR Add SOURCE_URL VARCHAR2(200 BYTE);
ALTER TABLE B4A_PHY_COUNTRY_GAPMNDR Add SOURCE_DESC_AND_COPYRIGHT VARCHAR2(200 BYTE);
update B4A_PHY_COUNTRY_GAPMNDR set SOURCE_URL = 'gapm.io/datageo';
update B4A_PHY_COUNTRY_GAPMNDR set SOURCE_DESC_AND_COPYRIGHT = 'All Gapminder material linking here are freely available under the Creative Commons Attribution 4.0 International license.';
commit;  

select * from BI4ALL.B4A_PHY_COUNTRY_GAPMNDR; /* 197 Names */
select * from BI4ALL.B4A_GDP_DATA_AND_METADATA;
delete  from BI4ALL.B4A_GDP_DATA_AND_METADATA; /* Oplossing: enkel 1e 3 kolommen geladen in importra data in sql developert, data period was het probleem geen nummer 2005-2020*/
select * from BI4ALL.B4A_GDP_DATA_AND_METADATA where AREA='Netherlands'order by YEAR desc;
select * from BI4ALL.B4A_GDP_DATA_AND_METADATA where AREA='Afghanistan'order by YEAR desc;

select distinct AREA from BI4ALL.B4A_GDP_DATA_AND_METADATA; /* 260 Area's */

select distinct AREA from BI4ALL.B4A_GDP_DATA_AND_METADATA
MINUS
select NAME from BI4ALL.B4A_PHY_COUNTRY_GAPMNDR; /* 75 o.a. Yemen 3x */

select * from BI4ALL.B4A_GDP_DATA_AND_METADATA
where AREA LIKE '%emen%';

select MAX(YEAR), MIN(YEAR) from BI4ALL.B4A_GDP_DATA_AND_METADATA; /* 1270 .. 2018 */
select * from BI4ALL.B4A_GDP_DATA_AND_METADATA ORDER BY YEAR ASC; /* 1270 .. 2018 */

ALTER TABLE B4A_GDP_DATA_AND_METADATA add FACT_ROWNUM number(38,0); 
update B4A_GDP_DATA_AND_METADATA set FACT_ROWNUM = rownum;

select NAME from BI4ALL.B4A_PHY_COUNTRY_GAPMNDR
MINUS
select distinct AREA from BI4ALL.B4A_GDP_DATA_AND_METADATA; /* 12 o.a. Czech Republic, Lao, Yemen */

select * 
from BI4ALL.B4A_PHY_COUNTRY_GAPMNDR C, BI4ALL.B4A_GDP_DATA_AND_METADATA G
where G.AREA = C.NAME;

select distinct AREA
from BI4ALL.B4A_PHY_COUNTRY_GAPMNDR C, BI4ALL.B4A_GDP_DATA_AND_METADATA G
where G.AREA = C.NAME; /* 185 area's in land en GDP */

/* Countries and Fact Population */

ALTER TABLE B4A_POPULATION_COUNTRY_YEAR add FACT_ROWNUM number(38,0); 
update B4A_POPULATION_COUNTRY_YEAR set FACT_ROWNUM = rownum;

ALTER TABLE B4A_POPULATION_COUNTRY_YEAR Add SOURCE_URL VARCHAR2(200 BYTE);
ALTER TABLE B4A_POPULATION_COUNTRY_YEAR Add SOURCE_DESC_AND_COPYRIGHT VARCHAR2(200 BYTE);
update B4A_POPULATION_COUNTRY_YEAR set SOURCE_URL = 'gapm.io/doc_pop';
update B4A_POPULATION_COUNTRY_YEAR set SOURCE_DESC_AND_COPYRIGHT = 'All Gapminder material linking here are freely available under the Creative Commons Attribution 4.0 International license.';
commit;  

ALTER TABLE B4A_POPULATION_COUNTRY_YEAR modify NAME VARCHAR2(200 BYTE);
select count(*) from B4A_POPULATION_COUNTRY_YEAR; /* 59297 */
select * from B4A_POPULATION_COUNTRY_YEAR;

select distinct P.GEO
from BI4ALL.B4A_PHY_COUNTRY_GAPMNDR C, BI4ALL.B4A_POPULATION_COUNTRY_YEAR P
where C.GEO = P.GEO; /* 197 geo's in land en population */

/* Countries and Fact Happiness */
select * from B4A_HAPPINESS_COUNTRY_YEAR;

/* TODO for all fact tables add FACT_ROWNUM, update after new import ! */
ALTER TABLE B4A_HAPPINESS_COUNTRY_YEAR add FACT_ROWNUM number(38,0); 
update B4A_HAPPINESS_COUNTRY_YEAR set FACT_ROWNUM = rownum;
commit;  

ALTER TABLE B4A_HAPPINESS_COUNTRY_YEAR Add SOURCE_URL VARCHAR2(200 BYTE);
ALTER TABLE B4A_HAPPINESS_COUNTRY_YEAR Add SOURCE_DESC_AND_COPYRIGHT VARCHAR2(200 BYTE);
update B4A_HAPPINESS_COUNTRY_YEAR set SOURCE_URL = 'https://worldhappiness.report/ed/2020/';
update B4A_HAPPINESS_COUNTRY_YEAR set SOURCE_DESC_AND_COPYRIGHT = 'World Happiness Report 2020, Data for Table 2.1';
commit;  

select distinct COUNTRY_NAME
from BI4ALL.B4A_PHY_COUNTRY_GAPMNDR C, BI4ALL.B4A_HAPPINESS_COUNTRY_YEAR H
where H.COUNTRY_NAME = C.NAME
ORDER BY COUNTRY_NAME; /* 153 area's in land en Happiness */

/* Countries and Dim + Fact SDG 1.1 SI.POV.DDAY Poverty headcount ratio at $1.90 a day (2011 PPP) (% of population) */
/* TODO Inlezen */

ALTER TABLE B4A_SDG_1_1_POV_HC_EXTREME modify COUNTRY_NAME VARCHAR2(200 BYTE);
/* delete from B4A_SDG_1_1_POV_HC_EXTREME; /* opgelost via restore state */
/* DROP TABLE B4A_SDG_1_1_POV_HC_EXTREME; /* opgelost via restore state, TODO: ook gebruiken voor andere SDG's veel zelfde kolommen ! */
select * from B4A_SDG_1_1_POV_HC_EXTREME;

ALTER TABLE B4A_SDG_1_1_POV_HC_EXTREME add FACT_ROWNUM number(38,0); 
update B4A_SDG_1_1_POV_HC_EXTREME set FACT_ROWNUM = rownum;
commit;  

/* Countries and Dim + Fact SDG 4.1 SE.SEC.UNER.LO.ZS Adolescents out of school (% of lower secondary school age) */
/* TODO Inlezen using restored input defintion POV and alter /save state */

select * from B4A_SDG_4_1_SEDU_SEC_ADOL_DROP_OUT; /* all same format redundantie geen probleem: zie Table size hieronder */

ALTER TABLE B4A_SDG_4_1_SEDU_SEC_ADOL_DROP_OUT add FACT_ROWNUM number(38,0); 
update B4A_SDG_4_1_SEDU_SEC_ADOL_DROP_OUT set FACT_ROWNUM = rownum;
commit; 

SELECT owner, segment_name, segment_type, tablespace_name, bytes/1048576 MB 
FROM DBA_SEGMENTS WHERE OWNER = 'BI4ALL' AND SEGMENT_NAME = 'B4A_SDG_4_1_SEDU_SEC_ADOL_DROP_OUT' AND SEGMENT_TYPE = 'TABLE'; /* 0,18 MB run as ADMIN */

SELECT segment_name, SUM( bytes/1048576) MB 
FROM DBA_SEGMENTS WHERE OWNER = 'BI4ALL' AND SEGMENT_TYPE = 'TABLE'
group by segment_name; /* run as ADMIN */

SELECT SUM( bytes/1048576) MB 
FROM DBA_SEGMENTS WHERE OWNER = 'BI4ALL' AND SEGMENT_TYPE = 'TABLE'; /* 8,8 MB run as ADMIN */

/* Countries and Dim + Fact SDG 15.1 AG.LND.FRST.ZS Forest area (% of land area) */
/* TODO Inlezen using restored input defintion POV and alter /save state */

select * from B4A_SDG_15_1_LAND_FORREST_PERC; /* all same format redundantie geen probleem: zie Table size hieronder */

ALTER TABLE B4A_SDG_15_1_LAND_FORREST_PERC add FACT_ROWNUM number(38,0); 
update B4A_SDG_15_1_LAND_FORREST_PERC set FACT_ROWNUM = rownum;
commit; 

/* TODO 
1) Gevoelens en beheoften lijsten in tabel inlezen
2) Later via sql loader scripts ? https://blogs.oracle.com/searchtech/loading-documents-and-other-file-data-into-the-oracle-database 
*/

CREATE TABLE B4A_MEDITATIONS 
  (id       NUMBER,
   name     VARCHAR2(200),
   author   VARCHAR2(200),
   text      CLOB
);

ALTER TABLE B4A_MEDITATIONS Add SOURCE_URL VARCHAR2(200 BYTE);
ALTER TABLE B4A_MEDITATIONS Add SOURCE_DESC_AND_COPYRIGHT VARCHAR2(200 BYTE);
ALTER TABLE B4A_MEDITATIONS Add Text_2000 VARCHAR2(2000 BYTE);

delete from B4A_MEDITATIONS;
INSERT INTO B4A_MEDITATIONS(id,name,author,text_2000,source_url,SOURCE_DESC_AND_COPYRIGHT ) VALUES 
( 1, 'Quote Krishnamurti Poverty reduction', 'Krishnamurti','We need clothes, food and shelter. We need to organise that on a world-scale not just on a communal scale, which means we need people who are not thinking in terms of nationalism, but thinking in terms of mankind, thinking in terms of human happiness.','https://twitter.com/K__Quotes/status/1340212895142072320?s=20','Copyright Krisnamurti Foundation');
INSERT INTO B4A_MEDITATIONS(id,name,author,text_2000,source_url,SOURCE_DESC_AND_COPYRIGHT ) VALUES 
( 2, 'Question Energy What fuels your energy', 'Martijn Ceelen','What gives you energy in life ?','https://www.wd-pl.com/powerful-questions/','Copyright Co-Intelligence Institute');
INSERT INTO B4A_MEDITATIONS(id,name,author,text_2000,source_url,SOURCE_DESC_AND_COPYRIGHT ) VALUES 
( 3, 'Question Happiness Score', 'Cantril life ladder and Gallup World Poll (GWP)','Please imagine a ladder, with steps numbered from 0 at the bottom to 10 at the top. The top of the ladder represents the best possible life for you and the bottom of the ladder represents the worst possible life for you. On which step of the ladder would you say you personally feel you stand at this time?','https://happiness-report.s3.amazonaws.com/2020/WHR20_Ch2_Statistical_Appendix.pdf','Source and Copyright: World Happiness Report 2020, Statistical Appendix');
INSERT INTO B4A_MEDITATIONS(id,name,author,text_2000,source_url,SOURCE_DESC_AND_COPYRIGHT ) VALUES 
( 4, 'Question Energy to Contribute Globally', 'Martijn Ceelen','Do you have energy to try to contribute to the happiness of 7 Billion people on this globe, including yourself ?','https://www.wd-pl.com/powerful-questions/','Copyright Co-Intelligence Institute');
INSERT INTO B4A_MEDITATIONS(id,name,author,text_2000,source_url,SOURCE_DESC_AND_COPYRIGHT ) VALUES 
( 5, 'Question Energy to Contribute Locally', 'Martijn Ceelen','Do you have energy to try to contribute to the happiness of the people in you environment, including yourself ?','https://www.wd-pl.com/powerful-questions/','Copyright Co-Intelligence Institute');
INSERT INTO B4A_MEDITATIONS(id,name,author,text_2000,source_url,SOURCE_DESC_AND_COPYRIGHT ) VALUES 
( 6, 'Question Energy to Contribute Individually', 'Martijn Ceelen','Do you need energy to recharge and contribute to your own happiness and survival first ?','https://www.wd-pl.com/powerful-questions/','Copyright Co-Intelligence Institute');
INSERT INTO B4A_MEDITATIONS(id,name,author,text_2000,source_url,SOURCE_DESC_AND_COPYRIGHT ) VALUES 
( 7, 'Quote Bregman Human Kindness', 'Rutger Bregman','De meeste mensen deugen, im grunde gut, most people are good hearted, a hopefull history of Humankind','https://www.littlebrown.com/titles/rutger-bregman/humankind/9780316418553/','Copyright Rutger Bregman');
INSERT INTO B4A_MEDITATIONS(id,name,author,text_2000,source_url,SOURCE_DESC_AND_COPYRIGHT ) VALUES 
( 8, 'Quote Hans Rosling Income vs Life Expectancy', 'Hans Rosling','How does Income Relate to Life Expectancy ? Short Answer: Rich people live longer !','https://www.gapminder.org/fw/world-health-chart/','Copyright Gapminder');
INSERT INTO B4A_MEDITATIONS(id,name,author,text_2000,source_url,SOURCE_DESC_AND_COPYRIGHT ) VALUES 
( 9, 'Quote Happiness GRP (DOM)', 'Patrick van Hees','Geluk is Doelen, Oplaadpunten en Mensen (DOM); Happiness is Goals, Recharge Points and People (GRP)','https://www.chaphappiness.com/en/what-is-chap','Source and Copyright: Patrick van Hees, Geluk is DOM, G.R.P. Happiness Theory');

/* ? TODO ergens toevoegen link (liever !) of downloaden ? https://s3.eu-west-1.amazonaws.com/static.gapminder.org/GapminderMedia/wp-uploads/20191018112129/test4.jpg Life on the four income levels 
https://www.gapminder.org/fw/income-levels/
https://drive.google.com/file/d/12Fxfbv57uHeZr6ePNCHDQKUShJoXucLq World Health Wealth Chart
https://www.gapminder.org/fw/world-health-chart/whc2019/
*/
select * from B4A_MEDITATIONS;

/* Werkt nog niet: Mooie openingstekst, moet vcia sql loader */
INSERT INTO my_table VALUES ( 2, 'ThisWorld', 'Copyright Anja Strik text and composition, Henri');

/* Check IN Texts, Feelings and Needs */

/* DROP TABLE B4A_CHECKIN_TEXTS; */
CREATE TABLE B4A_CHECKIN_TEXTS 
(LANG           VARCHAR2(20),
 TXT_GROUP       VARCHAR2(200),
 TXT_GRP_INDEX      INTEGER,
 TXT_DETAILS   VARCHAR(200)
);

/* TODO Add NVC Key differntiations and NVC pathways to liberations Matrix */

/* delete from B4A_CHECKIN_TEXTS; */
INSERT INTO B4A_CHECKIN_TEXTS(LANG, TXT_GROUP, TXT_GRP_INDEX, TXT_DETAILS) VALUES ('en', 'modes',1,'Clearly expressing how I AM without blaming or criticizing');
select * from B4A_CHECKIN_TEXTS;

/* TODO Add 2 columns: Source url plus copyright reference columns in Gapminder and worldbank tables of eerst met de hand copyright 
en enkel source kolom, zie knowlegde base. ? */
/* TODO Save parts of this file in ADW CLoud and merge with w7pc sql file in cloud */
/* TODO Texten intype van 7 bladzijden boek en via sql loader laden, net als andere inspiratie meditatie */
/* TODO Create table met urls van 3dwd plaatjes en category vragen / metadata, inclusief source url column en copyright column OF eerst met de hand op pagina 1 ? */ 
/* TODO Create table with donations and other actions from google sheet */

https://www.wd-pl.com/69-quality-of-life-indicators-v2/
https://www.wd-pl.com/wp-content/uploads/69-Quality-of-Life-Indicators-card.jpg /* bevat copyright plaatje maar niet van kaarten ? */
https://www.wd-pl.com/licensing/ /* licensed in 2019 under CC BY-SA 4.0 – Creative Commons Attribution-ShareAlike 4.0. by Co-Intelligence Institute */
https://creativecommons.org/licenses/by-sa/4.0/ /* Includes haring with commercial use under same terms */

https://www.gapminder.org/free-material/ /*  All Gapminder material linking here are freely available under the Creative Commons Attribution 4.0 International license. */
https://creativecommons.org/licenses/by/4.0/ /* No statements on commercial use just same attribution (science like)  terms */ 
https://www.gapminder.org/data/ /* FREE DATA FROM WORLD BANK VIA GAPMINDER.ORG, CC-BY LICENSE */

https://data.worldbank.org/summary-terms-of-use /* When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:   ... */
https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets

https://creativecommons.org/about/cclicenses/

/* WD PL Cards, Texts, copyright */

CREATE TABLE B4A_3DWD_WDPL_CARDS 
(
 CARD_NAME				VARCHAR2(200),
 CARD_NR				INTEGER,
 CARD_CATEGORY	 		VARCHAR2(200),	
 CARD_CATEGORY_QUESTION VARCHAR2(200),	
 CARD_DESC_URL	 		VARCHAR2(200),
 CARD_JPG_URL    		VARCHAR2(200)
);

INSERT INTO B4A_3DWD_WDPL_CARDS(CARD_NAME, CARD_NR, CARD_CATEGORY, CARD_CATEGORY_QUESTION, CARD_DESC_URL,CARD_JPG_URL ) 
VALUES ('Quality of Life Indicators',69,'VII Sustainability','How can we sustain our wise activities over time?','https://www.wd-pl.com/69-quality-of-life-indicators-v2/','https://www.wd-pl.com/wp-content/uploads/69-Quality-of-Life-Indicators-card.jpg');
INSERT INTO B4A_3DWD_WDPL_CARDS(CARD_NAME, CARD_NR, CARD_CATEGORY, CARD_CATEGORY_QUESTION, CARD_DESC_URL,CARD_JPG_URL ) 
VALUES ('Powerfull Questions',64,'II Interaction','What kind of healthy interaction can help us generate wisdom and resourcefulness?','https://www.wd-pl.com/64-powerful-questions-v2/','https://www.wd-pl.com/wp-content/uploads/64-Powerful-Questions-card.jpg');
INSERT INTO B4A_3DWD_WDPL_CARDS(CARD_NAME, CARD_NR, CARD_CATEGORY, CARD_CATEGORY_QUESTION, CARD_DESC_URL,CARD_JPG_URL ) 
VALUES ('Story',80,'II Interaction','What kind of healthy interaction can help us generate wisdom and resourcefulness?','https://www.wd-pl.com/80-story-v2/','https://www.wd-pl.com/wp-content/uploads/80-Story-card.jpg');

ALTER TABLE B4A_3DWD_WDPL_CARDS Add SOURCE_URL VARCHAR2(200 BYTE);
ALTER TABLE B4A_3DWD_WDPL_CARDS Add SOURCE_DESC_AND_COPYRIGHT VARCHAR2(200 BYTE);
update B4A_3DWD_WDPL_CARDS set SOURCE_URL = 'https://www.wd-pl.com/patterns/';
update B4A_3DWD_WDPL_CARDS set SOURCE_DESC_AND_COPYRIGHT = 'The Patterns 2.0, a Wise Democracy Project from the Co-Intelligence Institute, licensed in 2019 under CC BY-SA 4.0';
commit;  

/* Balancing Action Suggestions */

CREATE TABLE B4A_BALANCING_ACTION_SUGGESTION 
(
 ACTION_NAME							VARCHAR2(200),
 ACTION_TYPE							VARCHAR2(200),
 ACTION_LANG							VARCHAR2(200),
 ACTION_INVESTMENT_UNIT	 				VARCHAR2(200),	
 ACTION_INVESTMENT_MIN_VALUE	 		INTEGER,	
 ACTION_URL 							VARCHAR2(200),	
 ACTION_RESULT_URL	 					VARCHAR2(200),
 ACTION_ORGANIZATION    				VARCHAR2(200),
 ACTION_ORGANIZATION_URL    			VARCHAR2(200),
 ACTION_DONATION_BANK_ACCOUNT 			VARCHAR2(200),
 ACTION_DONATION_BANK_ACCOUNT_HOLDER 	VARCHAR2(200),
 ACTION_DESCRIPTION    					VARCHAR2(200),
 ACTION_RESULT_DESCRIPTION	 			VARCHAR2(200)
);

ALTER TABLE B4A_BALANCING_ACTION_SUGGESTION Add ACTION_SCOPE VARCHAR2(200 BYTE);
UPDATE B4A_BALANCING_ACTION_SUGGESTION SET ACTION_SCOPE = 'Personal Recharge' where ;
UPDATE B4A_BALANCING_ACTION_SUGGESTION SET ACTION_SCOPE = 'Global Goal Contribution' where ;
UPDATE B4A_BALANCING_ACTION_SUGGESTION SET ACTION_SCOPE = 'Relational Connection' where ;

/* DROP TABLE B4A_BALANCING_ACTION_SUGGESTION; */
delete from B4A_BALANCING_ACTION_SUGGESTION;

INSERT INTO B4A_BALANCING_ACTION_SUGGESTION(
 ACTION_NAME,
 ACTION_TYPE,
 ACTION_SCOPE,
 ACTION_LANG,
 ACTION_INVESTMENT_UNIT,	
 ACTION_INVESTMENT_MIN_VALUE,	
 ACTION_URL,	
 ACTION_RESULT_URL,
 ACTION_ORGANIZATION,
 ACTION_ORGANIZATION_URL,
 ACTION_DONATION_BANK_ACCOUNT,
 ACTION_DONATION_BANK_ACCOUNT_HOLDER,
 ACTION_DESCRIPTION,
 ACTION_RESULT_DESCRIPTION)
VALUES (
 'Donate to Oxfam Novib',
 'Money donation',
 'Global Goal Contribution',
 'nl',
 'Euro/Dollar',	
 2,	
 'https://secure.oxfamnovib.nl/algemeen?tab=1',	
 'https://www.oxfamnovib.nl/dit-doen-wij/zo-besteden-we-ons-geld',
 'Oxfam Novib',
 'https://www.oxfamnovib.nl/',
 'NL95DEUT0410187526',
 'Oxfam Novib via CM.com stichting',
 'Money Donation to reduce proverty worldwide through not-for-profit organization Oxfam Novib',
 'Action Result contributes to SDG1 wordlwide');

INSERT INTO B4A_BALANCING_ACTION_SUGGESTION(
 ACTION_NAME,
 ACTION_TYPE,
 ACTION_SCOPE,
 ACTION_LANG,
 ACTION_INVESTMENT_UNIT,	
 ACTION_INVESTMENT_MIN_VALUE,	
 ACTION_URL,	
 ACTION_RESULT_URL,
 ACTION_ORGANIZATION,
 ACTION_ORGANIZATION_URL,
 ACTION_DONATION_BANK_ACCOUNT,
 ACTION_DONATION_BANK_ACCOUNT_HOLDER,
 ACTION_DESCRIPTION,
 ACTION_RESULT_DESCRIPTION)
VALUES (
 'Donate to Kiva Micro Lending',
 'Money donation',
 'Global Goal Contribution',
 'en',
 'Euro/Dollar',	
 2,	
 'https://www.kiva.org/donate/supportus',	
 'https://www.kiva.org/about/impact',
 'Kiva',
 'https://www.kiva.org/',
 '',
 '',
 'Money Donation to reduce proverty worldwide through not for profit micro credit / lending organization Kiva',
 'Action Result contributes to SDG1 and others worldwide, 1 B Loans to 3 M people by 1 M people, by 2020');


INSERT INTO B4A_BALANCING_ACTION_SUGGESTION(
 ACTION_NAME,
 ACTION_TYPE,
 ACTION_SCOPE,
 ACTION_LANG,
 ACTION_INVESTMENT_UNIT,	
 ACTION_INVESTMENT_MIN_VALUE,	
 ACTION_URL,	
 ACTION_RESULT_URL,
 ACTION_ORGANIZATION,
 ACTION_ORGANIZATION_URL,
 ACTION_DONATION_BANK_ACCOUNT,
 ACTION_DONATION_BANK_ACCOUNT_HOLDER,
 ACTION_DESCRIPTION,
 ACTION_RESULT_DESCRIPTION)
VALUES (
 'Perform research on UN Millenium goals (SDG) and possible authentic or money contributions',
 'Time donation',
 'Global Goal Contribution',
 'en',
 'Hours',	
 2,	
 'https://www.un.org/sustainabledevelopment/takeaction/',	
 'https://www.gapminder.org/sdg/',
 'United Nations',
 'https://www.un.org',
 'NL86 INGB 0000 0001 21',
 'Unicef',
 'Perform research on UN Millenium goals (SDG) and possible contributing charity''s or other contributions from my own authentic resources',
 'Awareness personal possibilities to contribute to wellbeing of 7 Billion people including yourself');

INSERT INTO B4A_BALANCING_ACTION_SUGGESTION(
 ACTION_NAME,
 ACTION_TYPE,
 ACTION_SCOPE,
 ACTION_LANG,
 ACTION_INVESTMENT_UNIT,	
 ACTION_INVESTMENT_MIN_VALUE,	
 ACTION_URL,	
 ACTION_RESULT_URL,
 ACTION_ORGANIZATION,
 ACTION_ORGANIZATION_URL,
 ACTION_DONATION_BANK_ACCOUNT,
 ACTION_DONATION_BANK_ACCOUNT_HOLDER,
 ACTION_DESCRIPTION,
 ACTION_RESULT_DESCRIPTION)
VALUES (
 'Donate to Team Trees',
 'Money donation',
 'Global Goal Contribution',
 'en',
 'Euro/Dollar',	
 2,	
 'https://teamtrees.org/',	
 'https://teamtrees.org/',
 'Team Trees',
 'https://teamtrees.org/',
 'Paypal',
 'Paypal',
 'Money Donation to plant trees worldwide through not-for-profit organization Team Trees',
 'Action Result contributes to SDG15 wordlwide');

INSERT INTO B4A_BALANCING_ACTION_SUGGESTION(
 ACTION_NAME,
 ACTION_TYPE,
 ACTION_SCOPE,
 ACTION_LANG,
 ACTION_INVESTMENT_UNIT,	
 ACTION_INVESTMENT_MIN_VALUE,	
 ACTION_URL,	
 ACTION_RESULT_URL,
 ACTION_ORGANIZATION,
 ACTION_ORGANIZATION_URL,
 ACTION_DONATION_BANK_ACCOUNT,
 ACTION_DONATION_BANK_ACCOUNT_HOLDER,
 ACTION_DESCRIPTION,
 ACTION_RESULT_DESCRIPTION)
VALUES (
 'Perform Personal Check In to self connect with Needs and create energy',
 'Check In',
 'Personal Recharge',
 'en',
 'Minutes',	
 10,	
 'https://vinetraining.nl/vinetunes/nvc-app/nvctm-check-in-app-en/',	
 'https://vinetraining.nl/vinetunes/nvc-app/nvctm-check-in-app-en/',
 'Vine Training',
 'https://www.vinetraining.nl',
 '',
 'Vine Training',
 'Perform Personal Check In to self connect with Needs and create energy',
 'Refuel personal energy to contribute to wellbeing of 7 Billion people starting with yourself');

INSERT INTO B4A_BALANCING_ACTION_SUGGESTION(
 ACTION_NAME,
 ACTION_TYPE,
 ACTION_SCOPE,
 ACTION_LANG,
 ACTION_INVESTMENT_UNIT,	
 ACTION_INVESTMENT_MIN_VALUE,	
 ACTION_URL,	
 ACTION_RESULT_URL,
 ACTION_ORGANIZATION,
 ACTION_ORGANIZATION_URL,
 ACTION_DONATION_BANK_ACCOUNT,
 ACTION_DONATION_BANK_ACCOUNT_HOLDER,
 ACTION_DESCRIPTION,
 ACTION_RESULT_DESCRIPTION)
VALUES (
 'Create Todo Wish List to self connect with Needs and create Daily planning with guaranteed satisfaction',
 'Todo Wish List',
 'Personal Action',
 'en',
 'Minutes',	
 10,	
 'https://vinetraining.nl/vinetunes/nvc-app/nvctm-check-in-app-en/',	
 'https://vinetraining.nl/vinetunes/nvc-app/nvctm-check-in-app-en/',
 'Vine Training',
 'https://www.vinetraining.nl',
 '',
 'Vine Training',
 'Create Todo Wish List to self connect with Needs and create Daily planning with guaranteed satisfaction',
 'Make aware/conscious choices on where to put your energy for a day to enrich Life');

INSERT INTO B4A_BALANCING_ACTION_SUGGESTION(
 ACTION_NAME,
 ACTION_TYPE,
 ACTION_SCOPE,
 ACTION_LANG,
 ACTION_INVESTMENT_UNIT,	
 ACTION_INVESTMENT_MIN_VALUE,	
 ACTION_URL,	
 ACTION_RESULT_URL,
 ACTION_ORGANIZATION,
 ACTION_ORGANIZATION_URL,
 ACTION_DONATION_BANK_ACCOUNT,
 ACTION_DONATION_BANK_ACCOUNT_HOLDER,
 ACTION_DESCRIPTION,
 ACTION_RESULT_DESCRIPTION)
VALUES (
 'Relax, create silence and/or go for a walk in nature and create energy',
 'Relaxation',
 'Personal Recharge',
 'en',
 'Minutes',	
 10,	
 'https://vinetraining.nl/vinetunes/nvc-app/nvctm-check-in-app-en/',	
 'https://vinetraining.nl/vinetunes/nvc-app/nvctm-check-in-app-en/',
 'Vine Training',
 'https://www.vinetraining.nl',
 '',
 'Vine Training',
 'Relax, do nothing, to self connect with Needs and create energy',
 'Refuel personal energy to contribute to wellbeing of 7 Billion people starting with yourself');

INSERT INTO B4A_BALANCING_ACTION_SUGGESTION(
 ACTION_NAME,
 ACTION_TYPE,
 ACTION_SCOPE,
 ACTION_LANG,
 ACTION_INVESTMENT_UNIT,	
 ACTION_INVESTMENT_MIN_VALUE,	
 ACTION_URL,	
 ACTION_RESULT_URL,
 ACTION_ORGANIZATION,
 ACTION_ORGANIZATION_URL,
 ACTION_DONATION_BANK_ACCOUNT,
 ACTION_DONATION_BANK_ACCOUNT_HOLDER,
 ACTION_DESCRIPTION,
 ACTION_RESULT_DESCRIPTION)
VALUES (
 'Beautify/clean your house/environment with dearest people around you to create connection with people',
 'Connect by co-creation',
 'Relational Connection',
 'en',
 'Minutes',	
 10,	
 'https://vinetraining.nl/vinetunes/nvc-app/nvctm-check-in-app-en/',	
 'https://vinetraining.nl/vinetunes/nvc-app/nvctm-check-in-app-en/',
 'Vine Training',
 'https://www.vinetraining.nl',
 '',
 'Vine Training',
 'Beautify/clean your house/environment with dearest people around you to create connection with people',
 'Connect with people around and Refuel team energy to contribute to environment and wellbeing of 7 Billion people starting with people around you');

/* https://www.chaphappiness.com/en/what-is-chap DOM actie met reference toevoegen 
/* KIVA data via rapport : see https://www.kiva.org/about , https://www.kiva.org/about/impact and https://kiva.global/annual-reports-and-finances/ toevoegen
/* +TODO Verlanglijstje maken als aktie toevoegen*/

/* TODO: Add Happiness Checik IN (1 getal -> hierarchisch ? , PBSC Check in, meditatie check in and WBSC Check in, OBSC/TBSC later, DOM related ,... */ 
select * from B4A_BALANCING_ACTION_SUGGESTION;