view: minor_approval_workflow {
  label: "Real-Time Approval Workflow (Dataverse Replacement)"
  derived_table: {
    sql:
      WITH properties AS (
        SELECT 'MINT-TH-01' AS property_code, 'Thailand & Indochina' AS region_name, 'Somchai Rattanakul (GM)' AS submitter_name, 'VP Ops — Asia (BKK HQ)' AS approver_role, 'High-Season Luxury ADR & Royal Suite Reforecast' AS request_category, 1.8 AS base_sla_hours, 420000.0 AS requested_budget_delta_usd UNION ALL
        SELECT 'MINT-TH-02', 'Thailand & Indochina', 'Nattapong Suwan (GM)', 'VP Ops — Asia (BKK HQ)', 'Experiential Elephant Camp & Private Jet Package Uplift', 2.1, 185000.0 UNION ALL
        SELECT 'MINT-TH-03', 'Thailand & Indochina', 'Kanda Vichit (GM)', 'VP Ops — Asia (BKK HQ)', 'Riverside Grand Ballroom MICE & Convention Target', 3.4, 310000.0 UNION ALL
        SELECT 'MINT-VN-04', 'Thailand & Indochina', 'Tran Minh Duc (GM)', 'VP Ops — Asia (BKK HQ)', 'Heritage Riverfront Villa & Wellness Spa Package', 2.6, 140000.0 UNION ALL
        SELECT 'MINT-ES-05', 'Europe & Americas', 'Carlos Mendoza (GM)', 'EVP Europe & Americas (Madrid)', 'Corporate Congress & Executive Floor Dynamic Pricing', 2.9, 520000.0 UNION ALL
        SELECT 'MINT-IT-06', 'Europe & Americas', 'Lorenzo Conti (GM)', 'EVP Europe & Americas (Madrid)', 'Jubilee Luxury Leisure & Rooftop Dining Re-Budget', 1.9, 490000.0 UNION ALL
        SELECT 'MINT-PT-07', 'Europe & Americas', 'Joao Pereira (GM)', 'EVP Europe & Americas (Madrid)', 'Avenida Liberdade Transatlantic Leisure & Suite Mix', 2.5, 295000.0 UNION ALL
        SELECT 'MINT-NL-08', 'Europe & Americas', 'Pieter van Dijk (GM)', 'EVP Europe & Americas (Madrid)', 'RAI Exhibition Calendar & Direct DISCOVERY Campaign', 3.8, 360000.0 UNION ALL
        SELECT 'MINT-AE-09', 'Middle East & Indian Ocean', 'Tariq Al-Mansoor (GM)', 'SVP Middle East & Indian Ocean (Dubai)', 'Overwater & Beach Pool Villa Winter Peak Reforecast', 1.6, 610000.0 UNION ALL
        SELECT 'MINT-MV-10', 'Middle East & Indian Ocean', 'Aishath Ibrahim (GM)', 'Group CFO & Investment Committee', 'Ultra-Luxury Underwater Dining & Yacht Charter Budget', 1.4, 680000.0 UNION ALL
        SELECT 'MINT-AU-11', 'Australasia & Africa', 'Liam OConnor (GM)', 'VP Australasia (Melbourne)', 'Extended-Stay Corporate & Major Sporting Event Rates', 2.8, 215000.0 UNION ALL
        SELECT 'MINT-TZ-12', 'Australasia & Africa', 'Juma Mwangi (GM)', 'Group CFO & Investment Committee', 'Great Migration Private Safari Wing & Conservation Levy', 2.2, 275000.0
      ),
      months AS (
        SELECT '2026-05' AS report_month, 0.85 AS month_factor UNION ALL
        SELECT '2026-06', 0.92 UNION ALL
        SELECT '2026-07', 1.00 UNION ALL
        SELECT '2026-08', 1.05 UNION ALL
        SELECT '2026-09', 0.96 UNION ALL
        SELECT '2026-10', 1.15
      )
      SELECT
        CONCAT(p.property_code, '-', m.report_month) AS workflow_request_id,
        CONCAT('WF-', REPLACE(m.report_month, '-', ''), '-', SUBSTR(p.property_code, 6)) AS workflow_ticket_code,
        p.property_code,
        m.report_month,
        p.submitter_name,
        p.approver_role,
        p.request_category,
        ROUND(p.base_sla_hours * m.month_factor, 1) AS sla_turnaround_hours,
        ROUND(p.requested_budget_delta_usd * m.month_factor, 0) AS requested_budget_delta_usd
      FROM properties p
      CROSS JOIN months m ;;
  }

  dimension: workflow_request_id {
    primary_key: yes
    type: string
    label: "Workflow Request ID (PK)"
    description: "Unique composite identifier (Property Code + Month) for each forecast/budget approval submission."
    sql: ${TABLE}.workflow_request_id ;;
  }

  dimension: workflow_ticket_code {
    type: string
    label: "Approval Ticket #"
    description: "Human-readable governance ticket code tracking the property forecast submission."
    sql: ${TABLE}.workflow_ticket_code ;;
  }

  dimension: submitter_name {
    type: string
    label: "Submitted By (Property GM)"
    description: "Hotel General Manager who submitted the property forecast or budget revision."
    sql: ${TABLE}.submitter_name ;;
  }

  dimension: approver_role {
    type: string
    label: "Assigned Approver Authority"
    description: "Governance authority responsible for reviewing and approving the submission."
    sql: ${TABLE}.approver_role ;;
  }

  dimension: request_category {
    type: string
    label: "Forecast / Budget Initiative"
    description: "Commercial or operational driver behind the property budget adjustment request."
    sql: ${TABLE}.request_category ;;
  }

  dimension: sla_turnaround_hours {
    type: number
    label: "Approval Turnaround SLA (Hours)"
    description: "Elapsed turnaround time in hours from GM submission to BigQuery live approval state update."
    sql: ${TABLE}.sla_turnaround_hours ;;
    value_format_name: decimal_1
  }

  dimension: requested_budget_delta_usd {
    type: number
    label: "Proposed Revenue Uplift Delta ($)"
    description: "Incremental revenue adjustment proposed by the Property GM in USD."
    sql: ${TABLE}.requested_budget_delta_usd ;;
    value_format_name: usd_0
  }

  measure: total_workflow_requests {
    type: count
    label: "Total Approval Submissions"
    description: "Total count of property-month forecast and budget approval requests in the workflow queue."
  }

  measure: avg_sla_turnaround_hours {
    type: average
    label: "Avg Approval Turnaround (Hours)"
    description: "Average approval cycle time in hours across selected workflow submissions."
    sql: ${sla_turnaround_hours} ;;
    value_format_name: decimal_1
  }

  measure: total_requested_budget_delta_usd {
    type: sum
    label: "Total Proposed Revenue Uplift ($)"
    description: "Sum of incremental budget revenue uplift proposed across active property workflow requests."
    sql: ${requested_budget_delta_usd} ;;
    value_format_name: usd_0
  }
}
