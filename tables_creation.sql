CREATE DATABASE travelling_tours;

CREATE SCHEMA GuideToursApp;

CREATE TABLE GuideToursApp.Users (
    UserID SERIAL PRIMARY KEY,
    Username VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    ProfilePicture VARCHAR(255),
    Role VARCHAR(255) DEFAULT 'User' CHECK (Role IN ('User', 'Admin'))
);

CREATE TABLE GuideToursApp.Rooms (
    RoomID SERIAL PRIMARY KEY,
    RoomName VARCHAR(255) NOT NULL,
    CreatedBy INT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CreatedBy) REFERENCES GuideToursApp.Users(UserID)
);

CREATE TABLE GuideToursApp.UserRooms (
    UserRoomID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    RoomID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES GuideToursApp.Users(UserID),
    FOREIGN KEY (RoomID) REFERENCES GuideToursApp.Rooms(RoomID)
);

CREATE TABLE GuideToursApp.Votes (
    VoteID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    RoomID INT NOT NULL,
    VoteType VARCHAR(255) NOT NULL CHECK (VoteType IN ('City', 'Landmark', 'Hotel', 'Restaurant')),
    VoteResult VARCHAR(255),
    VoteTargetID INT,
    VotedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES GuideToursApp.Users(UserID),
    FOREIGN KEY (RoomID) REFERENCES GuideToursApp.Rooms(RoomID)
);

CREATE TABLE GuideToursApp.Countries (
    CountryID SERIAL PRIMARY KEY,
    CountryName VARCHAR(255) NOT NULL,
    Description TEXT
);

CREATE TABLE GuideToursApp.Cities (
    CityID SERIAL PRIMARY KEY,
    CityName VARCHAR(255) NOT NULL,
    CountryID INT NOT NULL,
    Description TEXT,
    FOREIGN KEY (CountryID) REFERENCES GuideToursApp.Countries(CountryID)
);

CREATE TABLE GuideToursApp.Landmarks (
    LandmarkID SERIAL PRIMARY KEY,
    LandmarkName VARCHAR(255) NOT NULL,
    CityID INT NOT NULL,
    Description TEXT,
    Latitude DECIMAL(9, 6),
    Longitude DECIMAL(9, 6),
    FOREIGN KEY (CityID) REFERENCES GuideToursApp.Cities(CityID)
);

CREATE TABLE GuideToursApp.Hotels (
    HotelID SERIAL PRIMARY KEY,
    HotelName VARCHAR(255) NOT NULL,
    CityID INT NOT NULL,
    Description TEXT,
    Latitude DECIMAL(9, 6),
    Longitude DECIMAL(9, 6),
    FOREIGN KEY (CityID) REFERENCES GuideToursApp.Cities(CityID)
);

CREATE TABLE GuideToursApp.Restaurants (
    RestaurantID SERIAL PRIMARY KEY,
    RestaurantName VARCHAR(255) NOT NULL,
    CityID INT NOT NULL,
    Description TEXT,
    Latitude DECIMAL(9, 6),
    Longitude DECIMAL(9, 6),
    FOREIGN KEY (CityID) REFERENCES GuideToursApp.Cities(CityID)
);
