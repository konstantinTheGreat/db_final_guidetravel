CREATE TABLE GuideToursApp.ETLLog (
    ETLProcess VARCHAR(50) PRIMARY KEY,
    LastProcessedID INT
);
--inserting info about every etl process 
INSERT INTO GuideToursApp.ETLLog (ETLProcess, LastProcessedID)
VALUES ('UserETL', 0);
INSERT INTO GuideToursApp.ETLLog (ETLProcess, LastProcessedID)
VALUES ('RoomETL', 0);
INSERT INTO GuideToursApp.ETLLog (ETLProcess, LastProcessedID)
VALUES ('CityETL', 0);
INSERT INTO GuideToursApp.ETLLog (ETLProcess, LastProcessedID)
VALUES ('CountryETL', 0);

--user ETL procedure
CREATE OR REPLACE PROCEDURE GuideToursApp.UserETLProcess()
LANGUAGE plpgsql
AS $$
DECLARE
    lastProcessedUserID INT;
BEGIN
    SELECT LastProcessedID INTO lastProcessedUserID 
    FROM GuideToursApp.ETLLog 
    WHERE ETLProcess = 'UserETL';

    CREATE TEMP TABLE NewUsers ON COMMIT DROP AS 
    SELECT UserID, Username, Email, ProfilePicture, Role
    FROM GuideToursApp.Users
    WHERE UserID > lastProcessedUserID;

    INSERT INTO GuideToursApp.DimUser (UserID, Username, Email, ProfilePicture, Role, ValidFrom, ValidTo)
    SELECT 
        UserID,
        Username,
        Email,
        ProfilePicture,
        Role,
        CURRENT_TIMESTAMP AS ValidFrom,
        '9999-12-31' AS ValidTo
    FROM NewUsers;

    UPDATE GuideToursApp.DimUser
    SET ValidTo = CURRENT_TIMESTAMP
    WHERE UserID IN (SELECT UserID FROM NewUsers) AND ValidTo = '9999-12-31';

    UPDATE GuideToursApp.ETLLog
    SET LastProcessedID = COALESCE((SELECT MAX(UserID) FROM GuideToursApp.Users), 0)
    WHERE ETLProcess = 'UserETL';
END;
$$;

--country ETL procedure
CREATE OR REPLACE PROCEDURE GuideToursApp.CountryETLProcess()
LANGUAGE plpgsql
AS $$
DECLARE
    lastProcessedCountryID INT;
BEGIN
    SELECT LastProcessedID INTO lastProcessedCountryID 
    FROM GuideToursApp.ETLLog 
    WHERE ETLProcess = 'CountryETL';

    CREATE TEMP TABLE NewCountries ON COMMIT DROP AS 
    SELECT CountryID, CountryName, Description
    FROM GuideToursApp.Countries
    WHERE CountryID > lastProcessedCountryID;

    INSERT INTO GuideToursApp.DimCountry (CountryID, CountryName, Description)
    SELECT 
        CountryID,
        CountryName,
        Description
    FROM NewCountries;

    UPDATE GuideToursApp.ETLLog
    SET LastProcessedID = COALESCE((SELECT MAX(CountryID) FROM GuideToursApp.Countries), 0)
    WHERE ETLProcess = 'CountryETL';
END;
$$;
--city ETL procedure
CREATE OR REPLACE PROCEDURE GuideToursApp.CityETLProcess()
LANGUAGE plpgsql
AS $$
DECLARE
    lastProcessedCityID INT;
BEGIN
    SELECT LastProcessedID INTO lastProcessedCityID 
    FROM GuideToursApp.ETLLog 
    WHERE ETLProcess = 'CityETL';

    CREATE TEMP TABLE NewCities ON COMMIT DROP AS 
    SELECT CityID, CityName, CountryID, Description
    FROM GuideToursApp.Cities
    WHERE CityID > lastProcessedCityID;

    INSERT INTO GuideToursApp.DimCity (CityID, CityName, CountryID, Description)
    SELECT 
        CityID,
        CityName,
        CountryID,
        Description
    FROM NewCities;

    UPDATE GuideToursApp.ETLLog
    SET LastProcessedID = COALESCE((SELECT MAX(CityID) FROM GuideToursApp.Cities), 0)
    WHERE ETLProcess = 'CityETL';
END;
$$;

--city ETL procedure
CREATE OR REPLACE PROCEDURE GuideToursApp.RoomETLProcess()
LANGUAGE plpgsql
AS $$
DECLARE
    lastProcessedRoomID INT;
BEGIN
    SELECT LastProcessedID INTO lastProcessedRoomID 
    FROM GuideToursApp.ETLLog 
    WHERE ETLProcess = 'RoomETL';

    CREATE TEMP TABLE NewRooms ON COMMIT DROP AS 
    SELECT RoomID, RoomName, CreatedBy
    FROM GuideToursApp.Rooms
    WHERE RoomID > lastProcessedRoomID;

    INSERT INTO GuideToursApp.DimRoom (RoomID, RoomName, CreatedBy)
    SELECT 
        RoomID,
        RoomName,
        CreatedBy
    FROM NewRooms;

    UPDATE GuideToursApp.ETLLog
    SET LastProcessedID = COALESCE((SELECT MAX(RoomID) FROM GuideToursApp.Rooms), 0)
    WHERE ETLProcess = 'RoomETL';
END;
$$;
-- date ETL procedure
CREATE OR REPLACE PROCEDURE GuideToursApp.DateETLProcess()
LANGUAGE plpgsql
AS $$
DECLARE
    startDate DATE := '2020-01-01'; 
    endDate DATE := '2024-12-31';   
    currentDate DATE := startDate;
BEGIN
	
DELETE FROM GuideToursApp.dimdate;

    WHILE currentDate <= endDate LOOP
        INSERT INTO GuideToursApp.DimDate (Date, Year, Month, Day, Quarter, Weekday)
        VALUES (
            currentDate,
            EXTRACT(YEAR FROM currentDate),
            EXTRACT(MONTH FROM currentDate),
            EXTRACT(DAY FROM currentDate),
            EXTRACT(QUARTER FROM currentDate),
            EXTRACT(ISODOW FROM currentDate)
        );
        currentDate := currentDate + INTERVAL '1 DAY';
    END LOOP;
END;
$$;

CALL GuideToursApp.UserETLProcess();
CALL GuideToursApp.RoomETLProcess();

-- Schedule all procedures to run at midnight (need to add a cron extension for this to work), so skip this if you dont have it
SELECT cron.schedule('0 0 * * *', 'CALL GuideToursApp.UserETLProcess()');
SELECT cron.schedule('0 0 * * *', 'CALL GuideToursApp.RoomETLProcess()');
SELECT cron.schedule('0 0 * * *', 'CALL GuideToursApp.CityETLProcess()');
SELECT cron.schedule('0 0 * * *', 'CALL GuideToursApp.CountryETLProcess()');
SELECT cron.schedule('0 0 * * *', 'CALL GuideToursApp.DateETLProcess()');