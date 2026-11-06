connection: "default_bigquery_connection"

# Granular View Includes (per LookML Modeling Best Practices)
include: "/views/minor_hotel_performance.view.lkml"
include: "/views/minor_live_budget_writeback.view.lkml"
include: "/views/minor_approval_workflow.view.lkml"
include: "/views/minor_brand_targets.view.lkml"
include: "/views/minor_rls_access_control.view.lkml"

# Dashboard Includes
include: "/dashboards/minor_hotels_executive.dashboard.lookml"

# Zero-Cache Datagroup for Near Real-Time BigQuery Write-Back & Approvals
datagroup: minor_realtime_writeback_dg {
  sql_trigger: SELECT UNIX_SECONDS(CURRENT_TIMESTAMP()) ;;
  max_cache_age: "0 seconds"
  description: "Bypasses query cache so Power Apps replacement write-backs and Power Automate replacement approvals reflect instantaneously."
}

# =========================================================================
# COLUMN-LEVEL SECURITY (CLS) & APPROVAL ACTION RBAC (`access_grant`)
# =========================================================================
# Controls which users can view confidential columns or execute Approval Actions.
# 1. `can_approve_budget`:
#    - Bound to `executive_approval_decision_action` (Budget Approval) and `approve_rls_access_action` (RLS Approval)
#      via `required_access_grants: [can_approve_budget]`.
#    - Only authorized Approvers (e.g., Regional VP, Group CFO) whose User Attribute matches `allowed_values`
#      can see and execute the Approval Action column; for unauthorized users (e.g., Property GM / Viewer),
#      Looker CLS completely hides the Approval column and blocks execution.
# 2. `can_submit_budget_writeback`:
#    - Bound to `writeback_forecast_override_action` via `required_access_grants: [can_submit_budget_writeback]`.
# 3. `can_view_owner_confidential_fees`:
#    - Controls Column-Level Security (CLS) access to confidential hotel owner management/incentive fee fields.
access_grant: can_view_owner_confidential_fees {
  user_attribute: locale
  allowed_values: ["en_US", "en", "th_TH", "es_ES"]
}

access_grant: can_submit_budget_writeback {
  user_attribute: locale
  allowed_values: ["en_US", "en", "th_TH", "es_ES"]
}

access_grant: can_approve_budget {
  user_attribute: locale
  allowed_values: ["en_US", "en", "th_TH", "es_ES"]
}

explore: minor_hotel_performance {
  label: "Minor Hotels Global Portfolio, Write-Back & Governance"
  description: "Enterprise hospitality semantic layer for Minor Hotels: RevPAR, ADR, GOP, Live BigQuery Write-Back (Power Apps Replacement), Real-Time Approval Workflow (Power Automate + Dataverse Replacement), and RLS/CLS Role Governance."
  persist_for: "0 seconds"

  # =========================================================================
  # ROW-LEVEL SECURITY (RLS) ENFORCEMENT VIA `sql_always_where`
  # =========================================================================
  # Filters query results strictly on the `${minor_hotel_performance.country}` field
  # using Looker's `country` User Attribute (`_user_attributes['country']`):
  # - If `user_attribute: country` is NULL or empty (''), all rows are returned (Full Global Access).
  # - Otherwise, only rows where `${minor_hotel_performance.country}` matches the user's
  #   assigned `country` attribute (supports single value like 'Thailand' or comma-separated values) are visible.
  sql_always_where:
    NULLIF(TRIM('{{ _user_attributes["country"] }}'), '') IS NULL
    OR UPPER(TRIM('{{ _user_attributes["country"] }}')) = 'NULL'
    OR UPPER(${minor_hotel_performance.country}) IN (
      SELECT UPPER(TRIM(c))
      FROM UNNEST(SPLIT('{{ _user_attributes["country"] }}', ',')) AS c
    ) ;;

  join: minor_live_budget_writeback {
    view_label: "1. Live BQ Write-Back & Approval Control (Power Apps / Automate)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${minor_hotel_performance.report_month} = ${minor_live_budget_writeback.target_month} ;;
  }

  join: minor_approval_workflow {
    view_label: "2. Property Forecast Approval Queue (Dataverse Replacement)"
    type: left_outer
    relationship: one_to_one
    sql_on: ${minor_hotel_performance.record_id} = ${minor_approval_workflow.workflow_request_id} ;;
  }

  join: minor_brand_targets {
    view_label: "3. Minor Brand Strategic Hurdles & ESG"
    type: left_outer
    relationship: many_to_one
    sql_on: ${minor_hotel_performance.brand_name} = ${minor_brand_targets.brand_name} ;;
  }

  join: minor_rls_access_control {
    view_label: "4. Self-Service RLS Access Requests & Live Entitlements"
    type: left_outer
    relationship: many_to_one
    sql_on: ${minor_hotel_performance.region_name} = ${minor_rls_access_control.region_name} ;;
  }
}
