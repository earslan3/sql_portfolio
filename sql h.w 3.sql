with face_google_ads as
(
select ad_date,
spend,
impressions,
reach,
clicks,
leads,
value,
'Facebook Ads' as media_source
from facebook_ads_basic_daily
union
select ad_date,
spend,
impressions,
reach,
clicks,
leads,
value,
'Google Ads' as media_source
from google_ads_basic_daily
)
select ad_date,
media_source,
SUM(spend) as total_spend,
SUM(impressions) as total_impressions,
SUM(clicks) as total_clicks,
SUM(value) as total_value
from face_google_ads 
group by ad_date,
media_source
order by ad_date,
media_source;



select ad_date,
campaign_name,
adset_name,
SUM(impressions) as total_imp,
SUM(reach) as total_reach,
SUM(clicks) as total_clicks,
SUM(leads) as total_leads,
SUM(value) as total_value
from face_ca_ad_hm4 
group by ad_date,
campaign_name,
adset_name
order by ad_date,
campaign_name,
adset_name;



union all

with google_ads_hm4 as
(
select ad_date,
campaign_name,
adset_name,
impressions,
reach,
clicks,
leads,
value
from google_ads_basic_daily

)





select ad_date,
campaign_name,
adset_name,
SUM(impressions) as total_imp,
SUM(reach) as total_reach,
SUM(clicks) as total_clicks,
SUM(leads) as total_leads,
SUM(value) as total_value
from face_ca_ad_hm4
group by ad_date,
campaign_name,
adset_name
order by ad_date,
campaign_name,
adset_name;




union all
select ad_date,
campaign_name,
adset_name,
impressions,
reach,
clicks,
leads,
value
from google_ads_basic_daily


select ad_date as reklam_tarihi,
'Google Ads / Facebook Ads' as media_source,
campaign_name as kampanya_adi,
adset_name as reklam_adi
from face_google_tot;
