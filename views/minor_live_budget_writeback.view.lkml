view: minor_live_budget_writeback {
  label: "Live BQ Budget Write-Back & Approvals"
  derived_table: {
    sql:
      WITH baseline_budget_seeds AS (
        SELECT '2026-05' AS target_month, 22100000.0 AS target_amount, 'somchai.r@minor.com' AS updated_by, TIMESTAMP('2026-05-01 08:00:00 UTC') AS updated_at, '[APPROVED BY REGIONAL VP] May 2026 Official Minor Group Portfolio Budget' AS note UNION ALL
        SELECT '2026-06', 23800000.0, 'carlos.m@minor-nh.com', TIMESTAMP('2026-06-01 08:30:00 UTC'), '[APPROVED BY GROUP CFO] June 2026 European Summer Ramp & MICE Target' UNION ALL
        SELECT '2026-07', 25900000.0, 'lorenzo.c@anantara.com', TIMESTAMP('2026-07-01 09:15:00 UTC'), '[APPROVED BY GROUP CFO] July 2026 Peak Leisure & Elewana Safari Target' UNION ALL
        SELECT '2026-08', 26850000.0, 'tariq.a@anantara.com', TIMESTAMP('2026-08-01 10:00:00 UTC'), '[APPROVED BY REGIONAL VP] August 2026 Mediterranean & Maldives High Season' UNION ALL
        SELECT '2026-09', 25600000.0, 'kanda.v@avanihotels.com', TIMESTAMP('2026-09-02 11:20:00 UTC'), '[PENDING VP APPROVAL] Sept 2026 APAC Corporate Conference Reforecast' UNION ALL
        SELECT '2026-10', 27500000.0, 'fpa.director@minor.com', TIMESTAMP('2026-10-01 14:45:00 UTC'), '[PENDING CFO COMMITTEE] Oct 2026 Q4 Thailand High Season & ADR Uplift'
      ),
      combined_history AS (
        SELECT
          CAST(target_month AS STRING) AS target_month,
          CAST(target_amount AS FLOAT64) AS target_amount,
          COALESCE(CAST(updated_by AS STRING), 'bi-analyst@minor.com') AS updated_by,
          COALESCE(CAST(updated_at AS TIMESTAMP), CURRENT_TIMESTAMP()) AS updated_at,
          COALESCE(CAST(note AS STRING), '[PENDING VP APPROVAL] Live Looker Write-Back Submission') AS note,
          'LIVE_BQ_WRITEBACK' AS record_source
        FROM `eco-shift-478607-e5.demo_dataset.monthly_sales_targets`
        WHERE target_month IS NOT NULL
          AND target_month NOT LIKE 'RLS|%'
          AND updated_at >= TIMESTAMP('2026-10-29 00:00:00 UTC')
        UNION ALL
        SELECT
          target_month,
          target_amount,
          updated_by,
          updated_at,
          note,
          'SEED_BASELINE' AS record_source
        FROM baseline_budget_seeds
      ),
      override_counts AS (
        SELECT
          CAST(target_month AS STRING) AS target_month,
          COUNT(*) AS bq_writeback_revision_count
        FROM `eco-shift-478607-e5.demo_dataset.monthly_sales_targets`
        WHERE updated_at >= TIMESTAMP('2026-10-29 00:00:00 UTC')
          AND target_month NOT LIKE 'RLS|%'
        GROUP BY 1
      ),
      ranked_latest AS (
        SELECT
          c.target_month,
          c.target_amount,
          c.updated_by,
          c.updated_at,
          c.note,
          c.record_source,
          COALESCE(o.bq_writeback_revision_count, 0) AS bq_writeback_revision_count,
          ROW_NUMBER() OVER (PARTITION BY c.target_month ORDER BY c.updated_at DESC) AS rn
        FROM combined_history c
        LEFT JOIN override_counts o
          ON c.target_month = o.target_month
      )
      SELECT
        target_month,
        target_amount AS live_budget_target_usd,
        updated_by,
        updated_at,
        note,
        record_source,
        bq_writeback_revision_count
      FROM ranked_latest
      WHERE rn = 1 ;;
  }

  dimension: target_month {
    primary_key: yes
    type: string
    label: "Budget Month (YYYY-MM)"
    description: "Unique reporting month (YYYY-MM) for live BigQuery budget targets and approval states."
    sql: ${TABLE}.target_month ;;
  }

  dimension: live_budget_target_usd {
    type: number
    label: "Live Monthly Portfolio Budget ($ USD)"
    description: "Current active monthly portfolio revenue target in USD retrieved in real time from BigQuery."
    sql: ${TABLE}.live_budget_target_usd ;;
    value_format_name: usd_0
  }

  dimension: updated_by {
    type: string
    label: "Last Submitted / Approved By"
    description: "Email or user ID of the GM, FP&A Analyst, or Regional VP who last updated this target in BigQuery."
    sql: ${TABLE}.updated_by ;;
  }

  dimension_group: updated_at {
    type: time
    label: "Last Write-Back"
    description: "Timestamp when the budget override or approval decision was committed to BigQuery."
    timeframes: [raw, time, date, month]
    sql: ${TABLE}.updated_at ;;
  }

  dimension: note {
    type: string
    label: "Workflow Note & Audit Justification"
    description: "Full governance note and approval stage tag recorded in the live BigQuery write-back table."
    sql: ${TABLE}.note ;;
  }

  dimension: record_source {
    type: string
    label: "Data Source State"
    description: "Indicates whether the active target comes from a live BigQuery write-back override or baseline seed."
    sql: ${TABLE}.record_source ;;
  }

  dimension: bq_writeback_revision_count {
    type: number
    label: "Live BQ Write-Back Revisions"
    description: "Number of live write-back or approval transactions recorded in BigQuery for this month."
    sql: ${TABLE}.bq_writeback_revision_count ;;
  }

  dimension: approval_workflow_status {
    type: string
    label: "Approval Workflow Stage"
    description: "Real-time multi-stage approval state parsed from the live BigQuery governance record (replaces Power Automate + Dataverse)."
    sql:
      CASE
        WHEN UPPER(${note}) LIKE '%APPROVED BY GROUP CFO%' THEN '1. Approved — Group CFO Final Sign-Off'
        WHEN UPPER(${note}) LIKE '%APPROVED%' THEN '2. Approved — Regional VP Verified (Live)'
        WHEN UPPER(${note}) LIKE '%CFO COMMITTEE%' OR UPPER(${note}) LIKE '%ESCALAT%' THEN '3. Pending Group CFO Committee'
        WHEN UPPER(${note}) LIKE '%REVISION%' OR UPPER(${note}) LIKE '%REJECT%' THEN '5. Revision Requested (Returned to GM)'
        ELSE '4. Pending Regional VP Approval'
      END ;;
    html:
      {% if value contains 'Approved' %}
        <span style="background:#ECFDF5; color:#047857; border:1px solid #6EE7B7; padding:3px 10px; border-radius:12px; font-weight:700; font-size:11px;">✅ {{ rendered_value }}</span>
      {% elsif value contains 'Pending' %}
        <span style="background:#FFFBEB; color:#B45309; border:1px solid #FCD34D; padding:3px 10px; border-radius:12px; font-weight:700; font-size:11px;">⏳ {{ rendered_value }}</span>
      {% else %}
        <span style="background:#FEF2F2; color:#B91C1C; border:1px solid #FCA5A5; padding:3px 10px; border-radius:12px; font-weight:700; font-size:11px;">↩️ {{ rendered_value }}</span>
      {% endif %} ;;
  }

  # [CLS / RBAC Gated Write-Back Action]
  # Governed by `required_access_grants: [can_submit_budget_writeback]` defined in `minor_hotels_analytics.model.lkml`.
  dimension: writeback_forecast_override_action {
    type: string
    label: "📝 1. Submit Budget Write-Back (Action)"
    description: "Click the three-dots menu to submit a new budget/forecast target directly into BigQuery (replaces Power Apps). Governed by can_submit_budget_writeback access grant."
    required_access_grants: [can_submit_budget_writeback]
    sql: ${target_month} ;;
    html:
      <span style="background:#1C1917; color:#C5A059; border:1px solid #C5A059; padding:4px 10px; border-radius:6px; font-weight:700; font-size:11px; letter-spacing:0.3px;">
        📝 Write-Back ({{ value }})
      </span> ;;
    action: {
      label: "📝 Submit Live Budget / Forecast Override to BigQuery (Power Apps Replacement)"
      url: "https://us-central1-eco-shift-478607-e5.cloudfunctions.net/demo-bq-insert-action/action-0/execute"
      user_attribute_param: {
        user_attribute: email
        name: "email"
      }
      form_param: {
        name: "target_month"
        type: string
        label: "Target Month (YYYY-MM)"
        default: "{{ target_month._value }}"
        required: yes
      }
      form_param: {
        name: "target_amount"
        type: string
        label: "Revised Monthly Portfolio Budget ($ USD)"
        default: "{{ live_budget_target_usd._value }}"
        description: "Enter the updated monthly revenue target in USD (e.g., 28500000). Writes immediately to BigQuery."
        required: yes
      }
      form_param: {
        name: "note"
        type: string
        label: "Forecast Justification & Initial Workflow Tag"
        default: "[PENDING VP APPROVAL] Q4 ADR & Occupancy Reforecast submitted via Looker Write-Back"
        description: "Prefix with [PENDING VP APPROVAL] or [PENDING CFO COMMITTEE] to route into the live approval queue."
        required: yes
      }
    }
  }

  # [CLS / RBAC Gated Approval Action — Approvers Only]
  # Governed by `required_access_grants: [can_approve_budget]` defined in `minor_hotels_analytics.model.lkml`.
  # Only users with the `can_approve_budget` access grant can view and execute this Approval column.
  # Additionally, when the Demo Role Simulator (`rls_role_persona`) is set to Property GM (`GMAnantaraSiamBKK`),
  # this column renders a locked badge (`🔒 Approval Locked (RVP / CFO Role Only)`).
  dimension: executive_approval_decision_action {
    type: string
    label: "✅ 2. Executive Approval Decision (Action)"
    description: "Click the three-dots menu to Approve, Escalate, or Reject this monthly budget in real time (replaces Power Automate + Dataverse). Governed by can_approve_budget access grant and Role Simulator."
    required_access_grants: [can_approve_budget]
    sql: ${target_month} ;;
    html:
      {% if minor_hotel_performance.rls_role_persona._parameter_value == "'GMAnantaraSiamBKK'" %}
        <span style="background:#FEF2F2; color:#991B1B; border:1px solid #FCA5A5; padding:4px 10px; border-radius:6px; font-weight:700; font-size:11px;">
          🔒 Approval Locked (RVP / CFO Role Only)
        </span>
      {% else %}
        <span style="background:#F5F0E6; color:#1E3A5F; border:1px solid #1E3A5F; padding:4px 10px; border-radius:6px; font-weight:700; font-size:11px;">
          ⚖️ Review & Approve ({{ value }})
        </span>
      {% endif %} ;;
    action: {
      label: "✅ Execute Live Budget Approval Decision in BigQuery (Power Automate Replacement)"
      url: "https://us-central1-eco-shift-478607-e5.cloudfunctions.net/demo-bq-insert-action/action-0/execute"
      user_attribute_param: {
        user_attribute: email
        name: "email"
      }
      form_param: {
        name: "target_month"
        type: string
        label: "Target Month (YYYY-MM)"
        default: "{{ target_month._value }}"
        required: yes
      }
      form_param: {
        name: "target_amount"
        type: string
        label: "Authorized Monthly Budget Amount ($ USD)"
        default: "{{ live_budget_target_usd._value }}"
        description: "Confirm or adjust the authorized USD budget amount before committing your approval decision."
        required: yes
      }
      form_param: {
        name: "note"
        type: select
        label: "Executive Approval Workflow Decision"
        default: "[APPROVED BY REGIONAL VP] Verified & Promoted to Official Minor Group Budget"
        option: {
          name: "[APPROVED BY REGIONAL VP] Verified & Promoted to Official Minor Group Budget"
          label: "✅ Approve (Regional VP) — Promote to Official Budget"
        }
        option: {
          name: "[APPROVED BY GROUP CFO] Final Executive Sign-Off & Locked in BigQuery"
          label: "🏆 Approve (Group CFO) — Final Executive Lock"
        }
        option: {
          name: "[PENDING CFO COMMITTEE] Escalated to Group Investment Committee for GOP Review"
          label: "🔄 Escalate — Route to Group CFO Committee"
        }
        option: {
          name: "[REVISION REQUESTED] Returned to Property GM for ADR & Channel Mix Adjustment"
          label: "↩️ Reject / Request Revision — Return to Property GM"
        }
        required: yes
      }
    }
  }

  measure: total_live_budget_target_usd {
    type: sum_distinct
    sql_distinct_key: ${target_month} ;;
    label: "Live BQ Portfolio Budget ($)"
    description: "Total live monthly portfolio revenue target in USD (deduplicated via Symmetric Aggregates on target_month)."
    sql: ${live_budget_target_usd} ;;
    value_format_name: usd_0
  }

  measure: total_approved_official_budget_usd {
    type: sum_distinct
    sql_distinct_key: ${target_month} ;;
    label: "Approved Official Budget ($)"
    description: "Total monthly portfolio budget in USD that has been formally Approved by Regional VP or Group CFO."
    sql: CASE WHEN UPPER(${note}) LIKE '%APPROVED%' THEN ${live_budget_target_usd} ELSE 0 END ;;
    value_format_name: usd_0
  }

  measure: total_pending_approval_budget_usd {
    type: sum_distinct
    sql_distinct_key: ${target_month} ;;
    label: "Pending Approval Budget ($)"
    description: "Total monthly portfolio budget in USD currently awaiting Regional VP or Group CFO sign-off."
    sql: CASE WHEN UPPER(${note}) NOT LIKE '%APPROVED%' THEN ${live_budget_target_usd} ELSE 0 END ;;
    value_format_name: usd_0
  }

  measure: total_bq_writeback_revisions {
    type: sum_distinct
    sql_distinct_key: ${target_month} ;;
    label: "Total Live BQ Write-Back Events"
    description: "Cumulative count of live write-back and approval transactions committed to BigQuery across selected months."
    sql: ${bq_writeback_revision_count} ;;
    value_format_name: decimal_0
  }
}
