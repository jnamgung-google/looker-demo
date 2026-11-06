- dashboard: minor_hotels_executive
  title: "Minor Hotels (MINT) — Global Hospitality BI, Live BQ Write-Back & Governance Command Center"
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: "Enterprise Looker replacement for Power BI + Power Apps + Power Automate + Dataverse for Minor Hotel Group (Anantara, Avani, NH Collection, Tivoli, nhow, Oaks, Elewana)."

  tabs:
  - name: "1. Executive Portfolio & Brand Pulse"
    label: "1. Executive Portfolio & Brand Pulse"
  - name: "2. Budgeting & BQ Write-Back (Power Apps)"
    label: "2. Budgeting & BQ Write-Back (Power Apps)"
  - name: "3. Real-Time Approval Flow (Power Automate)"
    label: "3. Real-Time Approval Flow (Power Automate)"
  - name: "4. RLS & CLS Governance Audit"
    label: "4. RLS & CLS Governance Audit"

  filters:
  - name: rls_role_simulator
    title: "🔐 1. Demo RLS & CLS Role Simulator"
    type: field_filter
    default_value: "AllCorporateHQ"
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    listens_to_filters: []
    field: minor_hotel_performance.rls_role_persona

  - name: global_operating_region
    title: "🌏 2. Global Operating Region"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    listens_to_filters: []
    field: minor_hotel_performance.region_name

  - name: hotel_brand
    title: "🏨 3. Minor Hotel Brand"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    listens_to_filters: [global_operating_region]
    field: minor_hotel_performance.brand_name

  - name: reporting_month
    title: "📅 4. Reporting Month (YYYY-MM)"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    listens_to_filters: []
    field: minor_hotel_performance.report_month

  - name: approval_workflow_stage
    title: "⚖️ 5. Approval Workflow Stage"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    listens_to_filters: []
    field: minor_live_budget_writeback.approval_workflow_status

  - name: what_if_adr_simulator
    title: "🎛️ 6. What-If ADR Uplift (%)"
    type: field_filter
    default_value: "0.05"
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    listens_to_filters: []
    field: minor_hotel_performance.what_if_adr_change_pct

  - name: what_if_occupancy_simulator
    title: "🎛️ 7. What-If Occupancy Shift (%)"
    type: field_filter
    default_value: "0.03"
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    listens_to_filters: []
    field: minor_hotel_performance.what_if_occupancy_change_pct

  elements:
  # ===========================================================================
  # TAB 1: 1. Executive Portfolio & Brand Pulse
  # ===========================================================================
  - name: banner_tab1_executive_masthead
    type: text
    tab_name: "1. Executive Portfolio & Brand Pulse"
    title_hidden: true
    title_text: ""
    subtitle_text: ""
    body_text: |
      <div style="background: linear-gradient(135deg, #1C1917 0%, #292524 65%, #3E2723 100%); color: #FAF7F2; padding: 10px 20px; border-radius: 8px; border-left: 6px solid #C5A059; font-family: sans-serif;">
        <div style="display: flex; justify-content: space-between; align-items: center; gap: 12px;">
          <div>
            <div style="color: #C5A059; font-size: 10px; font-weight: 700; letter-spacing: 1.8px; text-transform: uppercase;">MINOR HOTELS GROUP (SET: MINT) • ENTERPRISE BI & SEMANTIC LAYER</div>
            <div style="font-size: 18px; font-weight: 700; margin-top: 2px; color: #FFFFFF;">Global Hospitality Portfolio, Live BigQuery Write-Back & Governance Hub</div>
            <div style="font-size: 11px; color: #D6D3D1; margin-top: 2px;">Anantara • Avani • NH Collection • Tivoli • nhow • Oaks • Elewana &nbsp;|&nbsp; <b>Unified Replacement for Power BI + Power Apps + Power Automate + Dataverse</b></div>
          </div>
          <div style="background: rgba(197, 160, 89, 0.16); border: 1px solid #C5A059; padding: 6px 12px; border-radius: 6px; font-size: 11px; color: #FDE68A; white-space: nowrap;">
            <b>⚡ Live Demo:</b> Filter 1 = <b>RLS/CLS</b> &nbsp;|&nbsp; Tab 2 = <b>BQ Write-Back</b> &nbsp;|&nbsp; Tab 3 = <b>Approvals</b>
          </div>
        </div>
      </div>
    row: 0
    col: 0
    width: 24
    height: 3

  - name: kpi_total_portfolio_revenue
    title: "Total Portfolio Revenue ($)"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.total_revenue_usd, minor_live_budget_writeback.total_live_budget_target_usd]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "Live BQ Portfolio Budget"
    custom_color: "#1C1917"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 0
    width: 4
    height: 4

  - name: kpi_portfolio_revpar
    title: "Portfolio RevPAR ($)"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.revpar_usd, minor_brand_targets.avg_target_revpar_usd]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "Brand Benchmark RevPAR"
    custom_color: "#9A3412"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 4
    width: 4
    height: 4

  - name: kpi_portfolio_adr
    title: "Average Daily Rate — ADR ($)"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.adr_usd, minor_hotel_performance.trevpar_usd]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "Total TRevPAR ($)"
    custom_color: "#1E3A5F"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 8
    width: 4
    height: 4

  - name: kpi_occupancy_rate
    title: "Portfolio Occupancy Rate (%)"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.occupancy_rate_pct, minor_hotel_performance.total_occupied_room_nights]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "Occupied Room Nights"
    custom_color: "#059669"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 12
    width: 4
    height: 4

  - name: kpi_consolidated_gop
    title: "Consolidated GOP ($)"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.total_gop_usd, minor_hotel_performance.gop_margin_pct]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "Realized GOP Margin (%)"
    custom_color: "#047857"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 16
    width: 4
    height: 4

  - name: kpi_discovery_direct_share
    title: "Minor DISCOVERY Direct (%)"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.discovery_direct_share_pct, minor_brand_targets.avg_target_discovery_direct_share_pct]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "Brand Direct Share Target"
    custom_color: "#B45309"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 20
    width: 4
    height: 4

  - name: chart_monthly_rev_vs_live_budget
    title: "Monthly Portfolio Revenue vs. Live BigQuery Write-Back Budget & GOP ($)"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_column
    fields: [
      minor_hotel_performance.report_month,
      minor_hotel_performance.total_revenue_usd,
      minor_live_budget_writeback.total_live_budget_target_usd,
      minor_hotel_performance.total_gop_usd
    ]
    sorts: [minor_hotel_performance.report_month asc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    legend_position: center
    point_style: circle_outline
    show_value_labels: true
    series_types:
      minor_live_budget_writeback.total_live_budget_target_usd: line
      minor_hotel_performance.total_gop_usd: area
    series_colors:
      minor_hotel_performance.total_revenue_usd: "#1C1917"
      minor_live_budget_writeback.total_live_budget_target_usd: "#C5A059"
      minor_hotel_performance.total_gop_usd: "#059669"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 7
    col: 0
    width: 15
    height: 8

  - name: chart_channel_mix_donut
    title: "Revenue by Distribution Channel & DISCOVERY Loyalty"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_pie
    fields: [minor_hotel_performance.primary_booking_channel, minor_hotel_performance.total_revenue_usd]
    sorts: [minor_hotel_performance.total_revenue_usd desc]
    limit: 500
    value_labels: labels
    label_type: labPer
    inner_radius: 55
    series_colors:
      "Minor DISCOVERY App & Direct Web": "#C5A059"
      "Global GDS & Corporate MICE": "#1E3A5F"
      "Luxury Wholesale & Consortia": "#059669"
      "OTA Partners (Booking/Expedia)": "#9A3412"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 7
    col: 15
    width: 9
    height: 8

  - name: chart_brand_revpar_gop
    title: "Minor Hotel Brands — Actual RevPAR ($) vs. Brand Benchmark & GOP Margin (%)"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_column
    fields: [
      minor_hotel_performance.brand_name,
      minor_hotel_performance.revpar_usd,
      minor_brand_targets.avg_target_revpar_usd,
      minor_hotel_performance.gop_margin_pct
    ]
    sorts: [minor_hotel_performance.revpar_usd desc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    legend_position: center
    show_value_labels: true
    y_axes:
    - label: "RevPAR ($ USD)"
      orientation: left
      series:
      - axisId: minor_hotel_performance.revpar_usd
        id: minor_hotel_performance.revpar_usd
        name: "Actual RevPAR ($)"
      - axisId: minor_brand_targets.avg_target_revpar_usd
        id: minor_brand_targets.avg_target_revpar_usd
        name: "Benchmark RevPAR ($)"
      showLabels: true
      showValues: true
    - label: "GOP Margin (%)"
      orientation: right
      series:
      - axisId: minor_hotel_performance.gop_margin_pct
        id: minor_hotel_performance.gop_margin_pct
        name: "GOP Margin (%)"
      showLabels: true
      showValues: true
    series_types:
      minor_hotel_performance.gop_margin_pct: line
    series_colors:
      minor_hotel_performance.revpar_usd: "#C5A059"
      minor_brand_targets.avg_target_revpar_usd: "#1C1917"
      minor_hotel_performance.gop_margin_pct: "#059669"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 15
    col: 0
    width: 12
    height: 8

  - name: chart_region_revenue_breakdown
    title: "Revenue Breakdown by Operating Region (Rooms vs. F&B/MICE vs. Anantara Spa)"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_bar
    fields: [
      minor_hotel_performance.region_name,
      minor_hotel_performance.total_room_revenue_usd,
      minor_hotel_performance.total_fb_banquet_revenue_usd,
      minor_hotel_performance.total_spa_ancillary_revenue_usd
    ]
    sorts: [minor_hotel_performance.total_room_revenue_usd desc]
    limit: 500
    stacking: normal
    show_view_names: false
    legend_position: center
    show_value_labels: true
    series_colors:
      minor_hotel_performance.total_room_revenue_usd: "#1C1917"
      minor_hotel_performance.total_fb_banquet_revenue_usd: "#C5A059"
      minor_hotel_performance.total_spa_ancillary_revenue_usd: "#059669"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 15
    col: 12
    width: 12
    height: 8

  - name: table_flagship_property_scorecard
    title: "Minor Hotels Flagship Property Scorecard — Commercial, GOP & Guest Experience"
    tab_name: "1. Executive Portfolio & Brand Pulse"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_grid
    fields: [
      minor_hotel_performance.property_code,
      minor_hotel_performance.property_name,
      minor_hotel_performance.brand_name,
      minor_hotel_performance.region_name,
      minor_hotel_performance.country_city,
      minor_hotel_performance.occupancy_rate_pct,
      minor_hotel_performance.adr_usd,
      minor_hotel_performance.revpar_usd,
      minor_hotel_performance.trevpar_usd,
      minor_hotel_performance.total_revenue_usd,
      minor_hotel_performance.total_gop_usd,
      minor_hotel_performance.gop_margin_pct,
      minor_hotel_performance.discovery_direct_share_pct,
      minor_hotel_performance.avg_guest_nps_score
    ]
    sorts: [minor_hotel_performance.total_revenue_usd desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: true
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 23
    col: 0
    width: 24
    height: 9

  # ===========================================================================
  # TAB 2: 2. Budgeting & BQ Write-Back (Power Apps)
  # ===========================================================================
  - name: banner_tab2_writeback_architecture
    type: text
    tab_name: "2. Budgeting & BQ Write-Back (Power Apps)"
    title_hidden: true
    title_text: ""
    subtitle_text: ""
    body_text: |
      <div style="background: linear-gradient(135deg, #1E3A5F 0%, #1C1917 100%); color: #FAF7F2; padding: 10px 20px; border-radius: 8px; border-left: 6px solid #C5A059; font-family: sans-serif;">
        <div style="color: #C5A059; font-size: 10px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;">REQUIREMENT 1 • POWER APPS REPLACEMENT VIA NATIVE BIGQUERY WRITE-BACK</div>
        <div style="font-size: 16px; font-weight: 700; margin-top: 2px; color: #FFFFFF;">Interactive FP&A Budget & Forecast Entry Directly Inside Looker</div>
        <div style="font-size: 11px; color: #E2E8F0; margin-top: 2px;">
          <b>How to Test Live:</b> Click the three-dots menu (<b>⋮</b>) on any cell in <b>📝 1. Submit Budget Write-Back (Action)</b> below &rarr; enter a revised monthly target (e.g., <code>29500000</code> for <code>2026-10</code>) &rarr; click <b>Submit</b> to write directly to BigQuery and refresh in place!
        </div>
      </div>
    row: 0
    col: 0
    width: 24
    height: 3

  - name: kpi_wb_actual_vs_live_target
    title: "Actual Revenue vs. Live BQ Target ($)"
    tab_name: "2. Budgeting & BQ Write-Back (Power Apps)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.total_revenue_usd, minor_live_budget_writeback.total_live_budget_target_usd]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    show_comparison_label: true
    comparison_label: "Live BigQuery Target ($)"
    custom_color: "#1C1917"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 0
    width: 6
    height: 4

  - name: kpi_wb_variance_usd
    title: "Variance vs. Live BQ Budget ($)"
    tab_name: "2. Budgeting & BQ Write-Back (Power Apps)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.variance_vs_live_bq_budget_usd, minor_hotel_performance.live_bq_budget_achievement_pct]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    show_comparison_label: true
    comparison_label: "Target Achievement (%)"
    custom_color: "#059669"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 6
    width: 6
    height: 4

  - name: kpi_wb_simulated_revenue
    title: "Simulated What-If Revenue ($)"
    tab_name: "2. Budgeting & BQ Write-Back (Power Apps)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.simulated_what_if_revenue_usd, minor_hotel_performance.total_revenue_usd]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    show_comparison_label: true
    comparison_label: "Baseline Actual Revenue ($)"
    custom_color: "#B45309"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      what_if_adr_simulator: minor_hotel_performance.what_if_adr_change_pct
      what_if_occupancy_simulator: minor_hotel_performance.what_if_occupancy_change_pct
    row: 3
    col: 12
    width: 6
    height: 4

  - name: kpi_wb_simulated_gop
    title: "Simulated What-If GOP ($)"
    tab_name: "2. Budgeting & BQ Write-Back (Power Apps)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.simulated_what_if_gop_usd, minor_hotel_performance.total_gop_usd]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    show_comparison_label: true
    comparison_label: "Baseline Actual GOP ($)"
    custom_color: "#1E3A5F"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      what_if_adr_simulator: minor_hotel_performance.what_if_adr_change_pct
      what_if_occupancy_simulator: minor_hotel_performance.what_if_occupancy_change_pct
    row: 3
    col: 18
    width: 6
    height: 4

  - name: table_interactive_budget_writeback
    title: "Interactive Budget & Forecast Write-Back Console (Click ⋮ on '📝 1. Submit Budget Write-Back' to Update BigQuery Live)"
    tab_name: "2. Budgeting & BQ Write-Back (Power Apps)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_grid
    fields: [
      minor_live_budget_writeback.target_month,
      minor_live_budget_writeback.writeback_forecast_override_action,
      minor_hotel_performance.total_revenue_usd,
      minor_hotel_performance.total_static_budget_usd,
      minor_live_budget_writeback.total_live_budget_target_usd,
      minor_hotel_performance.variance_vs_live_bq_budget_usd,
      minor_hotel_performance.live_bq_budget_achievement_pct,
      minor_live_budget_writeback.approval_workflow_status,
      minor_live_budget_writeback.updated_by,
      minor_live_budget_writeback.updated_at_time,
      minor_live_budget_writeback.note
    ]
    sorts: [minor_live_budget_writeback.target_month desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    size_to_fit: true
    table_theme: white
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 7
    col: 0
    width: 24
    height: 9

  - name: chart_actual_vs_static_vs_live_budget
    title: "Monthly Actual Revenue vs. Static Seed Budget vs. Live BigQuery Write-Back Target ($)"
    tab_name: "2. Budgeting & BQ Write-Back (Power Apps)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_column
    fields: [
      minor_hotel_performance.report_month,
      minor_hotel_performance.total_revenue_usd,
      minor_hotel_performance.total_static_budget_usd,
      minor_live_budget_writeback.total_live_budget_target_usd
    ]
    sorts: [minor_hotel_performance.report_month asc]
    limit: 500
    show_view_names: false
    legend_position: center
    show_value_labels: true
    series_types:
      minor_live_budget_writeback.total_live_budget_target_usd: line
    series_colors:
      minor_hotel_performance.total_revenue_usd: "#1C1917"
      minor_hotel_performance.total_static_budget_usd: "#94A3B8"
      minor_live_budget_writeback.total_live_budget_target_usd: "#C5A059"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 16
    col: 0
    width: 12
    height: 8

  - name: chart_what_if_brand_simulation
    title: "What-If ADR & Occupancy Sensitivity Simulator by Brand (Actual vs. Simulated Revenue)"
    tab_name: "2. Budgeting & BQ Write-Back (Power Apps)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_bar
    fields: [
      minor_hotel_performance.brand_name,
      minor_hotel_performance.total_revenue_usd,
      minor_hotel_performance.simulated_what_if_revenue_usd,
      minor_hotel_performance.simulated_what_if_gop_usd
    ]
    sorts: [minor_hotel_performance.simulated_what_if_revenue_usd desc]
    limit: 500
    show_view_names: false
    legend_position: center
    show_value_labels: true
    series_colors:
      minor_hotel_performance.total_revenue_usd: "#1C1917"
      minor_hotel_performance.simulated_what_if_revenue_usd: "#C5A059"
      minor_hotel_performance.simulated_what_if_gop_usd: "#059669"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      what_if_adr_simulator: minor_hotel_performance.what_if_adr_change_pct
      what_if_occupancy_simulator: minor_hotel_performance.what_if_occupancy_change_pct
    row: 16
    col: 12
    width: 12
    height: 8

  # ===========================================================================
  # TAB 3: 3. Real-Time Approval Flow (Power Automate)
  # ===========================================================================
  - name: banner_tab3_approval_architecture
    type: text
    tab_name: "3. Real-Time Approval Flow (Power Automate)"
    title_hidden: true
    title_text: ""
    subtitle_text: ""
    body_text: |
      <div style="background: linear-gradient(135deg, #292524 0%, #431407 100%); color: #FAF7F2; padding: 10px 20px; border-radius: 8px; border-left: 6px solid #059669; font-family: sans-serif;">
        <div style="color: #6EE7B7; font-size: 10px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;">REQUIREMENT 3 • POWER AUTOMATE + DATAVERSE + DIRECTQUERY REPLACEMENT</div>
        <div style="font-size: 16px; font-weight: 700; margin-top: 2px; color: #FFFFFF;">Zero-Latency Multi-Stage Budget Approval Workflow Backed by BigQuery</div>
        <div style="font-size: 11px; color: #E2E8F0; margin-top: 2px;">
          <b>How to Test Live:</b> Click the three-dots menu (<b>⋮</b>) on any cell in <b>✅ 2. Executive Approval Decision (Action)</b> below &rarr; select <b>✅ Approve (Regional VP)</b>, <b>🏆 Approve (Group CFO)</b>, <b>🔄 Escalate</b>, or <b>↩️ Request Revision</b> to update BigQuery in real time!
        </div>
      </div>
    row: 0
    col: 0
    width: 24
    height: 3

  - name: kpi_wf_approved_budget
    title: "Approved Official Budget ($)"
    tab_name: "3. Real-Time Approval Flow (Power Automate)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_live_budget_writeback.total_approved_official_budget_usd, minor_live_budget_writeback.total_live_budget_target_usd]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    show_comparison_label: true
    comparison_label: "Total Submitted Budget ($)"
    custom_color: "#059669"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 0
    width: 6
    height: 4

  - name: kpi_wf_pending_budget
    title: "Pending Approval Queue ($)"
    tab_name: "3. Real-Time Approval Flow (Power Automate)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_live_budget_writeback.total_pending_approval_budget_usd, minor_approval_workflow.total_requested_budget_delta_usd]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    show_comparison_label: true
    comparison_label: "Proposed GM Uplift Delta ($)"
    custom_color: "#B45309"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 6
    width: 6
    height: 4

  - name: kpi_wf_avg_sla_hours
    title: "Avg Approval Turnaround (Hours)"
    tab_name: "3. Real-Time Approval Flow (Power Automate)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_approval_workflow.avg_sla_turnaround_hours, minor_approval_workflow.total_workflow_requests]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    show_comparison_label: true
    comparison_label: "Property Workflow Submissions"
    custom_color: "#1E3A5F"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 12
    width: 6
    height: 4

  - name: kpi_wf_total_bq_events
    title: "Live BQ Audit Events Logged"
    tab_name: "3. Real-Time Approval Flow (Power Automate)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_live_budget_writeback.total_bq_writeback_revisions]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    custom_color: "#9A3412"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 3
    col: 18
    width: 6
    height: 4

  - name: table_executive_approval_console
    title: "Executive Sign-Off & State Transition Console (Click ⋮ on '✅ 2. Executive Approval Decision' to Approve or Reject Live)"
    tab_name: "3. Real-Time Approval Flow (Power Automate)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_grid
    fields: [
      minor_live_budget_writeback.target_month,
      minor_live_budget_writeback.approval_workflow_status,
      minor_live_budget_writeback.executive_approval_decision_action,
      minor_live_budget_writeback.total_live_budget_target_usd,
      minor_hotel_performance.total_revenue_usd,
      minor_hotel_performance.live_bq_budget_achievement_pct,
      minor_live_budget_writeback.record_source,
      minor_live_budget_writeback.updated_by,
      minor_live_budget_writeback.updated_at_time,
      minor_live_budget_writeback.note
    ]
    sorts: [minor_live_budget_writeback.target_month desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    size_to_fit: true
    table_theme: white
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 7
    col: 0
    width: 24
    height: 9

  - name: table_property_forecast_submission_queue
    title: "Property GM Forecast & Budget Submission Queue (Dataverse Replacement)"
    tab_name: "3. Real-Time Approval Flow (Power Automate)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_grid
    fields: [
      minor_approval_workflow.workflow_ticket_code,
      minor_hotel_performance.report_month,
      minor_hotel_performance.property_name,
      minor_hotel_performance.brand_name,
      minor_approval_workflow.submitter_name,
      minor_approval_workflow.approver_role,
      minor_approval_workflow.request_category,
      minor_approval_workflow.total_requested_budget_delta_usd,
      minor_approval_workflow.avg_sla_turnaround_hours,
      minor_live_budget_writeback.approval_workflow_status
    ]
    sorts: [minor_hotel_performance.report_month desc, minor_approval_workflow.total_requested_budget_delta_usd desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    size_to_fit: true
    table_theme: white
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 16
    col: 0
    width: 16
    height: 9

  - name: chart_approval_stage_breakdown
    title: "Portfolio Budget & Proposed Uplift by Approval Stage ($)"
    tab_name: "3. Real-Time Approval Flow (Power Automate)"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_column
    fields: [
      minor_live_budget_writeback.approval_workflow_status,
      minor_live_budget_writeback.total_live_budget_target_usd,
      minor_approval_workflow.total_requested_budget_delta_usd
    ]
    sorts: [minor_live_budget_writeback.approval_workflow_status asc]
    limit: 500
    show_view_names: false
    legend_position: center
    show_value_labels: true
    series_colors:
      minor_live_budget_writeback.total_live_budget_target_usd: "#059669"
      minor_approval_workflow.total_requested_budget_delta_usd: "#C5A059"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
      approval_workflow_stage: minor_live_budget_writeback.approval_workflow_status
    row: 16
    col: 16
    width: 8
    height: 9

  # ===========================================================================
  # TAB 4: 4. RLS & CLS Governance Audit
  # ===========================================================================
  - name: banner_tab4_rls_cls_architecture
    type: text
    tab_name: "4. RLS & CLS Governance Audit"
    title_hidden: true
    title_text: ""
    subtitle_text: ""
    body_text: |
      <div style="background: linear-gradient(135deg, #1C1917 0%, #064E3B 100%); color: #FAF7F2; padding: 10px 20px; border-radius: 8px; border-left: 6px solid #C5A059; font-family: sans-serif;">
        <div style="color: #C5A059; font-size: 10px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;">REQUIREMENT 2 • ROW-LEVEL SECURITY (RLS) & COLUMN-LEVEL SECURITY (CLS)</div>
        <div style="font-size: 16px; font-weight: 700; margin-top: 2px; color: #FFFFFF;">Semantic Layer Role Governance Over a Shared BigQuery Service Account</div>
        <div style="font-size: 11px; color: #E2E8F0; margin-top: 2px;">
          <b>How to Test Live:</b> Change <b>🔐 1. Demo RLS & CLS Role Simulator</b> above from <code>Global Corporate BI</code> to <code>Regional VP</code> or <code>Property GM</code> to dynamically filter visible hotel rows (<b>RLS</b>) AND mask confidential <b>Owner Incentive Fees</b> &amp; <b>VIP Account PII</b> (<b>CLS</b>)!
        </div>
      </div>
    row: 0
    col: 0
    width: 24
    height: 3

  - name: kpi_rls_visible_properties
    title: "Visible Hotel Properties (RLS Scope)"
    tab_name: "4. RLS & CLS Governance Audit"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.property_count]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    custom_color: "#1C1917"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
    row: 3
    col: 0
    width: 6
    height: 4

  - name: kpi_rls_visible_regions
    title: "Visible Operating Regions (RLS Scope)"
    tab_name: "4. RLS & CLS Governance Audit"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.region_count]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    custom_color: "#1E3A5F"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
    row: 3
    col: 6
    width: 6
    height: 4

  - name: kpi_cls_owner_fees
    title: "Owner Incentive Fees (CLS Governed)"
    tab_name: "4. RLS & CLS Governance Audit"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.total_owner_incentive_fee_cls_masked]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    custom_color: "#059669"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
    row: 3
    col: 12
    width: 6
    height: 4

  - name: kpi_rls_authorized_revenue
    title: "Authorized Visible Revenue ($)"
    tab_name: "4. RLS & CLS Governance Audit"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: single_value
    fields: [minor_hotel_performance.total_revenue_usd, minor_hotel_performance.total_gop_usd]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    show_comparison_label: true
    comparison_label: "Authorized Visible GOP ($)"
    custom_color: "#9A3412"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
    row: 3
    col: 18
    width: 6
    height: 4

  - name: table_rls_cls_governance_matrix
    title: "Live Row-Level (RLS) & Column-Level Security (CLS) Audit Matrix + Self-Service RLS Access Request & Approval"
    tab_name: "4. RLS & CLS Governance Audit"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_grid
    fields: [
      minor_hotel_performance.active_rls_persona_badge,
      minor_rls_access_control.dynamic_rls_entitlement_status,
      minor_rls_access_control.request_rls_access_action,
      minor_rls_access_control.approve_rls_access_action,
      minor_hotel_performance.property_code,
      minor_hotel_performance.property_name,
      minor_hotel_performance.brand_name,
      minor_hotel_performance.region_name,
      minor_hotel_performance.general_manager,
      minor_hotel_performance.vip_account_director_cls_masked,
      minor_hotel_performance.owner_contract_structure_cls_masked,
      minor_hotel_performance.total_owner_incentive_fee_cls_masked,
      minor_hotel_performance.total_revenue_usd,
      minor_hotel_performance.total_gop_usd
    ]
    sorts: [minor_hotel_performance.total_revenue_usd desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    size_to_fit: true
    table_theme: white
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
    row: 7
    col: 0
    width: 24
    height: 10

  - name: chart_rls_region_visibility
    title: "Authorized Revenue & GOP by Region under Active RLS Role ($)"
    tab_name: "4. RLS & CLS Governance Audit"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_bar
    fields: [
      minor_hotel_performance.region_name,
      minor_hotel_performance.total_revenue_usd,
      minor_hotel_performance.total_gop_usd
    ]
    sorts: [minor_hotel_performance.total_revenue_usd desc]
    limit: 500
    show_view_names: false
    legend_position: center
    show_value_labels: true
    series_colors:
      minor_hotel_performance.total_revenue_usd: "#1C1917"
      minor_hotel_performance.total_gop_usd: "#C5A059"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
    row: 17
    col: 0
    width: 12
    height: 8

  - name: chart_esg_sustainability_benchmark
    title: "Minor Green Growth 2030 — Energy Intensity (kWh/Night) vs. Brand ESG Target"
    tab_name: "4. RLS & CLS Governance Audit"
    model: minor_hotels_analytics
    explore: minor_hotel_performance
    type: looker_column
    fields: [
      minor_hotel_performance.brand_name,
      minor_hotel_performance.avg_energy_kwh_per_night,
      minor_brand_targets.sustainability_target_kwh_per_night
    ]
    sorts: [minor_hotel_performance.avg_energy_kwh_per_night desc]
    limit: 500
    show_view_names: false
    legend_position: center
    show_value_labels: true
    series_types:
      minor_brand_targets.sustainability_target_kwh_per_night: line
    series_colors:
      minor_hotel_performance.avg_energy_kwh_per_night: "#059669"
      minor_brand_targets.sustainability_target_kwh_per_night: "#C5A059"
    listen:
      rls_role_simulator: minor_hotel_performance.rls_role_persona
      global_operating_region: minor_hotel_performance.region_name
      hotel_brand: minor_hotel_performance.brand_name
      reporting_month: minor_hotel_performance.report_month
    row: 17
    col: 12
    width: 12
    height: 8
