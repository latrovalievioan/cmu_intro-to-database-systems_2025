with
    all_participants as (
        select code as w_code, country_code as c_code
        from athletes
        union
        select code as w_code, country_code as c_code
        from teams
    ),
    gold_medals_per_country as (
        select c_code, count(*) as gold_medal
        from all_participants 
        join medals m on w_code = m.winner_code
        where m.medal_code = 1
        group by c_code
    ),
    top_improvers as (
        select pm.c_code, (pm.gold_medal - tm.gold_medal) as diff
        from tokyo_medals tm
        join gold_medals_per_country pm on tm.country_code = pm.c_code
        order by diff desc
        limit 5
    ),
    all_female_teams as (
        select t.code, t.country_code, a.gender
        from teams t
        join athletes a on t.athletes_code = a.code
        group by t.code
        having min(gender) = 1
    )
select
    top_improvers.c_code,
    diff,
    all_female_teams.code as t_code
from all_female_teams
join top_improvers on all_female_teams.country_code = top_improvers.c_code
order by
    diff desc,
    c_code asc,
    t_code asc
