with teams_winning_players as
    (
        select appearances.yearID, appearances.teamID, appearances.lgID, count(distinct appearances.playerID) c
        from appearances
        join awardsplayers
            on appearances.playerID = awardsplayers.playerID
            and appearances.yearID = awardsplayers.yearID
        group
            by appearances.yearID, 
            appearances.teamID,
            appearances.lgID
        having
            c > 5
    ),
    awarded_team_managers as
    (
        select distinct managers.lgID, managers.playerID as managerID, managers.teamID, managers.yearID
        from awardsmanagers
        join managers
            on awardsmanagers.yearID = managers.yearID
            and awardsmanagers.playerID = managers.playerID
    )
select *
from awarded_team_managers
;
