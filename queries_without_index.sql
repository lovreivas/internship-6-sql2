--1
EXPLAIN ANALYZE
SELECT 
    t.name AS tournament_name,
    t.year AS year,
    t.location AS location,
    COALESCE(tm.name, 'Not finished') AS winner
FROM tournament t
LEFT JOIN team tm ON t.winner_team_id = tm.id; 
--Execution Time: 2.128 ms

--2
EXPLAIN ANALYZE
SELECT 
    tm.name AS team_name,
    tm.representative AS representative,
    tm.country AS country
FROM team tm
JOIN participation p ON tm.id = p.team_id
WHERE p.tournament_id = 1;
--Execution Time: 0.186 ms

--3
EXPLAIN ANALYZE
SELECT 
    first_name,
    last_name,
    birth_date,
    position
FROM player
WHERE team_id = 1;
--Execution Time: 0.138 ms

--4
EXPLAIN ANALYZE
SELECT 
    g.match_date,
    t1.name AS home_team,
    t2.name AS away_team,
    mt.name AS match_stage,
    g.home_score,
    g.away_score
FROM game g
JOIN team t1 ON g.home_team_id = t1.id
JOIN team t2 ON g.away_team_id = t2.id
JOIN match_type mt ON g.match_type_id = mt.id
WHERE g.tournament_id = 1;
--Execution Time: 0.393 ms

--5
EXPLAIN ANALYZE
SELECT 
    t.name AS tournament,
    mt.name AS stage,
    g.match_date,
    t1.name AS home_team,
    g.home_score,
    g.away_score,
    t2.name AS away_team
FROM game g
JOIN tournament t ON g.tournament_id = t.id
JOIN match_type mt ON g.match_type_id = mt.id
JOIN team t1 ON g.home_team_id = t1.id
JOIN team t2 ON g.away_team_id = t2.id
WHERE g.home_team_id = 1 OR g.away_team_id = 1;
--Execution Time: 0.327 ms

--6
EXPLAIN ANALYZE
SELECT 
    ge.minute,
    ge.event_type,
    p.first_name || ' ' || p.last_name AS player_name,
    ge.description
FROM game_event ge
JOIN player p ON ge.player_id = p.id
WHERE ge.game_id = 749
ORDER BY ge.minute;
--Execution Time: 0.338 ms

--7
EXPLAIN ANALYZE
SELECT 
    t.name AS team,
    p.first_name || ' ' || p.last_name AS player_name,
    ge.event_type AS card_type,
    g.match_date,
    ge.minute
FROM game_event ge
JOIN game g ON ge.game_id = g.id
JOIN player p ON ge.player_id = p.id
JOIN team t ON p.team_id = t.id
WHERE g.tournament_id = 1 
  AND ge.event_type IN ('YELLOW_CARD', 'RED_CARD');
--Execution Time: 0.819 ms

--8
EXPLAIN ANALYZE
SELECT 
    p.first_name || ' ' || p.last_name AS player_name,
    t.name AS team,
    COUNT(ge.id) AS total_goals
FROM game_event ge
JOIN game g ON ge.game_id = g.id
JOIN player p ON ge.player_id = p.id
JOIN team t ON p.team_id = t.id
WHERE g.tournament_id = 1 
  AND ge.event_type = 'GOAL'
GROUP BY p.id, t.name, p.first_name, p.last_name
ORDER BY total_goals DESC;
--Execution Time: 0.369 ms

--9
EXPLAIN ANALYZE
SELECT 
    t.name AS team,
    p.points AS points,
    p.standing AS standing,
    p.stage_reached
FROM participation p
JOIN team t ON p.team_id = t.id
WHERE p.tournament_id = 1
ORDER BY p.points DESC, p.standing ASC;
--Execution Time: 0.188 ms

--10
EXPLAIN ANALYZE
SELECT 
    t.name AS tournament,
    t.year,
    tm1.name AS home_team,
    g.home_score,
    g.away_score,
    tm2.name AS away_team,
    CASE 
        WHEN g.home_score > g.away_score THEN tm1.name
        WHEN g.away_score > g.home_score THEN tm2.name
        ELSE 'Draw/Penalties'
    END AS match_winner
