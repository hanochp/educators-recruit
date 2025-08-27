-- Educators Recruit Business Scenario Implementation
-- T-SQL script creating table, inserting sample data and report queries

DROP TABLE IF EXISTS dbo.Educator;
GO


CREATE TABLE dbo.Educator (
    educator_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL
        CONSTRAINT CK_Educator_DateOfBirth CHECK (date_of_birth <= GETDATE()),
    gender NVARCHAR(10) NULL
        CONSTRAINT CK_Educator_Gender CHECK (gender IN ('male','female')),
    college_attended NVARCHAR(100) NOT NULL,
    degree_title NVARCHAR(100) NOT NULL,
    media_source NVARCHAR(50) NOT NULL
        CONSTRAINT CK_Educator_Media CHECK (media_source IN ('magazine','newspaper','social media','social media site','word of mouth')),
    date_contacted DATE NOT NULL
        CONSTRAINT CK_Educator_DateContacted CHECK (date_contacted >= '2017-02-17'),
    school_placed NVARCHAR(100) NULL,
    date_job_found DATE NULL
        CONSTRAINT CK_Educator_DateJobFound CHECK (date_job_found IS NULL OR date_job_found >= date_contacted)
);
GO

-- Insert sample data
INSERT INTO dbo.Educator (first_name, last_name, date_of_birth, gender, college_attended, degree_title, media_source, date_contacted, school_placed, date_job_found) VALUES
('Mary','Lynn','2000-09-13','female','Excelsior College','BA in Mathematics Education','magazine','2022-05-02','Brooklyn High School','2022-05-09'),
('Josh','Frank','1998-04-23','male','Georgia State University','MA in Social Studies Education','social media site','2022-02-12','Manhattan Elementary School','2022-05-09'),
('Charles','Smith','1994-07-09','male','Excelsior College','PhD in Education','social media site','2021-08-07','New York City Day School','2021-08-12'),
('Samantha','Brown','1999-09-24','female','Columbia University','BA in English Education','newspaper','2021-05-23','Brooklyn High School','2021-07-30'),
('Howard','Lang','1998-08-04','male','Georgia State University','MA in History Education','word of mouth','2022-01-31',NULL,NULL),
('Sarah','Blanks','1995-10-20','female','Columbia University','MA in Science Education','social media','2020-05-23','New York City Day School','2020-08-17'),
('Ella','Lewis','2000-08-22','female','Excelsior College','BA in English Education','word of mouth','2022-04-01',NULL,NULL),
('Julie','Goldman','1997-03-30',NULL,'University of Denver','MA in Social Studies Education','social media','2020-07-14','Manhattan Elementary School','2020-08-17');
GO

-- Report 1: Number of students from each college placed in under two weeks
SELECT college_attended,
       COUNT(*) AS placed_within_two_weeks
FROM dbo.Educator
WHERE date_job_found IS NOT NULL
  AND DATEDIFF(day, date_contacted, date_job_found) <= 14
GROUP BY college_attended;

-- Report 2: Placement success by gender
SELECT gender,
       COUNT(*) AS placed_count
FROM dbo.Educator
WHERE date_job_found IS NOT NULL
GROUP BY gender;

-- Report 3a: Average number of people contacting per day
SELECT CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT date_contacted) AS avg_contacts_per_day
FROM dbo.Educator;

-- Report 3b: Average number of people contacting per day by media source
SELECT media_source,
       CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT date_contacted) AS avg_contacts_per_day
FROM dbo.Educator
GROUP BY media_source;

-- Report 4: Average number of placements per day
SELECT CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT date_job_found) AS avg_placements_per_day
FROM dbo.Educator
WHERE date_job_found IS NOT NULL;

-- Report 5: Average placements per day per degree type
SELECT degree_title,
       CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT date_job_found) AS avg_placements_per_day
FROM dbo.Educator
WHERE date_job_found IS NOT NULL
GROUP BY degree_title;

-- Report 6: List of educators who reached out (first name, last name, age, degree)
SELECT first_name,
       last_name,
       DATEDIFF(year, date_of_birth, GETDATE()) AS age,
       degree_title
FROM dbo.Educator;
GO
