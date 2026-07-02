with 
    player_pa_schools as (
        select *
        from schools s
        join collegeplaying c
            on s.schoolid = c.schoolid
        join people p
            on p.playerid = c.playerid
        where s.state = 'PA'
        order by p.playerid desc
    )
select 
    (p.namefirst || ' (' || p.namegiven || ') ' || p.namelast) as name, 
    max(hr) as max_hr_appearance
from player_pa_schools p
join appearances a
    on p.playerid = a.playerid
group by
    p.playerid,
    p.namefirst,
    p.namelast,
    p.namegiven
order by 
    max_hr_appearance desc, 
    p.namefirst asc
limit 10;
