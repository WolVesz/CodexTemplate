PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS schema_metadata (
    metadata_key TEXT PRIMARY KEY,
    metadata_value TEXT NOT NULL
);

INSERT OR IGNORE INTO schema_metadata (metadata_key, metadata_value)
VALUES ('schema_version', '1');

CREATE TABLE IF NOT EXISTS migration_history (
    migration_id TEXT PRIMARY KEY,
    description TEXT NOT NULL,
    applied_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT OR IGNORE INTO migration_history (migration_id, description)
VALUES ('0001_initial_lightning_events_v1', 'Initial Lightning telemetry schema');

CREATE TABLE IF NOT EXISTS lightning_run (
    run_id INTEGER PRIMARY KEY AUTOINCREMENT,
    workflow_name TEXT NOT NULL,
    scope_thread_key TEXT NOT NULL,
    review_mode TEXT NOT NULL CHECK (review_mode IN ('delta', 'full')),
    final_status TEXT NOT NULL CHECK (final_status IN ('completed', 'blocked', 'failed', 'aborted')),
    started_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TEXT,
    total_llm_queries INTEGER NOT NULL DEFAULT 0,
    total_tool_calls INTEGER NOT NULL DEFAULT 0,
    estimated_llm_cost_usd REAL NOT NULL DEFAULT 0.0,
    total_prompt_tokens INTEGER NOT NULL DEFAULT 0,
    workload_context_json TEXT NOT NULL DEFAULT '{}',
    total_completion_tokens INTEGER NOT NULL DEFAULT 0,
    review_iterations INTEGER NOT NULL DEFAULT 0,
    open_in_scope_findings INTEGER NOT NULL DEFAULT 0,
    closed_in_scope_findings INTEGER NOT NULL DEFAULT 0,
    duplicate_findings INTEGER NOT NULL DEFAULT 0,
    confirmed_findings INTEGER NOT NULL DEFAULT 0,
    confirmed_finding_precision REAL NOT NULL DEFAULT 0.0,
    finding_yield_proxy REAL NOT NULL DEFAULT 0.0,
    false_negative_risk_proxy REAL NOT NULL DEFAULT 0.0,
    policy_override_count INTEGER NOT NULL DEFAULT 0,
    code_revision TEXT,
    build_id TEXT,
    eval_dataset_version TEXT,
    lightning_enabled INTEGER NOT NULL DEFAULT 0 CHECK (lightning_enabled IN (0, 1)),
    notes TEXT
);

CREATE TABLE IF NOT EXISTS phase_event (
    event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    run_id INTEGER NOT NULL,
    phase_id TEXT NOT NULL,
    agent_id TEXT NOT NULL,
    step_index INTEGER NOT NULL DEFAULT 0,
    action_kind TEXT NOT NULL CHECK (
        action_kind IN ('enter', 'exit', 'llm-query', 'tool-call', 'recommendation', 'decision', 'reward')
    ),
    status TEXT NOT NULL CHECK (status IN ('started', 'succeeded', 'failed', 'blocked', 'skipped')),
    llm_query_count INTEGER NOT NULL DEFAULT 0,
    estimated_cost_usd REAL NOT NULL DEFAULT 0.0,
    latency_ms INTEGER,
    metadata_json TEXT NOT NULL DEFAULT '{}',
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (run_id) REFERENCES lightning_run (run_id)
);

CREATE TABLE IF NOT EXISTS llm_query_event (
    query_id INTEGER PRIMARY KEY AUTOINCREMENT,
    run_id INTEGER NOT NULL,
    phase_id TEXT NOT NULL,
    agent_id TEXT NOT NULL,
    model_name TEXT NOT NULL,
    prompt_version TEXT NOT NULL,
    query_kind TEXT NOT NULL CHECK (query_kind IN ('execution', 'review', 'remediation', 'recommendation', 'other')),
    prompt_tokens INTEGER NOT NULL DEFAULT 0,
    completion_tokens INTEGER NOT NULL DEFAULT 0,
    estimated_cost_usd REAL NOT NULL DEFAULT 0.0,
    latency_ms INTEGER,
    cache_hit INTEGER NOT NULL DEFAULT 0 CHECK (cache_hit IN (0, 1)),
    success INTEGER NOT NULL DEFAULT 1 CHECK (success IN (0, 1)),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (run_id) REFERENCES lightning_run (run_id)
);

CREATE TABLE IF NOT EXISTS tool_invocation_event (
    tool_call_id INTEGER PRIMARY KEY AUTOINCREMENT,
    run_id INTEGER NOT NULL,
    phase_id TEXT NOT NULL,
    agent_id TEXT NOT NULL,
    tool_name TEXT NOT NULL,
    success INTEGER NOT NULL DEFAULT 1 CHECK (success IN (0, 1)),
    latency_ms INTEGER,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (run_id) REFERENCES lightning_run (run_id)
);

CREATE TABLE IF NOT EXISTS optimization_recommendation (
    recommendation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    run_id INTEGER NOT NULL,
    surface TEXT NOT NULL CHECK (
        surface IN ('execution', 'reviewer_quality', 'review_mode_selection', 'remediation')
    ),
    recommendation_key TEXT NOT NULL,
    recommendation_json TEXT NOT NULL DEFAULT '{}',
    was_applied INTEGER NOT NULL DEFAULT 0 CHECK (was_applied IN (0, 1)),
    policy_blocked INTEGER NOT NULL DEFAULT 0 CHECK (policy_blocked IN (0, 1)),
    policy_check_passed INTEGER NOT NULL DEFAULT 0 CHECK (policy_check_passed IN (0, 1)),
    policy_check_ref TEXT NOT NULL DEFAULT '',
    blocked_by_rule TEXT NOT NULL DEFAULT '',
    final_decision TEXT NOT NULL CHECK (final_decision IN ('applied', 'ignored', 'blocked', 'superseded')),
    rationale TEXT NOT NULL,
    llm_queries_saved_estimate REAL NOT NULL DEFAULT 0.0,
    cost_saved_estimate_usd REAL NOT NULL DEFAULT 0.0,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (run_id) REFERENCES lightning_run (run_id)
);

CREATE TABLE IF NOT EXISTS finding_adjudication (
    adjudication_id INTEGER PRIMARY KEY AUTOINCREMENT,
    run_id INTEGER NOT NULL,
    finding_key TEXT NOT NULL,
    reviewer_id TEXT NOT NULL,
    outcome TEXT NOT NULL CHECK (
        outcome IN ('confirmed', 'rejected', 'duplicate', 'out-of-scope', 'fixed', 'reopened')
    ),
    confidence REAL CHECK (confidence IS NULL OR (confidence >= 0.0 AND confidence <= 1.0)),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (run_id) REFERENCES lightning_run (run_id)
);

CREATE TABLE IF NOT EXISTS reward_snapshot (
    reward_id INTEGER PRIMARY KEY AUTOINCREMENT,
    run_id INTEGER NOT NULL,
    surface TEXT NOT NULL CHECK (
        surface IN ('execution', 'reviewer_quality', 'review_mode_selection', 'remediation', 'overall')
    ),
    metric_name TEXT NOT NULL,
    metric_value REAL NOT NULL,
    reward_value REAL NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (run_id) REFERENCES lightning_run (run_id)
);

CREATE INDEX IF NOT EXISTS idx_phase_event_run_id ON phase_event (run_id);
CREATE INDEX IF NOT EXISTS idx_llm_query_event_run_id ON llm_query_event (run_id);
CREATE INDEX IF NOT EXISTS idx_tool_invocation_event_run_id ON tool_invocation_event (run_id);
CREATE INDEX IF NOT EXISTS idx_optimization_recommendation_run_id ON optimization_recommendation (run_id);
CREATE INDEX IF NOT EXISTS idx_reward_snapshot_run_id ON reward_snapshot (run_id);
CREATE INDEX IF NOT EXISTS idx_finding_adjudication_run_id ON finding_adjudication (run_id);
