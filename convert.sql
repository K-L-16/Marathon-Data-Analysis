select * from showproject.ultracleanedupdate_output;

select count(distinct State) as distinct_count
from ultracleanedupdate_output;

select Gender, avg(Total_Minutes) as avg_time
from ultracleanedupdate_output
group by Gender;

select Gender, min(Age) as youngest, max(Age) as oldest
from ultracleanedupdate_output
group by Gender;

with age_buckets as (
  select Total_Minutes,
         case
           when Age < 30 then 'age_20_29'
           when Age < 40 then 'age_30_39'
           when Age < 50 then 'age_40_49'
           when Age < 60 then 'age_50_59'
           else 'age_60+'
         end as age_group
  from ultracleanedupdate_output
)
select age_group, avg(Total_Minutes) as avg_rave_time
from age_buckets
group by age_group;

with gender_rank as(
    select rank() over (partition by ultracleanedupdate_output.Gender order by ultracleanedupdate_output.Total_Minutes asc )as gender_rank,
           ultracleanedupdate_output.fullname,
           ultracleanedupdate_output.Gender,
           ultracleanedupdate_output.Total_Minutes
    from ultracleanedupdate_output
)

select *
from gender_rank
where gender_rank < 4
order by Total_Minutes;