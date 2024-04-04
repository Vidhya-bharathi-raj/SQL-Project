SHOW DATABASES;
USE mobile_data;
SHOW TABLES;
													  -- " Data Viewing " --
SELECT `Phone_Name`,`Ratings`,`Number_of_Ratings`,
        `RAM`,`ROM/Storage`,`Back_Camera`,
        `Front_Camera`,`Battery`,`Processor`,`Price_in_INR`
        FROM mobile_data;
													 -- " Data Cleaning " --
-- to convert the table and it's data as make more easily accessible to call by renaming the column name into short span

ALTER TABLE mobile_data DROP Date_of_Scraping ;

ALTER TABLE mobile_data 
RENAME COLUMN   `Phone_Name` TO `phone_name`,
RENAME COLUMN   `Ratings` TO `ratings`,
RENAME COLUMN   `Number_of_Ratings` TO `ratings_count`,
RENAME COLUMN   `RAM` TO `RAM`,
RENAME COLUMN   `ROM/Storage` TO `ROM`,
RENAME COLUMN   `Back_Camera` TO `back_camera`,
RENAME COLUMN   `Front_Camera` TO `front_camera`,
RENAME COLUMN   `Battery` TO `battery`,
RENAME COLUMN   `Processor` TO `processor`,
RENAME COLUMN   `Price_in_INR` TO `price_in_rupee`; 

-- to remove the value nan from ROM column and enter null value

UPDATE mobile_data SET ROM = REPLACE(ROM, 'nan', NULL) WHERE ROM LIKE '%nan%';
UPDATE mobile_data SET RAM = REPLACE(RAM, 'nan', NULL) WHERE RAM LIKE '%nan%';
UPDATE mobile_data SET battery = REPLACE(battery, 'nan', NULL) WHERE battery LIKE '%nan%';
UPDATE mobile_data SET back_camera = REPLACE(back_camera, 'nan', NULL) WHERE back_camera LIKE '%nan%';
UPDATE mobile_data SET processor = REPLACE(processor, 'nan', NULL) WHERE processor LIKE '%nan%';
UPDATE mobile_data SET front_camera = REPLACE(front_camera, 'nan', NULL) WHERE front_camera LIKE '%nan%';

													 -- " Data Validating " --
-- to seperate the 'phone_name' column into to columns and name it as 'phone and model' and colour and then remove the remaining thing 

ALTER TABLE mobile_data
	   ADD phone_and_model VARCHAR(250),
	   ADD colour VARCHAR(250),
	   ADD ram_unit VARCHAR(250),
	   ADD rom_unit VARCHAR(250);

-- to remove the thousand seperator in ratings_count column, to make ratings_column to int(datatype)

UPDATE mobile_data
   SET ratings_count = REPLACE (ratings_count, ',', '');
 
 -- to remove the unwanted symbol from the price_in_rupee column

UPDATE mobile_data
   SET price_in_rupee = REPLACE (REPLACE (price_in_rupee, 'â‚¹', ''), ',', '');

-- we need to change the datatype of the some column to select or filter the column like, how we want..

ALTER TABLE mobile_data
	 MODIFY phone_name VARCHAR(600), 
     MODIFY ratings INT,
	 MODIFY ratings_count INT,
     MODIFY RAM VARCHAR(600),
     MODIFY ROM VARCHAR(600),
	 MODIFY back_camera VARCHAR(600),
     MODIFY front_camera VARCHAR(600),
     MODIFY battery VARCHAR(200),
     MODIFY processor VARCHAR(200),
     MODIFY price_in_rupee INT;

                                                   -- " Data Converting " --
describe mobile_data;

UPDATE mobile_data
   SET phone_and_model = SUBSTRING_INDEX(phone_name, '(', 1),
    colour = SUBSTRING_INDEX(SUBSTRING_INDEX(phone_name, '(', -1), ',', 1);

-- to remove and adjust the wrongly entered rom column's data to the right column

UPDATE mobile_data
SET ROM = RAM , RAM = NUll
WHERE RAM like '%rom%';

UPDATE mobile_data
SET  RAM = NULL
WHERE RAM LIKE '%upto%' ;

UPDATE mobile_data
SET  RAM = NULL
WHERE RAM NOT LIKE '%RAM%';

-- to remove the mistakenly entered from the processor column

UPDATE mobile_data
SET processor = NULL
WHERE processor NOT LIKE '%Processor%' ;

-- to remove the mistakenly entered data from back_camera column to the right column

UPDATE mobile_data
SET back_camera = NULL
WHERE back_camera LIKE '%Front%' ;


UPDATE mobile_data
SET battery = back_camera ,back_camera = NUll
WHERE back_camera like '%Battery%';

-- to move the mistakenly entered processor's data from battery to processor's column

UPDATE mobile_data
SET processor = battery ,battery = 'Not_Represented'
WHERE battery like '%A1%';

SELECT RAM,ROM,ram_unit,rom_unit
FROM mobile_data;

UPDATE mobile_data
   SET ram_unit = SUBSTRING_INDEX(SUBSTRING_INDEX(RAM, ' ', -2), ' ', 1),
       rom_unit = SUBSTRING_INDEX(SUBSTRING_INDEX(ROM, ' ', -2), ' ', 1);
UPDATE mobile_data
   SET RAM = SUBSTRING_INDEX(RAM, ' ', 1),
       ROM = SUBSTRING_INDEX(ROM, ' ', 1);
                                                -- Data Filtering and Sorting
-- to find the highlhy rated mobiles with high ratings count

SELECT * FROM mobile_data 
ORDER BY ratings DESC, ratings_count DESC;

-- to find the highly priced apple mobile

SELECT * FROM mobile_data 
WHERE phone_name LIKE '%APPLE%' 
ORDER BY price_in_rupee DESC;

-- to find the mobile with tera byte storage facility and have a colour black

SELECT * FROM mobile_data 
WHERE rom_unit LIKE '%TB%' AND colour LIKE '%Black%';

-- to find the mobile with dual camera facility on front side;

SELECT * 
FROM mobile_data 
WHERE front_camera LIKE '%dual%';

-- to find the mobile between the price 10,000 to 20,000

SELECT *
FROM mobile_data
WHERE price_in_rupee BETWEEN 10000 AND 20000 
ORDER BY price_in_rupee;




