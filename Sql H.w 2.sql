--Task1
select DISTINCT ad_date,
campaign_id
from facebook_ads_basic_daily

--Task 2
select ad_date,
campaign_id,
SUM(SPEND) as toplam_harcama,
SUM(impressions) as gösterim_sayısı,
SUM(clicks) as tıklama_sayısı,
SUM(VALUE) as toplam_deger
from facebook_ads_basic_daily
where ad_date is not null
group by ad_date,
campaign_id;

--Task 3
select ad_date,
campaign_id,
SUM(SPEND)::numeric/Sum(clicks)::numeric as cpc,
SUM(SPEND)::numeric/sum(impressions) * 1000 as cpm,
SUM(clicks)::numeric/sum(impressions) * 100 as ctr,
((sum(value)::numeric -sum(spend)::numeric) / sum(spend)::numeric) * 100 as ROMI
from facebook_ads_basic_daily
where clicks > 0
group by ad_date,
campaign_id
order by ad_date, campaign_id;

