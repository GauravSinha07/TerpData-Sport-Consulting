USE BUDT702_Project_0501_01

-- What were the winning percentages over 21 years
WITH UMDMatches AS (
    -- Select matches where UMD is either the home or away team
    SELECT 
        m.matchId,
        m.matchSeason,
        m.matchHomeGoal,
        m.matchAwayGoal,
        CASE 
            WHEN r.resultHomeTeamId = 'T0001' THEN 'home'
            WHEN r.resultAwayTeamId = 'T0001' THEN 'away'
        END AS teamSide,
        r.resultHomeTeamId,
        r.resultAwayTeamId
    FROM [Soccer.Match]  AS m
    JOIN [Soccer.Result] AS r ON m.matchId = r.matchId
    WHERE r.resultHomeTeamId = 'T0001' OR r.resultAwayTeamId = 'T0001'
	AND m.matchHomeGoal IS NOT NULL
	AND m.matchAwayGoal IS NOT NULL
),
UMDResults AS (
    -- Determine if UMD won or lost the match
    SELECT 
        matchId,
        matchSeason,
        CASE
            WHEN teamSide = 'home' AND matchHomeGoal > matchAwayGoal THEN 1
            WHEN teamSide = 'away' AND matchAwayGoal > matchHomeGoal THEN 1
            ELSE 0
        END AS win
    FROM UMDMatches
),
SeasonStats AS (
    -- Calculate total matches and wins per season for UMD
    SELECT 
        matchSeason,
        SUM(win) AS totalWins,
        COUNT(*) AS totalMatches,
        ROUND((CAST(SUM(win) AS FLOAT) / CAST(COUNT(*) AS FLOAT)),2 )AS winPercentage
    FROM UMDResults
    GROUP BY matchSeason
)

SELECT matchSeason as 'Season', winPercentage as 'Wining Percentage'
FROM SeasonStats
ORDER BY winPercentage DESC;


-- What were the Goal scored and conceded each season?
SELECT 
    M.matchSeason As 'Season', 
    SUM(CASE 
        WHEN R.resultHomeTeamId = 'T0001' THEN M.matchHomeGoal 
        WHEN R.resultAwayTeamId = 'T0001' THEN M.matchAwayGoal 
        ELSE 0 
    END) AS 'Goals Scored', 
    SUM(CASE 
        WHEN R.resultHomeTeamId = 'T0001' THEN M.matchAwayGoal    
        WHEN R.resultAwayTeamId = 'T0001' THEN M.matchHomeGoal 
        ELSE 0 
    END) AS 'Goals conceded'
FROM [Soccer.Match] M
JOIN [Soccer.Result] R ON M.matchId = R.matchId
WHERE R.resultHomeTeamId = 'T0001' OR R.resultAwayTeamId = 'T0001'
GROUP BY M.matchSeason
ORDER BY M.matchSeason;


--What were the wining percentages against each opponents
WITH MatchResults AS (
    SELECT 
        R.resultHomeTeamId AS homeTeam, 
        R.resultAwayTeamId AS awayTeam, 
        M.matchHomeGoal, 
        M.matchAwayGoal,
        R.locationId,
        CASE 
            WHEN R.resultHomeTeamId = 'T0001' AND M.matchHomeGoal > M.matchAwayGoal THEN 'win'
            WHEN R.resultAwayTeamId = 'T0001' AND M.matchAwayGoal > M.matchHomeGoal THEN 'win'
            WHEN (R.resultHomeTeamId = 'T0001' OR R.resultAwayTeamId = 'T0001') AND M.matchHomeGoal = M.matchAwayGoal THEN 'draw'
            ELSE 'loss'
        END AS result,
        CASE
            WHEN R.resultHomeTeamId = 'T0001' THEN R.resultAwayTeamId
            WHEN R.resultAwayTeamId = 'T0001' THEN R.resultHomeTeamId
        END AS opponentTeamId
    FROM [Soccer.Match] M
    JOIN [Soccer.Result] R ON M.matchId = R.matchId
    WHERE R.resultHomeTeamId = 'T0001' OR R.resultAwayTeamId = 'T0001'
)

SELECT 
    T.teamName AS 'Opponent',
	    COUNT(*) AS 'Total Matches',
    SUM(CASE WHEN result = 'win' THEN 1 ELSE 0 END) AS Wins,
    ROUND((CAST(SUM(CASE WHEN result = 'win' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) * 100,2) AS WinningPercentage
FROM MatchResults MR
JOIN [Soccer.Team] T ON MR.opponentTeamId = T.teamId
GROUP BY T.teamName
ORDER BY WinningPercentage DESC;



--What were the winning rate in each location
WITH MatchResults AS (
    SELECT 
        R.resultHomeTeamId AS homeTeam, 
        R.resultAwayTeamId AS awayTeam, 
        M.matchHomeGoal, 
        M.matchAwayGoal,
        R.locationId,
        CASE 
            WHEN R.resultHomeTeamId = 'T0001' AND M.matchHomeGoal > M.matchAwayGoal THEN 'win'
            WHEN R.resultAwayTeamId = 'T0001' AND M.matchAwayGoal > M.matchHomeGoal THEN 'win'
            WHEN (R.resultHomeTeamId = 'T0001' OR R.resultAwayTeamId = 'T0001') AND M.matchHomeGoal = M.matchAwayGoal THEN 'draw'
            ELSE 'loss'
        END AS result
    FROM [Soccer.Match] M
    JOIN [Soccer.Result]  R ON M.matchId = R.matchId
    WHERE R.resultHomeTeamId = 'T0001' OR R.resultAwayTeamId = 'T0001'
)

SELECT 
    L.locationCity AS 'City',
    L.locationState AS 'State',
    SUM(CASE WHEN result = 'win' THEN 1 ELSE 0 END) AS Wins,
    COUNT(*) AS 'Total Matches',
    ROUND((CAST(SUM(CASE WHEN result = 'win' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) * 100,2 )AS 'Winning Percentage'
FROM MatchResults MR
JOIN [Soccer.Location] L ON MR.locationId = L.locationId
GROUP BY L.locationCity, L.locationState
ORDER BY 'Winning Percentage' DESC;