FROM game g
JOIN match_type mt ON g.match_type_id = mt.id
JOIN tournament t ON g.tournament_id = t.id
JOIN team tm1 ON g.home_team_id = tm1.id
JOIN team tm2 ON g.away_team_id = tm2.id
WHERE mt.name ILIKE '%final%';
--Execution Time: 1.845 ms

--11
EXPLAIN ANALYZE
SELECT 
    mt.name AS match_type,
    COUNT(g.id) AS games_count
FROM match_type mt
LEFT JOIN game g ON mt.id = g.match_type_id
GROUP BY mt.name;
--Execution Time: 0.604 ms

--12
EXPLAIN ANALYZE
SELECT 
    t1.name AS home_team,
    t2.name AS away_team,
    mt.name AS match_type,
    g.home_score, 
    g.away_score
FROM game g
JOIN team t1 ON g.home_team_id = t1.id
JOIN team t2 ON g.away_team_id = t2.id
JOIN match_type mt ON g.match_type_id = mt.id
WHERE DATE(g.match_date) = '2003-06-26';
--Execution Time: 0.369 ms

--13
EXPLAIN ANALYZE
SELECT 
    p.first_name, 
    p.last_name, 
    COUNT(ge.id) as goal_count
FROM game_event ge
JOIN game g ON ge.game_id = g.id
JOIN player p ON ge.player_id = p.id
WHERE g.tournament_id = 1 AND ge.event_type = 'GOAL'
GROUP BY p.id
ORDER BY goal_count DESC;
--Execution Time: 0.331 ms

--14
EXPLAIN ANALYZE
SELECT 
    t.name AS tournament, 
    t.year, 
    p.standing AS final_standing
FROM participation p
JOIN tournament t ON p.tournament_id = t.id
WHERE p.team_id = 52;
--Execution Time: 0.116 ms

--15
EXPLAIN ANALYZE
SELECT 
    t.name AS tournament,
    CASE 
        WHEN g.home_score > g.away_score THEN t1.name
        ELSE t2.name 
    END AS final_winner
FROM game g
JOIN match_type mt ON g.match_type_id = mt.id
JOIN tournament t ON g.tournament_id = t.id
JOIN team t1 ON g.home_team_id = t1.id
JOIN team t2 ON g.away_team_id = t2.id
WHERE t.id = 1 AND mt.name ILIKE '%final%'
LIMIT 1;
--Execution Time: 0.200 ms

--16
EXPLAIN ANALYZE
SELECT 
    t.name AS tournament,
    COUNT(DISTINCT p.team_id) AS team_count,
    COUNT(DISTINCT pl.id) AS player_count
FROM tournament t
JOIN participation p ON t.id = p.tournament_id
JOIN team tm ON p.team_id = tm.id
JOIN player pl ON tm.id = pl.team_id
GROUP BY t.id;
--Execution Time: 3.859 ms

--17
EXPLAIN ANALYZE
WITH ScorerStats AS (
    SELECT 
        t.name AS team_name,
        p.first_name,
        p.last_name,
        COUNT(ge.id) AS goals
    FROM game_event ge
    JOIN player p ON ge.player_id = p.id
    JOIN team t ON p.team_id = t.id
    WHERE ge.event_type = 'GOAL'
    GROUP BY t.name, p.id
),
RankedScorers AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY team_name ORDER BY goals DESC) as rank
    FROM ScorerStats
)
SELECT team_name, first_name, last_name, goals
FROM RankedScorers
WHERE rank = 1;
--Execution Time: 0.944 ms

--18
EXPLAIN ANALYZE
SELECT 
    g.match_date,
    t1.name AS home_team,
    t2.name AS away_team,
    g.home_score,
    g.away_score
FROM game g
JOIN team t1 ON g.home_team_id = t1.id
JOIN team t2 ON g.away_team_id = t2.id
WHERE g.referee_id = 1;
--Execution Time: 0.224 ms