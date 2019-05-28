-- Here are some questions to answer
-- Keep the questions in the file, and just put the answers below the questions.

/*
  About the DATA
  There are 4 tables
  here is a list with descriptions

  IMPORTANT: YOU MAY CHANGE THE TABLE STRUCTURES IF YOU WOULD LIKE.
      THE LAST QUESTION WILL ASK ABOUT ALL YOUR CHANGES.

  - users
     - just a list of user data
  - emails
     - holds users emails.
     - There is a one to many relationship with the users table. Each user can have many emails
     - One email is marked as the primary email for the user
  - usage_log
     - holds the users session dates and times.
     - contains the login and logout times of every user session.
     - So every time a user logs in, it creates a new entry in this table
  - users_admin
     - only holds a user id
     - if a user's id is in this table, then they are an admin
*/

-- EXAMPLE
-- Write a statement that will return all the users
--  with the last name 'Johnson'
SELECT *
  FROM [users]
  WHERE [lName] = 'Johnson';


-- QUESTION 1
-- write a statement that returns all the users data
--   including their primary email, if they have one
--   and if they are an admin or not
SELECT u.[fName]
	,u.[lName]
	,u.[age]
	,e.[email] [primaryEmail]
	,CASE 
		WHEN a.[id] IS NOT NULL
			THEN 'true'
		ELSE 'false'
		END [isAdmin]
FROM [dbo].[users] u
LEFT JOIN [dbo].[emails] e ON u.[id] = e.[userId]
	AND e.[primary] = 1
LEFT JOIN [dbo].[user_admin] a ON u.[id] = a.[userId]


-- QUESTION 2
-- write a statement that returns all user data
--   including their primary email
--   and if they are an admin or not
--   but only users with emails
SELECT u.[fName]
	,u.[lName]
	,u.[age]
	,e.[email] [primaryEmail]
	,CASE 
		WHEN a.[id] IS NOT NULL
			THEN 'true'
		ELSE 'false'
		END [isAdmin]
FROM [dbo].[users] u
LEFT JOIN [dbo].[emails] e ON u.[id] = e.[userId]
	AND e.[primary] = 1
LEFT JOIN [dbo].[user_admin] a ON u.[id] = a.[userId]
WHERE e.[id] IS NOT NULL


-- QUESTION 3
-- write a statement that returns all user data
--   that do not have an email
--   and are not admins
SELECT u.[fName]
	,u.[lName]
	,u.[age]
FROM [dbo].[users] u
RIGHT JOIN [dbo].[user_admin] a ON u.[id] = a.[userId]


-- QUESTION 4
-- write a statement that returns all the users data
--    only users with last name that contains a letter 'B'
--    and also return the number of emails those users have
SELECT u.[fName]
	,u.[lName]
	,u.[age]
	,COUNT(e.[id]) [numberOfEmails]
FROM [dbo].[users] u
LEFT JOIN [dbo].[emails] e ON u.[id] = e.[userId]
WHERE u.[lName] LIKE 'B%'
GROUP BY u.[fName]
	,u.[lName]
	,u.[age]


-- QUESTION 5
-- write a statement that returns all the users data
--    only users that have more than one email
--    and are admins
SELECT u.[fName]
	,u.[lName]
	,u.[age]
	,COUNT(e.[id]) [numberOfEmails]
FROM [dbo].[users] u
RIGHT JOIN [dbo].[user_admin] a ON u.[id] = a.[userId]
LEFT JOIN [dbo].[emails] e ON u.[id] = e.[userId]
GROUP BY u.[fName]
	,u.[lName]
	,u.[age]
HAVING COUNT(e.[id]) > 1


-- QUESTION 6
-- write a statement that returns all user data
--   with the total amount of time the users have spent on the site
--   in the past 21 days, in minutes
SELECT u.[fName]
	,u.[lName]
	,u.[age]
	,SUM(DATEDIFF(MINUTE, l.[login], l.[logout])) [timeLoggedIn]
