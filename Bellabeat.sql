
SELECT *
FROM Wellness..Activity
-- Activeness of users
SELECT Id,Avg_VeryActiveMinutes ,Avg_FairlyActiveMinutes, Avg_LightlyActiveMinutes, Avg_SedentaryMinutes,
	CASE WHEN 19 < Avg_VeryActiveMinutes THEN 'Very Active' -- Average minutes of very active user is 19
	WHEN 12 < Avg_FairlyActiveMinutes THEN 'Fairly Active' -- Average minutes of fairly active user is 12
	WHEN 190 < Avg_LightlyActiveMinutes THEN 'Lightly Active' -- Average minutes of lightly active user is 190
	WHEN 998 < Avg_SedentaryMinutes THEN 'Sedentary' -- Average minutes of Sedentary user is 998
	END AS ACTIVE
FROM (SELECT Id, AVG(CAST(VeryActiveMinutes as INT)) as Avg_VeryActiveMinutes,
	AVG(CAST(FairlyActiveMinutes as INT)) as Avg_FairlyActiveMinutes,
	AVG(CAST(LightlyActiveMinutes as INT)) as Avg_LightlyActiveMinutes,
	AVG(CAST(SedentaryMinutes as INT)) as Avg_SedentaryMinutes
	FROM Wellness..Activity
	GROUP BY Id) as activeness

--STEPS AND DISTANCE
SELECT Id, AVG(CAST(TotalSteps as float)) as Avg_TotalSteps, AVG(CAST(TotalDistance as float)) as Avg_TotalDistance
FROM Wellness..Activity
GROUP BY Id

-- SLEEP
SELECT *
FROM Wellness..Sleep
-- AVERAGE TIME FOR SLEEPING
SELECT Id, CAST(Avg(CAST(TotalMinutesAsleep as float))/60 As decimal(18,2)) As Avg_Hour_Sleep
FROM Wellness..Sleep
GROUP BY Id
-- SLEEP VS ACTIVENESS
SELECT s.id, s.Avg_Hour_sleep, a.ACTIVE
FROM Wellness..avg_sleep as s
JOIN Wellness..activeness as a on a.Id = s.id

--Intensity
SELECT *
FROM Wellness..intensity
--Avg intensity throughout the day
SELECT Activity_time, CAST(AVG(CAST(AverageIntensity as float)) as DECIMAL(18,3)) AS Avg_intensity
FROM(	SELECT Id, CAST(ActivityHour as time(0)) as Activity_time, AverageIntensity
	FROM Wellness..intensity) AS Time_period
GROUP BY Activity_time
ORDER BY Activity_time

SELECT Activity_time, CAST(AVG(CAST(TotalIntensity as float)) as DECIMAL(18,3)) AS Duration
FROM(	SELECT Id, CAST(ActivityHour as time(0)) as Activity_time, TotalIntensity
	FROM Wellness..intensity) AS Time_period
GROUP BY Activity_time
ORDER BY Activity_time
