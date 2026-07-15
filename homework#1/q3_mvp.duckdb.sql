with player_teams_appearances as 
    (
        select *
        from people p
        join appearances a
            on p.playerID = a.playerID
        join teams t
            on t.teamID = a.teamID
            and t.yearID = a.yearID
            
    ),
    gold_glove_players as (
        select *
        from player_teams_appearances p
        join awardsplayers a
            on a.playerID = p.playerID
            and p.yearID = a.yearID
        where 
            a.yearID > 1999 and
            awardID = 'Gold Glove'
    ),
    t_batting_avgs as (
        select teamID, avg(G_batting) as batting_avg
        from appearances a
        where teamID 
            in (
                select teamID
                from gold_glove_players
            )
            and a.yearID > 1999
        group by teamID
    )
select nameGiven, teamID, count(distinct yearID) distinct_years
from gold_glove_players g
where g.G_batting > (
    select batting_avg
    from t_batting_avgs t
    where t.teamID = g.teamID
)
group by nameGiven, teamID
order by distinct_years desc, nameGiven asc
limit 10
;