FROM [dbo].[users] u
JOIN [dbo].[usage_log] l ON u.[id] = l.[userId]
WHERE l.[login] > DATEADD(DAY, - 21, GETDATE())
GROUP BY u.[fName]
	,u.[lName]
	,u.[age]


-- QUESTION 7
-- Write a statement that returns all user data
--   with the total amount of time spent on the site
--   and with the total number of logins
--   beginning of time
SELECT u.[fName]
	,u.[lName]
	,u.[age]
	,SUM(DATEDIFF(MINUTE, l.[login], l.[logout])) [timeLoggedIn]
	,COUNT(l.id) [numberOfLogins]
FROM [dbo].[users] u
JOIN [dbo].[usage_log] l ON u.[id] = l.[userId]
GROUP BY u.[fName]
	,u.[lName]
	,u.[age]


-- QUESTION 8
-- given the table structure provided.
-- How would you did/would you change/improve our schema? Any Why?
-- Please list all changes that were made and a justification for the change.

--Below is a script that includes all of the changes that were made:

--Every table should have a primary key.
ALTER TABLE emails ADD CONSTRAINT PK_Emails PRIMARY KEY (id);
ALTER TABLE usage_log ADD CONSTRAINT PK_Usage_log PRIMARY KEY (id);
ALTER TABLE user_admin ADD CONSTRAINT PK_User_admin PRIMARY KEY (id);
ALTER TABLE users ADD CONSTRAINT PK_Users PRIMARY KEY (id);

--We need to know what user the record belongs to
--so we create a column on the tables that don't have it.
ALTER TABLE emails ADD [userId] [int] NOT NULL;
ALTER TABLE usage_log ADD [userId] [int] NOT NULL;

--Email addresses are not longer than 254 characters,
--so this column should be reduced to save space.
ALTER TABLE emails
ALTER COLUMN email VARCHAR(255);

--A true or false field doesn't need more than two values.
ALTER TABLE emails
ALTER COLUMN [primary] [bit];

--A new email record will not be primary unless the field is
--manually specified during an insert. This could be different
--depending on what the application logic is.
ALTER TABLE emails ADD CONSTRAINT [DF_Emails_Primary] DEFAULT 0
FOR [primary];

--The date the record was added can be defaulted in, for ease.
ALTER TABLE emails ADD CONSTRAINT [DF_Emails_Date] DEFAULT(getdate())
FOR DATE;

ALTER TABLE users ADD CONSTRAINT [DF_Users_Date] DEFAULT(getdate())
FOR [date];

--The session ID should not be null.
ALTER TABLE usage_log
ALTER COLUMN [sessionId] [int] NOT NULL;

--It seems like most tables had a date field, so it made
--sense to make sure all of the tables where consistent.
--The date field was added to the tables below.
ALTER TABLE usage_log ADD [date] [datetime] NOT NULL CONSTRAINT [DF_Usage_log_Date] DEFAULT(getdate());
ALTER TABLE user_admin ADD [date] [datetime] NOT NULL CONSTRAINT [DF_User_admin_Date] DEFAULT(getdate());

--User's names are probably not that long. We can shorten
--these fields to save space.
ALTER TABLE users
ALTER COLUMN fName VARCHAR(255);
ALTER TABLE users
ALTER COLUMN lName VARCHAR(255);

--People usually don't live past 255 years, so a data type
--of tinyint seemed more appropriate.
ALTER TABLE users
ALTER COLUMN age [tinyint];

--Adding a foreign key for the user ID field help maintain
--the integrity of the database.
ALTER TABLE emails ADD CONSTRAINT FK_Emails_Users FOREIGN KEY (userId) REFERENCES users (id);
ALTER TABLE user_admin ADD CONSTRAINT FK_User_admin_Users FOREIGN KEY (userId) REFERENCES users (id);
ALTER TABLE usage_log ADD CONSTRAINT FK_Usage_log_Users FOREIGN KEY (userId) REFERENCES users (id);
