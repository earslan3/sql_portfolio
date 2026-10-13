with face_ca_ad_hm4 as
(
select f.ad_date,
ca.campaign_name,
ad.adset_name,
f.spend,
f.impressions,
f.reach,
f.clicks,
f.leads,
f.value,
'Facebook Ads' as media_source
from facebook_ads_basic_daily f
left join facebook_adset ad on ad.adset_id =f.adset_id
left join facebook_campaign ca  on ca.campaign_id =f.campaign_id
union all
select ad_date,
campaign_name,
adset_name,
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
campaign_name,
adset_name,
SUM(spend) as tot_spend,
SUM(impressions) as tot_imp,
SUM(clicks) as tot_clicks,
SUM(value) as tot_value
from face_ca_ad_hm4
group by ad_date,
media_source,
campaign_name,
adset_name
order by ad_date,
media_source,
campaign_name,
adset_name;




