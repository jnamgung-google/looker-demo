view: minor_brand_targets {
  label: "Minor Brand Strategic Targets"
  derived_table: {
    sql:
      SELECT * FROM UNNEST([
        STRUCT(
          'Anantara Hotels & Resorts' AS brand_name,
          'Ultra-Luxury & Indigenous Experiential' AS brand_positioning,
          'Indigenous Luxury Resorts & Flagship Urban Icons' AS brand_segment_focus,
          0.425 AS target_gop_margin_pct,
          0.380 AS target_discovery_direct_share_pct,
          0.115 AS owner_wacc_hurdle_pct,
          445.0 AS target_revpar_usd,
          28.5 AS sustainability_target_kwh_per_night
        ),
        STRUCT('Avani Hotels & Resorts', 'Upscale Contemporary Lifestyle', 'Millennial-Minded Upscale Resorts & MICE', 0.390, 0.340, 0.105, 165.0, 21.0),
        STRUCT('NH Collection', 'Upper-Upscale Urban Landmark', 'Gateway European & Latin American City Centers', 0.385, 0.350, 0.100, 225.0, 19.5),
        STRUCT('Tivoli Hotels & Resorts', 'Timeless Heritage & Cosmopolitan Luxury', 'Historic European & Cultural Leisure Destinations', 0.405, 0.360, 0.108, 295.0, 23.0),
        STRUCT('nhow Hotels', 'Disruptive Design & Creative Lifestyle', 'High-Energy Convention & Cultural Hubs', 0.375, 0.320, 0.098, 175.0, 18.0),
        STRUCT('Oaks Hotels, Resorts & Suites', 'Upper-Midscale Serviced Apartments', 'Extended Stay & Regional Corporate Suites', 0.440, 0.300, 0.095, 145.0, 16.5),
        STRUCT('Elewana Collection', 'Ultra-Luxury Boutique Safari & Conservation', 'East African Iconic Bush Camps & Lodges', 0.460, 0.420, 0.125, 820.0, 14.0)
      ]) ;;
  }

  dimension: brand_name {
    primary_key: yes
    type: string
    label: "Brand Name"
    description: "Unique Minor Hotels brand identifier (Primary Key for Brand Strategic Targets)."
    sql: ${TABLE}.brand_name ;;
  }

  dimension: brand_positioning {
    type: string
    label: "Brand Tier & Positioning"
    description: "Strategic hospitality tier and market positioning across the Minor Hotels portfolio."
    sql: ${TABLE}.brand_positioning ;;
  }

  dimension: brand_segment_focus {
    type: string
    label: "Target Guest & Asset Segment"
    description: "Primary guest profile and real estate asset class for the brand."
    sql: ${TABLE}.brand_segment_focus ;;
  }

  dimension: target_gop_margin_pct {
    type: number
    label: "Brand Target GOP Margin (%)"
    description: "Corporate Gross Operating Profit (GOP) margin hurdle rate established for the brand."
    sql: ${TABLE}.target_gop_margin_pct ;;
    value_format_name: percent_1
  }

  dimension: target_discovery_direct_share_pct {
    type: number
    label: "Target GHA DISCOVERY Direct Share (%)"
    description: "Strategic direct booking share goal via Minor.com and the Minor DISCOVERY loyalty app."
    sql: ${TABLE}.target_discovery_direct_share_pct ;;
    value_format_name: percent_1
  }

  dimension: owner_wacc_hurdle_pct {
    type: number
    label: "Owner Return Hurdle / WACC (%)"
    description: "Minimum annual asset return hurdle rate required before full owner incentive fee acceleration."
    sql: ${TABLE}.owner_wacc_hurdle_pct ;;
    value_format_name: percent_1
  }

  dimension: target_revpar_usd {
    type: number
    label: "Brand Target RevPAR ($ USD)"
    description: "Strategic benchmark Revenue Per Available Room (RevPAR) in USD for the brand."
    sql: ${TABLE}.target_revpar_usd ;;
    value_format_name: usd
  }

  dimension: sustainability_target_kwh_per_night {
    type: number
    label: "ESG Energy Target (kWh / Night)"
    description: "Minor Green Growth 2030 target energy intensity (kWh per occupied room night)."
    sql: ${TABLE}.sustainability_target_kwh_per_night ;;
    value_format_name: decimal_1
  }

  measure: avg_target_gop_margin_pct {
    type: average
    label: "Brand Hurdle GOP Margin (%)"
    description: "Average strategic GOP margin target across selected Minor Hotels brands."
    sql: ${target_gop_margin_pct} ;;
    value_format_name: percent_1
  }

  measure: avg_target_discovery_direct_share_pct {
    type: average
    label: "Brand Hurdle Direct Loyalty Share (%)"
    description: "Average target direct booking share via Minor DISCOVERY loyalty channels."
    sql: ${target_discovery_direct_share_pct} ;;
    value_format_name: percent_1
  }

  measure: avg_target_revpar_usd {
    type: average
    label: "Brand Benchmark RevPAR ($)"
    description: "Average strategic RevPAR benchmark in USD across selected brands."
    sql: ${target_revpar_usd} ;;
    value_format_name: usd
  }
}
