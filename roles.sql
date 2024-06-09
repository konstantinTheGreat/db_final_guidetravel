CREATE ROLE app_user;
CREATE ROLE app_admin;

GRANT CONNECT ON DATABASE tours_db_final TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA GuideToursApp TO app_user;

GRANT CONNECT ON DATABASE tours_db_final TO app_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA GuideToursApp TO app_admin;



GRANT app_user TO some_user; -- some_user should be changed with the actual username of a user
GRANT app_admin TO some_admin; -- some_admin should be changed with the actual admin name