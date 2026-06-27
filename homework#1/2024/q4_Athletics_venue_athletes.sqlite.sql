with 
    all_athletes as (
        select name, athletes.code, athletes.country_code, athletes.nationality_code
        from athletes
        union 
        select name, teams.code, teams.country_code, athletes.nationality_code
        from teams
        join athletes on athletes.code = teams.athletes_code
    ),
    results_from_venues_hosting_athletics as (
        select results.participant_code
        from results
        join venues on results.venue = venues.venue
        where venues.disciplines like '%''Athletics''%'
    )
select distinct name, ca.code, cb.code
from results_from_venues_hosting_athletics as r
join all_athletes as a on a.code = r.participant_code
join countries ca on ca.code = a.country_code
join countries cb on cb.code = a.nationality_code
where ca.Latitude not NULL and ca.Longitude not NULL
order by pow((ca.Latitude - cb.Latitude), 2) + pow((ca.Longitude - cb.Longitude), 2) desc,
    name asc;
