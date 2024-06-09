--Retrieve All Rooms Created by a User
SELECT RoomID, RoomName, CreatedAt
FROM GuideToursApp.Rooms
WHERE CreatedBy = 1
ORDER BY CreatedAt DESC;

--Retrieve All Votes in a Room
SELECT VoteID, UserID, VoteType, VoteResult, VotedAt
FROM GuideToursApp.Votes
WHERE RoomID = 1
ORDER BY VotedAt DESC;

--Retrieve Cities, Landmarks, Hotels, Restaurants for a Room
SELECT c.CityID, c.CityName, l.LandmarkID, l.LandmarkName, h.HotelID, h.HotelName, r.RestaurantID, r.RestaurantName
FROM GuideToursApp.Rooms rm
JOIN GuideToursApp.Votes v ON rm.RoomID = v.RoomID
LEFT JOIN GuideToursApp.Cities c ON v.VoteType = 'City' AND v.VoteTargetID = c.CityID
LEFT JOIN GuideToursApp.Landmarks l ON v.VoteType = 'Landmark' AND v.VoteTargetID = l.LandmarkID
LEFT JOIN GuideToursApp.Hotels h ON v.VoteType = 'Hotel' AND v.VoteTargetID = h.HotelID
LEFT JOIN GuideToursApp.Restaurants r ON v.VoteType = 'Restaurant' AND v.VoteTargetID = r.RestaurantID
WHERE rm.RoomID = 1;




