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
VALUES ('0001_initial_review_state_v1', 'Initial review-state schema');

CREATE TABLE IF NOT EXISTS review_run (
    run_id INTEGER PRIMARY KEY AUTOINCREMENT,
    scope_thread_key TEXT NOT NULL,
    scope_snapshot_version INTEGER NOT NULL,
    review_mode TEXT NOT NULL CHECK (review_mode IN ('delta', 'full')),
    change_summary TEXT NOT NULL,
    change_context_json TEXT NOT NULL DEFAULT '{}',
    quality_gate_status_json TEXT NOT NULL DEFAULT '{}',
    finding_counts_json TEXT NOT NULL DEFAULT '{}',
    open_in_scope_count INTEGER NOT NULL DEFAULT 0,
    started_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TEXT
);

CREATE TABLE IF NOT EXISTS review_category (
    category_key TEXT PRIMARY KEY,
    domain TEXT NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS review_finding (
    finding_id INTEGER PRIMARY KEY AUTOINCREMENT,
    run_id INTEGER NOT NULL,
    finding_key TEXT NOT NULL,
    reviewer_id TEXT NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    file_path TEXT NOT NULL,
    line_start INTEGER,
    line_end INTEGER,
    evidence TEXT NOT NULL,
    normalized_evidence TEXT NOT NULL,
    expected_behavior TEXT NOT NULL,
    observed_behavior TEXT NOT NULL,
    reproduction_steps TEXT,
    suggested_fix TEXT NOT NULL,
    confidence REAL NOT NULL CHECK (confidence >= 0.0 AND confidence <= 1.0),
    missing_test INTEGER NOT NULL DEFAULT 0 CHECK (missing_test IN (0, 1)),
    review_mode TEXT NOT NULL CHECK (review_mode IN ('delta', 'full')),
    scope_anchor TEXT,
    scope_status TEXT NOT NULL CHECK (scope_status IN ('pending', 'in-scope', 'out-of-scope')),
    scope_rationale TEXT,
    remediation_status TEXT NOT NULL DEFAULT 'open' CHECK (
        remediation_status IN ('open', 'fixed', 'wont-fix', 'duplicate', 'blocked')
    ),
    duplicate_of_finding_id INTEGER,
    prompt_version TEXT NOT NULL,
    model_name TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TEXT,
    FOREIGN KEY (run_id) REFERENCES review_run (run_id),
    FOREIGN KEY (category) REFERENCES review_category (category_key),
    FOREIGN KEY (duplicate_of_finding_id) REFERENCES review_finding (finding_id)
);

CREATE INDEX IF NOT EXISTS idx_review_run_scope_thread_key ON review_run (scope_thread_key);
CREATE INDEX IF NOT EXISTS idx_review_category_domain ON review_category (domain);
CREATE INDEX IF NOT EXISTS idx_review_finding_run_id ON review_finding (run_id);
CREATE INDEX IF NOT EXISTS idx_review_finding_finding_key ON review_finding (finding_key);
CREATE INDEX IF NOT EXISTS idx_review_finding_scope_status ON review_finding (scope_status);
CREATE INDEX IF NOT EXISTS idx_review_finding_reviewer_id ON review_finding (reviewer_id);
