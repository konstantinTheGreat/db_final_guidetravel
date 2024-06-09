CREATE INDEX idx_users_email ON GuideToursApp.Users (Email);
CREATE INDEX idx_rooms_createdby ON GuideToursApp.Rooms (CreatedBy);
CREATE INDEX idx_votes_userid ON GuideToursApp.Votes (UserID);
CREATE INDEX idx_votes_roomid ON GuideToursApp.Votes (RoomID);
CREATE INDEX idx_cities_countryid ON GuideToursApp.Cities (CountryID);
CREATE INDEX idx_landmarks_cityid ON GuideToursApp.Landmarks (CityID);
CREATE INDEX idx_hotels_cityid ON GuideToursApp.Hotels (CityID);
CREATE INDEX idx_restaurants_cityid ON GuideToursApp.Restaurants (CityID);
