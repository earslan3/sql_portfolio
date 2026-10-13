with facebook_a_b_d as (
    select 
        fads.ad_date,
        fads.url_parameters,
        fads.spend,
        fads.impressions,
        fads.reach,
        fads.clicks,
        fads.leads,
        fads.value
    from facebook_ads_basic_daily fads
    left join facebook_adset fa ON fa.adset_id = fads.adset_id
    left join facebook_campaign fca ON fca.campaign_id = fads.campaign_id
),
face_gog_ads AS (
    select ad_date, url_parameters, spend, impressions, reach, clicks, leads, value
    from google_ads_basic_daily
    union all
    select ad_date, url_parameters, spend, impressions, reach, clicks, leads, value
    from facebook_a_b_d
),
monthly_data as (
select date_trunc('month', ad_date)::date as ad_month,
		case
			when lower(substring(url_parameters from 'utm_campaign=([^&]+)')) = 'nan' 
			then null  
			else lower(substring(url_parameters from 'utm_campaign=([^&]+)'))
			end as utm_campaign,
				sum(coalesce(spend, 0)) as total_spend,
    		    sum(coalesce(impressions, 0)) as total_imp,
    		    sum(coalesce(clicks, 0)) as total_clicks,
    		    sum(coalesce(value, 0)) as total_value,
        case
        	when sum(impressions) > 0 
        	then round(sum(clicks) * 100.0 / sum(impressions),2)
        	else 0
            end as ctr,
        case
        	when sum(clicks) > 0 
        	then round(sum(spend) / sum(clicks),2)
        	else 0
            end as cpc,
        case
        	when sum(impressions) > 0 
        	then round(sum(spend) / sum(impressions) * 1000,2)
        	else 0
            end as cpm,
        case
        	when sum(spend)> 0 
        	then round((sum(value) - sum(spend)) * 100.0 / sum(spend), 2)
        	else 0
            end as romi
from face_gog_ads
group by
    date_trunc('month', ad_date)::date,
    	case
        when lower(substring(url_parameters from 'utm_campaign=([^&]+)')) = 'nan'
        then null
        else lower(substring(url_parameters from'utm_campaign=([^&]+)'))
    	end
        )
select
	ad_month,
	utm_campaign,
	total_spend,
	total_imp,
	total_clicks,
	ctr,
	cpc,
	cpm,
	romi,
	round(
        (cpm - lag(cpm) over (partition by utm_campaign order by ad_month)) * 100.0 / nullif(lag(cpm) over (partition by utm_campaign order by ad_month), 0), 2 ) as cpm_diff_pct,
    round(
        (ctr - lag(ctr) over (partition by utm_campaign order by ad_month)) * 100.0 / nullif(lag(ctr) over (partition by utm_campaign order by ad_month), 0), 2 ) as ctr_diff_pct,
    round(
        (romi - lag(romi) over (partition by utm_campaign order by ad_month)) * 100.0 / nullif(lag(romi) over (partition by utm_campaign order by ad_month), 0), 2 ) as romi_diff_pct
from monthly_data
order by utm_campaign, ad_month;

        
        
        
        
		