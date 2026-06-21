select name, sum(count) as sum
from (
    select count(*) as count, athletes.name
    from athletes
    join medals on athletes.code = medals.winner_code
    where athletes.disciplines like "%judo%"
    group by athletes.name
    union all
    select count(*) as count, athletes.name 
    from teams
    join athletes on teams.athletes_code = athletes.code
    join medals on teams.code = medals.winner_code
    where athletes.disciplines like "%judo%"
    group by athletes.name 
)
group by name
order by sum desc, name;
