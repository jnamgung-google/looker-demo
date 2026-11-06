view: minor_hotel_performance {
  label: "Minor Hotels Portfolio Performance"
  derived_table: {
    sql:
      WITH properties AS (
        SELECT
          'MINT-TH-01' AS property_code,
          'Anantara Siam Bangkok Hotel' AS property_name,
          'Anantara Hotels & Resorts' AS brand_name,
          'Thailand & Indochina' AS region_name,
          'Bangkok, Thailand' AS country_city,
          'Luxury Urban Flagship' AS property_tier,
          'Somchai Rattanakul' AS general_manager,
          'Arthit Charoenpong (SVP Global Key Accounts)' AS vip_account_director,
          'Base 3.0% Total Rev + 8.5% GOP Incentive' AS owner_contract_structure,
          'Minor DISCOVERY App & Direct Web' AS primary_booking_channel,
          7900 AS base_avail_rooms,
          0.785 AS base_occ_rate,
          310.0 AS base_adr_usd,
          0.370 AS fb_rev_ratio,
          0.125 AS spa_rev_ratio,
          0.435 AS base_gop_margin,
          0.085 AS owner_fee_pct,
          0.410 AS discovery_direct_pct,
          88.4 AS base_nps_score,
          26.4 AS energy_kwh_per_night
        UNION ALL
        SELECT 'MINT-TH-02', 'Anantara Golden Triangle Elephant Camp', 'Anantara Hotels & Resorts', 'Thailand & Indochina', 'Chiang Rai, Thailand', 'Ultra-Luxury Experiential', 'Nattapong Suwan', 'Arthit Charoenpong (SVP Global Key Accounts)', 'Base 3.5% Total Rev + 9.5% GOP Incentive', 'Luxury Wholesale & Consortia', 1360, 0.740, 1150.0, 0.245, 0.265, 0.475, 0.095, 0.440, 94.2, 24.1 UNION ALL
        SELECT 'MINT-TH-03', 'Avani+ Riverside Bangkok Hotel', 'Avani Hotels & Resorts', 'Thailand & Indochina', 'Bangkok, Thailand', 'Upscale Lifestyle & MICE', 'Kanda Vichit', 'Pimchanok Lek (VP APAC Corporate MICE)', 'Base 2.5% Total Rev + 7.0% GOP Incentive', 'Global GDS & Corporate MICE', 5580, 0.810, 185.0, 0.550, 0.125, 0.395, 0.070, 0.355, 84.6, 19.8 UNION ALL
        SELECT 'MINT-VN-04', 'Anantara Hoi An Resort', 'Anantara Hotels & Resorts', 'Thailand & Indochina', 'Hoi An, Vietnam', 'Boutique Heritage Resort', 'Tran Minh Duc', 'Pimchanok Lek (VP APAC Corporate MICE)', 'Base 3.0% Total Rev + 8.0% GOP Incentive', 'Minor DISCOVERY App & Direct Web', 2100, 0.765, 295.0, 0.280, 0.160, 0.420, 0.080, 0.390, 89.5, 21.5 UNION ALL
        SELECT 'MINT-ES-05', 'NH Collection Madrid Eurobuilding', 'NH Collection', 'Europe & Americas', 'Madrid, Spain', 'Upper-Upscale Urban Congress', 'Carlos Mendoza', 'Elena Rostova (EVP European Consortia)', 'Base 2.8% Total Rev + 7.5% GOP Incentive', 'Global GDS & Corporate MICE', 9200, 0.825, 245.0, 0.360, 0.075, 0.390, 0.075, 0.365, 85.8, 18.4 UNION ALL
        SELECT 'MINT-IT-06', 'Anantara Palazzo Naiadi Rome Hotel', 'Anantara Hotels & Resorts', 'Europe & Americas', 'Rome, Italy', 'Luxury Historic Landmark', 'Lorenzo Conti', 'Elena Rostova (EVP European Consortia)', 'Base 3.2% Total Rev + 9.0% GOP Incentive', 'Minor DISCOVERY App & Direct Web', 5180, 0.795, 540.0, 0.265, 0.100, 0.430, 0.090, 0.405, 90.8, 25.2 UNION ALL
        SELECT 'MINT-PT-07', 'Tivoli Avenida Liberdade Lisboa', 'Tivoli Hotels & Resorts', 'Europe & Americas', 'Lisbon, Portugal', 'Luxury Heritage Urban', 'Joao Pereira', 'Marco Silva (VP Atlantic Leisure & GDS)', 'Base 3.0% Total Rev + 8.2% GOP Incentive', 'Minor DISCOVERY App & Direct Web', 6360, 0.805, 340.0, 0.290, 0.095, 0.415, 0.082, 0.385, 88.9, 21.8 UNION ALL
        SELECT 'MINT-NL-08', 'nhow Amsterdam RAI', 'nhow Hotels', 'Europe & Americas', 'Amsterdam, Netherlands', 'Creative Lifestyle & Convention', 'Pieter van Dijk', 'Marco Silva (VP Atlantic Leisure & GDS)', 'Base 2.5% Total Rev + 6.8% GOP Incentive', 'OTA Partners (Booking/Expedia)', 14500, 0.775, 195.0, 0.220, 0.045, 0.380, 0.068, 0.315, 83.4, 17.2 UNION ALL
        SELECT 'MINT-AE-09', 'Anantara The Palm Dubai Resort', 'Anantara Hotels & Resorts', 'Middle East & Indian Ocean', 'Dubai, UAE', 'Luxury Beachfront Resort', 'Tariq Al-Mansoor', 'Layla Al-Hashemi (SVP Gulf Royal & Diplomatic)', 'Base 3.2% Total Rev + 9.2% GOP Incentive', 'Minor DISCOVERY App & Direct Web', 6540, 0.835, 460.0, 0.310, 0.115, 0.445, 0.092, 0.425, 91.4, 29.5 UNION ALL
        SELECT 'MINT-MV-10', 'Anantara Kihavah Maldives Villas', 'Anantara Hotels & Resorts', 'Middle East & Indian Ocean', 'Baa Atoll, Maldives', 'Ultra-Luxury Overwater Villas', 'Aishath Ibrahim', 'Layla Al-Hashemi (SVP Gulf Royal & Diplomatic)', 'Base 3.8% Total Rev + 10.5% GOP Incentive', 'Luxury Wholesale & Consortia', 1785, 0.725, 1680.0, 0.285, 0.145, 0.485, 0.105, 0.450, 95.6, 31.0 UNION ALL
        SELECT 'MINT-AU-11', 'Oaks Melbourne on Market Hotel', 'Oaks Hotels, Resorts & Suites', 'Australasia & Africa', 'Melbourne, Australia', 'Serviced Suites & Extended Stay', 'Liam OConnor', 'Hannah Wright (VP ANZ Corporate Travel)', 'Base 2.2% Total Rev + 6.5% GOP Incentive', 'OTA Partners (Booking/Expedia)', 6250, 0.840, 165.0, 0.140, 0.030, 0.450, 0.065, 0.310, 82.9, 15.8 UNION ALL
        SELECT 'MINT-TZ-12', 'Elewana Serengeti Migration Camp', 'Elewana Collection', 'Australasia & Africa', 'Serengeti, Tanzania', 'Ultra-Luxury Safari Camp', 'Juma Mwangi', 'Hannah Wright (VP ANZ Corporate Travel)', 'Base 4.0% Total Rev + 11.0% GOP Incentive', 'Luxury Wholesale & Consortia', 450, 0.755, 1420.0, 0.220, 0.180, 0.490, 0.110, 0.460, 96.1, 13.5
      ),
      months AS (
        SELECT '2026-05' AS report_month, DATE '2026-05-01' AS report_date, 'FY26-Q2' AS fiscal_quarter, 0.88 AS rev_seasonality, 0.96 AS occ_seasonality, 0.92 AS adr_seasonality, 0.86 AS budget_seasonality UNION ALL
        SELECT '2026-06', DATE '2026-06-01', 'FY26-Q2', 0.94, 0.98, 0.96, 0.93 UNION ALL
        SELECT '2026-07', DATE '2026-07-01', 'FY26-Q3', 1.03, 1.02, 1.01, 1.01 UNION ALL
        SELECT '2026-08', DATE '2026-08-01', 'FY26-Q3', 1.06, 1.03, 1.03, 1.05 UNION ALL
        SELECT '2026-09', DATE '2026-09-01', 'FY26-Q3', 0.98, 0.99, 0.99, 1.00 UNION ALL
        SELECT '2026-10', DATE '2026-10-01', 'FY26-Q4', 1.11, 1.04, 1.07, 1.07
      ),
      calculated AS (
        SELECT
          CONCAT(p.property_code, '-', m.report_month) AS record_id,
          p.property_code,
          p.property_name,
          p.brand_name,
          p.region_name,
          p.country_city,
          p.property_tier,
          p.general_manager,
          p.vip_account_director,
          p.owner_contract_structure,
          p.primary_booking_channel,
          m.report_month,
          m.report_date,
          m.fiscal_quarter,
          CAST(p.base_avail_rooms AS INT64) AS available_room_nights,
          CAST(ROUND(p.base_avail_rooms * LEAST(0.96, p.base_occ_rate * m.occ_seasonality), 0) AS INT64) AS occupied_room_nights,
          ROUND(p.base_adr_usd * m.adr_seasonality, 2) AS realized_adr_usd,
          ROUND(p.base_avail_rooms * p.base_occ_rate * p.base_adr_usd * m.rev_seasonality, 0) AS room_revenue_usd,
          ROUND(p.base_avail_rooms * p.base_occ_rate * p.base_adr_usd * m.rev_seasonality * p.fb_rev_ratio, 0) AS fb_banquet_revenue_usd,
          ROUND(p.base_avail_rooms * p.base_occ_rate * p.base_adr_usd * m.rev_seasonality * p.spa_rev_ratio, 0) AS spa_ancillary_revenue_usd,
          ROUND(p.base_avail_rooms * p.base_occ_rate * p.base_adr_usd * (1.0 + p.fb_rev_ratio + p.spa_rev_ratio) * m.budget_seasonality, 0) AS property_static_budget_usd,
          p.base_gop_margin,
          p.owner_fee_pct,
          p.discovery_direct_pct,
          ROUND(p.base_nps_score + (m.occ_seasonality - 1.0) * 15.0, 1) AS guest_nps_score,
          ROUND(p.energy_kwh_per_night * m.occ_seasonality, 1) AS energy_kwh_per_night
        FROM properties p
        CROSS JOIN months m
      )
      SELECT
        record_id,
        property_code,
        property_name,
        brand_name,
        region_name,
        country_city,
        property_tier,
        general_manager,
        vip_account_director,
        owner_contract_structure,
        primary_booking_channel,
        report_month,
        report_date,
        fiscal_quarter,
        available_room_nights,
        occupied_room_nights,
        realized_adr_usd,
        room_revenue_usd,
        fb_banquet_revenue_usd,
        spa_ancillary_revenue_usd,
        (room_revenue_usd + fb_banquet_revenue_usd + spa_ancillary_revenue_usd) AS total_operating_revenue_usd,
        property_static_budget_usd,
        ROUND((room_revenue_usd + fb_banquet_revenue_usd + spa_ancillary_revenue_usd) * base_gop_margin, 0) AS gross_operating_profit_usd,
        ROUND((room_revenue_usd + fb_banquet_revenue_usd + spa_ancillary_revenue_usd) * owner_fee_pct, 0) AS owner_incentive_fee_usd,
        ROUND((room_revenue_usd + fb_banquet_revenue_usd + spa_ancillary_revenue_usd) * discovery_direct_pct, 0) AS discovery_direct_revenue_usd,
        guest_nps_score,
        energy_kwh_per_night
      FROM calculated ;;
  }

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
