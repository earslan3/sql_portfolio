with facebook_a_b_d as (  
select fads.ad_date, fads.url_parameters,fads.spend,fads.impressions,fads.reach,fads.clicks,fads.leads,fads.value
from facebook_ads_basic_daily fads
left join facebook_adset fa on fa.adset_id = fads.adset_id
left join facebook_campaign fca on fca.campaign_id = fads.campaign_id 
	),
face_gog_ads as (
select ad_date,	
url_parameters,spend,impressions,reach,clicks,leads,value
from google_ads_basic_daily 
union all
select ad_date,	url_parameters,spend,impressions,reach,clicks,leads,value
from facebook_a_b_d
	)
select ad_date,
case
when LOWER(SUBSTRING(url_parameters from 'utm_campaign=([^&]+)')) = 'nan' then NULL
else LOWER(SUBSTRING(url_parameters from 'utm_campaign=([^&]+)')) end as utm_campaign_value,
sum(coalesce(spend,0)) as total_spend,
sum(coalesce(impressions,0)) as total_imp,
sum(coalesce(clicks,0)) as total_clicks,
sum(coalesce(value,0)) as total_value,
CASE
WHEN SUM(spend) > 0 THEN ROUND((SUM(value) - SUM(spend)) * 100.0 / SUM(spend), 2)
ELSE 0
END AS romi,
case
when sum(impressions) > 0 then round (sum(clicks) * 100.0 / sum(impressions),2)
else 0
end as ctr,
case
when sum(clicks) > 0 then round (sum(spend) / sum(clicks),2)
else 0
end as cpc,
case
when sum(impressions) > 0 then round (sum(spend) / sum(impressions) * 1000,2)
else 0
end as cpm
from face_gog_ads
group by ad_date,
utm_campaign_value
order by ad_date desc;
		