PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS schema_metadata (
    metadata_key TEXT PRIMARY KEY,
    metadata_value TEXT NOT NULL
);

INSERT OR IGNORE INTO schema_metadata (metadata_key, metadata_value)
VALUES ('schema_version', '2');

CREATE TABLE IF NOT EXISTS migration_history (
    migration_id TEXT PRIMARY KEY,
    description TEXT NOT NULL,
    applied_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT OR IGNORE INTO migration_history (migration_id, description)
VALUES ('0001_initial_scope_memory_v2', 'Initial scope-memory schema with thread isolation and structured findings');

CREATE TABLE IF NOT EXISTS scope_thread (
    thread_id INTEGER PRIMARY KEY AUTOINCREMENT,
    thread_key TEXT NOT NULL UNIQUE,
    branch_name TEXT,
    task_key TEXT,
    conversation_key TEXT,
    created_by TEXT NOT NULL DEFAULT 'scope-agent',
    status TEXT NOT NULL CHECK (status IN ('active', 'archived')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    archived_at TEXT
);

CREATE TABLE IF NOT EXISTS scope_snapshot (
    snapshot_id INTEGER PRIMARY KEY AUTOINCREMENT,
    thread_id INTEGER NOT NULL,
    version INTEGER NOT NULL,
    project_name TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('active', 'superseded')),
    summary TEXT NOT NULL,
    constraints_json TEXT NOT NULL DEFAULT '{}',
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    superseded_at TEXT,
    FOREIGN KEY (thread_id) REFERENCES scope_thread (thread_id),
    UNIQUE (thread_id, version)
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_scope_snapshot_single_active
ON scope_snapshot (thread_id)
WHERE status = 'active';

CREATE TABLE IF NOT EXISTS scope_event (
    event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    thread_id INTEGER NOT NULL,
    snapshot_id INTEGER,
    role TEXT NOT NULL CHECK (role IN ('user', 'scope-agent', 'triage-agent', 'system')),
    event_type TEXT NOT NULL CHECK (
        event_type IN ('clarification', 'decision', 'scope-update', 'triage-note', 'review-mode-decision', 'escalation')
    ),
    content TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (thread_id) REFERENCES scope_thread (thread_id),
    FOREIGN KEY (snapshot_id) REFERENCES scope_snapshot (snapshot_id)
);

CREATE TABLE IF NOT EXISTS scope_clause (
    clause_id INTEGER PRIMARY KEY AUTOINCREMENT,
    snapshot_id INTEGER NOT NULL,
    clause_type TEXT NOT NULL CHECK (
        clause_type IN ('goal', 'in-scope', 'out-of-scope', 'constraint', 'acceptance-criterion', 'preference')
    ),
    clause_key TEXT NOT NULL,
    clause_text TEXT NOT NULL,
    source_event_id INTEGER,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (snapshot_id) REFERENCES scope_snapshot (snapshot_id),
    FOREIGN KEY (source_event_id) REFERENCES scope_event (event_id),
    UNIQUE (snapshot_id, clause_type, clause_key)
);

CREATE INDEX IF NOT EXISTS idx_scope_snapshot_thread_id ON scope_snapshot (thread_id);
CREATE INDEX IF NOT EXISTS idx_scope_event_thread_id ON scope_event (thread_id);
CREATE INDEX IF NOT EXISTS idx_scope_clause_snapshot_id ON scope_clause (snapshot_id);
