view: minor_approval_workflow {
  label: "Real-Time Approval Workflow (Dataverse Replacement)"
  sql_table_name: `eco-shift-478607-e5.minor_hotels_demo.minor_approval_workflow` ;;

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
