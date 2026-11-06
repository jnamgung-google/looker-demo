view: minor_hotel_performance {
  label: "Minor Hotels Portfolio Performance"
  sql_table_name: `eco-shift-478607-e5.minor_hotels_demo.minor_hotel_performance` ;;

  # =========================================================================
  # PRIMARY KEY (First Dimension for Symmetric Aggregates)
  # =========================================================================

  dimension: record_id {
    primary_key: yes
    type: string
    label: "Record ID (PK)"
    description: "Unique composite primary key (Property Code + Reporting Month) for Minor Hotels performance records."
    sql: ${TABLE}.record_id ;;
  }

  # =========================================================================
  # INTERACTIVE PARAMETERS (RLS/CLS Role Simulator & What-If Revenue Engine)
  # =========================================================================

  parameter: rls_role_persona {
    type: string
    label: "🔐 Demo RLS & CLS Role Simulator"
    description: "Simulate Row-Level Security (RLS) row filtering and Column-Level Security (CLS) field masking across different Minor Hotels user personas."
    default_value: "AllCorporateHQ"
    allowed_value: {
      label: "1. Global Corporate BI & Executive HQ (All 12 Properties | Unmasked CLS)"
      value: "AllCorporateHQ"
    }
    allowed_value: {
      label: "2. Regional VP — Thailand & Indochina (4 Asia Properties | CLS Masked Fees)"
      value: "RVPThailandAsia"
    }
    allowed_value: {
      label: "3. Regional VP — Europe & Americas (4 Europe Properties | CLS Masked Fees)"
      value: "RVPEuropeAmericas"
    }
    allowed_value: {
      label: "4. Regional VP — Middle East, Africa & ANZ (4 ME/ANZ Properties | CLS Masked Fees)"
      value: "RVPMiddleEastAfrica"
    }
    allowed_value: {
      label: "5. Property GM — Anantara Siam Bangkok Only (Single Hotel RLS | Strict CLS)"
      value: "GMAnantaraSiamBKK"
    }
  }

  parameter: what_if_adr_change_pct {
    type: number
    label: "🎛️ What-If ADR Uplift Simulator (%)"
    description: "Simulate the revenue and GOP impact of adjusting Average Daily Rate (ADR) across the portfolio."
    default_value: "0.05"
    allowed_value: { label: "-10% ADR Stress Test" value: "-0.10" }
    allowed_value: { label: "-5% Promotional Discount" value: "-0.05" }
    allowed_value: { label: "0% Baseline Actuals" value: "0.0" }
    allowed_value: { label: "+5% High-Season Yield Uplift (Default)" value: "0.05" }
    allowed_value: { label: "+10% Luxury Suite Repositioning" value: "0.10" }
    allowed_value: { label: "+15% Peak Event Surge Pricing" value: "0.15" }
  }

  parameter: what_if_occupancy_change_pct {
    type: number
    label: "🎛️ What-If Occupancy Shift Simulator (%)"
    description: "Simulate the revenue impact of shifting portfolio Occupancy Rate via Minor DISCOVERY campaigns."
    default_value: "0.03"
    allowed_value: { label: "-5% Demand Softness" value: "-0.05" }
    allowed_value: { label: "0% Baseline Occupancy" value: "0.0" }
    allowed_value: { label: "+3% Direct Loyalty Push (Default)" value: "0.03" }
    allowed_value: { label: "+5% Corporate MICE Recovery" value: "0.05" }
    allowed_value: { label: "+8% Peak Holiday Compression" value: "0.08" }
  }

  # =========================================================================
  # CORE PORTFOLIO & PROPERTY DIMENSIONS
  # =========================================================================

  dimension: property_code {
    type: string
    label: "Property Code"
    description: "Official Minor Hotels property code."
    sql: ${TABLE}.property_code ;;
  }

  dimension: property_name {
    type: string
    label: "Hotel Property Name"
    description: "Name of the Minor Hotels resort or urban property."
    sql: ${TABLE}.property_name ;;
    drill_fields: [brand_name, country_city, report_month, primary_booking_channel]
  }

  dimension: brand_name {
    type: string
    label: "Hotel Brand"
    description: "Minor Hotels portfolio brand (Anantara, Avani, NH Collection, Tivoli, nhow, Oaks, Elewana)."
    sql: ${TABLE}.brand_name ;;
    drill_fields: [property_name, country_city, report_month]
  }

  dimension: region_name {
    type: string
    label: "Global Operating Region"
    description: "Geographic operating theatre used for Regional VP Row-Level Security (RLS) governance."
    sql: ${TABLE}.region_name ;;
    drill_fields: [brand_name, property_name, country_city]
  }

  dimension: country_city {
    type: string
    label: "Destination (City & Country)"
    description: "City and country location of the hotel property."
    sql: ${TABLE}.country_city ;;
  }

  # [RLS Target Dimension] Country dimension mapped to `user_attribute: country`
  # Example: 'Bangkok, Thailand' -> 'Thailand', 'Madrid, Spain' -> 'Spain'
  dimension: country {
    type: string
    label: "Country (RLS Target)"
    description: "Operating country extracted from Destination (e.g., Thailand, Vietnam, Spain, Italy, Portugal, Netherlands, UAE, Maldives, Australia, Tanzania). Used for user_attribute: country Row-Level Security (RLS)."
    sql: TRIM(SPLIT(${TABLE}.country_city, ',')[SAFE_OFFSET(1)]) ;;
    drill_fields: [property_name, brand_name, country_city]
  }

  dimension: property_tier {
    type: string
    label: "Asset Tier & Operating Profile"
    description: "Hospitality asset positioning classification (e.g., Ultra-Luxury Experiential, Upper-Upscale Urban)."
    sql: ${TABLE}.property_tier ;;
  }

  dimension: general_manager {
    type: string
    label: "Property General Manager (GM)"
    description: "General Manager accountable for property budget submission and GOP delivery."
    sql: ${TABLE}.general_manager ;;
  }

  dimension: primary_booking_channel {
    type: string
    label: "Primary Distribution Channel"
    description: "Dominant booking source channel (Minor DISCOVERY App & Direct Web, Global GDS & MICE, Luxury Wholesale, OTA)."
    sql: ${TABLE}.primary_booking_channel ;;
  }

  dimension: report_month {
    type: string
    label: "Reporting Month (YYYY-MM)"
    description: "Reporting calendar month formatted as YYYY-MM."
    sql: ${TABLE}.report_month ;;
  }

  dimension_group: reporting_period {
    type: time
    label: "Reporting Date"
    description: "Reporting date dimension group for time-series trend analysis."
    timeframes: [raw, date, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
  }

  dimension: fiscal_quarter {
    type: string
    label: "Fiscal Quarter"
    description: "Minor International fiscal quarter (FY26-Q2, FY26-Q3, FY26-Q4)."
    sql: ${TABLE}.fiscal_quarter ;;
  }

  # =========================================================================
  # ROW-LEVEL SECURITY (RLS) & COLUMN-LEVEL SECURITY (CLS) DIMENSIONS
  # =========================================================================

  dimension: active_rls_persona_badge {
    type: string
    label: "Active RLS Security Scope"
    description: "Displays the active Row-Level Security (RLS) persona and row filter policy enforced on BigQuery."
    sql:
      CASE {% parameter rls_role_persona %}
        WHEN 'RVPThailandAsia' THEN 'RLS: Regional VP Asia (Thailand & Indochina Only)'
        WHEN 'RVPEuropeAmericas' THEN 'RLS: Regional VP Europe (Europe & Americas Only)'
        WHEN 'RVPMiddleEastAfrica' THEN 'RLS: Regional VP ME/Africa/ANZ (4 Properties)'
        WHEN 'GMAnantaraSiamBKK' THEN 'RLS: Property GM (Anantara Siam Bangkok Only)'
        ELSE 'RLS: Corporate HQ BI (Global Full Portfolio Access)'
      END ;;
    html:
      {% if value contains 'Corporate HQ' %}
        <span style="background:#ECFDF5; color:#047857; border:1px solid #6EE7B7; padding:3px 10px; border-radius:12px; font-weight:700; font-size:11px;">🌐 {{ value }}</span>
      {% else %}
        <span style="background:#FEF3C7; color:#9A3412; border:1px solid #F59E0B; padding:3px 10px; border-radius:12px; font-weight:700; font-size:11px;">🛡️ {{ value }}</span>
      {% endif %} ;;
  }

  dimension: vip_account_director_raw {
    hidden: yes
    type: string
    description: "Raw unmasked VIP account director name."
    sql: ${TABLE}.vip_account_director ;;
  }

  dimension: vip_account_director_cls_masked {
    type: string
    label: "VIP Account Lead (CLS Protected PII)"
    description: "Demonstrates Column-Level Security (CLS): masks VIP commercial lead PII for single-property GM roles under PDPA/GDPR policy."
    sql:
      CASE
        WHEN {% parameter rls_role_persona %} = 'GMAnantaraSiamBKK'
          THEN '🔒 [CLS MASKED — PDPA/GDPR Commercial PII]'
        ELSE ${vip_account_director_raw}
      END ;;
    html:
      {% if value contains 'CLS MASKED' %}
        <span style="background:#FEF2F2; color:#991B1B; border:1px solid #FCA5A5; padding:2px 8px; border-radius:6px; font-weight:700; font-size:11px;">{{ value }}</span>
      {% else %}
        <span style="color:#1C1917; font-weight:600;">👤 {{ value }}</span>
      {% endif %} ;;
  }

  dimension: owner_contract_structure_raw {
    hidden: yes
    type: string
    description: "Raw owner management fee contract terms."
    sql: ${TABLE}.owner_contract_structure ;;
  }

  dimension: owner_contract_structure_cls_masked {
    type: string
    label: "Owner Fee Contract Terms (CLS Protected)"
    description: "Demonstrates Column-Level Security (CLS): exposes confidential hotel owner fee structures only to Global Corporate HQ Finance."
    sql:
      CASE
        WHEN {% parameter rls_role_persona %} = 'AllCorporateHQ'
          THEN ${owner_contract_structure_raw}
        ELSE '🔒 [CLS MASKED — HQ Asset Management Only]'
      END ;;
    html:
      {% if value contains 'CLS MASKED' %}
        <span style="background:#FEF2F2; color:#991B1B; border:1px solid #FCA5A5; padding:2px 8px; border-radius:6px; font-weight:700; font-size:11px;">{{ value }}</span>
      {% else %}
        <span style="background:#F5F0E6; color:#9A3412; border:1px solid #C5A059; padding:2px 8px; border-radius:6px; font-weight:600; font-size:11px;">🔓 {{ value }}</span>
      {% endif %} ;;
  }

  # =========================================================================
  # METRIC BASE DIMENSIONS (Referenced by Measures per Best Practices)
  # =========================================================================

  dimension: available_room_nights {
    type: number
    label: "Available Room Nights"
    description: "Total available room inventory nights for the property and month."
    sql: ${TABLE}.available_room_nights ;;
    value_format_name: decimal_0
  }

  dimension: occupied_room_nights {
    type: number
    label: "Occupied Room Nights (Rooms Sold)"
    description: "Total occupied room nights sold during the reporting month."
    sql: ${TABLE}.occupied_room_nights ;;
    value_format_name: decimal_0
  }

  dimension: realized_adr_usd {
    type: number
    label: "Property Realized ADR ($)"
    description: "Average Daily Rate (ADR) in USD for the property-month."
    sql: ${TABLE}.realized_adr_usd ;;
    value_format_name: usd
  }

  dimension: room_revenue_usd {
    type: number
    label: "Rooms Revenue ($)"
    description: "Total rooms division revenue in USD."
    sql: ${TABLE}.room_revenue_usd ;;
    value_format_name: usd_0
  }

  dimension: fb_banquet_revenue_usd {
    type: number
    label: "F&B and MICE Banquet Revenue ($)"
    description: "Total Food, Beverage, and MICE banquet revenue in USD."
    sql: ${TABLE}.fb_banquet_revenue_usd ;;
    value_format_name: usd_0
  }

  dimension: spa_ancillary_revenue_usd {
    type: number
    label: "Anantara Spa & Experiential Revenue ($)"
    description: "Total spa, wellness, safari, and ancillary guest experience revenue in USD."
    sql: ${TABLE}.spa_ancillary_revenue_usd ;;
    value_format_name: usd_0
  }

  dimension: total_operating_revenue_usd {
    type: number
    label: "Total Operating Revenue ($)"
    description: "Total property operating revenue across Rooms, F&B/Banquet, and Spa/Experiential divisions in USD."
    sql: ${TABLE}.total_operating_revenue_usd ;;
    value_format_name: usd_0
  }

  dimension: property_static_budget_usd {
    type: number
    label: "Baseline Static Property Budget ($)"
    description: "Initial annual baseline property operating budget in USD prior to live Looker write-back revisions."
    sql: ${TABLE}.property_static_budget_usd ;;
    value_format_name: usd_0
  }

  dimension: gross_operating_profit_usd {
    type: number
    label: "Gross Operating Profit — GOP ($)"
    description: "Property Gross Operating Profit (GOP) in USD after departmental and undistributed operating expenses."
    sql: ${TABLE}.gross_operating_profit_usd ;;
    value_format_name: usd_0
  }

  dimension: owner_incentive_fee_usd {
    type: number
    label: "Owner Management & Incentive Fee ($)"
    description: "Confidential hotel management and GOP incentive fee earned by Minor Hotels (governed by CLS)."
    sql: ${TABLE}.owner_incentive_fee_usd ;;
    value_format_name: usd_0
  }

  dimension: discovery_direct_revenue_usd {
    type: number
    label: "Minor DISCOVERY Direct Revenue ($)"
    description: "Operating revenue generated directly through Minor.com and GHA Minor DISCOVERY loyalty members."
    sql: ${TABLE}.discovery_direct_revenue_usd ;;
    value_format_name: usd_0
  }

  dimension: guest_nps_score {
    type: number
    label: "Guest Net Promoter Score (NPS)"
    description: "Verified post-stay guest satisfaction Net Promoter Score (0–100 scale)."
    sql: ${TABLE}.guest_nps_score ;;
    value_format_name: decimal_1
  }

  dimension: energy_kwh_per_night {
    type: number
    label: "Energy Intensity (kWh / Occupied Night)"
    description: "Property energy consumption in kWh per occupied room night for ESG tracking."
    sql: ${TABLE}.energy_kwh_per_night ;;
    value_format_name: decimal_1
  }

  # =========================================================================
  # CORE HOSPITALITY & FINANCIAL MEASURES
  # =========================================================================

  measure: property_count {
    type: count_distinct
    label: "Active Hotel Properties"
    description: "Count of distinct Minor Hotels properties visible under the active Row-Level Security (RLS) role."
    sql: ${property_code} ;;
    value_format_name: decimal_0
    drill_fields: [property_code, property_name, brand_name, region_name, total_revenue_usd, revpar_usd, gop_margin_pct]
  }

  measure: region_count {
    type: count_distinct
    label: "Visible Global Regions"
    description: "Count of distinct operating regions visible under the active Row-Level Security (RLS) role."
    sql: ${region_name} ;;
    value_format_name: decimal_0
  }

  measure: total_available_room_nights {
    type: sum
    label: "Total Available Room Nights"
    description: "Sum of available room nights across selected properties and months."
    sql: ${available_room_nights} ;;
    value_format_name: decimal_0
  }

  measure: total_occupied_room_nights {
    type: sum
    label: "Total Occupied Room Nights"
    description: "Sum of occupied room nights sold across selected properties and months."
    sql: ${occupied_room_nights} ;;
    value_format_name: decimal_0
  }

  measure: occupancy_rate_pct {
    type: number
    label: "Occupancy Rate (%)"
    description: "Portfolio Occupancy Rate calculated as Occupied Room Nights divided by Available Room Nights."
    sql: SAFE_DIVIDE(${total_occupied_room_nights}, ${total_available_room_nights}) ;;
    value_format_name: percent_1
    drill_fields: [brand_name, property_name, report_month, total_occupied_room_nights, total_available_room_nights, occupancy_rate_pct]
  }

  measure: total_room_revenue_usd {
    type: sum
    label: "Total Rooms Revenue ($)"
    description: "Total rooms division revenue in USD across selected properties."
    sql: ${room_revenue_usd} ;;
    value_format_name: usd_0
  }

  measure: total_fb_banquet_revenue_usd {
    type: sum
    label: "Total F&B and MICE Revenue ($)"
    description: "Total Food, Beverage, and MICE conference revenue in USD."
    sql: ${fb_banquet_revenue_usd} ;;
    value_format_name: usd_0
  }

  measure: total_spa_ancillary_revenue_usd {
    type: sum
    label: "Total Spa & Experiential Revenue ($)"
    description: "Total Anantara Spa, wellness, and experiential activity revenue in USD."
    sql: ${spa_ancillary_revenue_usd} ;;
    value_format_name: usd_0
  }

  measure: total_revenue_usd {
    type: sum
    label: "Total Portfolio Revenue ($)"
    description: "Consolidated Operating Revenue (Rooms + F&B/MICE + Spa/Experiential) in USD."
    sql: ${total_operating_revenue_usd} ;;
    value_format_name: usd_0
    drill_fields: [brand_name, property_name, country_city, report_month, total_revenue_usd, total_gop_usd, revpar_usd]
  }

  measure: total_static_budget_usd {
    type: sum
    label: "Baseline Static Budget ($)"
    description: "Sum of initial property static budget in USD prior to live BigQuery write-back overrides."
    sql: ${property_static_budget_usd} ;;
    value_format_name: usd_0
  }

  measure: adr_usd {
    type: number
    label: "ADR — Average Daily Rate ($)"
    description: "Portfolio Average Daily Rate (ADR) in USD, calculated as Total Rooms Revenue divided by Occupied Room Nights."
    sql: SAFE_DIVIDE(${total_room_revenue_usd}, ${total_occupied_room_nights}) ;;
    value_format_name: usd
    drill_fields: [brand_name, property_name, report_month, adr_usd, occupancy_rate_pct, revpar_usd]
  }

  measure: revpar_usd {
    type: number
    label: "RevPAR — Revenue Per Available Room ($)"
    description: "Portfolio Revenue Per Available Room (RevPAR) in USD, calculated as Total Rooms Revenue divided by Available Room Nights."
    sql: SAFE_DIVIDE(${total_room_revenue_usd}, ${total_available_room_nights}) ;;
    value_format_name: usd
    drill_fields: [brand_name, property_name, report_month, revpar_usd, adr_usd, occupancy_rate_pct]
  }

  measure: trevpar_usd {
    type: number
    label: "TRevPAR — Total Rev Per Available Room ($)"
    description: "Total Operating Revenue Per Available Room (TRevPAR) including Rooms, F&B, and Spa in USD."
    sql: SAFE_DIVIDE(${total_revenue_usd}, ${total_available_room_nights}) ;;
    value_format_name: usd
  }

  measure: total_gop_usd {
    type: sum
    label: "Gross Operating Profit — GOP ($)"
    description: "Consolidated Gross Operating Profit (GOP) in USD across selected properties."
    sql: ${gross_operating_profit_usd} ;;
    value_format_name: usd_0
    drill_fields: [brand_name, property_name, report_month, total_revenue_usd, total_gop_usd, gop_margin_pct]
  }

  measure: goppar_usd {
    type: number
    label: "GOPPAR — GOP Per Available Room ($)"
    description: "Gross Operating Profit Per Available Room (GOPPAR) in USD."
    sql: SAFE_DIVIDE(${total_gop_usd}, ${total_available_room_nights}) ;;
    value_format_name: usd
  }

  measure: gop_margin_pct {
    type: number
    label: "GOP Margin (%)"
    description: "Gross Operating Profit (GOP) as a percentage of Total Operating Revenue."
    sql: SAFE_DIVIDE(${total_gop_usd}, ${total_revenue_usd}) ;;
    value_format_name: percent_1
  }

  measure: total_discovery_direct_revenue_usd {
    type: sum
    label: "Minor DISCOVERY Direct Revenue ($)"
    description: "Total operating revenue generated via Minor.com and GHA DISCOVERY loyalty direct channels."
    sql: ${discovery_direct_revenue_usd} ;;
    value_format_name: usd_0
  }

  measure: discovery_direct_share_pct {
    type: number
    label: "Minor DISCOVERY Direct Share (%)"
    description: "Percentage of total operating revenue booked directly through Minor DISCOVERY loyalty channels."
    sql: SAFE_DIVIDE(${total_discovery_direct_revenue_usd}, ${total_revenue_usd}) ;;
    value_format_name: percent_1
  }

  measure: avg_guest_nps_score {
    type: average
    label: "Guest NPS Score"
    description: "Average Guest Net Promoter Score across selected properties and periods."
    sql: ${guest_nps_score} ;;
    value_format_name: decimal_1
  }

  measure: avg_energy_kwh_per_night {
    type: average
    label: "Avg Energy Intensity (kWh / Night)"
    description: "Average energy consumption (kWh per occupied room night) for Minor Green Growth ESG monitoring."
    sql: ${energy_kwh_per_night} ;;
    value_format_name: decimal_1
  }

  # =========================================================================
  # CLS-GOVERNED MEASURES (Column-Level Security Demonstration)
  # =========================================================================

  measure: total_owner_incentive_fee_unmasked_internal {
    hidden: yes
    type: sum
    description: "Internal unmasked sum of owner management and incentive fees."
    sql: ${owner_incentive_fee_usd} ;;
  }

  measure: total_owner_incentive_fee_cls_masked {
    type: number
    label: "Owner Incentive Fee ($ — CLS Governed)"
    description: "Demonstrates Column-Level Security (CLS): returns actual Owner Management & Incentive Fee ($) for Corporate HQ BI, and masks values (0 / Locked Badge) for Regional or Property roles."
    sql:
      CASE
        WHEN {% parameter rls_role_persona %} = 'AllCorporateHQ'
          THEN ${total_owner_incentive_fee_unmasked_internal}
        ELSE 0
      END ;;
    value_format_name: usd_0
    html:
      {% if rls_role_persona._parameter_value == "'AllCorporateHQ'" %}
        <span style="color:#047857; font-weight:700;">🔓 {{ rendered_value }}</span>
      {% else %}
        <span style="background:#FEF2F2; color:#991B1B; border:1px solid #FCA5A5; padding:2px 8px; border-radius:6px; font-weight:700; font-size:11px;">🔒 CLS MASKED (HQ Only)</span>
      {% endif %} ;;
  }

  # =========================================================================
  # LIVE BIGQUERY WRITE-BACK VARIANCE MEASURES (Power Apps Replacement)
  # =========================================================================

  measure: variance_vs_live_bq_budget_usd {
    type: number
    label: "Variance vs. Live BQ Budget ($)"
    description: "Real-time dollar variance between Actual Portfolio Revenue and the Live BigQuery Write-Back Budget Target."
    sql: ${total_revenue_usd} - ${minor_live_budget_writeback.total_live_budget_target_usd} ;;
    value_format_name: usd_0
    html:
      {% if value >= 0 %}
        <span style="color:#047857; font-weight:700;">▲ {{ rendered_value }}</span>
      {% else %}
        <span style="color:#B91C1C; font-weight:700;">▼ {{ rendered_value }}</span>
      {% endif %} ;;
  }

  measure: live_bq_budget_achievement_pct {
    type: number
    label: "Live BQ Budget Achievement (%)"
    description: "Percentage of the Live BigQuery Write-Back Budget Target achieved by Actual Portfolio Revenue."
    sql: SAFE_DIVIDE(${total_revenue_usd}, ${minor_live_budget_writeback.total_live_budget_target_usd}) ;;
    value_format_name: percent_1
    html:
      {% if value >= 1.0 %}
        <span style="background:#ECFDF5; color:#047857; border:1px solid #6EE7B7; padding:2px 8px; border-radius:10px; font-weight:700;">✅ {{ rendered_value }}</span>
      {% elsif value >= 0.95 %}
        <span style="background:#FFFBEB; color:#B45309; border:1px solid #FCD34D; padding:2px 8px; border-radius:10px; font-weight:700;">⚠️ {{ rendered_value }}</span>
      {% else %}
        <span style="background:#FEF2F2; color:#B91C1C; border:1px solid #FCA5A5; padding:2px 8px; border-radius:10px; font-weight:700;">🚨 {{ rendered_value }}</span>
      {% endif %} ;;
  }

  # =========================================================================
  # WHAT-IF SENSITIVITY SIMULATION MEASURES
  # =========================================================================

  measure: simulated_what_if_revenue_usd {
    type: number
    label: "Simulated What-If Portfolio Revenue ($)"
    description: "Projected portfolio revenue factoring in interactive What-If ADR and Occupancy Simulator adjustments."
    sql:
      (${total_room_revenue_usd} * (1.0 + {% parameter what_if_adr_change_pct %}) * (1.0 + {% parameter what_if_occupancy_change_pct %}))
      + (${total_fb_banquet_revenue_usd} * (1.0 + {% parameter what_if_occupancy_change_pct %}))
      + (${total_spa_ancillary_revenue_usd} * (1.0 + {% parameter what_if_occupancy_change_pct %})) ;;
    value_format_name: usd_0
  }

  measure: simulated_what_if_gop_usd {
    type: number
    label: "Simulated What-If GOP ($)"
    description: "Projected Gross Operating Profit (GOP) assuming 75% flow-through on ADR gains and 55% flow-through on volume gains."
    sql:
      ${total_gop_usd}
      + ((${total_room_revenue_usd} * {% parameter what_if_adr_change_pct %}) * 0.75)
      + ((${total_revenue_usd} * {% parameter what_if_occupancy_change_pct %}) * 0.55) ;;
    value_format_name: usd_0
  }
}
