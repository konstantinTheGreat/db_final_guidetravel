--RUN THIS IN PSQL TOOL!!!

--Step 1: run this 2 create temp table 

CREATE TEMP TABLE staging_users (
    UserID SERIAL PRIMARY KEY,
    Username VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    ProfilePicture VARCHAR(255),
    Role VARCHAR(255) DEFAULT 'User' CHECK (Role IN ('User', 'Admin'))
);

CREATE TEMP TABLE staging_rooms (
    RoomID SERIAL PRIMARY KEY,
    RoomName VARCHAR(255) NOT NULL,
    CreatedBy INT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


--Step 2: copy the data from csv to these 2 temp tables

\COPY staging_users (UserID, Username, Email, Password, ProfilePicture, Role) FROM 'C:\Users\Kon\Downloads\data_set1_users.csv' DELIMITER ',' CSV HEADER; --your own path to the file
\COPY staging_rooms (RoomID, RoomName, CreatedBy, CreatedAt) FROM 'C:\Users\Kon\Downloads\data_set2_rooms.csv' DELIMITER ',' CSV HEADER;  --your own path to the file

--Step 3: Now merge with the actual tables in our database

INSERT INTO GuideToursApp.Users (Username, Email, Password, ProfilePicture, Role)	--if copying 4 of this lines check the spaces between SELECT FROM WHERE
SELECT Username, Email, Password, ProfilePicture, Role
FROM staging_users
WHERE Email NOT IN (SELECT Email FROM GuideToursApp.Users);

INSERT INTO GuideToursApp.Rooms (RoomName, CreatedBy, CreatedAt)
SELECT RoomName, CreatedBy, CreatedAt
FROM staging_rooms
WHERE RoomID NOT IN (SELECT RoomID FROM GuideToursApp.Rooms);

-- Step 4: clean the temp tables ( they are of no use now)
DROP TABLE IF EXISTS staging_users;	
DROP TABLE IF EXISTS staging_rooms;

-- do every step one by one (if inserting the whole script it does not work)
SELECT * from guidetoursapp.rooms -- this is just a check
