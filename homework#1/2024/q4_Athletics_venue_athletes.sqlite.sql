-- explain query plan
-- with 
--     all_athletes as (
--         select name, athletes.code as a_c, teams.code as t_c, athletes.country_code, athletes.nationality_code
--         from athletes
--         left join teams on teams.athletes_code = athletes.code
--     ),
--     results_from_venues_hosting_athletics as (
--         select results.participant_code as p_c
--         from results
--         join venues on results.venue = venues.venue
--         where venues.disciplines like "%Athletics%"
--     )
-- select * 
-- from results_from_venues_hosting_athletics as r
-- join all_athletes as a on r.p_c = a.a_c or r.p_c = a.t_c
-- group by name;

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
select * 
from results_from_venues_hosting_athletics as r
join all_athletes as a on a.code = r.participant_code
join countries on 
group by name
order by ;

select count(*)
from athletes a
where a.country_code <> a.nationality_code;
