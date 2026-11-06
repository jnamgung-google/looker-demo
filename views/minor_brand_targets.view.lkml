view: minor_brand_targets {
  label: "Minor Brand Strategic Targets"
  sql_table_name: `eco-shift-478607-e5.minor_hotels_demo.minor_brand_targets` ;;

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
