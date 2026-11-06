view: minor_rls_access_control {
  label: "Dynamic RLS Access Requests & Live Entitlements"
  derived_table: {
    sql:
      WITH live_rls_events AS (
        SELECT
          CAST(target_month AS STRING) AS rls_scope_key,
          COALESCE(CAST(updated_by AS STRING), 'requester@minor.com') AS updated_by,
          COALESCE(CAST(updated_at AS TIMESTAMP), CURRENT_TIMESTAMP()) AS updated_at,
          COALESCE(CAST(note AS STRING), '[RLS_PENDING] Access Request') AS note,
          ROW_NUMBER() OVER (PARTITION BY CAST(target_month AS STRING) ORDER BY updated_at DESC) AS rn,
          COUNT(*) OVER (PARTITION BY CAST(target_month AS STRING)) AS request_event_count
        FROM `eco-shift-478607-e5.demo_dataset.monthly_sales_targets`
        WHERE target_month LIKE 'RLS|%'
      )
      SELECT
        b.region_name,
        b.rls_scope_key,
        b.data_steward,
        COALESCE(l.updated_by, 'governance-system@minor.com') AS last_actor_email,
        COALESCE(l.updated_at, TIMESTAMP('2026-10-01 00:00:00 UTC')) AS last_updated_at,
        COALESCE(l.note, b.default_note) AS rls_status_note,
        COALESCE(l.request_event_count, 0) AS rls_audit_event_count,
        CASE
          WHEN UPPER(COALESCE(l.note, '')) LIKE '%[RLS_APPROVED]%' THEN '1. Approved — Dynamic RLS Unlocked (Live)'
          WHEN UPPER(COALESCE(l.note, '')) LIKE '%[RLS_PENDING]%' THEN '2. Pending Steward Approval (Locked)'
          WHEN UPPER(COALESCE(l.note, '')) LIKE '%[RLS_REVOKED]%' THEN '3. Access Revoked — Returned to Baseline'
          ELSE '0. Default Role Policy (No Override)'
        END AS dynamic_rls_entitlement_status
      FROM `eco-shift-478607-e5.minor_hotels_demo.minor_rls_region_stewards` b
      LEFT JOIN live_rls_events l
        ON b.rls_scope_key = l.rls_scope_key
        AND l.rn = 1 ;;
  }

  dimension: region_name {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.region_name ;;
  }

  dimension: rls_scope_key {
    type: string
    label: "RLS Entitlement Scope Key"
    description: "BigQuery entitlement key (RLS|<Region>) used to dynamically unlock Row-Level Security upon approval."
    sql: ${TABLE}.rls_scope_key ;;
  }

  dimension: data_steward {
    type: string
    label: "RLS Data Steward / Approver"
    description: "Regional executive or data governance owner responsible for approving RLS access requests."
    sql: ${TABLE}.data_steward ;;
  }

  dimension: last_actor_email {
    type: string
    label: "Last RLS Requester / Approver"
    description: "SSO email of the user who last requested, approved, or revoked dynamic RLS access for this region."
    sql: ${TABLE}.last_actor_email ;;
  }

  dimension_group: last_updated_at {
    type: time
    label: "Last RLS Entitlement Update"
    description: "Timestamp of the most recent RLS access request or approval in BigQuery."
    timeframes: [raw, time, date]
    sql: ${TABLE}.last_updated_at ;;
  }

  dimension: rls_status_note {
    type: string
    label: "RLS Access Audit Note"
    description: "Latest governance justification or approval note recorded in BigQuery for this region's RLS policy."
    sql: ${TABLE}.rls_status_note ;;
  }

  dimension: dynamic_rls_entitlement_status {
    type: string
    label: "Dynamic RLS Entitlement Status"
    description: "Current real-time status of self-service RLS access requests for this region."
    sql: ${TABLE}.dynamic_rls_entitlement_status ;;
    html:
      {% if value contains 'Approved' %}
        <span style="background:#ECFDF5; color:#047857; border:1px solid #6EE7B7; padding:3px 10px; border-radius:12px; font-weight:700; font-size:11px;">🔓 {{ rendered_value }}</span>
      {% elsif value contains 'Pending' %}
        <span style="background:#FFFBEB; color:#B45309; border:1px solid #FCD34D; padding:3px 10px; border-radius:12px; font-weight:700; font-size:11px;">⏳ {{ rendered_value }}</span>
      {% elsif value contains 'Revoked' %}
        <span style="background:#FEF2F2; color:#B91C1C; border:1px solid #FCA5A5; padding:3px 10px; border-radius:12px; font-weight:700; font-size:11px;">🚫 {{ rendered_value }}</span>
      {% else %}
        <span style="background:#F5F5F4; color:#57534E; border:1px solid #D6D3D1; padding:3px 10px; border-radius:12px; font-weight:600; font-size:11px;">🛡️ {{ rendered_value }}</span>
      {% endif %} ;;
  }

  dimension: request_rls_access_action {
    type: string
    label: "🔑 1. Request RLS Data Access (Action)"
    description: "Click the three-dots menu to submit a self-service RLS data access request for an additional region."
    sql: ${region_name} ;;
    html:
      <span style="background:#1C1917; color:#C5A059; border:1px solid #C5A059; padding:4px 10px; border-radius:6px; font-weight:700; font-size:11px;">
        🔑 Request Access ({{ value }})
      </span> ;;
    action: {
      label: "🔑 Request Dynamic RLS Data Access (Self-Service Governance)"
      url: "https://us-central1-eco-shift-478607-e5.cloudfunctions.net/demo-bq-insert-action/action-0/execute"
      user_attribute_param: {
        user_attribute: email
        name: "email"
      }
      form_param: {
        name: "target_month"
        type: select
        label: "Requested Region to Unlock (RLS Scope)"
        default: "RLS|Europe & Americas"
        option: {
          name: "RLS|Thailand & Indochina"
          label: "🌏 Thailand & Indochina (All 4 Properties)"
        }
        option: {
          name: "RLS|Europe & Americas"
          label: "🌍 Europe & Americas (NH Collection, Tivoli, nhow)"
        }
        option: {
          name: "RLS|Middle East & Indian Ocean"
          label: "🏝️ Middle East & Indian Ocean (Dubai & Maldives)"
        }
        option: {
          name: "RLS|Australasia & Africa"
          label: "🦁 Australasia & Africa (Oaks & Elewana Safari)"
        }
        required: yes
      }
      form_param: {
        name: "target_amount"
        type: string
        label: "Access Duration (Days)"
        default: "30"
        required: yes
      }
      form_param: {
        name: "note"
        type: string
        label: "Business Justification for RLS Access"
        default: "[RLS_PENDING] Requesting cross-regional benchmarking access for Q4 budget review"
        description: "Keep [RLS_PENDING] prefix. Once approved by Data Steward, RLS automatically unlocks."
        required: yes
      }
    }
  }

  dimension: approve_rls_access_action {
    type: string
    label: "🛡️ 2. Approve / Revoke RLS Access (Action)"
    description: "Click the three-dots menu to Approve or Revoke a user's RLS access request in BigQuery. Immediately updates sql_always_where RLS scope!"
    required_access_grants: [can_approve_budget]
    sql: ${region_name} ;;
    html:
      <span style="background:#ECFDF5; color:#047857; border:1px solid #6EE7B7; padding:4px 10px; border-radius:6px; font-weight:700; font-size:11px;">
        🛡️ Approve / Revoke RLS ({{ value }})
      </span> ;;
    action: {
      label: "🛡️ Approve or Revoke Dynamic RLS Access in Real Time"
      url: "https://us-central1-eco-shift-478607-e5.cloudfunctions.net/demo-bq-insert-action/action-0/execute"
      user_attribute_param: {
        user_attribute: email
        name: "email"
      }
      form_param: {
        name: "target_month"
        type: select
        label: "Target Region Scope to Unlock / Lock"
        default: "RLS|Europe & Americas"
        option: {
          name: "RLS|Thailand & Indochina"
          label: "🌏 Thailand & Indochina (All 4 Properties)"
        }
        option: {
          name: "RLS|Europe & Americas"
          label: "🌍 Europe & Americas (NH Collection, Tivoli, nhow)"
        }
        option: {
          name: "RLS|Middle East & Indian Ocean"
          label: "🏝️ Middle East & Indian Ocean (Dubai & Maldives)"
        }
        option: {
          name: "RLS|Australasia & Africa"
          label: "🦁 Australasia & Africa (Oaks & Elewana Safari)"
        }
        required: yes
      }
      form_param: {
        name: "target_amount"
        type: string
        label: "Entitlement Active Flag (1 = Active, 0 = Revoked)"
        default: "1"
        required: yes
      }
      form_param: {
        name: "note"
        type: select
        label: "RLS Governance Approval Decision"
        default: "[RLS_APPROVED] Dynamic RLS access granted — region unlocked in sql_always_where"
        option: {
          name: "[RLS_APPROVED] Dynamic RLS access granted — region unlocked in sql_always_where"
          label: "✅ Approve RLS Access — Unlock Region Immediately"
        }
        option: {
          name: "[RLS_REVOKED] Dynamic RLS access revoked — returned to baseline RLS scope"
          label: "🚫 Revoke RLS Access — Lock Region Immediately"
        }
        option: {
          name: "[RLS_PENDING] Routed to Group CISO / Data Privacy Officer for PDPA/GDPR Review"
          label: "⏳ Hold / Escalate to Data Privacy Officer"
        }
        required: yes
      }
    }
  }

  measure: total_rls_audit_events {
    type: sum_distinct
    sql_distinct_key: ${region_name} ;;
    label: "Total RLS Access Audit Events"
    description: "Total count of self-service RLS access requests and approvals recorded in BigQuery."
    sql: ${TABLE}.rls_audit_event_count ;;
    value_format_name: decimal_0
  }
}
