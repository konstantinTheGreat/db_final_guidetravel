
--function that creates a new room
CREATE OR REPLACE FUNCTION GuideToursApp.CreateRoom(
    p_RoomName VARCHAR,
    p_CreatedBy INT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO GuideToursApp.Rooms (RoomName, CreatedBy)
    VALUES (p_RoomName, p_CreatedBy);
END;
$$ LANGUAGE plpgsql;


--function to vote for something
CREATE OR REPLACE FUNCTION GuideToursApp.CastVote(
    p_UserID INT,
    p_RoomID INT,
    p_VoteType VARCHAR,
    p_VoteResult VARCHAR,
    p_VoteTargetID INT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO GuideToursApp.Votes (UserID, RoomID, VoteType, VoteResult, VoteTargetID)
    VALUES (p_UserID, p_RoomID, p_VoteType, p_VoteResult, p_VoteTargetID);
END;
$$ LANGUAGE plpgsql;


--function to get the vote count in the room
CREATE OR REPLACE FUNCTION GuideToursApp.GetVoteCount(
    p_RoomID INT,
    p_VoteType VARCHAR
)
RETURNS INT AS $$
DECLARE
    vote_count INT;
BEGIN
    SELECT COUNT(*) INTO vote_count
    FROM GuideToursApp.Votes
    WHERE RoomID = p_RoomID AND VoteType = p_VoteType;
    RETURN vote_count;
END;
$$ LANGUAGE plpgsql;
