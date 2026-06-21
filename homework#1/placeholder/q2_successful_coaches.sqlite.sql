explain query plan
select name, count(*) as count
from (
    select coaches.*
    from medals
    join athletes on medals.winner_code = athletes.code
    join coaches on athletes.country_code = coaches.country_code and medals.discipline = coaches.discipline
    UNION ALL
    select coaches.*
    from medals
    join (select distinct code, country_code from teams) as teams on medals.winner_code = teams.code
    join coaches on teams.country_code = coaches.country_code and medals.discipline = coaches.discipline
)
group by code, name
order by count desc, name asc;
