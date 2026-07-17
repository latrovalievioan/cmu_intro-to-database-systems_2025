with 
    teams_winning_players as (
        select 
            appearances.yearID, 
            appearances.teamID, 
            appearances.lgID, 
            count(distinct appearances.playerID) c
        from appearances
        join awardsplayers
            on appearances.playerID = awardsplayers.playerID
            and appearances.yearID = awardsplayers.yearID
            and appearances.lgID = awardsplayers.lgID
        group by 
            appearances.yearID, 
            appearances.teamID,
            appearances.lgID
        having c > 5
    ),
    awarded_team_managers as (
        -- distinct because a manager can have more than 1 awards for team year lgId
        select distinct 
            managers.lgID, 
            managers.playerID as managerID, 
            managers.teamID, 
            managers.yearID
        from awardsmanagers
        join managers
            on awardsmanagers.yearID = managers.yearID
            and awardsmanagers.playerID = managers.playerID
            and awardsmanagers.lgID = managers.lgID
    ),
    events as (
        select teams.lgID, teams.teamID, count(*) as distinct_years, teams.name as team_name
        from (
            select distinct teamID, yearID, lgID
            from teams_winning_players
            intersect
            select distinct teamID, yearID, lgID
            from awarded_team_managers
        ) as j
        join teams 
            on teams.teamID = j.teamID
            and teams.yearID = j.yearID
        group by teams.teamID, teams.lgID, teams.name
    )
select leagues.league, events.team_name, distinct_years
from events
join leagues on leagues.lgID = events.lgID
where active = 'Y' and distinct_years > 1
order by distinct_years desc, events.team_name asc;
