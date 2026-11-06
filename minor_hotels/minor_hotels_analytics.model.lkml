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
# user_attribute: country 또는 locale 등을 활용해 컬럼 노출 및 Action 실행 권한을 통제합니다.
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
  # [1] `user_attribute: country` 기반 실서버 RLS 통제:
  #     - Looker Admin > User Attributes 의 `country` 속성값을 읽어 행(Row)을 자동 필터링합니다.
  #     - 사용자의 `country` 값이 비어있거나(''), NULL, 'All', '%' 인 경우:
  #       -> 조건이 TRUE가 되어 전체 국가(12개 모든 호텔) 데이터가 조회됩니다.
  #     - 사용자의 `country` 값에 특정 국가명이 입력된 경우 (예: 'Thailand', 'Spain' 또는 'Thailand, Vietnam'):
  #       -> 해당 국가(또는 지역/도시)에 속한 호텔 데이터만 조회됩니다.
  # [2] 데모용 Role Simulator 파라미터 & 실시간 BigQuery RLS 승인(`minor_rls_access_control`) 연동:
  #     - 대시보드 상단 Role Simulator 필터 테스트와 함께, 사용자가 추가 지역 권한을 신청해
  #       승인(`[RLS_APPROVED]`)을 받으면 재로그인 없이 즉시 해당 지역 RLS가 열립니다.
  sql_always_where:
    (
      -- 1) User Attribute `country` 기반 RLS (NULL / 빈 문자열이면 전체 조회 허용)
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
      -- 2) 대시보드 Demo Role Simulator 파라미터 & 실시간 BigQuery RLS 승인(Dynamic Unlock)
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
