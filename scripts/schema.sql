-- Tested on PostgreSQL 12


CREATE TABLE IF NOT EXISTS timers
(
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    expiry timestamp without time zone,
    created timestamp without time zone DEFAULT (now() at time zone 'utc'),
    event TEXT,
    extra JSONB
);

CREATE TABLE IF NOT EXISTS user_restrictions
(
    guild_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS commands_usage
(
    id bigint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    guild_id BIGINT,
    channel_id BIGINT,
    user_id BIGINT,
    used_at TIMESTAMP WITHOUT TIME ZONE,-- DEFAULT (now() at time zone 'utc'),
    command_name TEXT,
    failure BOOLEAN
);

CREATE INDEX IF NOT EXISTS commands_usage_guild_id_idx ON commands_usage (user_id, used_at, command_name);

CREATE TABLE IF NOT EXISTS nin_updates
(
    guild_id BIGINT PRIMARY KEY,
    id BIGINT,
    webhook_token VARCHAR (100)
);

CREATE TABLE IF NOT EXISTS guilds
(
    id BIGINT PRIMARY KEY,
    name TEXT NOT NULL,
    left_at timestamp without time zone,
    owner_id BIGINT NOT NULL,
    whitelisted BOOLEAN DEFAULT 't'
);

CREATE TABLE IF NOT EXISTS guild_config
(
    guild_id BIGINT PRIMARY KEY,
    prefix TEXT [],
    autorole BIGINT,
    extra_config JSONB
);

CREATE TABLE IF NOT EXISTS guild_mod_config
(
    guild_id BIGINT PRIMARY KEY,
    temp_mute_role BIGINT,
    warn_kick BIGINT,
    warn_ban BIGINT,
    mute_role_id BIGINT
);

CREATE TYPE log_format_enum AS ENUM ('minimal with timestamp', 'minimal without timestamp', 'emoji', 'embed');

CREATE TABLE IF NOT EXISTS logging
(
    guild_id BIGINT NOT NULL,
    channel_id BIGINT PRIMARY KEY,
    types TEXT [],
    format log_format_enum DEFAULT 'minimal with timestamp',
    timezone TEXT
);

CREATE TABLE IF NOT EXISTS command_plonks
(
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    guild_id BIGINT,
    name TEXT,
    whitelist BOOLEAN
);

CREATE UNIQUE INDEX IF NOT EXISTS command_plonks_uniq_idx ON command_plonks (guild_id, name, whitelist);

CREATE TABLE IF NOT EXISTS socket_stats
(
    event VARCHAR (100) PRIMARY KEY,
    count BIGINT DEFAULT '0'
);

CREATE TABLE IF NOT EXISTS command_bugs
(
    token VARCHAR (50) PRIMARY KEY,
    traceback TEXT,
    created_at timestamp without time zone
);

CREATE TABLE IF NOT EXISTS infractions
(
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    guild_id BIGINT,
    user_id BIGINT,
    moderator_id BIGINT,
    action INT,
    reason VARCHAR (2000),
    created_at timestamp without time zone DEFAULT (now() at time zone 'utc'),
    active BOOLEAN DEFAULT 't',
    extra JSONB
);
