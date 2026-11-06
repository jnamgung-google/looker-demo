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
# COLUMN-LEVEL SECURITY (CLS) & ACTION RBAC ACCESS GRANTS
# =========================================================================
# Controls column visibility and Looker Action execution permissions using User Attributes.
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
  description: "Enterprise hospitality semantic layer for Minor Hotel Group (MINT): RevPAR, ADR, GOP, Live BigQuery Write-Back (Power Apps Replacement), Real-Time Approval Workflow (Power Automate + Dataverse Replacement), and RLS/CLS Role Governance."
  persist_for: "0 seconds"

  # =========================================================================
  # ROW-LEVEL SECURITY (RLS) ENFORCEMENT VIA `sql_always_where`
  # =========================================================================
  # [1] Production RLS Governed by `user_attribute: country`:
  #     - Automatically filters hotel rows based on the user's `country` User Attribute in Looker Admin.
  #     - If the user's `country` attribute is empty (''), NULL, 'All', '%', or '*':
  #       -> Evaluates to TRUE, granting full global visibility across all 12 properties.
  #     - If the user's `country` attribute specifies one or more countries (e.g., 'Thailand', 'Spain', or 'Thailand, Vietnam'):
  #       -> Restricts query results strictly to properties matching the assigned country/region.
  # [2] Interactive Demo Role Simulator & Real-Time Dynamic RLS Approval (`minor_rls_access_control`):
  #     - Works alongside the dashboard Role Simulator filter and immediately unlocks additional regions
  #       in real time once a self-service RLS access request is marked `[RLS_APPROVED]` in BigQuery.
  sql_always_where:
    (
      -- 1) User Attribute `country` RLS (If NULL or empty string, allow full global access)
      NULLIF(TRIM('{{ _user_attributes["country"] }}'), '') IS NULL
      OR UPPER(TRIM('{{ _user_attributes["country"] }}')) IN ('NULL', 'ALL', '%', '*')
      OR UPPER(${minor_hotel_performance.country}) IN (
        SELECT UPPER(TRIM(c))
        FROM UNNEST(SPLIT('{{ _user_attributes["country"] }}', ',')) AS c
      )
      OR UPPER(${minor_hotel_performance.country_city}) LIKE CONCAT('%', UPPER(TRIM('{{ _user_attributes["country"] }}')), '%')
      OR UPPER(${minor_hotel_performance.region_name}) LIKE CONCAT('%', UPPER(TRIM('{{ _user_attributes["country"] }}')), '%')
      OR ${minor_rls_access_control.dynamic_rls_entitlement_status} = '1. Approved — Dynamic RLS Unlocked (Live)'
    )
    AND
    (
      -- 2) Interactive Demo Role Simulator Parameter & Live BigQuery RLS Approval (Dynamic Unlock)
      CASE {% parameter minor_hotel_performance.rls_role_persona %}
        WHEN 'RVPThailandAsia' THEN ${minor_hotel_performance.region_name} = 'Thailand & Indochina'
        WHEN 'RVPEuropeAmericas' THEN ${minor_hotel_performance.region_name} = 'Europe & Americas'
        WHEN 'RVPMiddleEastAfrica' THEN ${minor_hotel_performance.region_name} IN ('Middle East & Indian Ocean', 'Australasia & Africa')
        WHEN 'GMAnantaraSiamBKK' THEN ${minor_hotel_performance.property_code} = 'MINT-TH-01'
        ELSE TRUE
      END
      OR ${minor_rls_access_control.dynamic_rls_entitlement_status} = '1. Approved — Dynamic RLS Unlocked (Live)'
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
