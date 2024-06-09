-- Creating Dimension Tables

--this is the scd type 2 
CREATE TABLE GuideToursApp.DimUser (
    UserKey SERIAL PRIMARY KEY,
    UserID INT,
    Username VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    ProfilePicture VARCHAR(255),
    Role VARCHAR(255) DEFAULT 'User',
    ValidFrom TIMESTAMP NOT NULL,
    ValidTo TIMESTAMP DEFAULT '9999-12-31', 
);

CREATE TABLE GuideToursApp.DimCountry (
    CountryID SERIAL PRIMARY KEY,
    CountryName VARCHAR(255) NOT NULL
);
CREATE TABLE GuideToursApp.DimCity (
    CityID SERIAL PRIMARY KEY,
    CityName VARCHAR(255) NOT NULL,
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES GuideToursApp.DimCountry(CountryID)
);


CREATE TABLE GuideToursApp.DimRoom (
    RoomID SERIAL PRIMARY KEY,
    RoomName VARCHAR(255) NOT NULL,
    CreatedBy INT NOT NULL,
    FOREIGN KEY (CreatedBy) REFERENCES GuideToursApp.DimUser(UserID)
);

CREATE TABLE GuideToursApp.DimDate (
    DateID SERIAL PRIMARY KEY,
    Date DATE NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    Day INT NOT NULL,
    Quarter INT NOT NULL,
    Weekday INT NOT NULL
);

-- Creating Fact Tables
CREATE TABLE GuideToursApp.BookingFact (
    BookingID SERIAL PRIMARY KEY,
    UserID INT,
    RoomID INT,
    DateID INT,
    NumberOfNights INT,
    TotalCost DECIMAL(10, 2),
    FOREIGN KEY (UserID) REFERENCES GuideToursApp.DimUser(UserID),
    FOREIGN KEY (RoomID) REFERENCES GuideToursApp.DimRoom(RoomID),
    FOREIGN KEY (DateID) REFERENCES GuideToursApp.DimDate(DateID)
);

CREATE TABLE GuideToursApp.VotesFact (
    VoteID SERIAL PRIMARY KEY,
    UserID INT,
    VoteType VARCHAR(255) NOT NULL,
    VoteResult VARCHAR(255),
    VoteTargetID INT,
    DateID INT,
    FOREIGN KEY (UserID) REFERENCES GuideToursApp.DimUser(UserID),
    FOREIGN KEY (VoteTargetID) REFERENCES GuideToursApp.DimCity(CityID),
    FOREIGN KEY (DateID) REFERENCES GuideToursApp.DimDate(DateID)
);


