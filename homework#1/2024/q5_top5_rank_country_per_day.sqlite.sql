with 
    ranked_countries as (
        select 
            code,
            rank() over (order by "GDP ($ per capita)" desc) as gdp_rank,
            rank() over (order by Population desc) as pop_rank
        from countries
        where Population is not null and "GDP ($ per capita)" is not null
    ),
    all_participants as (
        select code, country_code
        from athletes
        union
        select teams.code, teams.country_code
        from athletes
        join teams on teams.athletes_code = athletes.code
    ),
    participating_countries as (
        select 
            ap.code as p_code, 
            c.code as c_code,
            gdp_rank,
            pop_rank
        from all_participants ap
        join ranked_countries c on ap.country_code = c.code
    ),
    countries_with_top5 as (
        select 
            date, 
            pc.c_code, 
            count(*) as top5,
            pc.gdp_rank, pc. pop_rank
        from participating_countries pc
        join results r on pc.p_code = r.participant_code
        where 
            rank < 6
        group by 
            c_code,
            date
    )
select date, c_code, top5, gdp_rank, pop_rank
from (
    select *, row_number() over (
        partition by date 
        order by top5 desc
    ) as rn
    from countries_with_top5
)
where rn = 1
order by date asc;
