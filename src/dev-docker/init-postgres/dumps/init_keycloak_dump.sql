--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0 (Debian 15.0-1.pgdg110+1)
-- Dumped by pg_dump version 15.0 (Debian 15.0-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO admin;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO admin;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO admin;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO admin;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO admin;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO admin;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO admin;

--
-- Name: client; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO admin;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO admin;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO admin;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO admin;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO admin;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO admin;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO admin;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO admin;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO admin;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO admin;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO admin;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO admin;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO admin;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO admin;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO admin;

--
-- Name: component; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO admin;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(4000)
);


ALTER TABLE public.component_config OWNER TO admin;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO admin;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO admin;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO admin;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO admin;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO admin;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255)
);


ALTER TABLE public.event_entity OWNER TO admin;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO admin;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO admin;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO admin;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO admin;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO admin;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO admin;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO admin;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO admin;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO admin;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO admin;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO admin;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO admin;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO admin;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO admin;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO admin;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO admin;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO admin;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO admin;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO admin;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO admin;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO admin;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO admin;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO admin;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO admin;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO admin;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO admin;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO admin;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO admin;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO admin;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO admin;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO admin;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO admin;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO admin;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO admin;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO admin;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO admin;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO admin;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO admin;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO admin;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO admin;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO admin;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO admin;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO admin;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO admin;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO admin;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO admin;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO admin;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO admin;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO admin;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO admin;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO admin;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO admin;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO admin;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO admin;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO admin;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO admin;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO admin;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO admin;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO admin;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO admin;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO admin;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO admin;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
71437359-5f8e-4f46-bc10-871df2c2ea77	\N	auth-cookie	f751882b-adae-4e57-96a2-61fcd0497761	7b61880c-3f9d-4a22-a4e7-2ac2802d642a	2	10	f	\N	\N
4269a716-a6bb-4817-ae45-0108eca71b76	\N	auth-spnego	f751882b-adae-4e57-96a2-61fcd0497761	7b61880c-3f9d-4a22-a4e7-2ac2802d642a	3	20	f	\N	\N
ee4c58e8-9bb1-44aa-b142-56b54db1a0f9	\N	identity-provider-redirector	f751882b-adae-4e57-96a2-61fcd0497761	7b61880c-3f9d-4a22-a4e7-2ac2802d642a	2	25	f	\N	\N
06d412dc-9daa-4ce6-a183-688dbaad5381	\N	\N	f751882b-adae-4e57-96a2-61fcd0497761	7b61880c-3f9d-4a22-a4e7-2ac2802d642a	2	30	t	1bc05c15-81ee-4ee7-b20e-0ea8786066a0	\N
4aa92464-5968-4407-a632-df4e9b3209dc	\N	auth-username-password-form	f751882b-adae-4e57-96a2-61fcd0497761	1bc05c15-81ee-4ee7-b20e-0ea8786066a0	0	10	f	\N	\N
d9b79043-df09-4f10-b799-5eb6c4f95b08	\N	\N	f751882b-adae-4e57-96a2-61fcd0497761	1bc05c15-81ee-4ee7-b20e-0ea8786066a0	1	20	t	bcb542f5-d808-44c3-a16c-7412406e39ad	\N
2fa7eeec-8d13-47e6-bd58-98d133136191	\N	conditional-user-configured	f751882b-adae-4e57-96a2-61fcd0497761	bcb542f5-d808-44c3-a16c-7412406e39ad	0	10	f	\N	\N
e4ed4d50-2892-449c-8fc3-ec014c1e96df	\N	auth-otp-form	f751882b-adae-4e57-96a2-61fcd0497761	bcb542f5-d808-44c3-a16c-7412406e39ad	0	20	f	\N	\N
2b5c77b9-9c80-4971-bfa1-2f623ea044eb	\N	direct-grant-validate-username	f751882b-adae-4e57-96a2-61fcd0497761	726b8320-8b73-4ca3-86b5-d114d3f11812	0	10	f	\N	\N
19458cf4-e9bd-4aae-8255-e167c02916de	\N	direct-grant-validate-password	f751882b-adae-4e57-96a2-61fcd0497761	726b8320-8b73-4ca3-86b5-d114d3f11812	0	20	f	\N	\N
6804925a-7faf-4540-93fd-67b4accfb968	\N	\N	f751882b-adae-4e57-96a2-61fcd0497761	726b8320-8b73-4ca3-86b5-d114d3f11812	1	30	t	64cbb7f7-290b-47f1-8eb4-282c6df3aab7	\N
6e0794e8-cf8b-43f8-97cc-be8abac937c6	\N	conditional-user-configured	f751882b-adae-4e57-96a2-61fcd0497761	64cbb7f7-290b-47f1-8eb4-282c6df3aab7	0	10	f	\N	\N
a924ea26-e82b-497b-8f8c-a0048ded27ec	\N	direct-grant-validate-otp	f751882b-adae-4e57-96a2-61fcd0497761	64cbb7f7-290b-47f1-8eb4-282c6df3aab7	0	20	f	\N	\N
1e4be2af-c599-4316-903c-b528e9e0e7b0	\N	registration-page-form	f751882b-adae-4e57-96a2-61fcd0497761	3f17f9eb-fc0b-45ed-a2cf-34191d7f7da3	0	10	t	2cec0e28-b319-4b76-8a8b-f74b53da85ef	\N
1e6a3d44-88f5-416d-a3dc-5173acfd6d41	\N	registration-user-creation	f751882b-adae-4e57-96a2-61fcd0497761	2cec0e28-b319-4b76-8a8b-f74b53da85ef	0	20	f	\N	\N
60d2818d-dc16-42b3-8c7f-7822eae7d35b	\N	registration-profile-action	f751882b-adae-4e57-96a2-61fcd0497761	2cec0e28-b319-4b76-8a8b-f74b53da85ef	0	40	f	\N	\N
c001ef89-1193-427e-8f65-366a6711fa19	\N	registration-password-action	f751882b-adae-4e57-96a2-61fcd0497761	2cec0e28-b319-4b76-8a8b-f74b53da85ef	0	50	f	\N	\N
9b873166-4304-48e5-ad32-71a5653a4309	\N	registration-recaptcha-action	f751882b-adae-4e57-96a2-61fcd0497761	2cec0e28-b319-4b76-8a8b-f74b53da85ef	3	60	f	\N	\N
229b4892-6ccc-427f-8565-eadc874cbbe5	\N	reset-credentials-choose-user	f751882b-adae-4e57-96a2-61fcd0497761	730b542f-91a3-4708-ac65-7ca3b0375f6b	0	10	f	\N	\N
7c6c8cd5-c457-4f28-b70f-7d8ddea8d37b	\N	reset-credential-email	f751882b-adae-4e57-96a2-61fcd0497761	730b542f-91a3-4708-ac65-7ca3b0375f6b	0	20	f	\N	\N
12c1954e-eb35-4781-9722-e2de9fa49276	\N	reset-password	f751882b-adae-4e57-96a2-61fcd0497761	730b542f-91a3-4708-ac65-7ca3b0375f6b	0	30	f	\N	\N
8e924132-1480-4e8a-96a7-dfcfb3549a87	\N	\N	f751882b-adae-4e57-96a2-61fcd0497761	730b542f-91a3-4708-ac65-7ca3b0375f6b	1	40	t	0a04ea2d-a9bb-423c-84cb-71377ffc98a4	\N
6834a5fd-e336-44f5-87f5-814ce1d259b1	\N	conditional-user-configured	f751882b-adae-4e57-96a2-61fcd0497761	0a04ea2d-a9bb-423c-84cb-71377ffc98a4	0	10	f	\N	\N
22bf9e1f-bdc9-4863-a6b9-7154c5ffe461	\N	reset-otp	f751882b-adae-4e57-96a2-61fcd0497761	0a04ea2d-a9bb-423c-84cb-71377ffc98a4	0	20	f	\N	\N
f9c7317b-90bb-4b70-be71-cf2c8af40a93	\N	client-secret	f751882b-adae-4e57-96a2-61fcd0497761	65bba1fb-f7c8-46be-bead-a96f6dce7773	2	10	f	\N	\N
30a97e7a-9f5a-49be-9609-1a7fdd4ec7a4	\N	client-jwt	f751882b-adae-4e57-96a2-61fcd0497761	65bba1fb-f7c8-46be-bead-a96f6dce7773	2	20	f	\N	\N
5a016cdd-5436-40e0-ba34-68cfca77b393	\N	client-secret-jwt	f751882b-adae-4e57-96a2-61fcd0497761	65bba1fb-f7c8-46be-bead-a96f6dce7773	2	30	f	\N	\N
be286893-6725-4a1e-b100-c439e481d1fe	\N	client-x509	f751882b-adae-4e57-96a2-61fcd0497761	65bba1fb-f7c8-46be-bead-a96f6dce7773	2	40	f	\N	\N
d38de2d6-0c26-45e1-9d81-1f942ddb4bd7	\N	idp-review-profile	f751882b-adae-4e57-96a2-61fcd0497761	4986d873-3326-443c-b68d-263d2ab502ed	0	10	f	\N	e7ad9e49-b1a7-4e3f-bec3-062fbb99c659
2ae5fc74-f7ae-4a2d-860f-132690942c4f	\N	\N	f751882b-adae-4e57-96a2-61fcd0497761	4986d873-3326-443c-b68d-263d2ab502ed	0	20	t	a43fb810-8483-4b9a-9c22-4a52a9214986	\N
3106f1bc-a7c0-4d3a-93dd-ed2204c27ca1	\N	idp-create-user-if-unique	f751882b-adae-4e57-96a2-61fcd0497761	a43fb810-8483-4b9a-9c22-4a52a9214986	2	10	f	\N	bb417ee9-40ab-4c16-af0e-0f7ead1a127a
dadc87eb-808c-4811-a604-fb258fc6ba60	\N	\N	f751882b-adae-4e57-96a2-61fcd0497761	a43fb810-8483-4b9a-9c22-4a52a9214986	2	20	t	7089c0dd-663f-4b59-b71f-ed30a1ac6a4b	\N
e05da86f-4bdd-4197-a929-f586fa7ef2f0	\N	idp-confirm-link	f751882b-adae-4e57-96a2-61fcd0497761	7089c0dd-663f-4b59-b71f-ed30a1ac6a4b	0	10	f	\N	\N
ad9ac761-b506-41f1-9003-5630bbe98f86	\N	\N	f751882b-adae-4e57-96a2-61fcd0497761	7089c0dd-663f-4b59-b71f-ed30a1ac6a4b	0	20	t	f69f81bb-3b44-4d08-87b6-390599e9696e	\N
450409c5-01fc-4ffb-84a0-faffec1e4de9	\N	idp-email-verification	f751882b-adae-4e57-96a2-61fcd0497761	f69f81bb-3b44-4d08-87b6-390599e9696e	2	10	f	\N	\N
37800360-c7c3-4415-9aff-176475184fb8	\N	\N	f751882b-adae-4e57-96a2-61fcd0497761	f69f81bb-3b44-4d08-87b6-390599e9696e	2	20	t	71cd1387-4984-4274-99d8-d66f85977bc2	\N
cdfe7e7d-3b37-4dc0-a69e-f03578ba4ca7	\N	idp-username-password-form	f751882b-adae-4e57-96a2-61fcd0497761	71cd1387-4984-4274-99d8-d66f85977bc2	0	10	f	\N	\N
822aa576-3d51-4701-b49f-c34cbf7ccc1b	\N	\N	f751882b-adae-4e57-96a2-61fcd0497761	71cd1387-4984-4274-99d8-d66f85977bc2	1	20	t	2e8d31a8-0af5-4ca1-acf3-7602d3467a3b	\N
ed6d67e0-f7d3-43c2-890e-7e7b02e596a0	\N	conditional-user-configured	f751882b-adae-4e57-96a2-61fcd0497761	2e8d31a8-0af5-4ca1-acf3-7602d3467a3b	0	10	f	\N	\N
75b3504d-7645-4197-bdb5-cf3a6a049f19	\N	auth-otp-form	f751882b-adae-4e57-96a2-61fcd0497761	2e8d31a8-0af5-4ca1-acf3-7602d3467a3b	0	20	f	\N	\N
b098ebf5-649f-4241-8059-a6f499281f96	\N	http-basic-authenticator	f751882b-adae-4e57-96a2-61fcd0497761	0fc41ca8-6a37-46b5-a104-bf52dead26ae	0	10	f	\N	\N
317943f0-9bbe-452a-82e8-994aa9000250	\N	docker-http-basic-authenticator	f751882b-adae-4e57-96a2-61fcd0497761	a8953591-c0c7-42ad-aede-03f4a162451a	0	10	f	\N	\N
2b831256-4972-4b0b-b7e1-ad9ba759361b	\N	no-cookie-redirect	f751882b-adae-4e57-96a2-61fcd0497761	003f962b-676a-448b-a104-4fc6c5b64fdb	0	10	f	\N	\N
4a20a22d-93c7-4f63-9160-01e8a93cb725	\N	\N	f751882b-adae-4e57-96a2-61fcd0497761	003f962b-676a-448b-a104-4fc6c5b64fdb	0	20	t	87d5976d-a4de-4e88-87c2-fe77dc7282e0	\N
8208a2c7-3433-41b5-97c8-50df276cbfbe	\N	basic-auth	f751882b-adae-4e57-96a2-61fcd0497761	87d5976d-a4de-4e88-87c2-fe77dc7282e0	0	10	f	\N	\N
d0f35cc5-beb0-4c0c-aa07-444cbaa525c5	\N	basic-auth-otp	f751882b-adae-4e57-96a2-61fcd0497761	87d5976d-a4de-4e88-87c2-fe77dc7282e0	3	20	f	\N	\N
8d3c066e-6b0e-41d8-a650-fd8bebc3b717	\N	auth-spnego	f751882b-adae-4e57-96a2-61fcd0497761	87d5976d-a4de-4e88-87c2-fe77dc7282e0	3	30	f	\N	\N
00d73a5d-e71b-462f-961a-df48c91ff485	\N	auth-cookie	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	599d63b2-77d9-4107-b79f-28665ef64a47	2	10	f	\N	\N
358e7ddf-ef29-4fe6-9c4a-9e8099c5ac1c	\N	auth-spnego	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	599d63b2-77d9-4107-b79f-28665ef64a47	3	20	f	\N	\N
7b32b2a2-1111-4675-8275-54ab9821dd71	\N	identity-provider-redirector	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	599d63b2-77d9-4107-b79f-28665ef64a47	2	25	f	\N	\N
64b1c248-cf4d-45b4-a064-139ed9ccdc61	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	599d63b2-77d9-4107-b79f-28665ef64a47	2	30	t	7fd2f04a-0c49-4efe-918b-793e9aa37d41	\N
22427061-fbfb-4980-80dd-e671454d07f2	\N	auth-username-password-form	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	7fd2f04a-0c49-4efe-918b-793e9aa37d41	0	10	f	\N	\N
0c95fdc2-b15b-4986-a35a-a79234eb1905	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	7fd2f04a-0c49-4efe-918b-793e9aa37d41	1	20	t	e63a6e51-0123-44f3-b3dc-e83b8d07d2f8	\N
fd886904-cce4-4928-b55c-54b07b49818b	\N	conditional-user-configured	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	e63a6e51-0123-44f3-b3dc-e83b8d07d2f8	0	10	f	\N	\N
879dec7c-2810-44fe-b4aa-493d36083e02	\N	auth-otp-form	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	e63a6e51-0123-44f3-b3dc-e83b8d07d2f8	0	20	f	\N	\N
82edb9fa-4fca-455e-b446-c5f06722a5ae	\N	direct-grant-validate-username	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	79dd0b33-8051-499b-9e32-1aba2d7e8a12	0	10	f	\N	\N
125841a7-d625-4c45-89a4-0058bdf65310	\N	direct-grant-validate-password	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	79dd0b33-8051-499b-9e32-1aba2d7e8a12	0	20	f	\N	\N
0b9228a8-8432-40c7-ae71-a92f2d18fa8c	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	79dd0b33-8051-499b-9e32-1aba2d7e8a12	1	30	t	29db4f0e-fd19-4df7-aa2c-faf29cabf844	\N
bd1ddd39-4f9e-4381-96dd-f9f744344fa3	\N	conditional-user-configured	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	29db4f0e-fd19-4df7-aa2c-faf29cabf844	0	10	f	\N	\N
0e87dfe9-a281-42bc-8209-32c42846489e	\N	direct-grant-validate-otp	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	29db4f0e-fd19-4df7-aa2c-faf29cabf844	0	20	f	\N	\N
d0c5c8d6-d2ee-448a-b6e4-9781d92ad2c1	\N	registration-page-form	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	fc74d967-3a8c-4e4b-a441-3fc96c1cc30f	0	10	t	20cb3f29-191f-41b0-bf19-63ca41979de8	\N
854f1615-1c86-45cb-8b7d-8f5c5de8ea95	\N	registration-user-creation	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	20cb3f29-191f-41b0-bf19-63ca41979de8	0	20	f	\N	\N
d660f966-b634-4cab-bd83-75a17987bbf3	\N	registration-profile-action	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	20cb3f29-191f-41b0-bf19-63ca41979de8	0	40	f	\N	\N
5f9fb248-0ab9-4101-bf6a-f335bc5bd890	\N	registration-password-action	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	20cb3f29-191f-41b0-bf19-63ca41979de8	0	50	f	\N	\N
0e5f776e-91ca-4e97-9e06-ba492aae4f3c	\N	registration-recaptcha-action	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	20cb3f29-191f-41b0-bf19-63ca41979de8	3	60	f	\N	\N
87859ddb-4de8-4da8-93e1-274ccc4fe643	\N	reset-credentials-choose-user	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	48487858-647b-4a20-83f0-83489bc2bf87	0	10	f	\N	\N
be5b3362-f3dc-4f0a-a029-571237fd9df9	\N	reset-credential-email	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	48487858-647b-4a20-83f0-83489bc2bf87	0	20	f	\N	\N
54ff8737-bce9-4159-912c-7240c2cbcc6c	\N	reset-password	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	48487858-647b-4a20-83f0-83489bc2bf87	0	30	f	\N	\N
003eb866-3c7b-4797-a45a-5f9cf9c69975	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	48487858-647b-4a20-83f0-83489bc2bf87	1	40	t	5a8fc497-56cf-451f-830e-1ce56f45b0a4	\N
f0d5c399-2885-436c-9612-164927158789	\N	conditional-user-configured	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	5a8fc497-56cf-451f-830e-1ce56f45b0a4	0	10	f	\N	\N
a0cc8698-5d0a-4925-a4d5-9b0415b4ddbf	\N	reset-otp	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	5a8fc497-56cf-451f-830e-1ce56f45b0a4	0	20	f	\N	\N
b7c933f1-7e5a-4919-841e-924f4327748c	\N	client-secret	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	2111e90a-c565-4db8-a03c-d96c01cd0fe4	2	10	f	\N	\N
e951a216-b866-4e1c-9003-695c0e5a4613	\N	client-jwt	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	2111e90a-c565-4db8-a03c-d96c01cd0fe4	2	20	f	\N	\N
c4107198-b19e-4e04-8b49-3f38c0a03376	\N	client-secret-jwt	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	2111e90a-c565-4db8-a03c-d96c01cd0fe4	2	30	f	\N	\N
5098e5b6-a5e4-4d6c-b47b-da5961f4a9ca	\N	client-x509	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	2111e90a-c565-4db8-a03c-d96c01cd0fe4	2	40	f	\N	\N
ebdd5362-7dd4-4bce-8659-3e2754f0aa05	\N	idp-review-profile	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9917f1c7-725b-4560-bb71-0f027904bca0	0	10	f	\N	35f9d09b-a744-4e57-8cb7-9260785d0593
d7300342-db57-4027-b662-615fc659b4d7	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9917f1c7-725b-4560-bb71-0f027904bca0	0	20	t	1965f2f7-34d9-4234-9fcd-9d81cc2cb88d	\N
70a4e3c2-c86e-4e8c-9921-b269870e74f3	\N	idp-create-user-if-unique	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	1965f2f7-34d9-4234-9fcd-9d81cc2cb88d	2	10	f	\N	38c3d4d2-ab26-4152-9b82-62d915a854a0
f9a2db5b-01b9-41cb-9340-dc1b77e16ca4	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	1965f2f7-34d9-4234-9fcd-9d81cc2cb88d	2	20	t	0a336483-8a14-4060-a781-8103ab4f957d	\N
b2f2504c-1939-4ff4-9391-28303f5c9cf7	\N	idp-confirm-link	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	0a336483-8a14-4060-a781-8103ab4f957d	0	10	f	\N	\N
d12ce97f-d6d4-4dd1-9873-ca81546acf00	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	0a336483-8a14-4060-a781-8103ab4f957d	0	20	t	5723dbb8-18e6-48c4-9f02-1bbf83aa8221	\N
2a866d2e-e5a7-4620-a67d-ee947ccf4c08	\N	idp-email-verification	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	5723dbb8-18e6-48c4-9f02-1bbf83aa8221	2	10	f	\N	\N
dd68c448-3df3-4090-ad66-55fb3c452496	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	5723dbb8-18e6-48c4-9f02-1bbf83aa8221	2	20	t	767f2729-2909-49d4-bcb4-d6ebf4149b19	\N
0bae660f-93af-46ed-8fcd-2d9a5a6b6219	\N	idp-username-password-form	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	767f2729-2909-49d4-bcb4-d6ebf4149b19	0	10	f	\N	\N
fb4c1a72-d7b1-485d-ba26-b37c29c97cd5	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	767f2729-2909-49d4-bcb4-d6ebf4149b19	1	20	t	f0f9164e-68f9-4e94-a67a-44a897075186	\N
d35f41df-a107-49c7-b57a-29d398d1ba0f	\N	conditional-user-configured	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	f0f9164e-68f9-4e94-a67a-44a897075186	0	10	f	\N	\N
01003769-cfab-4487-b231-9e588d3c17a9	\N	auth-otp-form	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	f0f9164e-68f9-4e94-a67a-44a897075186	0	20	f	\N	\N
b47ad009-bfb2-4128-a29b-c33f57e5e868	\N	http-basic-authenticator	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	589b6783-2277-42fb-8b6a-15f1e8767cbb	0	10	f	\N	\N
4ae8ba1d-0198-4483-b072-8054441fc76a	\N	docker-http-basic-authenticator	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9fe56abe-be8c-45d8-be97-78fc807644b3	0	10	f	\N	\N
7bfd568d-0a26-4f26-98fc-f32208c15cc3	\N	no-cookie-redirect	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	028c80d2-69ba-4cd4-98d3-b369aaaa9934	0	10	f	\N	\N
13605ea3-2d83-4767-b0a7-57e5b9bd6f80	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	028c80d2-69ba-4cd4-98d3-b369aaaa9934	0	20	t	c54fb830-f5f3-4f5d-9ca5-43de78d1f267	\N
32544334-19c3-47fe-8184-ed43edaf099d	\N	basic-auth	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	c54fb830-f5f3-4f5d-9ca5-43de78d1f267	0	10	f	\N	\N
9f287ae0-00f0-4415-90b5-d118014ee3e0	\N	basic-auth-otp	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	c54fb830-f5f3-4f5d-9ca5-43de78d1f267	3	20	f	\N	\N
908ebb7a-2d50-4f95-bd00-77082fe49ba9	\N	auth-spnego	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	c54fb830-f5f3-4f5d-9ca5-43de78d1f267	3	30	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
7b61880c-3f9d-4a22-a4e7-2ac2802d642a	browser	browser based authentication	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	t	t
1bc05c15-81ee-4ee7-b20e-0ea8786066a0	forms	Username, password, otp and other auth forms.	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	f	t
bcb542f5-d808-44c3-a16c-7412406e39ad	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	f	t
726b8320-8b73-4ca3-86b5-d114d3f11812	direct grant	OpenID Connect Resource Owner Grant	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	t	t
64cbb7f7-290b-47f1-8eb4-282c6df3aab7	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	f	t
3f17f9eb-fc0b-45ed-a2cf-34191d7f7da3	registration	registration flow	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	t	t
2cec0e28-b319-4b76-8a8b-f74b53da85ef	registration form	registration form	f751882b-adae-4e57-96a2-61fcd0497761	form-flow	f	t
730b542f-91a3-4708-ac65-7ca3b0375f6b	reset credentials	Reset credentials for a user if they forgot their password or something	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	t	t
0a04ea2d-a9bb-423c-84cb-71377ffc98a4	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	f	t
65bba1fb-f7c8-46be-bead-a96f6dce7773	clients	Base authentication for clients	f751882b-adae-4e57-96a2-61fcd0497761	client-flow	t	t
4986d873-3326-443c-b68d-263d2ab502ed	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	t	t
a43fb810-8483-4b9a-9c22-4a52a9214986	User creation or linking	Flow for the existing/non-existing user alternatives	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	f	t
7089c0dd-663f-4b59-b71f-ed30a1ac6a4b	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	f	t
f69f81bb-3b44-4d08-87b6-390599e9696e	Account verification options	Method with which to verity the existing account	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	f	t
71cd1387-4984-4274-99d8-d66f85977bc2	Verify Existing Account by Re-authentication	Reauthentication of existing account	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	f	t
2e8d31a8-0af5-4ca1-acf3-7602d3467a3b	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	f	t
0fc41ca8-6a37-46b5-a104-bf52dead26ae	saml ecp	SAML ECP Profile Authentication Flow	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	t	t
a8953591-c0c7-42ad-aede-03f4a162451a	docker auth	Used by Docker clients to authenticate against the IDP	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	t	t
003f962b-676a-448b-a104-4fc6c5b64fdb	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	t	t
87d5976d-a4de-4e88-87c2-fe77dc7282e0	Authentication Options	Authentication options.	f751882b-adae-4e57-96a2-61fcd0497761	basic-flow	f	t
599d63b2-77d9-4107-b79f-28665ef64a47	browser	browser based authentication	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	t	t
7fd2f04a-0c49-4efe-918b-793e9aa37d41	forms	Username, password, otp and other auth forms.	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	f	t
e63a6e51-0123-44f3-b3dc-e83b8d07d2f8	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	f	t
79dd0b33-8051-499b-9e32-1aba2d7e8a12	direct grant	OpenID Connect Resource Owner Grant	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	t	t
29db4f0e-fd19-4df7-aa2c-faf29cabf844	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	f	t
fc74d967-3a8c-4e4b-a441-3fc96c1cc30f	registration	registration flow	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	t	t
20cb3f29-191f-41b0-bf19-63ca41979de8	registration form	registration form	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	form-flow	f	t
48487858-647b-4a20-83f0-83489bc2bf87	reset credentials	Reset credentials for a user if they forgot their password or something	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	t	t
5a8fc497-56cf-451f-830e-1ce56f45b0a4	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	f	t
2111e90a-c565-4db8-a03c-d96c01cd0fe4	clients	Base authentication for clients	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	client-flow	t	t
9917f1c7-725b-4560-bb71-0f027904bca0	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	t	t
1965f2f7-34d9-4234-9fcd-9d81cc2cb88d	User creation or linking	Flow for the existing/non-existing user alternatives	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	f	t
0a336483-8a14-4060-a781-8103ab4f957d	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	f	t
5723dbb8-18e6-48c4-9f02-1bbf83aa8221	Account verification options	Method with which to verity the existing account	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	f	t
767f2729-2909-49d4-bcb4-d6ebf4149b19	Verify Existing Account by Re-authentication	Reauthentication of existing account	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	f	t
f0f9164e-68f9-4e94-a67a-44a897075186	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	f	t
589b6783-2277-42fb-8b6a-15f1e8767cbb	saml ecp	SAML ECP Profile Authentication Flow	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	t	t
9fe56abe-be8c-45d8-be97-78fc807644b3	docker auth	Used by Docker clients to authenticate against the IDP	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	t	t
028c80d2-69ba-4cd4-98d3-b369aaaa9934	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	t	t
c54fb830-f5f3-4f5d-9ca5-43de78d1f267	Authentication Options	Authentication options.	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	basic-flow	f	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
e7ad9e49-b1a7-4e3f-bec3-062fbb99c659	review profile config	f751882b-adae-4e57-96a2-61fcd0497761
bb417ee9-40ab-4c16-af0e-0f7ead1a127a	create unique user config	f751882b-adae-4e57-96a2-61fcd0497761
35f9d09b-a744-4e57-8cb7-9260785d0593	review profile config	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc
38c3d4d2-ab26-4152-9b82-62d915a854a0	create unique user config	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
bb417ee9-40ab-4c16-af0e-0f7ead1a127a	false	require.password.update.after.registration
e7ad9e49-b1a7-4e3f-bec3-062fbb99c659	missing	update.profile.on.first.login
35f9d09b-a744-4e57-8cb7-9260785d0593	missing	update.profile.on.first.login
38c3d4d2-ab26-4152-9b82-62d915a854a0	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
ca13f022-86a6-4d5a-98d6-0f96164f7250	t	f	master-realm	0	f	\N	\N	t	\N	f	f751882b-adae-4e57-96a2-61fcd0497761	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
e74587da-c704-485d-9717-1bd7df7f05fd	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	f751882b-adae-4e57-96a2-61fcd0497761	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
2783b436-a88e-4b71-97dc-7bd3898f39d0	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	f751882b-adae-4e57-96a2-61fcd0497761	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
d9059ade-73d5-4e38-b29c-360e89af1918	t	f	broker	0	f	\N	\N	t	\N	f	f751882b-adae-4e57-96a2-61fcd0497761	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
edd1bb01-6648-440a-aa92-b1c51b766aad	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	f751882b-adae-4e57-96a2-61fcd0497761	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
51bba564-08da-4e42-b1f0-85c117cda097	t	f	admin-cli	0	t	\N	\N	f	\N	f	f751882b-adae-4e57-96a2-61fcd0497761	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	f	concerto-realm	0	f	\N	\N	t	\N	f	f751882b-adae-4e57-96a2-61fcd0497761	\N	0	f	f	concerto Realm	f	client-secret	\N	\N	\N	t	f	f	f
9272434e-b7d2-407f-8efa-1a525aedf732	t	f	realm-management	0	f	\N	\N	t	\N	f	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
39b034e8-297a-4e48-adc3-0d53c0797cb7	t	f	account	0	t	\N	/realms/concerto/account/	f	\N	f	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
7bfaf0df-680c-4fb7-8b75-62b58880d428	t	f	account-console	0	t	\N	/realms/concerto/account/	f	\N	f	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
25de7b22-1f9a-4008-a602-0f9d042b6cb5	t	f	broker	0	f	\N	\N	t	\N	f	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
07a8e7af-80f6-4672-abef-5786c95e7867	t	f	security-admin-console	0	t	\N	/admin/concerto/console/	f	\N	f	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
e1851637-5a8a-4189-ac2e-6fa23c55c381	t	f	admin-cli	0	t	\N	\N	f	\N	f	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	t	t	concerto-client	0	t	\N	https://concerto.local:5000	f	http://localhost:8080/	f	f751882b-adae-4e57-96a2-61fcd0497761	openid-connect	-1	t	f		f	client-secret	https://concerto.local:5000		\N	t	f	t	f
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	t	t	concerto-server	0	f	p88W1d2Dbrug8BaAJaz41glSDARxaoXn	https://concerto.local:5000/	f	http://localhost:8080/	f	f751882b-adae-4e57-96a2-61fcd0497761	openid-connect	-1	t	f		f	client-secret	https://concerto.local:5000		\N	t	f	t	f
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	t	t	concerto-client	0	t	\N	https://concerto.local:5000/	f	http://localhost:8080/	f	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	openid-connect	-1	t	f		f	client-secret	https://concerto.local:5000/		\N	t	f	t	f
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	t	t	concerto-server	0	f	Wxs9xJ3aFjPqCK9PsXsuHuriaS3MNf5j	https://concerto.local:5000/	f	http://localhost:8080/admin/realms/concerto	f	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	openid-connect	-1	t	f		t	client-secret	https://concerto.local:5000/		\N	t	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
e74587da-c704-485d-9717-1bd7df7f05fd	post.logout.redirect.uris	+
2783b436-a88e-4b71-97dc-7bd3898f39d0	post.logout.redirect.uris	+
2783b436-a88e-4b71-97dc-7bd3898f39d0	pkce.code.challenge.method	S256
edd1bb01-6648-440a-aa92-b1c51b766aad	post.logout.redirect.uris	+
edd1bb01-6648-440a-aa92-b1c51b766aad	pkce.code.challenge.method	S256
39b034e8-297a-4e48-adc3-0d53c0797cb7	post.logout.redirect.uris	+
7bfaf0df-680c-4fb7-8b75-62b58880d428	post.logout.redirect.uris	+
7bfaf0df-680c-4fb7-8b75-62b58880d428	pkce.code.challenge.method	S256
07a8e7af-80f6-4672-abef-5786c95e7867	post.logout.redirect.uris	+
07a8e7af-80f6-4672-abef-5786c95e7867	pkce.code.challenge.method	S256
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	backchannel.logout.session.required	true
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	client.secret.creation.time	1744151634
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	display.on.consent.screen	false
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	oauth2.device.authorization.grant.enabled	false
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	oidc.ciba.grant.enabled	false
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	post.logout.redirect.uris	https://concerto.local:5000/
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	acr.loa.map	{}
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	backchannel.logout.revoke.offline.tokens	false
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	backchannel.logout.session.required	true
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	client.secret.creation.time	1744141612
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	client_credentials.use_refresh_token	false
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	backchannel.logout.revoke.offline.tokens	false
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	backchannel.logout.session.required	true
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	display.on.consent.screen	false
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	oauth2.device.authorization.grant.enabled	false
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	oidc.ciba.grant.enabled	false
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	use.refresh.tokens	true
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	client_credentials.use_refresh_token	false
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	token.response.type.bearer.lower-case	false
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	tls.client.certificate.bound.access.tokens	false
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	require.pushed.authorization.requests	false
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	acr.loa.map	{}
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	display.on.consent.screen	false
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	oauth2.device.authorization.grant.enabled	false
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	oidc.ciba.grant.enabled	false
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	post.logout.redirect.uris	https://concerto.local:5000/
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	require.pushed.authorization.requests	false
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	tls.client.certificate.bound.access.tokens	false
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	backchannel.logout.revoke.offline.tokens	false
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	backchannel.logout.revoke.offline.tokens	false
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	backchannel.logout.session.required	true
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	display.on.consent.screen	false
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	oauth2.device.authorization.grant.enabled	false
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	oidc.ciba.grant.enabled	false
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	token.response.type.bearer.lower-case	false
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	use.refresh.tokens	true
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	offline_access	f751882b-adae-4e57-96a2-61fcd0497761	OpenID Connect built-in scope: offline_access	openid-connect
f5bc50af-4046-40e1-bed7-80c4e2cb1683	role_list	f751882b-adae-4e57-96a2-61fcd0497761	SAML role list	saml
27164090-ad2f-4f1d-90c8-caf67e188950	profile	f751882b-adae-4e57-96a2-61fcd0497761	OpenID Connect built-in scope: profile	openid-connect
426ce351-b77e-416c-97b8-8dfef86c4d69	email	f751882b-adae-4e57-96a2-61fcd0497761	OpenID Connect built-in scope: email	openid-connect
7b2b8a93-c087-432f-87f7-d592dddd6b1b	address	f751882b-adae-4e57-96a2-61fcd0497761	OpenID Connect built-in scope: address	openid-connect
eecde97e-b5ec-42f2-acde-ac6080deaaf7	phone	f751882b-adae-4e57-96a2-61fcd0497761	OpenID Connect built-in scope: phone	openid-connect
23a8810c-cd80-478b-b6c7-0d542bea0da4	roles	f751882b-adae-4e57-96a2-61fcd0497761	OpenID Connect scope for add user roles to the access token	openid-connect
4b00688a-cd52-48f8-b60e-95d94d7dd20f	web-origins	f751882b-adae-4e57-96a2-61fcd0497761	OpenID Connect scope for add allowed web origins to the access token	openid-connect
c757081c-545d-4395-94c2-ac60009726bf	microprofile-jwt	f751882b-adae-4e57-96a2-61fcd0497761	Microprofile - JWT built-in scope	openid-connect
2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	acr	f751882b-adae-4e57-96a2-61fcd0497761	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
26ac1db2-719e-4c3f-841d-a6a1228db92a	offline_access	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	OpenID Connect built-in scope: offline_access	openid-connect
358ac934-814a-47fc-82c9-44c6e189bf7a	role_list	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	SAML role list	saml
cf9da1d5-1f21-417e-9772-f212e5d26248	profile	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	OpenID Connect built-in scope: profile	openid-connect
76bfa8d9-5cd0-46ae-a381-7a47a25714a5	email	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	OpenID Connect built-in scope: email	openid-connect
6eb6bf43-c68c-4005-90d0-ea69691db402	address	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	OpenID Connect built-in scope: address	openid-connect
15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	phone	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	OpenID Connect built-in scope: phone	openid-connect
697238b2-3932-4934-bcdb-641a26e41e53	roles	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	OpenID Connect scope for add user roles to the access token	openid-connect
4d0caf81-668f-4968-b48b-e990aad05905	web-origins	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	OpenID Connect scope for add allowed web origins to the access token	openid-connect
8ffff1b6-aaa2-4105-b406-944aa6fd333f	microprofile-jwt	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	Microprofile - JWT built-in scope	openid-connect
04d16d6b-27f5-4353-84fe-f0dda2b75ce8	acr	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	true	display.on.consent.screen
4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	${offlineAccessScopeConsentText}	consent.screen.text
f5bc50af-4046-40e1-bed7-80c4e2cb1683	true	display.on.consent.screen
f5bc50af-4046-40e1-bed7-80c4e2cb1683	${samlRoleListScopeConsentText}	consent.screen.text
27164090-ad2f-4f1d-90c8-caf67e188950	true	display.on.consent.screen
27164090-ad2f-4f1d-90c8-caf67e188950	${profileScopeConsentText}	consent.screen.text
27164090-ad2f-4f1d-90c8-caf67e188950	true	include.in.token.scope
426ce351-b77e-416c-97b8-8dfef86c4d69	true	display.on.consent.screen
426ce351-b77e-416c-97b8-8dfef86c4d69	${emailScopeConsentText}	consent.screen.text
426ce351-b77e-416c-97b8-8dfef86c4d69	true	include.in.token.scope
7b2b8a93-c087-432f-87f7-d592dddd6b1b	true	display.on.consent.screen
7b2b8a93-c087-432f-87f7-d592dddd6b1b	${addressScopeConsentText}	consent.screen.text
7b2b8a93-c087-432f-87f7-d592dddd6b1b	true	include.in.token.scope
eecde97e-b5ec-42f2-acde-ac6080deaaf7	true	display.on.consent.screen
eecde97e-b5ec-42f2-acde-ac6080deaaf7	${phoneScopeConsentText}	consent.screen.text
eecde97e-b5ec-42f2-acde-ac6080deaaf7	true	include.in.token.scope
23a8810c-cd80-478b-b6c7-0d542bea0da4	true	display.on.consent.screen
23a8810c-cd80-478b-b6c7-0d542bea0da4	${rolesScopeConsentText}	consent.screen.text
23a8810c-cd80-478b-b6c7-0d542bea0da4	false	include.in.token.scope
4b00688a-cd52-48f8-b60e-95d94d7dd20f	false	display.on.consent.screen
4b00688a-cd52-48f8-b60e-95d94d7dd20f		consent.screen.text
4b00688a-cd52-48f8-b60e-95d94d7dd20f	false	include.in.token.scope
c757081c-545d-4395-94c2-ac60009726bf	false	display.on.consent.screen
c757081c-545d-4395-94c2-ac60009726bf	true	include.in.token.scope
2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	false	display.on.consent.screen
2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	false	include.in.token.scope
26ac1db2-719e-4c3f-841d-a6a1228db92a	true	display.on.consent.screen
26ac1db2-719e-4c3f-841d-a6a1228db92a	${offlineAccessScopeConsentText}	consent.screen.text
358ac934-814a-47fc-82c9-44c6e189bf7a	true	display.on.consent.screen
358ac934-814a-47fc-82c9-44c6e189bf7a	${samlRoleListScopeConsentText}	consent.screen.text
cf9da1d5-1f21-417e-9772-f212e5d26248	true	display.on.consent.screen
cf9da1d5-1f21-417e-9772-f212e5d26248	${profileScopeConsentText}	consent.screen.text
cf9da1d5-1f21-417e-9772-f212e5d26248	true	include.in.token.scope
76bfa8d9-5cd0-46ae-a381-7a47a25714a5	true	display.on.consent.screen
76bfa8d9-5cd0-46ae-a381-7a47a25714a5	${emailScopeConsentText}	consent.screen.text
76bfa8d9-5cd0-46ae-a381-7a47a25714a5	true	include.in.token.scope
6eb6bf43-c68c-4005-90d0-ea69691db402	true	display.on.consent.screen
6eb6bf43-c68c-4005-90d0-ea69691db402	${addressScopeConsentText}	consent.screen.text
6eb6bf43-c68c-4005-90d0-ea69691db402	true	include.in.token.scope
15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	true	display.on.consent.screen
15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	${phoneScopeConsentText}	consent.screen.text
15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	true	include.in.token.scope
697238b2-3932-4934-bcdb-641a26e41e53	true	display.on.consent.screen
697238b2-3932-4934-bcdb-641a26e41e53	${rolesScopeConsentText}	consent.screen.text
697238b2-3932-4934-bcdb-641a26e41e53	false	include.in.token.scope
4d0caf81-668f-4968-b48b-e990aad05905	false	display.on.consent.screen
4d0caf81-668f-4968-b48b-e990aad05905		consent.screen.text
4d0caf81-668f-4968-b48b-e990aad05905	false	include.in.token.scope
8ffff1b6-aaa2-4105-b406-944aa6fd333f	false	display.on.consent.screen
8ffff1b6-aaa2-4105-b406-944aa6fd333f	true	include.in.token.scope
04d16d6b-27f5-4353-84fe-f0dda2b75ce8	false	display.on.consent.screen
04d16d6b-27f5-4353-84fe-f0dda2b75ce8	false	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
e74587da-c704-485d-9717-1bd7df7f05fd	27164090-ad2f-4f1d-90c8-caf67e188950	t
e74587da-c704-485d-9717-1bd7df7f05fd	2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	t
e74587da-c704-485d-9717-1bd7df7f05fd	4b00688a-cd52-48f8-b60e-95d94d7dd20f	t
e74587da-c704-485d-9717-1bd7df7f05fd	426ce351-b77e-416c-97b8-8dfef86c4d69	t
e74587da-c704-485d-9717-1bd7df7f05fd	23a8810c-cd80-478b-b6c7-0d542bea0da4	t
e74587da-c704-485d-9717-1bd7df7f05fd	eecde97e-b5ec-42f2-acde-ac6080deaaf7	f
e74587da-c704-485d-9717-1bd7df7f05fd	c757081c-545d-4395-94c2-ac60009726bf	f
e74587da-c704-485d-9717-1bd7df7f05fd	4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	f
e74587da-c704-485d-9717-1bd7df7f05fd	7b2b8a93-c087-432f-87f7-d592dddd6b1b	f
2783b436-a88e-4b71-97dc-7bd3898f39d0	27164090-ad2f-4f1d-90c8-caf67e188950	t
2783b436-a88e-4b71-97dc-7bd3898f39d0	2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	t
2783b436-a88e-4b71-97dc-7bd3898f39d0	4b00688a-cd52-48f8-b60e-95d94d7dd20f	t
2783b436-a88e-4b71-97dc-7bd3898f39d0	426ce351-b77e-416c-97b8-8dfef86c4d69	t
2783b436-a88e-4b71-97dc-7bd3898f39d0	23a8810c-cd80-478b-b6c7-0d542bea0da4	t
2783b436-a88e-4b71-97dc-7bd3898f39d0	eecde97e-b5ec-42f2-acde-ac6080deaaf7	f
2783b436-a88e-4b71-97dc-7bd3898f39d0	c757081c-545d-4395-94c2-ac60009726bf	f
2783b436-a88e-4b71-97dc-7bd3898f39d0	4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	f
2783b436-a88e-4b71-97dc-7bd3898f39d0	7b2b8a93-c087-432f-87f7-d592dddd6b1b	f
51bba564-08da-4e42-b1f0-85c117cda097	27164090-ad2f-4f1d-90c8-caf67e188950	t
51bba564-08da-4e42-b1f0-85c117cda097	2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	t
51bba564-08da-4e42-b1f0-85c117cda097	4b00688a-cd52-48f8-b60e-95d94d7dd20f	t
51bba564-08da-4e42-b1f0-85c117cda097	426ce351-b77e-416c-97b8-8dfef86c4d69	t
51bba564-08da-4e42-b1f0-85c117cda097	23a8810c-cd80-478b-b6c7-0d542bea0da4	t
51bba564-08da-4e42-b1f0-85c117cda097	eecde97e-b5ec-42f2-acde-ac6080deaaf7	f
51bba564-08da-4e42-b1f0-85c117cda097	c757081c-545d-4395-94c2-ac60009726bf	f
51bba564-08da-4e42-b1f0-85c117cda097	4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	f
51bba564-08da-4e42-b1f0-85c117cda097	7b2b8a93-c087-432f-87f7-d592dddd6b1b	f
d9059ade-73d5-4e38-b29c-360e89af1918	27164090-ad2f-4f1d-90c8-caf67e188950	t
d9059ade-73d5-4e38-b29c-360e89af1918	2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	t
d9059ade-73d5-4e38-b29c-360e89af1918	4b00688a-cd52-48f8-b60e-95d94d7dd20f	t
d9059ade-73d5-4e38-b29c-360e89af1918	426ce351-b77e-416c-97b8-8dfef86c4d69	t
d9059ade-73d5-4e38-b29c-360e89af1918	23a8810c-cd80-478b-b6c7-0d542bea0da4	t
d9059ade-73d5-4e38-b29c-360e89af1918	eecde97e-b5ec-42f2-acde-ac6080deaaf7	f
d9059ade-73d5-4e38-b29c-360e89af1918	c757081c-545d-4395-94c2-ac60009726bf	f
d9059ade-73d5-4e38-b29c-360e89af1918	4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	f
d9059ade-73d5-4e38-b29c-360e89af1918	7b2b8a93-c087-432f-87f7-d592dddd6b1b	f
ca13f022-86a6-4d5a-98d6-0f96164f7250	27164090-ad2f-4f1d-90c8-caf67e188950	t
ca13f022-86a6-4d5a-98d6-0f96164f7250	2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	t
ca13f022-86a6-4d5a-98d6-0f96164f7250	4b00688a-cd52-48f8-b60e-95d94d7dd20f	t
ca13f022-86a6-4d5a-98d6-0f96164f7250	426ce351-b77e-416c-97b8-8dfef86c4d69	t
ca13f022-86a6-4d5a-98d6-0f96164f7250	23a8810c-cd80-478b-b6c7-0d542bea0da4	t
ca13f022-86a6-4d5a-98d6-0f96164f7250	eecde97e-b5ec-42f2-acde-ac6080deaaf7	f
ca13f022-86a6-4d5a-98d6-0f96164f7250	c757081c-545d-4395-94c2-ac60009726bf	f
ca13f022-86a6-4d5a-98d6-0f96164f7250	4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	f
ca13f022-86a6-4d5a-98d6-0f96164f7250	7b2b8a93-c087-432f-87f7-d592dddd6b1b	f
edd1bb01-6648-440a-aa92-b1c51b766aad	27164090-ad2f-4f1d-90c8-caf67e188950	t
edd1bb01-6648-440a-aa92-b1c51b766aad	2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	t
edd1bb01-6648-440a-aa92-b1c51b766aad	4b00688a-cd52-48f8-b60e-95d94d7dd20f	t
edd1bb01-6648-440a-aa92-b1c51b766aad	426ce351-b77e-416c-97b8-8dfef86c4d69	t
edd1bb01-6648-440a-aa92-b1c51b766aad	23a8810c-cd80-478b-b6c7-0d542bea0da4	t
edd1bb01-6648-440a-aa92-b1c51b766aad	eecde97e-b5ec-42f2-acde-ac6080deaaf7	f
edd1bb01-6648-440a-aa92-b1c51b766aad	c757081c-545d-4395-94c2-ac60009726bf	f
edd1bb01-6648-440a-aa92-b1c51b766aad	4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	f
edd1bb01-6648-440a-aa92-b1c51b766aad	7b2b8a93-c087-432f-87f7-d592dddd6b1b	f
39b034e8-297a-4e48-adc3-0d53c0797cb7	cf9da1d5-1f21-417e-9772-f212e5d26248	t
39b034e8-297a-4e48-adc3-0d53c0797cb7	04d16d6b-27f5-4353-84fe-f0dda2b75ce8	t
39b034e8-297a-4e48-adc3-0d53c0797cb7	76bfa8d9-5cd0-46ae-a381-7a47a25714a5	t
39b034e8-297a-4e48-adc3-0d53c0797cb7	4d0caf81-668f-4968-b48b-e990aad05905	t
39b034e8-297a-4e48-adc3-0d53c0797cb7	697238b2-3932-4934-bcdb-641a26e41e53	t
39b034e8-297a-4e48-adc3-0d53c0797cb7	6eb6bf43-c68c-4005-90d0-ea69691db402	f
39b034e8-297a-4e48-adc3-0d53c0797cb7	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	f
39b034e8-297a-4e48-adc3-0d53c0797cb7	8ffff1b6-aaa2-4105-b406-944aa6fd333f	f
39b034e8-297a-4e48-adc3-0d53c0797cb7	26ac1db2-719e-4c3f-841d-a6a1228db92a	f
7bfaf0df-680c-4fb7-8b75-62b58880d428	cf9da1d5-1f21-417e-9772-f212e5d26248	t
7bfaf0df-680c-4fb7-8b75-62b58880d428	04d16d6b-27f5-4353-84fe-f0dda2b75ce8	t
7bfaf0df-680c-4fb7-8b75-62b58880d428	76bfa8d9-5cd0-46ae-a381-7a47a25714a5	t
7bfaf0df-680c-4fb7-8b75-62b58880d428	4d0caf81-668f-4968-b48b-e990aad05905	t
7bfaf0df-680c-4fb7-8b75-62b58880d428	697238b2-3932-4934-bcdb-641a26e41e53	t
7bfaf0df-680c-4fb7-8b75-62b58880d428	6eb6bf43-c68c-4005-90d0-ea69691db402	f
7bfaf0df-680c-4fb7-8b75-62b58880d428	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	f
7bfaf0df-680c-4fb7-8b75-62b58880d428	8ffff1b6-aaa2-4105-b406-944aa6fd333f	f
7bfaf0df-680c-4fb7-8b75-62b58880d428	26ac1db2-719e-4c3f-841d-a6a1228db92a	f
e1851637-5a8a-4189-ac2e-6fa23c55c381	cf9da1d5-1f21-417e-9772-f212e5d26248	t
e1851637-5a8a-4189-ac2e-6fa23c55c381	04d16d6b-27f5-4353-84fe-f0dda2b75ce8	t
e1851637-5a8a-4189-ac2e-6fa23c55c381	76bfa8d9-5cd0-46ae-a381-7a47a25714a5	t
e1851637-5a8a-4189-ac2e-6fa23c55c381	4d0caf81-668f-4968-b48b-e990aad05905	t
e1851637-5a8a-4189-ac2e-6fa23c55c381	697238b2-3932-4934-bcdb-641a26e41e53	t
e1851637-5a8a-4189-ac2e-6fa23c55c381	6eb6bf43-c68c-4005-90d0-ea69691db402	f
e1851637-5a8a-4189-ac2e-6fa23c55c381	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	f
e1851637-5a8a-4189-ac2e-6fa23c55c381	8ffff1b6-aaa2-4105-b406-944aa6fd333f	f
e1851637-5a8a-4189-ac2e-6fa23c55c381	26ac1db2-719e-4c3f-841d-a6a1228db92a	f
25de7b22-1f9a-4008-a602-0f9d042b6cb5	cf9da1d5-1f21-417e-9772-f212e5d26248	t
25de7b22-1f9a-4008-a602-0f9d042b6cb5	04d16d6b-27f5-4353-84fe-f0dda2b75ce8	t
25de7b22-1f9a-4008-a602-0f9d042b6cb5	76bfa8d9-5cd0-46ae-a381-7a47a25714a5	t
25de7b22-1f9a-4008-a602-0f9d042b6cb5	4d0caf81-668f-4968-b48b-e990aad05905	t
25de7b22-1f9a-4008-a602-0f9d042b6cb5	697238b2-3932-4934-bcdb-641a26e41e53	t
25de7b22-1f9a-4008-a602-0f9d042b6cb5	6eb6bf43-c68c-4005-90d0-ea69691db402	f
25de7b22-1f9a-4008-a602-0f9d042b6cb5	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	f
25de7b22-1f9a-4008-a602-0f9d042b6cb5	8ffff1b6-aaa2-4105-b406-944aa6fd333f	f
25de7b22-1f9a-4008-a602-0f9d042b6cb5	26ac1db2-719e-4c3f-841d-a6a1228db92a	f
9272434e-b7d2-407f-8efa-1a525aedf732	cf9da1d5-1f21-417e-9772-f212e5d26248	t
9272434e-b7d2-407f-8efa-1a525aedf732	04d16d6b-27f5-4353-84fe-f0dda2b75ce8	t
9272434e-b7d2-407f-8efa-1a525aedf732	76bfa8d9-5cd0-46ae-a381-7a47a25714a5	t
9272434e-b7d2-407f-8efa-1a525aedf732	4d0caf81-668f-4968-b48b-e990aad05905	t
9272434e-b7d2-407f-8efa-1a525aedf732	697238b2-3932-4934-bcdb-641a26e41e53	t
9272434e-b7d2-407f-8efa-1a525aedf732	6eb6bf43-c68c-4005-90d0-ea69691db402	f
9272434e-b7d2-407f-8efa-1a525aedf732	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	f
9272434e-b7d2-407f-8efa-1a525aedf732	8ffff1b6-aaa2-4105-b406-944aa6fd333f	f
9272434e-b7d2-407f-8efa-1a525aedf732	26ac1db2-719e-4c3f-841d-a6a1228db92a	f
07a8e7af-80f6-4672-abef-5786c95e7867	cf9da1d5-1f21-417e-9772-f212e5d26248	t
07a8e7af-80f6-4672-abef-5786c95e7867	04d16d6b-27f5-4353-84fe-f0dda2b75ce8	t
07a8e7af-80f6-4672-abef-5786c95e7867	76bfa8d9-5cd0-46ae-a381-7a47a25714a5	t
07a8e7af-80f6-4672-abef-5786c95e7867	4d0caf81-668f-4968-b48b-e990aad05905	t
07a8e7af-80f6-4672-abef-5786c95e7867	697238b2-3932-4934-bcdb-641a26e41e53	t
07a8e7af-80f6-4672-abef-5786c95e7867	6eb6bf43-c68c-4005-90d0-ea69691db402	f
07a8e7af-80f6-4672-abef-5786c95e7867	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	f
07a8e7af-80f6-4672-abef-5786c95e7867	8ffff1b6-aaa2-4105-b406-944aa6fd333f	f
07a8e7af-80f6-4672-abef-5786c95e7867	26ac1db2-719e-4c3f-841d-a6a1228db92a	f
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	cf9da1d5-1f21-417e-9772-f212e5d26248	t
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	04d16d6b-27f5-4353-84fe-f0dda2b75ce8	t
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	76bfa8d9-5cd0-46ae-a381-7a47a25714a5	t
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	4d0caf81-668f-4968-b48b-e990aad05905	t
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	697238b2-3932-4934-bcdb-641a26e41e53	t
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	6eb6bf43-c68c-4005-90d0-ea69691db402	f
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	f
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	8ffff1b6-aaa2-4105-b406-944aa6fd333f	f
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	26ac1db2-719e-4c3f-841d-a6a1228db92a	f
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	cf9da1d5-1f21-417e-9772-f212e5d26248	t
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	04d16d6b-27f5-4353-84fe-f0dda2b75ce8	t
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	76bfa8d9-5cd0-46ae-a381-7a47a25714a5	t
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	4d0caf81-668f-4968-b48b-e990aad05905	t
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	6eb6bf43-c68c-4005-90d0-ea69691db402	f
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	f
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	8ffff1b6-aaa2-4105-b406-944aa6fd333f	f
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	26ac1db2-719e-4c3f-841d-a6a1228db92a	f
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	27164090-ad2f-4f1d-90c8-caf67e188950	t
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	t
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	4b00688a-cd52-48f8-b60e-95d94d7dd20f	t
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	426ce351-b77e-416c-97b8-8dfef86c4d69	t
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	23a8810c-cd80-478b-b6c7-0d542bea0da4	t
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	eecde97e-b5ec-42f2-acde-ac6080deaaf7	f
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	c757081c-545d-4395-94c2-ac60009726bf	f
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	f
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	7b2b8a93-c087-432f-87f7-d592dddd6b1b	f
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	27164090-ad2f-4f1d-90c8-caf67e188950	t
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	t
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	4b00688a-cd52-48f8-b60e-95d94d7dd20f	t
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	426ce351-b77e-416c-97b8-8dfef86c4d69	t
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	23a8810c-cd80-478b-b6c7-0d542bea0da4	t
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	eecde97e-b5ec-42f2-acde-ac6080deaaf7	f
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	c757081c-545d-4395-94c2-ac60009726bf	f
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	f
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	7b2b8a93-c087-432f-87f7-d592dddd6b1b	f
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	697238b2-3932-4934-bcdb-641a26e41e53	t
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	e3f4b80d-9223-487d-94c2-dc7143455a51
26ac1db2-719e-4c3f-841d-a6a1228db92a	932362fb-58e7-4fec-91f6-8a383e06819f
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
6160affd-0b4c-49af-941c-e99f3939f3bb	Trusted Hosts	f751882b-adae-4e57-96a2-61fcd0497761	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	f751882b-adae-4e57-96a2-61fcd0497761	anonymous
86786c89-85f4-45b2-a7b5-a6beeee4dac9	Consent Required	f751882b-adae-4e57-96a2-61fcd0497761	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	f751882b-adae-4e57-96a2-61fcd0497761	anonymous
a19a9e49-fdf4-47f4-b980-f2af0ec4eca7	Full Scope Disabled	f751882b-adae-4e57-96a2-61fcd0497761	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	f751882b-adae-4e57-96a2-61fcd0497761	anonymous
500f8b22-e479-46ab-afa7-d83b793958f1	Max Clients Limit	f751882b-adae-4e57-96a2-61fcd0497761	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	f751882b-adae-4e57-96a2-61fcd0497761	anonymous
6627e879-0c8e-42e2-b753-6a8ec69eeef5	Allowed Protocol Mapper Types	f751882b-adae-4e57-96a2-61fcd0497761	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	f751882b-adae-4e57-96a2-61fcd0497761	anonymous
7e181b35-1e46-4cce-aa8b-e001692dadc7	Allowed Client Scopes	f751882b-adae-4e57-96a2-61fcd0497761	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	f751882b-adae-4e57-96a2-61fcd0497761	anonymous
0f626fe2-d539-4629-b6dd-027e4c3ae9dc	Allowed Protocol Mapper Types	f751882b-adae-4e57-96a2-61fcd0497761	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	f751882b-adae-4e57-96a2-61fcd0497761	authenticated
1749cc89-0481-464e-8ddb-ce9c12eaf200	Allowed Client Scopes	f751882b-adae-4e57-96a2-61fcd0497761	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	f751882b-adae-4e57-96a2-61fcd0497761	authenticated
788d3fd4-3816-4636-8ef5-c5609716999d	rsa-generated	f751882b-adae-4e57-96a2-61fcd0497761	rsa-generated	org.keycloak.keys.KeyProvider	f751882b-adae-4e57-96a2-61fcd0497761	\N
22993f12-672a-4cef-acbd-c48390cc7367	rsa-enc-generated	f751882b-adae-4e57-96a2-61fcd0497761	rsa-enc-generated	org.keycloak.keys.KeyProvider	f751882b-adae-4e57-96a2-61fcd0497761	\N
c5997794-d8c0-4a7b-88fe-997df4a90165	hmac-generated	f751882b-adae-4e57-96a2-61fcd0497761	hmac-generated	org.keycloak.keys.KeyProvider	f751882b-adae-4e57-96a2-61fcd0497761	\N
cc6676c3-23b0-4956-80b3-adb12a21a563	aes-generated	f751882b-adae-4e57-96a2-61fcd0497761	aes-generated	org.keycloak.keys.KeyProvider	f751882b-adae-4e57-96a2-61fcd0497761	\N
6b426ff9-6687-4da3-aaa2-a4505b80ce08	rsa-generated	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	rsa-generated	org.keycloak.keys.KeyProvider	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N
f07088fc-1229-4f0d-9cef-0e565747706c	rsa-enc-generated	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	rsa-enc-generated	org.keycloak.keys.KeyProvider	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N
c313dc95-a224-416c-bd7f-0e7dda768257	hmac-generated	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	hmac-generated	org.keycloak.keys.KeyProvider	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N
b1a5c138-a025-46d0-88c6-410ef4e981e7	aes-generated	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	aes-generated	org.keycloak.keys.KeyProvider	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N
17ba2162-a0e8-420a-acfa-751c8df41926	Trusted Hosts	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	anonymous
c7de0189-f2f8-4762-a10a-f47c29a6a185	Consent Required	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	anonymous
8fde74fd-1c7d-4d21-8747-e742e2f852f7	Full Scope Disabled	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	anonymous
6c528085-9654-4487-a671-4a156ed0c831	Max Clients Limit	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	anonymous
ff606c52-12b9-4905-8f17-4d06ad6c3483	Allowed Protocol Mapper Types	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	anonymous
8094336c-a339-4b71-a68d-6bea810b879b	Allowed Client Scopes	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	anonymous
94c87219-58d7-4dc3-8a73-5e054a61e72a	Allowed Protocol Mapper Types	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	authenticated
43bf8e5b-817f-4844-8699-9d5fbfc0de74	Allowed Client Scopes	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
872ca2ba-1aa6-4ae7-b0f9-c9cbe898ab32	7e181b35-1e46-4cce-aa8b-e001692dadc7	allow-default-scopes	true
bfcae7d1-cd0e-401f-8dc3-fb45e43cb1a0	0f626fe2-d539-4629-b6dd-027e4c3ae9dc	allowed-protocol-mapper-types	saml-user-attribute-mapper
401a9426-17b5-46a2-8275-7798e35a2d09	0f626fe2-d539-4629-b6dd-027e4c3ae9dc	allowed-protocol-mapper-types	oidc-full-name-mapper
4e237504-a5b6-49fb-be4f-45f50f0570b5	0f626fe2-d539-4629-b6dd-027e4c3ae9dc	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
a576ddfb-c0c5-4032-b28f-64e33188b771	0f626fe2-d539-4629-b6dd-027e4c3ae9dc	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
c98a4cbc-502b-42c7-a520-8b11e9a2e2d9	0f626fe2-d539-4629-b6dd-027e4c3ae9dc	allowed-protocol-mapper-types	oidc-address-mapper
89378b53-6a46-4465-b8af-2758b887077b	0f626fe2-d539-4629-b6dd-027e4c3ae9dc	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
acf14dd3-f34b-4099-96a6-7a4f5ff61eba	0f626fe2-d539-4629-b6dd-027e4c3ae9dc	allowed-protocol-mapper-types	saml-role-list-mapper
cdb1ef61-10a2-4abe-b9d1-22ad58a85306	0f626fe2-d539-4629-b6dd-027e4c3ae9dc	allowed-protocol-mapper-types	saml-user-property-mapper
849ef91d-c457-4a6d-8cad-259a19edbfa6	6627e879-0c8e-42e2-b753-6a8ec69eeef5	allowed-protocol-mapper-types	saml-user-property-mapper
6fa74ab7-56b0-44ba-9078-54b9f1f32382	6627e879-0c8e-42e2-b753-6a8ec69eeef5	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
80d3a151-e320-4062-8896-bda4707fe3d5	6627e879-0c8e-42e2-b753-6a8ec69eeef5	allowed-protocol-mapper-types	saml-user-attribute-mapper
38451391-54ee-4a4f-9652-0f03560990f8	6627e879-0c8e-42e2-b753-6a8ec69eeef5	allowed-protocol-mapper-types	oidc-address-mapper
786d5c9d-353f-467f-850c-1365e8ffb923	6627e879-0c8e-42e2-b753-6a8ec69eeef5	allowed-protocol-mapper-types	oidc-full-name-mapper
7729d7a0-4c9a-4c84-b6e5-7fc623dfba26	6627e879-0c8e-42e2-b753-6a8ec69eeef5	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
6785493b-fc0f-4666-9f0b-549db365425f	6627e879-0c8e-42e2-b753-6a8ec69eeef5	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
890b0877-9c45-4249-a9bf-c30d57edc02b	6627e879-0c8e-42e2-b753-6a8ec69eeef5	allowed-protocol-mapper-types	saml-role-list-mapper
6274b036-f4ff-4ff1-88df-e681adf4609f	6160affd-0b4c-49af-941c-e99f3939f3bb	client-uris-must-match	true
4776d605-43c0-4603-bbaf-a47d254e7c3a	6160affd-0b4c-49af-941c-e99f3939f3bb	host-sending-registration-request-must-match	true
64539a00-f9d2-403e-8a53-110025c8a5c5	500f8b22-e479-46ab-afa7-d83b793958f1	max-clients	200
f6239fc7-fbb3-4044-9bd8-b4bb5f59a11c	1749cc89-0481-464e-8ddb-ce9c12eaf200	allow-default-scopes	true
0a4f5216-2cfc-4f25-90e2-a8dfc7e5d6d0	788d3fd4-3816-4636-8ef5-c5609716999d	keyUse	SIG
1f6bd197-cd72-4c16-afe5-82956f409526	788d3fd4-3816-4636-8ef5-c5609716999d	privateKey	MIIEpAIBAAKCAQEAviBtLEKTD/dJ7g+41nYhWVEbzS3oBXskTn1sNO3EScPSI3LWxHw7Po2p7QPKmgWHVDkSZNImX7Lji/JESZa9k8SBw4qXUtv/zBmSGJPb0jErQ7rD0bkBlRtuQzxRqB6iTkGqQzHj8m7ABxy7D6t00ReoEhKmdvieIa+WyES9PI/zZm9lHBUjPDOWOF8B6O0ac+zoWCSOhPdUhyG4i7gle+1M7UN80ouQ7ANBJxiKR7y0kti8TvfMB0gHZXX138sX8fYOxd3g4BWTXjejNhqZufe8wz6D/QRsRweoHm9CwaM1NFK9/G+MyPO/n/SLSd0K7KfDLW0uWfXEK7e2ttHXZQIDAQABAoIBAAFszstotc6hMlbsL/tEXggmCGBq84JNUuBJ1b1sPYnsAC+UW+CutypUmS1Lw0t2B6xtdYCf2LbxVRjcbkLqGR1YXi8l6eJx5Q5ZCu1xY72ckvGm9ledtA5wNPwnSg9Joc704DLteInb9G/E//AJcfOzrHrEF9yvrpHYRup2udp8E66G2eH32J+vC7oQFyE5C1yPVrg/DPIGs+C7B6bvHnYT575IzaBsTkKeXN3zLiENXQAwRLJDdUxqLwoIwRd5SAkO5RaP6Z0N7amG/zhvLLOOn+jC4EPBieOvx95aXbVqfe809rxLlW4Py03yXr61KTy2JwVmZOxTkY0D3u3FQhUCgYEA4jBllHUG3nB2NO2+2Wop0y0UG5DvZIXb0wRN96X+xNNhdADVjbt73D9dGz4c/RzI/b2DgufFbgBAA8jUZdtkKy8IWvA2L1Il7+iyew/YYX13ToCfp0x3jeHI2KhhpHa0tf9rNUfIbbFEKppgE2w0iBwhu9ZcRdZe2VklzipQGUsCgYEA1y9JijmywcpZNnjihQQy9/38UAZ/ZfHnvdKA05h9+oSWTxnXnIvdPGFjBZKABbyX2jtJE/x/XvGowvTesTmq9YbI0NYX9BacBC9eT5Z8i+Ys8GB+WDRlnB41zGbRNrj78mAvuy2dhvYF0mEsGEnHlwqpxYXkKrW/r8qrgIDjlA8CgYAdla7zqArp9VPAwIgB7/zgfjjvEhn9z/RcuWdpSPD11aAdiC5mh2s/95m6AnnQMX+okK0u5hnQtX+p/w6o8/U6IMC7BEhSEDCeHJWbuwrWVY7RWcmIHFxW1n1quTtsQ4qHc40WPvlcP59m4yJF6BVG6EcRRoxzJgLp8tsbCDXJ2QKBgQCU+LTFz/oUNX0bvAa+JdEPZLOXx1fNgPJ5tNDhLFIS7FWO/4oIY7/O/HDsO6cL0aujNqX6AzU+yriV96ZwNUdI4X4HLiC5KCnsr8pv+PPSepCj/XmaoPOzaCrAjnHKm7g47SQ+Rm8nLw2KvyEi03ks9QHhsDbs5pSFJB8lQJXNOwKBgQDIJzWluUq6BPkOs77KjXBngy3UvItInZXWjdUGfhZwq81niQnLxZr/uvSxPNUNzT7RrgcJ56xJOyvGjS5HYwjTIArJEZl1DwQ25r3t+IkN3nSDt/X5vGn5whNN28Xa3yFpUg0W1cXge9D7Cd30FBY06p1t+xLKGPDcvX0P1NO7fQ==
030b30df-0c03-416a-a5e2-a1b53d4ef8af	788d3fd4-3816-4636-8ef5-c5609716999d	certificate	MIICmzCCAYMCBgGWFtxpgjANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNDA4MTkyMjQ1WhcNMzUwNDA4MTkyNDI1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+IG0sQpMP90nuD7jWdiFZURvNLegFeyROfWw07cRJw9IjctbEfDs+jantA8qaBYdUORJk0iZfsuOL8kRJlr2TxIHDipdS2//MGZIYk9vSMStDusPRuQGVG25DPFGoHqJOQapDMePybsAHHLsPq3TRF6gSEqZ2+J4hr5bIRL08j/Nmb2UcFSM8M5Y4XwHo7Rpz7OhYJI6E91SHIbiLuCV77UztQ3zSi5DsA0EnGIpHvLSS2LxO98wHSAdldfXfyxfx9g7F3eDgFZNeN6M2Gpm597zDPoP9BGxHB6geb0LBozU0Ur38b4zI87+f9ItJ3Qrsp8MtbS5Z9cQrt7a20ddlAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAIrAC4fkH60nt+gh1k+AJpk6rCsz793arPxT9nCfyPmMSgVC63o2AEA9Itu/l9X65phmLAopRUjw2GEs41AolzxU4m86yAh4xAWJfQfN0G2upd9v5bMF0390dzCXjSZPelzjbBsPlawtCLw8yS7CuXzOOVR87VUXsveI3Tn619BFvWBR4G1kpqn4037oimXDF/20/lLsebQ+3qkOG55mVjj7HCsXIOLZx7u6BLaJTZ6oFDli2pCEKCeHnjACuLAcp5r+usU5YwnPBU0xi4tosSSKDdAkOcsTxF4DuRborCKr+54jvQ15F7r0PVtI3w5mAZKKS/2CLKH7p8piFid6FU8=
86dd3b84-cd69-45f0-a1c8-96440b10679d	788d3fd4-3816-4636-8ef5-c5609716999d	priority	100
b973b9bc-8b50-4967-b6ac-8c6db42b8af0	cc6676c3-23b0-4956-80b3-adb12a21a563	secret	__sCtuwPfwjOmLrYwyoFBQ
a9eeb5b3-16d5-4401-b7ab-a0d602999c2c	cc6676c3-23b0-4956-80b3-adb12a21a563	kid	dba38ad0-c438-4f37-9bbc-837e028ca6cd
bb0833da-5dc5-4f61-8720-6a29215b78a6	cc6676c3-23b0-4956-80b3-adb12a21a563	priority	100
821cde00-6c11-46e8-a189-f5a0861917e9	c5997794-d8c0-4a7b-88fe-997df4a90165	priority	100
e6b7a1a1-f916-42be-91bc-21766020372f	c5997794-d8c0-4a7b-88fe-997df4a90165	secret	azGi1zgtYljn3jru3rW_oFjzyX3tpNRu3wo9DH6mI8xGwSF4SVJ8ToCxJvDIN0QIWUF4jAuuhglh5BxRWaq-gw
39a00a6e-fd5d-48c7-acf2-76bdee2bf228	c5997794-d8c0-4a7b-88fe-997df4a90165	algorithm	HS256
96b62bc4-26e3-444e-b34a-ba574fedeb63	c5997794-d8c0-4a7b-88fe-997df4a90165	kid	f541eafd-5ccf-40ca-98ab-5aef46d3dd6e
55dabd1f-64d3-47e3-abef-c1878e6fffef	22993f12-672a-4cef-acbd-c48390cc7367	keyUse	ENC
a1b69a3a-ac31-4c95-8f1f-74b856baec65	22993f12-672a-4cef-acbd-c48390cc7367	priority	100
86ea9aa4-9c8f-4832-be79-ed51c2e435a8	f07088fc-1229-4f0d-9cef-0e565747706c	priority	100
b3e8657e-34ee-4dcf-8203-3008951bd5c3	f07088fc-1229-4f0d-9cef-0e565747706c	algorithm	RSA-OAEP
a3929b02-3c04-4bb1-aca5-85bd2c965590	f07088fc-1229-4f0d-9cef-0e565747706c	keyUse	ENC
f6c21a4c-927e-450f-bd81-610a46b385a4	22993f12-672a-4cef-acbd-c48390cc7367	privateKey	MIIEowIBAAKCAQEAsZdB0x2tEIJbnJmFot4MvxUOxHzgmrS6GlivNzgJ1Zdz5ilWV2qop0jcWMihq//28SIJ+dcjVdse9echhFFrQL8NPKo00KLL5iZovRgUKJSYRImu5ZA9aTiOB76DC8CC0/zRI/FdpKVDT/x17/VbG3+d/rYAkzccHRVnHmoOwO9JemCLI4rBuxJSq/p6EyfgJ4ma30levkw1Y9r6bT9XqtMTHW4fa7NG5MllmATAt0/zKVlKQX4+MH4uGx7cIuJvIOPPOK2kr1n0/3qsnBWvVMe9rLz1/zil/WKuL27N6N5vn4pErD3oooIL32oSZGkuxyBEiuHXwjrndFC2ZU46ywIDAQABAoIBAC44KBUKba7UxoQIvquHL/kRQXEo8QnCjIbr2to7tu+EhdD6pDKHG1LCVzqyKMWLjhju23rPH66qIzIrj+EQkaHdt1O5FprQK9H/4BWKrUBsf/6ieMbdVeZLJkfksNV/qm0CqOm6WT1PF6g7E/S6PhZ3jcarVpX561K0bcyQHLvge72FIvM6NeQWc5l2NlCnemPbqUA5oK+3WXZUkjF0Ob2ZLJPFI+t2DNoHJ4wJAnl2ul9fbWsKTksLL/0CzOoja+gNdsIh+v73Mv1e8T4kMa2I1q1G93olzQjqolZLqhpLmRykx3QHWHnEv5UsSRcBNkRFyHZCdasqH0Qlwfdc1DECgYEA5yQWQ1Wl7DCxEWlakeNk8DKSIf4tLvV7ojrmZwRhqkB6WGhJ80emzshA1yzJ3xbmLDFylOStZYinQASK4hhqT+8oECxLFehzE3B/O8sNMhnFU4ZtXWLAk6M/jLizCHF2NZD0SD7pK+OgoHhtth1ka5JdRLz+znCPOLJttNrrO/ECgYEAxLDLwWx7wySCUwZOeMjiw1w8JNp+NDEgWD1cCiMyFbM/DcxETcB2/3nWHxRnBcLTXhlxEk5QVbKGttoxVs34fDKTaZ+gakapnYHGfMjv0TO8wzIqc+PesU0P2RG5KUyLzKNfA6v5TYFRaTZQUvPXjxw8ghLef01tHnE+S9NVTnsCgYEAveebVwVGhpDW2jxaCmTu6J5UDBO+YceVJYwJAvjJmUzSeFJu96+V8Gz9QQzuaxlwUTzrLEPZ5wLojyNsTCjNKBGRNACATGaoLX+PObwxgklEI8TdlA1vtZ05uE+D4Nr/yTDoU3dEsieaMF3hne/2Mp+Ve8VgAJLgSS/oDOCUxrECgYA8SdSqnQ3yaqZnvG8hJrIbH5Jv2WkFpmk7otMraE5ZyG9zU0E8c9oFxNqU/DP32Bfhp/q4mbiWC/qu4YJuEQQxTW9R2NPav34OAVFNvmmDvlAFpMLOcvI3dl99MamHtybCuvDMt1HbJ+BEV5mXU5anDwic9hus+ZaQ1jU6GLT1MQKBgGsfNtl1hMIFdKwOFNueXrbtySjiJYdBPNGsYsgehfj8wHisncEKGnD4Cvz8+fHK7HUjN8JMuWwLHJKGMo0BWON6LaeRSNAfnHn00lFronPJoFcA5PkUgUKU2K4srJ+c/SfCIaRl8PbSPc/wwDBBea3m7gIVvOpULSn+efCclnN9
f43444b4-e741-4e75-bad1-eb3bebcb546e	22993f12-672a-4cef-acbd-c48390cc7367	certificate	MIICmzCCAYMCBgGWFtxqizANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNDA4MTkyMjQ2WhcNMzUwNDA4MTkyNDI2WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCxl0HTHa0QglucmYWi3gy/FQ7EfOCatLoaWK83OAnVl3PmKVZXaqinSNxYyKGr//bxIgn51yNV2x715yGEUWtAvw08qjTQosvmJmi9GBQolJhEia7lkD1pOI4HvoMLwILT/NEj8V2kpUNP/HXv9Vsbf53+tgCTNxwdFWceag7A70l6YIsjisG7ElKr+noTJ+AniZrfSV6+TDVj2vptP1eq0xMdbh9rs0bkyWWYBMC3T/MpWUpBfj4wfi4bHtwi4m8g4884raSvWfT/eqycFa9Ux72svPX/OKX9Yq4vbs3o3m+fikSsPeiiggvfahJkaS7HIESK4dfCOud0ULZlTjrLAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAD344AKISuUsnHe1Q3xz3PQlh8x+QDn0WrYJ846Qumx7c3aD+luskhg90poYmiZZdU0jVuz1sbBz9EICOxCoeczgHj5AHhlsIUw/DTMgK6d4bFFY8tYH9NYJi9/eu94otSBa8p9X5HILfcNNfQ+8fAdSz0YPBT+Lt285HBMMvwR3N82BIhXtnBskuV4SUBqRgWWhWM4Q/pop1gawJxve2jNldfZv52ESXDkxuvumy4AWYkMuBXiLWyRLh70xh1zMlqHLHRSJVA35/o2rvVngDf1Dj3aRaoHxXGSOcWjLmD7IfvOhUPA9Z8hE8eZPu3/1UPqNPHZ7djJVFKnDE3ygS18=
b6839918-0747-4994-be6e-0209316c0317	22993f12-672a-4cef-acbd-c48390cc7367	algorithm	RSA-OAEP
069efb7f-cc65-4ce3-9ae0-76e46bc68891	c313dc95-a224-416c-bd7f-0e7dda768257	kid	1d4fcf2c-d258-497d-a51b-7bc144da2d67
7833730c-7868-47ee-8754-0e3c475f4ed3	c313dc95-a224-416c-bd7f-0e7dda768257	secret	7zj3OFYEgq-dKrpqop8T5zVW2sDiKBvj6rgb29eMBYK0cJ_GsKQzDykNeahOQ1RMq1DeeswW5BFScodPdVDxwg
f7cc7b5d-d934-4c51-93ed-58460e4c2e84	c313dc95-a224-416c-bd7f-0e7dda768257	algorithm	HS256
b02b94ce-785f-4f7f-a32c-7b00449a0779	c313dc95-a224-416c-bd7f-0e7dda768257	priority	100
a62e129b-6e55-4f74-abec-84a0076b864c	6b426ff9-6687-4da3-aaa2-a4505b80ce08	priority	100
fb965837-a414-4859-a394-b3c0130341df	6b426ff9-6687-4da3-aaa2-a4505b80ce08	certificate	MIICnzCCAYcCBgGWFuz3GTANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhjb25jZXJ0bzAeFw0yNTA0MDgxOTQwNTBaFw0zNTA0MDgxOTQyMzBaMBMxETAPBgNVBAMMCGNvbmNlcnRvMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4kvwVHAzdaQw/7jFcj+QKgwo15MDP+UWo+rRqEc2Azhv2pyMVFOqynHi917ysAMJmHGeItsPndT7HKEGXkA9+hODvzpMBHi9s1xx6DuS08dG9AOn3imD0VQQxm0an8HBM/wuANaOkaa8XlrRYSUgglyOecfSnfPPd3wAnP/1mZyTYQUB2BAOhtJR99C58Wuh1sjc6D02i6qX4WnRJsp9IitnJD+vYOb0qmyznWNqQTcQW2FNPtQL+eLgYoKDKrA5dZuPYaJ2cJ3LZ15CUNrdgh98WwMu20mFuIY/qVrlUuCf+FoTw90zlV8/AmTesty6w/cPJn/qm35vPeTjeDtWRQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBw3Im29LVQRCEHlAvi7gK1BROh1S0j6Qv6iDhnxKruruBnQIsC2c6nwq4+elvkIXpH0+/jWSjSzAEZzagPTW1jg/cCnP79LVpxLMT/1L03U5CuKniOswR2RTrY+rzaNI65yFJxj4p1SB2MnaSDtaMcRqKP2hpb+HOzjMTCozhzcVWp9R7meazDKXS/xWPSJQWrCQql4UPu2cKXChJa9OzK65BIzsWSs4ACJsg7JtVP8iO6Gimq8nw/Mg4J+Iq7hvLmdnNVlx4ukTAg0azkNa58gVhjmAZCCYRc5PrCVtHaTAXPbrAkVfAV7ZIQ6Ka26qQEt9hlxLJu7MbrBw02Op7A
3849b48a-904f-42f8-b0a5-6aa5726b40d8	6b426ff9-6687-4da3-aaa2-a4505b80ce08	keyUse	SIG
e3c3af82-316a-4e12-8c81-3d3f3b9bd6c0	6b426ff9-6687-4da3-aaa2-a4505b80ce08	privateKey	MIIEpAIBAAKCAQEA4kvwVHAzdaQw/7jFcj+QKgwo15MDP+UWo+rRqEc2Azhv2pyMVFOqynHi917ysAMJmHGeItsPndT7HKEGXkA9+hODvzpMBHi9s1xx6DuS08dG9AOn3imD0VQQxm0an8HBM/wuANaOkaa8XlrRYSUgglyOecfSnfPPd3wAnP/1mZyTYQUB2BAOhtJR99C58Wuh1sjc6D02i6qX4WnRJsp9IitnJD+vYOb0qmyznWNqQTcQW2FNPtQL+eLgYoKDKrA5dZuPYaJ2cJ3LZ15CUNrdgh98WwMu20mFuIY/qVrlUuCf+FoTw90zlV8/AmTesty6w/cPJn/qm35vPeTjeDtWRQIDAQABAoIBACdBtzJeuH6a+ikSe6YjIrY4n8kt5q1p53COJsrDd7o9SyIocCuczA8MjKwPG5ivHjYE18MCL4ZY0SsZQAqPqHC+e+drjI5mB7qauePomcMFWeiwzak7mHNy2uohOTInoYWMJMrebaMUwq63oITytN4Igmrb4EyoZAA9UbnqqUd5T2zR+UQAB66KkkLyar5rxtHpZaupXPtFM7aOYaVz0rgv6lEIBy3XZW70tQaxWtY982lC+8osAlmL2a6VsEEW7NC9Zj6P3UwkEoM20m7t/N6jEIeRy2M2/Q0qtSJpsGOVtr8Gs+4CRgdrytPzC8hNTKqAyvXqI/ldEFxjfNoKceECgYEA/zrq/0lNMIOu7do+ivaa1fvKRzGpFrdHuM+UuDKuxapj7mPyOfVJZwVWP6TikMh1Ats5jNnH0VBeWMjWIEIJaMTOwGA7v2Twe4v4TH7ssKw/kjjieKdALvO5eh+PaqgKNIYsWeyHDscFCnpccJl4mq40kmnOkoB6Eg+EByVE/wkCgYEA4vqt22xNjxN1J/W+uta7JtUoV2gDxgQecQKbyUSv95jdjMU0HzRMwTloDm5OPbSi8QirUcNsL7qPEAu3LQHYMqvXZGL3b/VJUfHXL34cebIYlklvkYt2hQnX9Lthz0JJf6CfMSUKFEkCLd8+3FBaqzOnBzP3CbYSINjQ1YjRMF0CgYA8YiMQzLXPYYg0S6r6U4ekUpKzr0MS1b/JMIs93PfOWhaUYt7+6VI5ZmDWY9saZ+KPD3CZKzkEA2Ce3r0SGq2BNPa5OstH58ihYicXafvzfHz5yi2CYAdmVFEwXGEg2aq4bHn3uGbnjxxZM0PFe/m1lrtnXFL8BBtdRIB29FFTiQKBgQDSPoMGCYa57bsKXZ3i8P4AFVe9xtIf/Da6VUE6KE6amNU3DH+gG9Cw9lzFaTU+APEhNPeDz/GJMFRN95wfq2K4ZOYpzWYHJXxZ1BqPmlAEBYyywKkAdt88kgagYWVTFsJ/3qc2XWm9qnbDSNOwPRoPFNQ1XtQIAcc+97ZQ5N9n3QKBgQDFHPXlOZ4fpmx+PX3nXJqmcjn+CIVZIKYhpvLcl45knpkKWQKZdnVzirBvuBeuD/I0+0INTj2NHZ1e/pm34fTH7JqVkgdDBe4kzF8EdROivfZiPuV2z2oPXyH/t0qDUzGMjUF7RShcHz8P3kp6fHz4kLwCaUBNYS66u9eAiVWjCA==
6efe538e-6bcb-4068-9d38-5cc0808ccf9a	f07088fc-1229-4f0d-9cef-0e565747706c	privateKey	MIIEogIBAAKCAQEA1qrwcC4/QZQdwALAaj4+HYFmTv7M4WGMw2iSJLav1naaP2Wfi8wWgK0RyPTqAMgDvqq7g9Ij3mb20v9ettVsNiD36ccL2RJeOMWm4HV2G9WoBC3j83JrvGSeGOVECNJ9kodMUb9tX12BphDP/mnow+13gnpKXUon7/RRtMWwBkFF6uXrZcXqgTA4zUfYR2p2Q8YkbezcwrzoJT6AltLlqJp5ZZHSUyaexY0UroPevW3AxDF9kItbYXgTAYA3Mf2ie4WGnzF0Y7XWbo9VRHNGhT1n7kBpnTQKMw6s1zPvAnHjR5RZKGCjdB81S3DsYf02lA0pO63hWbu65Bz2uBrrWQIDAQABAoIBAC2dM4uGzDKtXDf3bbb1pGHFI/3vpw3SGmTQVNN/zTPTTlnfyGvecT6k5+VNY2bImYEbis5LKguBUfvKPzA2//Ath7hRbwtQW5yRJTFHTFJET1gZ/zi07L8imzR7jP4Z6gxnevhY5o7v0dN9eZDcJNVzIWSkgyY5Emzqu6zfn9RoCPh+gTTBHz1C9g/UPLyeC9nZ3EroE9aJokt+Vzf3mtfZPvCY7Ycd+bzb9bW13lw60Y3GJq2jZijimBWoeeATar6LYieGoPtsb5u5qqL1Wkg0i5hC95uksmxKZ2NWHGqMZ0emoukpD/uV5q2CZX1AnTK7DRmMeL9ZVLqQSo+mz+0CgYEA+U892BDZtRIm+gYb0yicl5Ktb2EfKMHTkHvFAjrD+NtNFpLUyVs4TQJic5blxLIU4lOzGr1/K4rPMkPhvei0UbXxYzXleV1W8RveU5P/SNk2irj/n/4o2jLJZCMpm+RFGD01FVNeoN+DzT0D79v5XrK7MX3RIpTN2O4S9FU33y0CgYEA3G21ShOm03U8nHVHR/Wy3sDf5oTX++qkCBewSkBW9DO6MOIsbi5XMGeLqe1GZ0CDQDMbv0gzz52VlwFu/57h53D44RdIugHRWDAC1AXoW1eybwXJVykn34+aZkqOt0afEPp7O+A4270X911D7qCtjti1KX1H31yEB9wqE5gROF0CgYAg2yWeXRIj/+FtH/L40Cha/XSn8hfGKk00hGtBUPdUy6oMKIusgb4YwBCzhRaA5qtD7J31DzY8Sc3mpPWSLqHdBupqFcdJSFjV68NQJngFZMMAY0MlFbzSjNDnxo6MQfgtKpvdVKBq+SoImVr0eHwT0+BBtIAkW5IJXc7XrodvfQKBgDPL89W8WG9IFT4OsPlP2wBNAlAA11/y+yiLqHlKNSSdIxtpilc5vHM7Ya5Ee0638h+b4uFH7iTTOtuJErQueZcRDOqXthc/Zhn67i80VC1ipiNAkNdSbHQ0Imv3CSI4DhjHQz4GqlW4UXFnERd52k6+zZM6RTFPZBcUvS5thV5hAoGAeTS6rQhsXM/lgKEW5+75YKD5vB6FTytbeTDgekuXvslUDdX2nsaoiIM0Ssg1bxkYYn4AJVLEQtcrdTM5fv1qjGRMy2sqgIVdn5i1vMCAw97RJl4amLei/MuAzukmeaHXgwiGIjEMkbRKQrSfTw4BppwgtA1Ym1CN3U75abupb30=
8382ee1a-369e-4867-b09e-e50ce1630d8b	f07088fc-1229-4f0d-9cef-0e565747706c	certificate	MIICnzCCAYcCBgGWFuz3nTANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhjb25jZXJ0bzAeFw0yNTA0MDgxOTQwNTBaFw0zNTA0MDgxOTQyMzBaMBMxETAPBgNVBAMMCGNvbmNlcnRvMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1qrwcC4/QZQdwALAaj4+HYFmTv7M4WGMw2iSJLav1naaP2Wfi8wWgK0RyPTqAMgDvqq7g9Ij3mb20v9ettVsNiD36ccL2RJeOMWm4HV2G9WoBC3j83JrvGSeGOVECNJ9kodMUb9tX12BphDP/mnow+13gnpKXUon7/RRtMWwBkFF6uXrZcXqgTA4zUfYR2p2Q8YkbezcwrzoJT6AltLlqJp5ZZHSUyaexY0UroPevW3AxDF9kItbYXgTAYA3Mf2ie4WGnzF0Y7XWbo9VRHNGhT1n7kBpnTQKMw6s1zPvAnHjR5RZKGCjdB81S3DsYf02lA0pO63hWbu65Bz2uBrrWQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBp1iZQ7y9lLMI9Z2KmXmwG6yn08kFNRfyJpaulrWaj6Yxjfz2mhYWBDM1CAewWTY1wRd4kOuwm0ArOoAI5J33mRvNWhlMpINnim6Sl9edsADd0oizzQ5DZY2ZjxQ+luRG5qJKXSWWrF6jvFSqCTBqA7pTt6/AMvaqny8u8QDQwz4lppd7D/E1Ugvbbc9BRwH5IagvQRMaZAdcdzrzGqw19ej/YI0D2HqlDp4RWytaFH6VNdq6qs41AsvogtvCIdpHp2gmb9jEL5F14oHpjKyqwNuZZGWx172r9Y6AME4aVdrMoil/ZzvXN3uM66+B33utNz4a57svwS2qOYo292BAM
c2ab7f31-b749-40cb-87b2-17b5a8ab9c93	b1a5c138-a025-46d0-88c6-410ef4e981e7	kid	99467fe4-2a16-469d-82a3-baaa040d26ce
51a86511-93a3-44c4-9139-aaf34596c68d	b1a5c138-a025-46d0-88c6-410ef4e981e7	secret	lkGWe7Jl3QoruAzoSzmDEA
fe764664-1def-443c-bfa5-89ef81c39c49	b1a5c138-a025-46d0-88c6-410ef4e981e7	priority	100
cd4c1bfe-78f2-45e2-a722-f29c5e92923e	6c528085-9654-4487-a671-4a156ed0c831	max-clients	200
ab1ba47f-9d64-4fcc-9751-85eb21b6b639	ff606c52-12b9-4905-8f17-4d06ad6c3483	allowed-protocol-mapper-types	oidc-address-mapper
6c0bf2d4-c0a0-48d2-9748-69458e57055a	ff606c52-12b9-4905-8f17-4d06ad6c3483	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
d3b4e365-4cca-4779-b5a0-bf6af949bd88	ff606c52-12b9-4905-8f17-4d06ad6c3483	allowed-protocol-mapper-types	saml-user-property-mapper
18ad66ea-daca-47ef-bb42-d413262e10ef	ff606c52-12b9-4905-8f17-4d06ad6c3483	allowed-protocol-mapper-types	saml-role-list-mapper
f2b3fc2f-a783-4858-81f1-1d0fdd28989f	ff606c52-12b9-4905-8f17-4d06ad6c3483	allowed-protocol-mapper-types	saml-user-attribute-mapper
53020319-9f0d-4903-a0ae-f0e17bfd1be0	ff606c52-12b9-4905-8f17-4d06ad6c3483	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
541f7f29-0de4-480a-aa23-155056b281c0	ff606c52-12b9-4905-8f17-4d06ad6c3483	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
c7bd7f48-1582-472b-bdd3-3188c405dbb1	ff606c52-12b9-4905-8f17-4d06ad6c3483	allowed-protocol-mapper-types	oidc-full-name-mapper
0ed37dcd-8cb5-447f-9ba8-e0f9971391ec	43bf8e5b-817f-4844-8699-9d5fbfc0de74	allow-default-scopes	true
ad6a8f35-676f-4ca3-9562-104004bbbd66	8094336c-a339-4b71-a68d-6bea810b879b	allow-default-scopes	true
f7eb6171-df89-4ada-b952-8afaa208e989	17ba2162-a0e8-420a-acfa-751c8df41926	client-uris-must-match	true
37737908-5421-46d8-b76c-e9f947228eee	17ba2162-a0e8-420a-acfa-751c8df41926	host-sending-registration-request-must-match	true
7a9f1dfc-57de-4011-9655-2a7219dd6152	94c87219-58d7-4dc3-8a73-5e054a61e72a	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
20717126-8d20-4c34-b27c-9433badfbbb6	94c87219-58d7-4dc3-8a73-5e054a61e72a	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
cf2a9198-8eef-4cdb-971a-1d9a380b82e0	94c87219-58d7-4dc3-8a73-5e054a61e72a	allowed-protocol-mapper-types	saml-user-property-mapper
21728418-479d-4ba5-941c-93e81349ed89	94c87219-58d7-4dc3-8a73-5e054a61e72a	allowed-protocol-mapper-types	saml-role-list-mapper
28268efe-e2d6-40c9-aba3-be745b0fc0fb	94c87219-58d7-4dc3-8a73-5e054a61e72a	allowed-protocol-mapper-types	oidc-full-name-mapper
a6a296b2-632d-4dbb-b3a6-4d0271dd3012	94c87219-58d7-4dc3-8a73-5e054a61e72a	allowed-protocol-mapper-types	oidc-address-mapper
9003d55f-af44-4f70-921c-7db83ac26a5b	94c87219-58d7-4dc3-8a73-5e054a61e72a	allowed-protocol-mapper-types	saml-user-attribute-mapper
2609ae62-9b4d-4730-ac3d-c121ee7c35d7	94c87219-58d7-4dc3-8a73-5e054a61e72a	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.composite_role (composite, child_role) FROM stdin;
15a55f35-fac7-45f5-9140-0340dcf01335	1b37fbef-9afc-4963-aa1f-2cc2f1890e1f
15a55f35-fac7-45f5-9140-0340dcf01335	333947cf-85ba-4195-824d-9970e21e4d8c
15a55f35-fac7-45f5-9140-0340dcf01335	953f110c-e419-4cd7-ac38-68585cfd5ebc
15a55f35-fac7-45f5-9140-0340dcf01335	686b0a59-7818-425f-9ccd-aea099462fc5
15a55f35-fac7-45f5-9140-0340dcf01335	4b66bbb2-fc19-4cec-8a81-63fd39772f9d
15a55f35-fac7-45f5-9140-0340dcf01335	26a0150f-9996-4fc9-adf6-53eac068b153
15a55f35-fac7-45f5-9140-0340dcf01335	d4ce1b6f-e2e0-4425-8d9f-be2c2162260e
15a55f35-fac7-45f5-9140-0340dcf01335	9420b71e-f790-486d-ad30-acd9be419bcf
15a55f35-fac7-45f5-9140-0340dcf01335	4c4d4a15-40e4-4564-b33e-bb5f7f0f75f4
15a55f35-fac7-45f5-9140-0340dcf01335	4928c7f5-39d6-46a1-ba6b-fa329ef9e8c8
15a55f35-fac7-45f5-9140-0340dcf01335	96d63338-88e9-4f6a-aa32-256491b15bf5
15a55f35-fac7-45f5-9140-0340dcf01335	d7cb6448-d6cd-4d58-8356-921b4de199d9
15a55f35-fac7-45f5-9140-0340dcf01335	320f8966-81f8-4523-92f9-2a127f0b7698
15a55f35-fac7-45f5-9140-0340dcf01335	abf3e015-9b0a-43d8-b489-cf586895f07b
15a55f35-fac7-45f5-9140-0340dcf01335	8ec98796-5cd8-474c-b52a-eed1e8f79a96
15a55f35-fac7-45f5-9140-0340dcf01335	c8db96fd-d195-4552-b93f-00c377940647
15a55f35-fac7-45f5-9140-0340dcf01335	83d7e6ee-85bc-4796-9e3f-ece17cf084cb
15a55f35-fac7-45f5-9140-0340dcf01335	dc87747d-025d-42b8-8777-5ae62fc55590
4b66bbb2-fc19-4cec-8a81-63fd39772f9d	c8db96fd-d195-4552-b93f-00c377940647
5a78721b-02ef-46e7-acd4-bf2eba624d5a	4d9b28e8-5274-4a3a-ba24-e54f40ebfaa6
686b0a59-7818-425f-9ccd-aea099462fc5	dc87747d-025d-42b8-8777-5ae62fc55590
686b0a59-7818-425f-9ccd-aea099462fc5	8ec98796-5cd8-474c-b52a-eed1e8f79a96
5a78721b-02ef-46e7-acd4-bf2eba624d5a	a644d7c4-3b78-425f-a77d-e4a686ac5e9d
a644d7c4-3b78-425f-a77d-e4a686ac5e9d	9eac9456-95dd-4b57-aa12-94c3ae877073
a24b8d9b-dd95-45b3-b3ea-da66b53906f0	7c1d4f06-2542-4938-82cf-89ef160e7513
15a55f35-fac7-45f5-9140-0340dcf01335	a89098ba-ad5f-44bc-88cf-afc60d2f8509
5a78721b-02ef-46e7-acd4-bf2eba624d5a	e3f4b80d-9223-487d-94c2-dc7143455a51
5a78721b-02ef-46e7-acd4-bf2eba624d5a	8b28c4fa-75ae-441d-9ddc-50cd416596e9
15a55f35-fac7-45f5-9140-0340dcf01335	79a314fc-3dff-496f-8911-f8acc7c4f293
15a55f35-fac7-45f5-9140-0340dcf01335	070c4c17-5df3-4933-bda9-b041fb9be884
15a55f35-fac7-45f5-9140-0340dcf01335	0444b156-a10e-49b7-afb5-f92756d4990c
15a55f35-fac7-45f5-9140-0340dcf01335	b232bb34-d681-47e6-b118-5cb5881076e9
15a55f35-fac7-45f5-9140-0340dcf01335	d0f0f072-b528-4a90-bdba-841d1a813442
15a55f35-fac7-45f5-9140-0340dcf01335	f0369cfd-47a9-4b96-81b9-288955e4e57c
15a55f35-fac7-45f5-9140-0340dcf01335	c0cc5abc-5eb2-4485-90f8-9645d30c8266
15a55f35-fac7-45f5-9140-0340dcf01335	9444c855-7d27-4eb4-bd74-ab5656a4827f
15a55f35-fac7-45f5-9140-0340dcf01335	5debe47a-2e6f-4924-ae72-0a3e7baddc9a
15a55f35-fac7-45f5-9140-0340dcf01335	9e4f59f3-2ff0-46b3-9a9a-b390dd4013fb
15a55f35-fac7-45f5-9140-0340dcf01335	570d908f-ce06-443c-8864-d4271c7e88b6
15a55f35-fac7-45f5-9140-0340dcf01335	e050ed2a-fad7-4f42-b748-8a20b83fb8eb
15a55f35-fac7-45f5-9140-0340dcf01335	8b568a8a-a4fb-4520-b0a0-639202dedc63
15a55f35-fac7-45f5-9140-0340dcf01335	7b23ab01-6972-47b9-b9af-76b369fc956d
15a55f35-fac7-45f5-9140-0340dcf01335	61be5a39-1c27-4351-9219-101f0a2690aa
15a55f35-fac7-45f5-9140-0340dcf01335	2c1a2318-2cd1-4832-a1de-3e17e9fff41f
15a55f35-fac7-45f5-9140-0340dcf01335	fd949fed-f0bb-4327-a651-fcc82add21eb
0444b156-a10e-49b7-afb5-f92756d4990c	7b23ab01-6972-47b9-b9af-76b369fc956d
0444b156-a10e-49b7-afb5-f92756d4990c	fd949fed-f0bb-4327-a651-fcc82add21eb
b232bb34-d681-47e6-b118-5cb5881076e9	61be5a39-1c27-4351-9219-101f0a2690aa
0b18b669-5c09-49e2-9f40-30fb7295d822	936aa81e-00f9-4b41-9114-4977932d7857
0b18b669-5c09-49e2-9f40-30fb7295d822	b4b13c66-4bec-4f26-8d62-7ac7cce29260
0b18b669-5c09-49e2-9f40-30fb7295d822	6521fc9c-5cfd-482d-9f51-7c1bdd1e9afc
0b18b669-5c09-49e2-9f40-30fb7295d822	50aa8776-b226-4f8e-95c0-f097edc3105a
0b18b669-5c09-49e2-9f40-30fb7295d822	f2d3f2f8-b453-40ab-ac68-700313e0818a
0b18b669-5c09-49e2-9f40-30fb7295d822	b0a3d6ce-ab84-4026-bbbf-33bd83c3b3b5
0b18b669-5c09-49e2-9f40-30fb7295d822	f0811660-df00-475f-af67-d5f64fea0818
0b18b669-5c09-49e2-9f40-30fb7295d822	2e74cdb7-a64c-4ddc-b80b-762751a78e92
0b18b669-5c09-49e2-9f40-30fb7295d822	cee750b6-7bb5-4f07-a882-1facca4099d4
0b18b669-5c09-49e2-9f40-30fb7295d822	73243003-8057-4c01-9686-829106fdfeaf
0b18b669-5c09-49e2-9f40-30fb7295d822	bb9d4102-8f1b-4a6a-8ad3-eb0d623db75e
0b18b669-5c09-49e2-9f40-30fb7295d822	082b57f5-48cb-4aba-9dd1-ac0f0c0e0df6
0b18b669-5c09-49e2-9f40-30fb7295d822	32563e37-878f-4cac-8f2a-6290e5e83154
0b18b669-5c09-49e2-9f40-30fb7295d822	1d3063ad-7fa2-4715-8da0-4452990c84c5
0b18b669-5c09-49e2-9f40-30fb7295d822	a18d4170-eb19-4b02-b402-e66c6884cfbb
0b18b669-5c09-49e2-9f40-30fb7295d822	a4487379-937e-450e-8e76-2e2b05d60067
0b18b669-5c09-49e2-9f40-30fb7295d822	1ce87057-a8cb-4ccc-9790-662eca5855f1
50aa8776-b226-4f8e-95c0-f097edc3105a	a18d4170-eb19-4b02-b402-e66c6884cfbb
6521fc9c-5cfd-482d-9f51-7c1bdd1e9afc	1d3063ad-7fa2-4715-8da0-4452990c84c5
6521fc9c-5cfd-482d-9f51-7c1bdd1e9afc	1ce87057-a8cb-4ccc-9790-662eca5855f1
b9781f4d-1f73-4b9c-9386-d4e1c1703a1d	7da31553-bdc7-4aad-b425-f70d1f5bbccb
b9781f4d-1f73-4b9c-9386-d4e1c1703a1d	dc032b67-388c-4d2a-8368-4a12e9806c3f
dc032b67-388c-4d2a-8368-4a12e9806c3f	07c61deb-f62e-43d0-90ab-8b0b7d2c4f3c
9e99c727-da71-406f-be24-c1aee990b0df	99465dfc-b1fc-4c51-a7d6-3df5a35dd3b3
15a55f35-fac7-45f5-9140-0340dcf01335	bc36e89a-1f0c-4ed2-abc0-59b2a01ec2d0
0b18b669-5c09-49e2-9f40-30fb7295d822	9c53af67-8227-46bc-b3e1-b06fa9ef1cc9
b9781f4d-1f73-4b9c-9386-d4e1c1703a1d	932362fb-58e7-4fec-91f6-8a383e06819f
b9781f4d-1f73-4b9c-9386-d4e1c1703a1d	d796e532-8099-447b-b687-c4ea9889a1e4
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
e702b638-ed22-4ede-a466-ef4063eed743	\N	password	655242f8-bc15-4119-87c6-b9d242495178	1744140267152	\N	{"value":"gefwvzqKTjyLe5JR+hjyxYArbGbuMMpn/+5nIOFIoBA=","salt":"Phc2J5I2obR7eKMoF80JbQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
30f6b431-e17c-40b4-a300-00009724bae0	\N	password	1b47e0c0-668d-4020-959c-412c241fdd05	1765407143277	\N	{"value":"ak/UrEtdo6FVsCfy75bGo7b9S9Gf2sJcvXsOp/qZHJ0=","salt":"endDTcSBIG33+oTvza4/dQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2025-04-08 19:23:36.839153	1	EXECUTED	8:bda77d94bf90182a1e30c24f1c155ec7	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.16.1	\N	\N	4140212118
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2025-04-08 19:23:36.91378	2	MARK_RAN	8:1ecb330f30986693d1cba9ab579fa219	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.16.1	\N	\N	4140212118
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2025-04-08 19:23:37.719721	3	EXECUTED	8:cb7ace19bc6d959f305605d255d4c843	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.16.1	\N	\N	4140212118
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2025-04-08 19:23:37.869548	4	EXECUTED	8:80230013e961310e6872e871be424a63	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.16.1	\N	\N	4140212118
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2025-04-08 19:23:39.75533	5	EXECUTED	8:67f4c20929126adc0c8e9bf48279d244	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.16.1	\N	\N	4140212118
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2025-04-08 19:23:39.852719	6	MARK_RAN	8:7311018b0b8179ce14628ab412bb6783	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.16.1	\N	\N	4140212118
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2025-04-08 19:23:41.400003	7	EXECUTED	8:037ba1216c3640f8785ee6b8e7c8e3c1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.16.1	\N	\N	4140212118
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2025-04-08 19:23:41.502696	8	MARK_RAN	8:7fe6ffe4af4df289b3157de32c624263	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.16.1	\N	\N	4140212118
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2025-04-08 19:23:41.634505	9	EXECUTED	8:9c136bc3187083a98745c7d03bc8a303	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.16.1	\N	\N	4140212118
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2025-04-08 19:23:43.713769	10	EXECUTED	8:b5f09474dca81fb56a97cf5b6553d331	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.16.1	\N	\N	4140212118
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2025-04-08 19:23:44.857308	11	EXECUTED	8:ca924f31bd2a3b219fdcfe78c82dacf4	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.16.1	\N	\N	4140212118
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2025-04-08 19:23:44.960549	12	MARK_RAN	8:8acad7483e106416bcfa6f3b824a16cd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.16.1	\N	\N	4140212118
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2025-04-08 19:23:45.202027	13	EXECUTED	8:9b1266d17f4f87c78226f5055408fd5e	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.16.1	\N	\N	4140212118
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-04-08 19:23:45.876441	14	EXECUTED	8:d80ec4ab6dbfe573550ff72396c7e910	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.16.1	\N	\N	4140212118
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-04-08 19:23:45.951632	15	MARK_RAN	8:d86eb172171e7c20b9c849b584d147b2	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.16.1	\N	\N	4140212118
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-04-08 19:23:46.018813	16	MARK_RAN	8:5735f46f0fa60689deb0ecdc2a0dea22	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.16.1	\N	\N	4140212118
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-04-08 19:23:46.094429	17	EXECUTED	8:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.16.1	\N	\N	4140212118
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2025-04-08 19:23:46.968289	18	EXECUTED	8:5c1a8fd2014ac7fc43b90a700f117b23	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.16.1	\N	\N	4140212118
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2025-04-08 19:23:47.984839	19	EXECUTED	8:1f6c2c2dfc362aff4ed75b3f0ef6b331	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.16.1	\N	\N	4140212118
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2025-04-08 19:23:48.19296	20	EXECUTED	8:dee9246280915712591f83a127665107	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.16.1	\N	\N	4140212118
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2025-04-08 19:23:48.301071	21	MARK_RAN	8:9eb2ee1fa8ad1c5e426421a6f8fdfa6a	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.16.1	\N	\N	4140212118
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2025-04-08 19:23:48.401208	22	MARK_RAN	8:dee9246280915712591f83a127665107	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.16.1	\N	\N	4140212118
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2025-04-08 19:23:48.751844	23	EXECUTED	8:d9fa18ffa355320395b86270680dd4fe	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.16.1	\N	\N	4140212118
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2025-04-08 19:23:48.98477	24	EXECUTED	8:90cff506fedb06141ffc1c71c4a1214c	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.16.1	\N	\N	4140212118
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2025-04-08 19:23:49.093176	25	MARK_RAN	8:11a788aed4961d6d29c427c063af828c	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.16.1	\N	\N	4140212118
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2025-04-08 19:23:50.468014	26	EXECUTED	8:a4218e51e1faf380518cce2af5d39b43	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.16.1	\N	\N	4140212118
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2025-04-08 19:23:52.659969	27	EXECUTED	8:d9e9a1bfaa644da9952456050f07bbdc	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.16.1	\N	\N	4140212118
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2025-04-08 19:23:52.773502	28	EXECUTED	8:d1bf991a6163c0acbfe664b615314505	update tableName=RESOURCE_SERVER_POLICY		\N	4.16.1	\N	\N	4140212118
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2025-04-08 19:23:55.093031	29	EXECUTED	8:88a743a1e87ec5e30bf603da68058a8c	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.16.1	\N	\N	4140212118
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2025-04-08 19:23:55.601539	30	EXECUTED	8:c5517863c875d325dea463d00ec26d7a	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.16.1	\N	\N	4140212118
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2025-04-08 19:23:56.06774	31	EXECUTED	8:ada8b4833b74a498f376d7136bc7d327	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.16.1	\N	\N	4140212118
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2025-04-08 19:23:56.197659	32	EXECUTED	8:b9b73c8ea7299457f99fcbb825c263ba	customChange		\N	4.16.1	\N	\N	4140212118
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-04-08 19:23:56.417505	33	EXECUTED	8:07724333e625ccfcfc5adc63d57314f3	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.16.1	\N	\N	4140212118
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-04-08 19:23:56.542209	34	MARK_RAN	8:8b6fd445958882efe55deb26fc541a7b	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.16.1	\N	\N	4140212118
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-04-08 19:23:57.218285	35	EXECUTED	8:29b29cfebfd12600897680147277a9d7	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.16.1	\N	\N	4140212118
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2025-04-08 19:23:57.499203	36	EXECUTED	8:73ad77ca8fd0410c7f9f15a471fa52bc	addColumn tableName=REALM		\N	4.16.1	\N	\N	4140212118
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-04-08 19:23:57.916037	37	EXECUTED	8:64f27a6fdcad57f6f9153210f2ec1bdb	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.16.1	\N	\N	4140212118
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2025-04-08 19:23:58.124536	38	EXECUTED	8:27180251182e6c31846c2ddab4bc5781	addColumn tableName=FED_USER_CONSENT		\N	4.16.1	\N	\N	4140212118
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2025-04-08 19:23:58.357606	39	EXECUTED	8:d56f201bfcfa7a1413eb3e9bc02978f9	addColumn tableName=IDENTITY_PROVIDER		\N	4.16.1	\N	\N	4140212118
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-04-08 19:23:58.432327	40	MARK_RAN	8:91f5522bf6afdc2077dfab57fbd3455c	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.16.1	\N	\N	4140212118
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-04-08 19:23:58.540741	41	MARK_RAN	8:0f01b554f256c22caeb7d8aee3a1cdc8	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.16.1	\N	\N	4140212118
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2025-04-08 19:23:58.655856	42	EXECUTED	8:ab91cf9cee415867ade0e2df9651a947	customChange		\N	4.16.1	\N	\N	4140212118
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-04-08 19:24:04.854424	43	EXECUTED	8:ceac9b1889e97d602caf373eadb0d4b7	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.16.1	\N	\N	4140212118
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2025-04-08 19:24:05.081937	44	EXECUTED	8:84b986e628fe8f7fd8fd3c275c5259f2	addColumn tableName=USER_ENTITY		\N	4.16.1	\N	\N	4140212118
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-04-08 19:24:05.266093	45	EXECUTED	8:a164ae073c56ffdbc98a615493609a52	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.16.1	\N	\N	4140212118
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-04-08 19:24:05.389433	46	EXECUTED	8:70a2b4f1f4bd4dbf487114bdb1810e64	customChange		\N	4.16.1	\N	\N	4140212118
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-04-08 19:24:05.507372	47	MARK_RAN	8:7be68b71d2f5b94b8df2e824f2860fa2	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.16.1	\N	\N	4140212118
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-04-08 19:24:06.721728	48	EXECUTED	8:bab7c631093c3861d6cf6144cd944982	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.16.1	\N	\N	4140212118
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-04-08 19:24:06.948858	49	EXECUTED	8:fa809ac11877d74d76fe40869916daad	addColumn tableName=REALM		\N	4.16.1	\N	\N	4140212118
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2025-04-08 19:24:08.965379	50	EXECUTED	8:fac23540a40208f5f5e326f6ceb4d291	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.16.1	\N	\N	4140212118
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2025-04-08 19:24:10.815215	51	EXECUTED	8:2612d1b8a97e2b5588c346e817307593	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.16.1	\N	\N	4140212118
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2025-04-08 19:24:11.006503	52	EXECUTED	8:9842f155c5db2206c88bcb5d1046e941	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	4140212118
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2025-04-08 19:24:11.076255	53	EXECUTED	8:2e12e06e45498406db72d5b3da5bbc76	update tableName=REALM		\N	4.16.1	\N	\N	4140212118
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2025-04-08 19:24:11.227064	54	EXECUTED	8:33560e7c7989250c40da3abdabdc75a4	update tableName=CLIENT		\N	4.16.1	\N	\N	4140212118
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-04-08 19:24:11.465564	55	EXECUTED	8:87a8d8542046817a9107c7eb9cbad1cd	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.16.1	\N	\N	4140212118
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-04-08 19:24:11.647791	56	EXECUTED	8:3ea08490a70215ed0088c273d776311e	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.16.1	\N	\N	4140212118
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-04-08 19:24:12.157417	57	EXECUTED	8:2d56697c8723d4592ab608ce14b6ed68	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.16.1	\N	\N	4140212118
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-04-08 19:24:13.765481	58	EXECUTED	8:3e423e249f6068ea2bbe48bf907f9d86	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.16.1	\N	\N	4140212118
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2025-04-08 19:24:14.264903	59	EXECUTED	8:15cabee5e5df0ff099510a0fc03e4103	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.16.1	\N	\N	4140212118
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2025-04-08 19:24:14.456643	60	EXECUTED	8:4b80200af916ac54d2ffbfc47918ab0e	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.16.1	\N	\N	4140212118
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-04-08 19:24:14.615216	61	EXECUTED	8:66564cd5e168045d52252c5027485bbb	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.16.1	\N	\N	4140212118
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-04-08 19:24:14.831788	62	EXECUTED	8:1c7064fafb030222be2bd16ccf690f6f	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.16.1	\N	\N	4140212118
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2025-04-08 19:24:14.932034	63	EXECUTED	8:2de18a0dce10cdda5c7e65c9b719b6e5	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.16.1	\N	\N	4140212118
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2025-04-08 19:24:14.99581	64	EXECUTED	8:03e413dd182dcbd5c57e41c34d0ef682	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.16.1	\N	\N	4140212118
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2025-04-08 19:24:15.052251	65	EXECUTED	8:d27b42bb2571c18fbe3fe4e4fb7582a7	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.16.1	\N	\N	4140212118
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2025-04-08 19:24:15.656611	66	EXECUTED	8:698baf84d9fd0027e9192717c2154fb8	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.16.1	\N	\N	4140212118
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2025-04-08 19:24:15.873272	67	EXECUTED	8:ced8822edf0f75ef26eb51582f9a821a	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.16.1	\N	\N	4140212118
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2025-04-08 19:24:16.039879	68	EXECUTED	8:f0abba004cf429e8afc43056df06487d	addColumn tableName=REALM		\N	4.16.1	\N	\N	4140212118
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2025-04-08 19:24:16.42302	69	EXECUTED	8:6662f8b0b611caa359fcf13bf63b4e24	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.16.1	\N	\N	4140212118
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2025-04-08 19:24:16.531623	70	EXECUTED	8:9e6b8009560f684250bdbdf97670d39e	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.16.1	\N	\N	4140212118
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2025-04-08 19:24:16.647812	71	EXECUTED	8:4223f561f3b8dc655846562b57bb502e	addColumn tableName=RESOURCE_SERVER		\N	4.16.1	\N	\N	4140212118
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-04-08 19:24:16.806187	72	EXECUTED	8:215a31c398b363ce383a2b301202f29e	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.16.1	\N	\N	4140212118
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-04-08 19:24:16.871149	73	EXECUTED	8:83f7a671792ca98b3cbd3a1a34862d3d	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.16.1	\N	\N	4140212118
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-04-08 19:24:16.922851	74	MARK_RAN	8:f58ad148698cf30707a6efbdf8061aa7	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.16.1	\N	\N	4140212118
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-04-08 19:24:17.067961	75	EXECUTED	8:79e4fd6c6442980e58d52ffc3ee7b19c	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.16.1	\N	\N	4140212118
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-04-08 19:24:17.325412	76	EXECUTED	8:87af6a1e6d241ca4b15801d1f86a297d	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.16.1	\N	\N	4140212118
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-04-08 19:24:17.523237	77	EXECUTED	8:b44f8d9b7b6ea455305a6d72a200ed15	addColumn tableName=CLIENT		\N	4.16.1	\N	\N	4140212118
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-04-08 19:24:17.573031	78	MARK_RAN	8:2d8ed5aaaeffd0cb004c046b4a903ac5	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.16.1	\N	\N	4140212118
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-04-08 19:24:17.914979	79	EXECUTED	8:e290c01fcbc275326c511633f6e2acde	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.16.1	\N	\N	4140212118
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-04-08 19:24:17.964341	80	MARK_RAN	8:c9db8784c33cea210872ac2d805439f8	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.16.1	\N	\N	4140212118
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-04-08 19:24:18.123125	81	EXECUTED	8:95b676ce8fc546a1fcfb4c92fae4add5	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.16.1	\N	\N	4140212118
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-04-08 19:24:18.172712	82	MARK_RAN	8:38a6b2a41f5651018b1aca93a41401e5	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.16.1	\N	\N	4140212118
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-04-08 19:24:18.281169	83	EXECUTED	8:3fb99bcad86a0229783123ac52f7609c	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.16.1	\N	\N	4140212118
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-04-08 19:24:18.331425	84	MARK_RAN	8:64f27a6fdcad57f6f9153210f2ec1bdb	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.16.1	\N	\N	4140212118
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-04-08 19:24:18.489654	85	EXECUTED	8:ab4f863f39adafd4c862f7ec01890abc	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.16.1	\N	\N	4140212118
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2025-04-08 19:24:18.589831	86	EXECUTED	8:13c419a0eb336e91ee3a3bf8fda6e2a7	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.16.1	\N	\N	4140212118
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-04-08 19:24:18.790162	87	EXECUTED	8:e3fb1e698e0471487f51af1ed80fe3ac	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.16.1	\N	\N	4140212118
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-04-08 19:24:19.240362	88	EXECUTED	8:babadb686aab7b56562817e60bf0abd0	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.16.1	\N	\N	4140212118
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-04-08 19:24:19.348373	89	EXECUTED	8:72d03345fda8e2f17093d08801947773	addColumn tableName=REALM; customChange		\N	4.16.1	\N	\N	4140212118
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-04-08 19:24:19.482077	90	EXECUTED	8:61c9233951bd96ffecd9ba75f7d978a4	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.16.1	\N	\N	4140212118
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-04-08 19:24:19.639658	91	EXECUTED	8:ea82e6ad945cec250af6372767b25525	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.16.1	\N	\N	4140212118
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-04-08 19:24:19.789595	92	EXECUTED	8:d3f4a33f41d960ddacd7e2ef30d126b3	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.16.1	\N	\N	4140212118
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-04-08 19:24:19.839958	93	MARK_RAN	8:1284a27fbd049d65831cb6fc07c8a783	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.16.1	\N	\N	4140212118
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-04-08 19:24:20.239728	94	EXECUTED	8:9d11b619db2ae27c25853b8a37cd0dea	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.16.1	\N	\N	4140212118
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-04-08 19:24:20.348017	95	MARK_RAN	8:3002bb3997451bb9e8bac5c5cd8d6327	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.16.1	\N	\N	4140212118
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-04-08 19:24:20.481071	96	EXECUTED	8:dfbee0d6237a23ef4ccbb7a4e063c163	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.16.1	\N	\N	4140212118
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-04-08 19:24:20.856209	97	EXECUTED	8:75f3e372df18d38c62734eebb986b960	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.16.1	\N	\N	4140212118
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-04-08 19:24:20.906355	98	MARK_RAN	8:7fee73eddf84a6035691512c85637eef	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	4140212118
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-04-08 19:24:20.981533	99	MARK_RAN	8:7a11134ab12820f999fbf3bb13c3adc8	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	4140212118
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-04-08 19:24:21.189971	100	EXECUTED	8:c0f6eaac1f3be773ffe54cb5b8482b70	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	4140212118
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-04-08 19:24:21.239618	101	MARK_RAN	8:18186f0008b86e0f0f49b0c4d0e842ac	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	4140212118
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-04-08 19:24:21.490074	102	EXECUTED	8:09c2780bcb23b310a7019d217dc7b433	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.16.1	\N	\N	4140212118
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-04-08 19:24:21.563706	103	EXECUTED	8:276a44955eab693c970a42880197fff2	customChange		\N	4.16.1	\N	\N	4140212118
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2025-04-08 19:24:21.672618	104	EXECUTED	8:ba8ee3b694d043f2bfc1a1079d0760d7	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.16.1	\N	\N	4140212118
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2025-04-08 19:24:21.831324	105	EXECUTED	8:5e06b1d75f5d17685485e610c2851b17	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.16.1	\N	\N	4140212118
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2025-04-08 19:24:22.031374	106	EXECUTED	8:4b80546c1dc550ac552ee7b24a4ab7c0	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.16.1	\N	\N	4140212118
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2025-04-08 19:24:22.160927	107	EXECUTED	8:af510cd1bb2ab6339c45372f3e491696	customChange		\N	4.16.1	\N	\N	4140212118
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-04-08 19:24:22.564547	108	EXECUTED	8:05c99fc610845ef66ee812b7921af0ef	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.16.1	\N	\N	4140212118
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-04-08 19:24:22.614359	109	MARK_RAN	8:314e803baf2f1ec315b3464e398b8247	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.16.1	\N	\N	4140212118
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-04-08 19:24:22.727062	110	EXECUTED	8:56e4677e7e12556f70b604c573840100	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.16.1	\N	\N	4140212118
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2025-04-08 19:24:22.784758	111	EXECUTED	8:8806cb33d2a546ce770384bf98cf6eac	customChange		\N	4.16.1	\N	\N	4140212118
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-04-08 19:24:23.751525	112	EXECUTED	8:fdb2924649d30555ab3a1744faba4928	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.16.1	\N	\N	4140212118
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
f751882b-adae-4e57-96a2-61fcd0497761	4f7561c2-4a69-4e76-9d5c-54ab9bef1d36	f
f751882b-adae-4e57-96a2-61fcd0497761	f5bc50af-4046-40e1-bed7-80c4e2cb1683	t
f751882b-adae-4e57-96a2-61fcd0497761	27164090-ad2f-4f1d-90c8-caf67e188950	t
f751882b-adae-4e57-96a2-61fcd0497761	426ce351-b77e-416c-97b8-8dfef86c4d69	t
f751882b-adae-4e57-96a2-61fcd0497761	7b2b8a93-c087-432f-87f7-d592dddd6b1b	f
f751882b-adae-4e57-96a2-61fcd0497761	eecde97e-b5ec-42f2-acde-ac6080deaaf7	f
f751882b-adae-4e57-96a2-61fcd0497761	23a8810c-cd80-478b-b6c7-0d542bea0da4	t
f751882b-adae-4e57-96a2-61fcd0497761	4b00688a-cd52-48f8-b60e-95d94d7dd20f	t
f751882b-adae-4e57-96a2-61fcd0497761	c757081c-545d-4395-94c2-ac60009726bf	f
f751882b-adae-4e57-96a2-61fcd0497761	2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c	t
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	26ac1db2-719e-4c3f-841d-a6a1228db92a	f
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	358ac934-814a-47fc-82c9-44c6e189bf7a	t
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	cf9da1d5-1f21-417e-9772-f212e5d26248	t
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	76bfa8d9-5cd0-46ae-a381-7a47a25714a5	t
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	6eb6bf43-c68c-4005-90d0-ea69691db402	f
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47	f
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	697238b2-3932-4934-bcdb-641a26e41e53	t
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	4d0caf81-668f-4968-b48b-e990aad05905	t
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	8ffff1b6-aaa2-4105-b406-944aa6fd333f	f
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	04d16d6b-27f5-4353-84fe-f0dda2b75ce8	t
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id) FROM stdin;
bfcca86d-be14-47ef-b8e9-164b83ad7b93	concerto-client	{"redirect_uri":"https://concerto.local/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1744142920241	LOGIN_ERROR	\N
fd0a6c0c-467d-426d-88ef-62af5a527f63	concerto-client	{"redirect_uri":"https://concerto.local/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1744142933794	LOGIN_ERROR	\N
2069f8b3-5f15-4b7b-8b67-efa73a66df6e	concerto-client	{"redirect_uri":"https://concerto.local/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1744142943842	LOGIN_ERROR	\N
dccdb319-34e3-4d01-a0ab-41f924ad7eeb	concerto-client	{"redirect_uri":"https://concerto.local/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1744142968465	LOGIN_ERROR	\N
0389ce90-ffb3-4b47-aab8-83b8bdb3f352	concerto-client	{"redirect_uri":"https://concerto.local/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1744142973075	LOGIN_ERROR	\N
9652ee62-7cea-4048-a2bd-1860b3a418ae	concerto-client	{"redirect_uri":"https://concerto.local/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1744143049856	LOGIN_ERROR	\N
f4cb567c-66ca-4db2-ab6a-36aca130cf76	concerto-client	{"redirect_uri":"https://concerto.local/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1744143061877	LOGIN_ERROR	\N
33974432-f051-45bf-8192-6bded31b4265	concerto-client	{"redirect_uri":"https://concerto.local/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1744143071920	LOGIN_ERROR	\N
ae64f32b-b606-428e-8ecb-f52082b8da2f	concerto-client	{"auth_method":"openid-connect","response_type":"code","redirect_uri":"https://concerto.local/authentication/login-callback","remember_me":"false","code_id":"da1f431e-528d-4a4d-9763-428a91c89581","email":"admin@admin.com","response_mode":"query","username":"admin"}	email_send_failed	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1744143174329	SEND_VERIFY_EMAIL_ERROR	1b47e0c0-668d-4020-959c-412c241fdd05
40973f0c-1cc7-4c9f-b71c-f841d1e4c7a1	concerto-client	{"redirect_uri":"https://localhost/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746555586692	LOGIN_ERROR	\N
b1c1d630-968c-4a17-b884-9d37018c2907	concerto-client	{"redirect_uri":"https://localhost/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746555599311	LOGIN_ERROR	\N
2ace34e5-3fa2-425e-a002-410e8f5652b3	concerto-client	{"redirect_uri":"https://localhost/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746555609353	LOGIN_ERROR	\N
62489ecf-2d6f-4b0c-8d5c-67529d88a5bc	concerto-client	{"redirect_uri":"https://localhost/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746555728959	LOGIN_ERROR	\N
1406f723-3079-4400-b652-8936383b709e	concerto-client	{"redirect_uri":"https://localhost/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746555740925	LOGIN_ERROR	\N
211d7cd2-0290-41e8-a090-9c8b661e5f62	concerto-client	{"redirect_uri":"https://localhost/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746555750967	LOGIN_ERROR	\N
ac35ed3d-a786-42f6-b515-ccfe8d40ba06	\N	{"redirect_uri":"https://concerto.local/"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746556565371	LOGOUT_ERROR	\N
44ddd67d-f3cb-421d-b18c-1836ba5c6e03	\N	{"redirect_uri":"https://concerto.local/"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746556617405	LOGOUT_ERROR	\N
15293e4d-b3c9-46ac-96e2-cc3bb135d203	\N	{"redirect_uri":"https://concerto.local/"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746556696955	LOGOUT_ERROR	\N
f393f5d3-e201-4d0c-86b0-f979516250c9	concerto-server	{"grant_type":"client_credentials"}	invalid_client_credentials	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746560831078	CLIENT_LOGIN_ERROR	\N
50cf4f41-f1f7-48e0-b263-2299d6e6bb39	concerto-server	{"grant_type":"client_credentials","client_auth_method":"client-secret"}	invalid_client	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746561080493	CLIENT_LOGIN_ERROR	\N
8a2fd684-891e-4f3d-b721-11f360f5955b	concerto-client	{"auth_method":"openid-connect","auth_type":"code","redirect_uri":"https://concerto.local/authentication/login-callback","code_id":"bf6579d1-0093-4c4d-8817-246c29807f43","username":"admin admin"}	user_not_found	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1746730414334	LOGIN_ERROR	\N
7ec080ad-7cac-4554-a568-39421f501629	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751387521611	LOGIN_ERROR	\N
cda0b66e-95ee-4698-9ba4-1f708327295a	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751387597793	LOGIN_ERROR	\N
9c268b30-d94d-469d-b213-1733a7b94ad5	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751387734901	LOGIN_ERROR	\N
f9ecdb12-1c3e-4cbe-9a15-02b0583c5b8e	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751388104986	LOGIN_ERROR	\N
afca82f9-dc99-4ded-8466-afe28d64114b	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751388350144	LOGIN_ERROR	\N
94591a89-17b7-4d24-b749-065a875e0439	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751388971025	LOGIN_ERROR	\N
361ac365-2cb5-4e26-9882-1a15a282acc4	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751389048404	LOGIN_ERROR	\N
359d7958-d8d3-4a7f-9c5d-565394076e2b	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751389062372	LOGIN_ERROR	\N
0d56c452-c95e-4765-886c-2754cfa14072	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751389072404	LOGIN_ERROR	\N
c2981b74-f59d-43b8-9637-7b7c61ff772e	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390449007	LOGIN_ERROR	\N
02869c5a-05b4-4af7-97ec-4b11d0745903	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390457957	LOGIN_ERROR	\N
12a83140-9ee3-455f-b20d-7dd34615c3d5	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390534718	LOGIN_ERROR	\N
a441af12-34cc-417c-b0cd-87f444512826	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390541498	LOGIN_ERROR	\N
080270fb-dac5-4f29-beba-6e05077fcaa6	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390639400	LOGIN_ERROR	\N
c3a0fdcf-b190-41b3-a540-bde467b7a7cc	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390648191	LOGIN_ERROR	\N
84ef3fff-e1b4-435b-8a4c-de7db50f040c	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390659937	LOGIN_ERROR	\N
96e071da-526f-4fd2-970d-5c4db97cb8a1	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390669998	LOGIN_ERROR	\N
d7c4bfb7-e969-4255-9f73-6104c4b9110f	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390716533	LOGIN_ERROR	\N
0868f39d-3a6d-4e2b-b357-f7bec3aec69d	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390741810	LOGIN_ERROR	\N
9f77c73e-f4e0-4bd3-b61d-a4dc701c7261	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390763928	LOGIN_ERROR	\N
929c6551-3a73-430b-bec5-7923a1d41f67	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751390773903	LOGIN_ERROR	\N
2106a15a-c99b-4209-a21f-0645b5ac49ac	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751391356201	LOGIN_ERROR	\N
48d3a043-f37a-4112-856e-8baf1123edfb	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751391359489	LOGIN_ERROR	\N
bc2610fb-edb1-4954-9551-08c928babf55	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751391372271	LOGIN_ERROR	\N
d7d82163-ffb8-461b-8be3-4708db3f2262	concerto-client	{"redirect_uri":"https://localhost:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751391382283	LOGIN_ERROR	\N
20976a75-325b-4de9-8ba2-da59054888d9	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751391543132	LOGIN_ERROR	\N
8bc071bb-85e7-4276-a9a2-bba5c96bf8d5	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751391643940	LOGIN_ERROR	\N
65a86179-1895-4a14-836c-65b5bbb9a6a1	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751391662220	LOGIN_ERROR	\N
3108c609-bb8e-4e89-84bf-23fda7033139	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751391672216	LOGIN_ERROR	\N
74b0ea53-b4de-49e7-80cf-2d3c0d344e76	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751392029274	LOGIN_ERROR	\N
41ee9a34-cd49-403a-9db4-a50d66e9c8e9	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751392041146	LOGIN_ERROR	\N
8e2ec7ab-ead1-486a-9223-83a3f55f6da8	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751392051151	LOGIN_ERROR	\N
746927d5-83e8-4168-b836-323023dcf0f5	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751392412673	LOGIN_ERROR	\N
d07d2fe7-59d8-42f7-b3cf-27d069b83d70	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751392684198	LOGIN_ERROR	\N
693e8998-2a8b-4460-9799-f352317ef8c8	concerto-client	{"redirect_uri":"https://concerto.local:5000/authentication/login-callback"}	invalid_redirect_uri	172.19.0.1	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	1751392694180	LOGIN_ERROR	\N
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
c986eb84-abb6-4442-bee5-8de6f5d6c71c	c8177640-fb95-4469-b43e-23d79048ee0e
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
c8177640-fb95-4469-b43e-23d79048ee0e	admins	 	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc
0241b635-1ef8-410f-b881-26dd5199930c	moderators	 	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc
0bd698e2-a766-4174-bab9-6b0846f31b30	unverified	 	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
5a78721b-02ef-46e7-acd4-bf2eba624d5a	f751882b-adae-4e57-96a2-61fcd0497761	f	${role_default-roles}	default-roles-master	f751882b-adae-4e57-96a2-61fcd0497761	\N	\N
1b37fbef-9afc-4963-aa1f-2cc2f1890e1f	f751882b-adae-4e57-96a2-61fcd0497761	f	${role_create-realm}	create-realm	f751882b-adae-4e57-96a2-61fcd0497761	\N	\N
333947cf-85ba-4195-824d-9970e21e4d8c	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_create-client}	create-client	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
953f110c-e419-4cd7-ac38-68585cfd5ebc	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_view-realm}	view-realm	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
686b0a59-7818-425f-9ccd-aea099462fc5	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_view-users}	view-users	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
4b66bbb2-fc19-4cec-8a81-63fd39772f9d	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_view-clients}	view-clients	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
26a0150f-9996-4fc9-adf6-53eac068b153	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_view-events}	view-events	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
d4ce1b6f-e2e0-4425-8d9f-be2c2162260e	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_view-identity-providers}	view-identity-providers	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
9420b71e-f790-486d-ad30-acd9be419bcf	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_view-authorization}	view-authorization	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
4c4d4a15-40e4-4564-b33e-bb5f7f0f75f4	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_manage-realm}	manage-realm	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
4928c7f5-39d6-46a1-ba6b-fa329ef9e8c8	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_manage-users}	manage-users	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
96d63338-88e9-4f6a-aa32-256491b15bf5	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_manage-clients}	manage-clients	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
d7cb6448-d6cd-4d58-8356-921b4de199d9	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_manage-events}	manage-events	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
320f8966-81f8-4523-92f9-2a127f0b7698	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_manage-identity-providers}	manage-identity-providers	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
abf3e015-9b0a-43d8-b489-cf586895f07b	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_manage-authorization}	manage-authorization	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
8ec98796-5cd8-474c-b52a-eed1e8f79a96	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_query-users}	query-users	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
c8db96fd-d195-4552-b93f-00c377940647	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_query-clients}	query-clients	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
83d7e6ee-85bc-4796-9e3f-ece17cf084cb	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_query-realms}	query-realms	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
15a55f35-fac7-45f5-9140-0340dcf01335	f751882b-adae-4e57-96a2-61fcd0497761	f	${role_admin}	admin	f751882b-adae-4e57-96a2-61fcd0497761	\N	\N
dc87747d-025d-42b8-8777-5ae62fc55590	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_query-groups}	query-groups	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
4d9b28e8-5274-4a3a-ba24-e54f40ebfaa6	e74587da-c704-485d-9717-1bd7df7f05fd	t	${role_view-profile}	view-profile	f751882b-adae-4e57-96a2-61fcd0497761	e74587da-c704-485d-9717-1bd7df7f05fd	\N
a644d7c4-3b78-425f-a77d-e4a686ac5e9d	e74587da-c704-485d-9717-1bd7df7f05fd	t	${role_manage-account}	manage-account	f751882b-adae-4e57-96a2-61fcd0497761	e74587da-c704-485d-9717-1bd7df7f05fd	\N
9eac9456-95dd-4b57-aa12-94c3ae877073	e74587da-c704-485d-9717-1bd7df7f05fd	t	${role_manage-account-links}	manage-account-links	f751882b-adae-4e57-96a2-61fcd0497761	e74587da-c704-485d-9717-1bd7df7f05fd	\N
e980f8b4-9b89-4761-b8ec-efce9e738493	e74587da-c704-485d-9717-1bd7df7f05fd	t	${role_view-applications}	view-applications	f751882b-adae-4e57-96a2-61fcd0497761	e74587da-c704-485d-9717-1bd7df7f05fd	\N
7c1d4f06-2542-4938-82cf-89ef160e7513	e74587da-c704-485d-9717-1bd7df7f05fd	t	${role_view-consent}	view-consent	f751882b-adae-4e57-96a2-61fcd0497761	e74587da-c704-485d-9717-1bd7df7f05fd	\N
a24b8d9b-dd95-45b3-b3ea-da66b53906f0	e74587da-c704-485d-9717-1bd7df7f05fd	t	${role_manage-consent}	manage-consent	f751882b-adae-4e57-96a2-61fcd0497761	e74587da-c704-485d-9717-1bd7df7f05fd	\N
88cc4c7e-378e-404a-9ac2-4d6c23243f21	e74587da-c704-485d-9717-1bd7df7f05fd	t	${role_view-groups}	view-groups	f751882b-adae-4e57-96a2-61fcd0497761	e74587da-c704-485d-9717-1bd7df7f05fd	\N
9b29a15c-5e6c-4be1-865d-741663c8ecda	e74587da-c704-485d-9717-1bd7df7f05fd	t	${role_delete-account}	delete-account	f751882b-adae-4e57-96a2-61fcd0497761	e74587da-c704-485d-9717-1bd7df7f05fd	\N
aed2ae40-2d00-467c-bf68-837d03bd8622	d9059ade-73d5-4e38-b29c-360e89af1918	t	${role_read-token}	read-token	f751882b-adae-4e57-96a2-61fcd0497761	d9059ade-73d5-4e38-b29c-360e89af1918	\N
a89098ba-ad5f-44bc-88cf-afc60d2f8509	ca13f022-86a6-4d5a-98d6-0f96164f7250	t	${role_impersonation}	impersonation	f751882b-adae-4e57-96a2-61fcd0497761	ca13f022-86a6-4d5a-98d6-0f96164f7250	\N
e3f4b80d-9223-487d-94c2-dc7143455a51	f751882b-adae-4e57-96a2-61fcd0497761	f	${role_offline-access}	offline_access	f751882b-adae-4e57-96a2-61fcd0497761	\N	\N
8b28c4fa-75ae-441d-9ddc-50cd416596e9	f751882b-adae-4e57-96a2-61fcd0497761	f	${role_uma_authorization}	uma_authorization	f751882b-adae-4e57-96a2-61fcd0497761	\N	\N
b9781f4d-1f73-4b9c-9386-d4e1c1703a1d	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	f	${role_default-roles}	default-roles-concerto	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	\N
79a314fc-3dff-496f-8911-f8acc7c4f293	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_create-client}	create-client	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
070c4c17-5df3-4933-bda9-b041fb9be884	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_view-realm}	view-realm	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
0444b156-a10e-49b7-afb5-f92756d4990c	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_view-users}	view-users	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
b232bb34-d681-47e6-b118-5cb5881076e9	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_view-clients}	view-clients	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
d0f0f072-b528-4a90-bdba-841d1a813442	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_view-events}	view-events	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
f0369cfd-47a9-4b96-81b9-288955e4e57c	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_view-identity-providers}	view-identity-providers	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
c0cc5abc-5eb2-4485-90f8-9645d30c8266	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_view-authorization}	view-authorization	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
9444c855-7d27-4eb4-bd74-ab5656a4827f	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_manage-realm}	manage-realm	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
5debe47a-2e6f-4924-ae72-0a3e7baddc9a	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_manage-users}	manage-users	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
9e4f59f3-2ff0-46b3-9a9a-b390dd4013fb	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_manage-clients}	manage-clients	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
570d908f-ce06-443c-8864-d4271c7e88b6	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_manage-events}	manage-events	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
e050ed2a-fad7-4f42-b748-8a20b83fb8eb	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_manage-identity-providers}	manage-identity-providers	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
8b568a8a-a4fb-4520-b0a0-639202dedc63	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_manage-authorization}	manage-authorization	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
7b23ab01-6972-47b9-b9af-76b369fc956d	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_query-users}	query-users	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
61be5a39-1c27-4351-9219-101f0a2690aa	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_query-clients}	query-clients	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
2c1a2318-2cd1-4832-a1de-3e17e9fff41f	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_query-realms}	query-realms	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
fd949fed-f0bb-4327-a651-fcc82add21eb	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_query-groups}	query-groups	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
0b18b669-5c09-49e2-9f40-30fb7295d822	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_realm-admin}	realm-admin	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
936aa81e-00f9-4b41-9114-4977932d7857	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_create-client}	create-client	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
b4b13c66-4bec-4f26-8d62-7ac7cce29260	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_view-realm}	view-realm	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
6521fc9c-5cfd-482d-9f51-7c1bdd1e9afc	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_view-users}	view-users	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
50aa8776-b226-4f8e-95c0-f097edc3105a	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_view-clients}	view-clients	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
f2d3f2f8-b453-40ab-ac68-700313e0818a	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_view-events}	view-events	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
b0a3d6ce-ab84-4026-bbbf-33bd83c3b3b5	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_view-identity-providers}	view-identity-providers	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
f0811660-df00-475f-af67-d5f64fea0818	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_view-authorization}	view-authorization	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
2e74cdb7-a64c-4ddc-b80b-762751a78e92	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_manage-realm}	manage-realm	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
cee750b6-7bb5-4f07-a882-1facca4099d4	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_manage-users}	manage-users	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
73243003-8057-4c01-9686-829106fdfeaf	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_manage-clients}	manage-clients	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
bb9d4102-8f1b-4a6a-8ad3-eb0d623db75e	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_manage-events}	manage-events	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
082b57f5-48cb-4aba-9dd1-ac0f0c0e0df6	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_manage-identity-providers}	manage-identity-providers	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
32563e37-878f-4cac-8f2a-6290e5e83154	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_manage-authorization}	manage-authorization	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
1d3063ad-7fa2-4715-8da0-4452990c84c5	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_query-users}	query-users	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
a18d4170-eb19-4b02-b402-e66c6884cfbb	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_query-clients}	query-clients	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
a4487379-937e-450e-8e76-2e2b05d60067	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_query-realms}	query-realms	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
1ce87057-a8cb-4ccc-9790-662eca5855f1	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_query-groups}	query-groups	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
7da31553-bdc7-4aad-b425-f70d1f5bbccb	39b034e8-297a-4e48-adc3-0d53c0797cb7	t	${role_view-profile}	view-profile	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	39b034e8-297a-4e48-adc3-0d53c0797cb7	\N
dc032b67-388c-4d2a-8368-4a12e9806c3f	39b034e8-297a-4e48-adc3-0d53c0797cb7	t	${role_manage-account}	manage-account	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	39b034e8-297a-4e48-adc3-0d53c0797cb7	\N
07c61deb-f62e-43d0-90ab-8b0b7d2c4f3c	39b034e8-297a-4e48-adc3-0d53c0797cb7	t	${role_manage-account-links}	manage-account-links	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	39b034e8-297a-4e48-adc3-0d53c0797cb7	\N
05609404-8455-4aa4-bf4a-0dab4444da1d	39b034e8-297a-4e48-adc3-0d53c0797cb7	t	${role_view-applications}	view-applications	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	39b034e8-297a-4e48-adc3-0d53c0797cb7	\N
99465dfc-b1fc-4c51-a7d6-3df5a35dd3b3	39b034e8-297a-4e48-adc3-0d53c0797cb7	t	${role_view-consent}	view-consent	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	39b034e8-297a-4e48-adc3-0d53c0797cb7	\N
9e99c727-da71-406f-be24-c1aee990b0df	39b034e8-297a-4e48-adc3-0d53c0797cb7	t	${role_manage-consent}	manage-consent	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	39b034e8-297a-4e48-adc3-0d53c0797cb7	\N
5edb82e7-0493-489a-99d0-c69800603a45	39b034e8-297a-4e48-adc3-0d53c0797cb7	t	${role_view-groups}	view-groups	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	39b034e8-297a-4e48-adc3-0d53c0797cb7	\N
9e3fb3e5-2504-4f73-86b1-73a077678740	39b034e8-297a-4e48-adc3-0d53c0797cb7	t	${role_delete-account}	delete-account	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	39b034e8-297a-4e48-adc3-0d53c0797cb7	\N
bc36e89a-1f0c-4ed2-abc0-59b2a01ec2d0	1ab5abb8-c141-48bc-b3f1-4d728ec53376	t	${role_impersonation}	impersonation	f751882b-adae-4e57-96a2-61fcd0497761	1ab5abb8-c141-48bc-b3f1-4d728ec53376	\N
9c53af67-8227-46bc-b3e1-b06fa9ef1cc9	9272434e-b7d2-407f-8efa-1a525aedf732	t	${role_impersonation}	impersonation	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	9272434e-b7d2-407f-8efa-1a525aedf732	\N
69939b1a-59ef-42e0-88d4-52d40fa49167	25de7b22-1f9a-4008-a602-0f9d042b6cb5	t	${role_read-token}	read-token	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	25de7b22-1f9a-4008-a602-0f9d042b6cb5	\N
932362fb-58e7-4fec-91f6-8a383e06819f	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	f	${role_offline-access}	offline_access	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	\N
d796e532-8099-447b-b687-c4ea9889a1e4	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	f	${role_uma_authorization}	uma_authorization	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	\N
9ad50496-650f-411f-ac1b-94344eb89f73	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	f		user	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	\N
3c56c421-4132-4ec5-a3ee-bc00cebed818	f751882b-adae-4e57-96a2-61fcd0497761	f		admins	f751882b-adae-4e57-96a2-61fcd0497761	\N	\N
f112f740-22d1-4e02-8dbb-f17093d29879	f751882b-adae-4e57-96a2-61fcd0497761	f		moderators	f751882b-adae-4e57-96a2-61fcd0497761	\N	\N
90f2de14-c61a-4a7e-862d-414da7228048	f751882b-adae-4e57-96a2-61fcd0497761	f		unverified	f751882b-adae-4e57-96a2-61fcd0497761	\N	\N
c986eb84-abb6-4442-bee5-8de6f5d6c71c	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	f		admin	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	\N
84ae5dc7-93f4-4c45-9434-40fde14b1a0a	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	f		moderator	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.migration_model (id, version, update_time) FROM stdin;
h2s9x	21.1.0	1744140264
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
d5bfd6f7-0a80-4b12-a394-516932c0630c	audience resolve	openid-connect	oidc-audience-resolve-mapper	2783b436-a88e-4b71-97dc-7bd3898f39d0	\N
2e5dc92c-f296-4889-9127-1a96816f4d60	locale	openid-connect	oidc-usermodel-attribute-mapper	edd1bb01-6648-440a-aa92-b1c51b766aad	\N
d10557ef-13b6-4fc6-a6a3-e31a48569628	role list	saml	saml-role-list-mapper	\N	f5bc50af-4046-40e1-bed7-80c4e2cb1683
f22b391c-6084-4a36-a226-bcd362c12267	full name	openid-connect	oidc-full-name-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
d4698b02-2f57-493c-86b1-4e90ae6f4e34	family name	openid-connect	oidc-usermodel-property-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
19a6baab-3e64-46c7-9821-347d06e8d980	given name	openid-connect	oidc-usermodel-property-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
3c9667d6-5a35-491c-8f09-87ba3f0c24b5	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
253bbf9e-9839-4fd4-9f6c-077de0307cc6	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
089b98e8-6484-4494-be31-f701bea1f423	username	openid-connect	oidc-usermodel-property-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
03255a4f-e4b8-43a5-922e-5adff3d7f917	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
35166105-5ecd-428a-b55f-b33ed8b0397c	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
9c7ca170-8c7d-4c58-b52c-1588ecd3103d	website	openid-connect	oidc-usermodel-attribute-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
e830fc37-4312-4fd9-9024-46485941fb24	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
85f2b704-faee-4b42-8d0c-878827282dac	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
604eecd7-7dcb-4556-933a-5d7d293879d7	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
2c6692b8-75c8-4bc6-8478-49a335ab9eaa	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
979733aa-3c68-4202-809d-410749192919	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	27164090-ad2f-4f1d-90c8-caf67e188950
9548b250-da7c-4d83-8061-3d47b942d2a1	email	openid-connect	oidc-usermodel-property-mapper	\N	426ce351-b77e-416c-97b8-8dfef86c4d69
12f238ec-5cb7-4740-8726-153d2b7a6db4	email verified	openid-connect	oidc-usermodel-property-mapper	\N	426ce351-b77e-416c-97b8-8dfef86c4d69
6104308f-ec5d-4d4a-906e-2f21539d66c7	address	openid-connect	oidc-address-mapper	\N	7b2b8a93-c087-432f-87f7-d592dddd6b1b
590134ee-23c2-4919-8147-e48c5f14522f	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	eecde97e-b5ec-42f2-acde-ac6080deaaf7
7a86330f-7266-425b-8748-3e4132292a8e	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	eecde97e-b5ec-42f2-acde-ac6080deaaf7
31aa4de8-14bb-462e-9cab-38571002776f	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	23a8810c-cd80-478b-b6c7-0d542bea0da4
fd52089f-49f3-4540-a507-4b936c747e93	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	23a8810c-cd80-478b-b6c7-0d542bea0da4
3bcd07ab-b1a7-4353-aa3a-52b3f0876d8d	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	23a8810c-cd80-478b-b6c7-0d542bea0da4
5e344cc9-7a46-4a7f-85cf-a9075152f119	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	4b00688a-cd52-48f8-b60e-95d94d7dd20f
17004bd8-f250-407a-a16e-954983455a16	upn	openid-connect	oidc-usermodel-property-mapper	\N	c757081c-545d-4395-94c2-ac60009726bf
3d0d80fd-529f-40fc-b034-a7c14e219b56	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	c757081c-545d-4395-94c2-ac60009726bf
2ba51f09-c686-4041-88bf-18f4b67d412b	acr loa level	openid-connect	oidc-acr-mapper	\N	2cb7acf1-4032-4ce9-bfc4-1cc775e2cc4c
adfff32f-8468-4afa-b706-58fa6106f05c	audience resolve	openid-connect	oidc-audience-resolve-mapper	7bfaf0df-680c-4fb7-8b75-62b58880d428	\N
9e9356c6-9ce1-44e8-8286-011e4a25d8bb	role list	saml	saml-role-list-mapper	\N	358ac934-814a-47fc-82c9-44c6e189bf7a
a89eb1d1-91b1-4eaa-8c94-81d8e22645de	full name	openid-connect	oidc-full-name-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
a6015bfb-38be-47eb-be89-1a51339448b4	family name	openid-connect	oidc-usermodel-property-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
89d6b876-3ec5-45c1-943b-1a19877b49a8	given name	openid-connect	oidc-usermodel-property-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
7fb868c7-1943-4b5b-90c7-0c3ac6742eae	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
74ec0c48-4c76-479c-aead-c365b17c824d	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
659d001b-0434-4d95-8608-44d67a969b17	username	openid-connect	oidc-usermodel-property-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
68f71669-4ca5-4e90-931b-47bae39492d1	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
727cceaa-beed-48cb-ba37-2dab516e5f37	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
f971523b-f608-4d3a-b569-5e5a0b1bbff4	website	openid-connect	oidc-usermodel-attribute-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
6dd3eb96-a563-429a-baf1-6f61dc6ff73d	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
7e1e5fd4-ff9b-4e95-8bc3-433ce35ecdba	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
186770db-9663-42ea-9bf8-c0b656a02d4f	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
49477467-566f-4303-8ff0-3200c1713989	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
4664990b-d15d-40c3-bba5-73befdaaed29	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	cf9da1d5-1f21-417e-9772-f212e5d26248
fb015838-00c1-4f11-be74-0979e34e6fa0	email	openid-connect	oidc-usermodel-property-mapper	\N	76bfa8d9-5cd0-46ae-a381-7a47a25714a5
61900c30-241b-4047-8f9c-8953798e5f36	email verified	openid-connect	oidc-usermodel-property-mapper	\N	76bfa8d9-5cd0-46ae-a381-7a47a25714a5
393642af-26d5-4cc2-a5bc-f93fc13fb284	address	openid-connect	oidc-address-mapper	\N	6eb6bf43-c68c-4005-90d0-ea69691db402
9a138c84-f2f8-4076-8d11-df291ed1e79d	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47
c28f4452-6bc6-4423-8d49-20936c8d37cd	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	15cc86cb-1c4d-4f25-a45f-3cd11f0bae47
ddde2d4d-e6d1-4461-8b11-3be29fb40355	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	697238b2-3932-4934-bcdb-641a26e41e53
5cb87337-98de-4ad6-81d4-de734b553372	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	697238b2-3932-4934-bcdb-641a26e41e53
a62c2870-9ba4-4508-b589-b72ffd48c88a	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	697238b2-3932-4934-bcdb-641a26e41e53
7289151a-bf2a-48c5-9ae8-22e2dddcd99f	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	4d0caf81-668f-4968-b48b-e990aad05905
d57c36f6-d080-4371-8400-c3234dda0884	upn	openid-connect	oidc-usermodel-property-mapper	\N	8ffff1b6-aaa2-4105-b406-944aa6fd333f
40c78783-f597-458b-8aca-08287cebaba0	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	8ffff1b6-aaa2-4105-b406-944aa6fd333f
68d4b0e2-1d85-483a-9728-af5ee5976f81	acr loa level	openid-connect	oidc-acr-mapper	\N	04d16d6b-27f5-4353-84fe-f0dda2b75ce8
602450d5-a9f9-432e-a27c-d40bfe3a72f0	locale	openid-connect	oidc-usermodel-attribute-mapper	07a8e7af-80f6-4672-abef-5786c95e7867	\N
ad387c1e-1525-4544-a8b1-658ee275922e	roles-unnested	openid-connect	oidc-usermodel-realm-role-mapper	8ab49cf2-6f70-438e-81a3-6b679dd04c7f	\N
0ae8a501-26f4-4532-b087-ffb40413043c	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	\N
781aec05-37f0-4bf6-a817-747c6a4fec30	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	\N
f212e8fb-0eba-4b7d-85c1-76d7d1b5a786	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
2e5dc92c-f296-4889-9127-1a96816f4d60	true	userinfo.token.claim
2e5dc92c-f296-4889-9127-1a96816f4d60	locale	user.attribute
2e5dc92c-f296-4889-9127-1a96816f4d60	true	id.token.claim
2e5dc92c-f296-4889-9127-1a96816f4d60	true	access.token.claim
2e5dc92c-f296-4889-9127-1a96816f4d60	locale	claim.name
2e5dc92c-f296-4889-9127-1a96816f4d60	String	jsonType.label
d10557ef-13b6-4fc6-a6a3-e31a48569628	false	single
d10557ef-13b6-4fc6-a6a3-e31a48569628	Basic	attribute.nameformat
d10557ef-13b6-4fc6-a6a3-e31a48569628	Role	attribute.name
03255a4f-e4b8-43a5-922e-5adff3d7f917	true	userinfo.token.claim
03255a4f-e4b8-43a5-922e-5adff3d7f917	profile	user.attribute
03255a4f-e4b8-43a5-922e-5adff3d7f917	true	id.token.claim
03255a4f-e4b8-43a5-922e-5adff3d7f917	true	access.token.claim
03255a4f-e4b8-43a5-922e-5adff3d7f917	profile	claim.name
03255a4f-e4b8-43a5-922e-5adff3d7f917	String	jsonType.label
089b98e8-6484-4494-be31-f701bea1f423	true	userinfo.token.claim
089b98e8-6484-4494-be31-f701bea1f423	username	user.attribute
089b98e8-6484-4494-be31-f701bea1f423	true	id.token.claim
089b98e8-6484-4494-be31-f701bea1f423	true	access.token.claim
089b98e8-6484-4494-be31-f701bea1f423	preferred_username	claim.name
089b98e8-6484-4494-be31-f701bea1f423	String	jsonType.label
19a6baab-3e64-46c7-9821-347d06e8d980	true	userinfo.token.claim
19a6baab-3e64-46c7-9821-347d06e8d980	firstName	user.attribute
19a6baab-3e64-46c7-9821-347d06e8d980	true	id.token.claim
19a6baab-3e64-46c7-9821-347d06e8d980	true	access.token.claim
19a6baab-3e64-46c7-9821-347d06e8d980	given_name	claim.name
19a6baab-3e64-46c7-9821-347d06e8d980	String	jsonType.label
253bbf9e-9839-4fd4-9f6c-077de0307cc6	true	userinfo.token.claim
253bbf9e-9839-4fd4-9f6c-077de0307cc6	nickname	user.attribute
253bbf9e-9839-4fd4-9f6c-077de0307cc6	true	id.token.claim
253bbf9e-9839-4fd4-9f6c-077de0307cc6	true	access.token.claim
253bbf9e-9839-4fd4-9f6c-077de0307cc6	nickname	claim.name
253bbf9e-9839-4fd4-9f6c-077de0307cc6	String	jsonType.label
2c6692b8-75c8-4bc6-8478-49a335ab9eaa	true	userinfo.token.claim
2c6692b8-75c8-4bc6-8478-49a335ab9eaa	locale	user.attribute
2c6692b8-75c8-4bc6-8478-49a335ab9eaa	true	id.token.claim
2c6692b8-75c8-4bc6-8478-49a335ab9eaa	true	access.token.claim
2c6692b8-75c8-4bc6-8478-49a335ab9eaa	locale	claim.name
2c6692b8-75c8-4bc6-8478-49a335ab9eaa	String	jsonType.label
35166105-5ecd-428a-b55f-b33ed8b0397c	true	userinfo.token.claim
35166105-5ecd-428a-b55f-b33ed8b0397c	picture	user.attribute
35166105-5ecd-428a-b55f-b33ed8b0397c	true	id.token.claim
35166105-5ecd-428a-b55f-b33ed8b0397c	true	access.token.claim
35166105-5ecd-428a-b55f-b33ed8b0397c	picture	claim.name
35166105-5ecd-428a-b55f-b33ed8b0397c	String	jsonType.label
3c9667d6-5a35-491c-8f09-87ba3f0c24b5	true	userinfo.token.claim
3c9667d6-5a35-491c-8f09-87ba3f0c24b5	middleName	user.attribute
3c9667d6-5a35-491c-8f09-87ba3f0c24b5	true	id.token.claim
3c9667d6-5a35-491c-8f09-87ba3f0c24b5	true	access.token.claim
3c9667d6-5a35-491c-8f09-87ba3f0c24b5	middle_name	claim.name
3c9667d6-5a35-491c-8f09-87ba3f0c24b5	String	jsonType.label
604eecd7-7dcb-4556-933a-5d7d293879d7	true	userinfo.token.claim
604eecd7-7dcb-4556-933a-5d7d293879d7	zoneinfo	user.attribute
604eecd7-7dcb-4556-933a-5d7d293879d7	true	id.token.claim
604eecd7-7dcb-4556-933a-5d7d293879d7	true	access.token.claim
604eecd7-7dcb-4556-933a-5d7d293879d7	zoneinfo	claim.name
604eecd7-7dcb-4556-933a-5d7d293879d7	String	jsonType.label
85f2b704-faee-4b42-8d0c-878827282dac	true	userinfo.token.claim
85f2b704-faee-4b42-8d0c-878827282dac	birthdate	user.attribute
85f2b704-faee-4b42-8d0c-878827282dac	true	id.token.claim
85f2b704-faee-4b42-8d0c-878827282dac	true	access.token.claim
85f2b704-faee-4b42-8d0c-878827282dac	birthdate	claim.name
85f2b704-faee-4b42-8d0c-878827282dac	String	jsonType.label
979733aa-3c68-4202-809d-410749192919	true	userinfo.token.claim
979733aa-3c68-4202-809d-410749192919	updatedAt	user.attribute
979733aa-3c68-4202-809d-410749192919	true	id.token.claim
979733aa-3c68-4202-809d-410749192919	true	access.token.claim
979733aa-3c68-4202-809d-410749192919	updated_at	claim.name
979733aa-3c68-4202-809d-410749192919	long	jsonType.label
9c7ca170-8c7d-4c58-b52c-1588ecd3103d	true	userinfo.token.claim
9c7ca170-8c7d-4c58-b52c-1588ecd3103d	website	user.attribute
9c7ca170-8c7d-4c58-b52c-1588ecd3103d	true	id.token.claim
9c7ca170-8c7d-4c58-b52c-1588ecd3103d	true	access.token.claim
9c7ca170-8c7d-4c58-b52c-1588ecd3103d	website	claim.name
9c7ca170-8c7d-4c58-b52c-1588ecd3103d	String	jsonType.label
d4698b02-2f57-493c-86b1-4e90ae6f4e34	true	userinfo.token.claim
d4698b02-2f57-493c-86b1-4e90ae6f4e34	lastName	user.attribute
d4698b02-2f57-493c-86b1-4e90ae6f4e34	true	id.token.claim
d4698b02-2f57-493c-86b1-4e90ae6f4e34	true	access.token.claim
d4698b02-2f57-493c-86b1-4e90ae6f4e34	family_name	claim.name
d4698b02-2f57-493c-86b1-4e90ae6f4e34	String	jsonType.label
e830fc37-4312-4fd9-9024-46485941fb24	true	userinfo.token.claim
e830fc37-4312-4fd9-9024-46485941fb24	gender	user.attribute
e830fc37-4312-4fd9-9024-46485941fb24	true	id.token.claim
e830fc37-4312-4fd9-9024-46485941fb24	true	access.token.claim
e830fc37-4312-4fd9-9024-46485941fb24	gender	claim.name
e830fc37-4312-4fd9-9024-46485941fb24	String	jsonType.label
f22b391c-6084-4a36-a226-bcd362c12267	true	userinfo.token.claim
f22b391c-6084-4a36-a226-bcd362c12267	true	id.token.claim
f22b391c-6084-4a36-a226-bcd362c12267	true	access.token.claim
12f238ec-5cb7-4740-8726-153d2b7a6db4	true	userinfo.token.claim
12f238ec-5cb7-4740-8726-153d2b7a6db4	emailVerified	user.attribute
12f238ec-5cb7-4740-8726-153d2b7a6db4	true	id.token.claim
12f238ec-5cb7-4740-8726-153d2b7a6db4	true	access.token.claim
12f238ec-5cb7-4740-8726-153d2b7a6db4	email_verified	claim.name
12f238ec-5cb7-4740-8726-153d2b7a6db4	boolean	jsonType.label
9548b250-da7c-4d83-8061-3d47b942d2a1	true	userinfo.token.claim
9548b250-da7c-4d83-8061-3d47b942d2a1	email	user.attribute
9548b250-da7c-4d83-8061-3d47b942d2a1	true	id.token.claim
9548b250-da7c-4d83-8061-3d47b942d2a1	true	access.token.claim
9548b250-da7c-4d83-8061-3d47b942d2a1	email	claim.name
9548b250-da7c-4d83-8061-3d47b942d2a1	String	jsonType.label
6104308f-ec5d-4d4a-906e-2f21539d66c7	formatted	user.attribute.formatted
6104308f-ec5d-4d4a-906e-2f21539d66c7	country	user.attribute.country
6104308f-ec5d-4d4a-906e-2f21539d66c7	postal_code	user.attribute.postal_code
6104308f-ec5d-4d4a-906e-2f21539d66c7	true	userinfo.token.claim
6104308f-ec5d-4d4a-906e-2f21539d66c7	street	user.attribute.street
6104308f-ec5d-4d4a-906e-2f21539d66c7	true	id.token.claim
6104308f-ec5d-4d4a-906e-2f21539d66c7	region	user.attribute.region
6104308f-ec5d-4d4a-906e-2f21539d66c7	true	access.token.claim
6104308f-ec5d-4d4a-906e-2f21539d66c7	locality	user.attribute.locality
590134ee-23c2-4919-8147-e48c5f14522f	true	userinfo.token.claim
590134ee-23c2-4919-8147-e48c5f14522f	phoneNumber	user.attribute
590134ee-23c2-4919-8147-e48c5f14522f	true	id.token.claim
590134ee-23c2-4919-8147-e48c5f14522f	true	access.token.claim
590134ee-23c2-4919-8147-e48c5f14522f	phone_number	claim.name
590134ee-23c2-4919-8147-e48c5f14522f	String	jsonType.label
7a86330f-7266-425b-8748-3e4132292a8e	true	userinfo.token.claim
7a86330f-7266-425b-8748-3e4132292a8e	phoneNumberVerified	user.attribute
7a86330f-7266-425b-8748-3e4132292a8e	true	id.token.claim
7a86330f-7266-425b-8748-3e4132292a8e	true	access.token.claim
7a86330f-7266-425b-8748-3e4132292a8e	phone_number_verified	claim.name
7a86330f-7266-425b-8748-3e4132292a8e	boolean	jsonType.label
31aa4de8-14bb-462e-9cab-38571002776f	true	multivalued
31aa4de8-14bb-462e-9cab-38571002776f	foo	user.attribute
31aa4de8-14bb-462e-9cab-38571002776f	true	access.token.claim
31aa4de8-14bb-462e-9cab-38571002776f	realm_access.roles	claim.name
31aa4de8-14bb-462e-9cab-38571002776f	String	jsonType.label
fd52089f-49f3-4540-a507-4b936c747e93	true	multivalued
fd52089f-49f3-4540-a507-4b936c747e93	foo	user.attribute
fd52089f-49f3-4540-a507-4b936c747e93	true	access.token.claim
fd52089f-49f3-4540-a507-4b936c747e93	resource_access.${client_id}.roles	claim.name
fd52089f-49f3-4540-a507-4b936c747e93	String	jsonType.label
17004bd8-f250-407a-a16e-954983455a16	true	userinfo.token.claim
17004bd8-f250-407a-a16e-954983455a16	username	user.attribute
17004bd8-f250-407a-a16e-954983455a16	true	id.token.claim
17004bd8-f250-407a-a16e-954983455a16	true	access.token.claim
17004bd8-f250-407a-a16e-954983455a16	upn	claim.name
17004bd8-f250-407a-a16e-954983455a16	String	jsonType.label
3d0d80fd-529f-40fc-b034-a7c14e219b56	true	multivalued
3d0d80fd-529f-40fc-b034-a7c14e219b56	foo	user.attribute
3d0d80fd-529f-40fc-b034-a7c14e219b56	true	id.token.claim
3d0d80fd-529f-40fc-b034-a7c14e219b56	true	access.token.claim
3d0d80fd-529f-40fc-b034-a7c14e219b56	groups	claim.name
3d0d80fd-529f-40fc-b034-a7c14e219b56	String	jsonType.label
2ba51f09-c686-4041-88bf-18f4b67d412b	true	id.token.claim
2ba51f09-c686-4041-88bf-18f4b67d412b	true	access.token.claim
9e9356c6-9ce1-44e8-8286-011e4a25d8bb	false	single
9e9356c6-9ce1-44e8-8286-011e4a25d8bb	Basic	attribute.nameformat
9e9356c6-9ce1-44e8-8286-011e4a25d8bb	Role	attribute.name
186770db-9663-42ea-9bf8-c0b656a02d4f	true	userinfo.token.claim
186770db-9663-42ea-9bf8-c0b656a02d4f	zoneinfo	user.attribute
186770db-9663-42ea-9bf8-c0b656a02d4f	true	id.token.claim
186770db-9663-42ea-9bf8-c0b656a02d4f	true	access.token.claim
186770db-9663-42ea-9bf8-c0b656a02d4f	zoneinfo	claim.name
186770db-9663-42ea-9bf8-c0b656a02d4f	String	jsonType.label
4664990b-d15d-40c3-bba5-73befdaaed29	true	userinfo.token.claim
4664990b-d15d-40c3-bba5-73befdaaed29	updatedAt	user.attribute
4664990b-d15d-40c3-bba5-73befdaaed29	true	id.token.claim
4664990b-d15d-40c3-bba5-73befdaaed29	true	access.token.claim
4664990b-d15d-40c3-bba5-73befdaaed29	updated_at	claim.name
4664990b-d15d-40c3-bba5-73befdaaed29	long	jsonType.label
49477467-566f-4303-8ff0-3200c1713989	true	userinfo.token.claim
49477467-566f-4303-8ff0-3200c1713989	locale	user.attribute
49477467-566f-4303-8ff0-3200c1713989	true	id.token.claim
49477467-566f-4303-8ff0-3200c1713989	true	access.token.claim
49477467-566f-4303-8ff0-3200c1713989	locale	claim.name
49477467-566f-4303-8ff0-3200c1713989	String	jsonType.label
659d001b-0434-4d95-8608-44d67a969b17	true	userinfo.token.claim
659d001b-0434-4d95-8608-44d67a969b17	username	user.attribute
659d001b-0434-4d95-8608-44d67a969b17	true	id.token.claim
659d001b-0434-4d95-8608-44d67a969b17	true	access.token.claim
659d001b-0434-4d95-8608-44d67a969b17	preferred_username	claim.name
659d001b-0434-4d95-8608-44d67a969b17	String	jsonType.label
68f71669-4ca5-4e90-931b-47bae39492d1	true	userinfo.token.claim
68f71669-4ca5-4e90-931b-47bae39492d1	profile	user.attribute
68f71669-4ca5-4e90-931b-47bae39492d1	true	id.token.claim
68f71669-4ca5-4e90-931b-47bae39492d1	true	access.token.claim
68f71669-4ca5-4e90-931b-47bae39492d1	profile	claim.name
68f71669-4ca5-4e90-931b-47bae39492d1	String	jsonType.label
6dd3eb96-a563-429a-baf1-6f61dc6ff73d	true	userinfo.token.claim
6dd3eb96-a563-429a-baf1-6f61dc6ff73d	gender	user.attribute
6dd3eb96-a563-429a-baf1-6f61dc6ff73d	true	id.token.claim
6dd3eb96-a563-429a-baf1-6f61dc6ff73d	true	access.token.claim
6dd3eb96-a563-429a-baf1-6f61dc6ff73d	gender	claim.name
6dd3eb96-a563-429a-baf1-6f61dc6ff73d	String	jsonType.label
727cceaa-beed-48cb-ba37-2dab516e5f37	true	userinfo.token.claim
727cceaa-beed-48cb-ba37-2dab516e5f37	picture	user.attribute
727cceaa-beed-48cb-ba37-2dab516e5f37	true	id.token.claim
727cceaa-beed-48cb-ba37-2dab516e5f37	true	access.token.claim
727cceaa-beed-48cb-ba37-2dab516e5f37	picture	claim.name
727cceaa-beed-48cb-ba37-2dab516e5f37	String	jsonType.label
74ec0c48-4c76-479c-aead-c365b17c824d	true	userinfo.token.claim
74ec0c48-4c76-479c-aead-c365b17c824d	nickname	user.attribute
74ec0c48-4c76-479c-aead-c365b17c824d	true	id.token.claim
74ec0c48-4c76-479c-aead-c365b17c824d	true	access.token.claim
74ec0c48-4c76-479c-aead-c365b17c824d	nickname	claim.name
74ec0c48-4c76-479c-aead-c365b17c824d	String	jsonType.label
7e1e5fd4-ff9b-4e95-8bc3-433ce35ecdba	true	userinfo.token.claim
7e1e5fd4-ff9b-4e95-8bc3-433ce35ecdba	birthdate	user.attribute
7e1e5fd4-ff9b-4e95-8bc3-433ce35ecdba	true	id.token.claim
7e1e5fd4-ff9b-4e95-8bc3-433ce35ecdba	true	access.token.claim
7e1e5fd4-ff9b-4e95-8bc3-433ce35ecdba	birthdate	claim.name
7e1e5fd4-ff9b-4e95-8bc3-433ce35ecdba	String	jsonType.label
7fb868c7-1943-4b5b-90c7-0c3ac6742eae	true	userinfo.token.claim
7fb868c7-1943-4b5b-90c7-0c3ac6742eae	middleName	user.attribute
7fb868c7-1943-4b5b-90c7-0c3ac6742eae	true	id.token.claim
7fb868c7-1943-4b5b-90c7-0c3ac6742eae	true	access.token.claim
7fb868c7-1943-4b5b-90c7-0c3ac6742eae	middle_name	claim.name
7fb868c7-1943-4b5b-90c7-0c3ac6742eae	String	jsonType.label
89d6b876-3ec5-45c1-943b-1a19877b49a8	true	userinfo.token.claim
89d6b876-3ec5-45c1-943b-1a19877b49a8	firstName	user.attribute
89d6b876-3ec5-45c1-943b-1a19877b49a8	true	id.token.claim
89d6b876-3ec5-45c1-943b-1a19877b49a8	true	access.token.claim
89d6b876-3ec5-45c1-943b-1a19877b49a8	given_name	claim.name
89d6b876-3ec5-45c1-943b-1a19877b49a8	String	jsonType.label
a6015bfb-38be-47eb-be89-1a51339448b4	true	userinfo.token.claim
a6015bfb-38be-47eb-be89-1a51339448b4	lastName	user.attribute
a6015bfb-38be-47eb-be89-1a51339448b4	true	id.token.claim
a6015bfb-38be-47eb-be89-1a51339448b4	true	access.token.claim
a6015bfb-38be-47eb-be89-1a51339448b4	family_name	claim.name
a6015bfb-38be-47eb-be89-1a51339448b4	String	jsonType.label
a89eb1d1-91b1-4eaa-8c94-81d8e22645de	true	userinfo.token.claim
a89eb1d1-91b1-4eaa-8c94-81d8e22645de	true	id.token.claim
a89eb1d1-91b1-4eaa-8c94-81d8e22645de	true	access.token.claim
f971523b-f608-4d3a-b569-5e5a0b1bbff4	true	userinfo.token.claim
f971523b-f608-4d3a-b569-5e5a0b1bbff4	website	user.attribute
f971523b-f608-4d3a-b569-5e5a0b1bbff4	true	id.token.claim
f971523b-f608-4d3a-b569-5e5a0b1bbff4	true	access.token.claim
f971523b-f608-4d3a-b569-5e5a0b1bbff4	website	claim.name
f971523b-f608-4d3a-b569-5e5a0b1bbff4	String	jsonType.label
61900c30-241b-4047-8f9c-8953798e5f36	true	userinfo.token.claim
61900c30-241b-4047-8f9c-8953798e5f36	emailVerified	user.attribute
61900c30-241b-4047-8f9c-8953798e5f36	true	id.token.claim
61900c30-241b-4047-8f9c-8953798e5f36	true	access.token.claim
61900c30-241b-4047-8f9c-8953798e5f36	email_verified	claim.name
61900c30-241b-4047-8f9c-8953798e5f36	boolean	jsonType.label
fb015838-00c1-4f11-be74-0979e34e6fa0	true	userinfo.token.claim
fb015838-00c1-4f11-be74-0979e34e6fa0	email	user.attribute
fb015838-00c1-4f11-be74-0979e34e6fa0	true	id.token.claim
fb015838-00c1-4f11-be74-0979e34e6fa0	true	access.token.claim
fb015838-00c1-4f11-be74-0979e34e6fa0	email	claim.name
fb015838-00c1-4f11-be74-0979e34e6fa0	String	jsonType.label
393642af-26d5-4cc2-a5bc-f93fc13fb284	formatted	user.attribute.formatted
393642af-26d5-4cc2-a5bc-f93fc13fb284	country	user.attribute.country
393642af-26d5-4cc2-a5bc-f93fc13fb284	postal_code	user.attribute.postal_code
393642af-26d5-4cc2-a5bc-f93fc13fb284	true	userinfo.token.claim
393642af-26d5-4cc2-a5bc-f93fc13fb284	street	user.attribute.street
393642af-26d5-4cc2-a5bc-f93fc13fb284	true	id.token.claim
393642af-26d5-4cc2-a5bc-f93fc13fb284	region	user.attribute.region
393642af-26d5-4cc2-a5bc-f93fc13fb284	true	access.token.claim
393642af-26d5-4cc2-a5bc-f93fc13fb284	locality	user.attribute.locality
9a138c84-f2f8-4076-8d11-df291ed1e79d	true	userinfo.token.claim
9a138c84-f2f8-4076-8d11-df291ed1e79d	phoneNumber	user.attribute
9a138c84-f2f8-4076-8d11-df291ed1e79d	true	id.token.claim
9a138c84-f2f8-4076-8d11-df291ed1e79d	true	access.token.claim
9a138c84-f2f8-4076-8d11-df291ed1e79d	phone_number	claim.name
9a138c84-f2f8-4076-8d11-df291ed1e79d	String	jsonType.label
c28f4452-6bc6-4423-8d49-20936c8d37cd	true	userinfo.token.claim
c28f4452-6bc6-4423-8d49-20936c8d37cd	phoneNumberVerified	user.attribute
c28f4452-6bc6-4423-8d49-20936c8d37cd	true	id.token.claim
c28f4452-6bc6-4423-8d49-20936c8d37cd	true	access.token.claim
c28f4452-6bc6-4423-8d49-20936c8d37cd	phone_number_verified	claim.name
c28f4452-6bc6-4423-8d49-20936c8d37cd	boolean	jsonType.label
5cb87337-98de-4ad6-81d4-de734b553372	true	multivalued
5cb87337-98de-4ad6-81d4-de734b553372	foo	user.attribute
5cb87337-98de-4ad6-81d4-de734b553372	true	access.token.claim
5cb87337-98de-4ad6-81d4-de734b553372	resource_access.${client_id}.roles	claim.name
5cb87337-98de-4ad6-81d4-de734b553372	String	jsonType.label
ddde2d4d-e6d1-4461-8b11-3be29fb40355	true	multivalued
ddde2d4d-e6d1-4461-8b11-3be29fb40355	foo	user.attribute
ddde2d4d-e6d1-4461-8b11-3be29fb40355	true	access.token.claim
ddde2d4d-e6d1-4461-8b11-3be29fb40355	realm_access.roles	claim.name
ddde2d4d-e6d1-4461-8b11-3be29fb40355	String	jsonType.label
40c78783-f597-458b-8aca-08287cebaba0	true	multivalued
40c78783-f597-458b-8aca-08287cebaba0	foo	user.attribute
40c78783-f597-458b-8aca-08287cebaba0	true	id.token.claim
40c78783-f597-458b-8aca-08287cebaba0	true	access.token.claim
40c78783-f597-458b-8aca-08287cebaba0	groups	claim.name
40c78783-f597-458b-8aca-08287cebaba0	String	jsonType.label
d57c36f6-d080-4371-8400-c3234dda0884	true	userinfo.token.claim
d57c36f6-d080-4371-8400-c3234dda0884	username	user.attribute
d57c36f6-d080-4371-8400-c3234dda0884	true	id.token.claim
d57c36f6-d080-4371-8400-c3234dda0884	true	access.token.claim
d57c36f6-d080-4371-8400-c3234dda0884	upn	claim.name
d57c36f6-d080-4371-8400-c3234dda0884	String	jsonType.label
68d4b0e2-1d85-483a-9728-af5ee5976f81	true	id.token.claim
68d4b0e2-1d85-483a-9728-af5ee5976f81	true	access.token.claim
602450d5-a9f9-432e-a27c-d40bfe3a72f0	true	userinfo.token.claim
602450d5-a9f9-432e-a27c-d40bfe3a72f0	locale	user.attribute
602450d5-a9f9-432e-a27c-d40bfe3a72f0	true	id.token.claim
602450d5-a9f9-432e-a27c-d40bfe3a72f0	true	access.token.claim
602450d5-a9f9-432e-a27c-d40bfe3a72f0	locale	claim.name
602450d5-a9f9-432e-a27c-d40bfe3a72f0	String	jsonType.label
ad387c1e-1525-4544-a8b1-658ee275922e	true	id.token.claim
ad387c1e-1525-4544-a8b1-658ee275922e	true	access.token.claim
ad387c1e-1525-4544-a8b1-658ee275922e	true	userinfo.token.claim
ad387c1e-1525-4544-a8b1-658ee275922e	roles	claim.name
ad387c1e-1525-4544-a8b1-658ee275922e	String	jsonType.label
ad387c1e-1525-4544-a8b1-658ee275922e	true	multivalued
0ae8a501-26f4-4532-b087-ffb40413043c	clientHost	user.session.note
0ae8a501-26f4-4532-b087-ffb40413043c	true	id.token.claim
0ae8a501-26f4-4532-b087-ffb40413043c	true	access.token.claim
0ae8a501-26f4-4532-b087-ffb40413043c	clientHost	claim.name
0ae8a501-26f4-4532-b087-ffb40413043c	String	jsonType.label
781aec05-37f0-4bf6-a817-747c6a4fec30	clientAddress	user.session.note
781aec05-37f0-4bf6-a817-747c6a4fec30	true	id.token.claim
781aec05-37f0-4bf6-a817-747c6a4fec30	true	access.token.claim
781aec05-37f0-4bf6-a817-747c6a4fec30	clientAddress	claim.name
781aec05-37f0-4bf6-a817-747c6a4fec30	String	jsonType.label
f212e8fb-0eba-4b7d-85c1-76d7d1b5a786	client_id	user.session.note
f212e8fb-0eba-4b7d-85c1-76d7d1b5a786	true	id.token.claim
f212e8fb-0eba-4b7d-85c1-76d7d1b5a786	true	access.token.claim
f212e8fb-0eba-4b7d-85c1-76d7d1b5a786	client_id	claim.name
f212e8fb-0eba-4b7d-85c1-76d7d1b5a786	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	60	300	300	\N	\N	\N	t	f	0	\N	concerto	0	\N	t	f	t	f	EXTERNAL	1800	36000	f	t	1ab5abb8-c141-48bc-b3f1-4d728ec53376	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	599d63b2-77d9-4107-b79f-28665ef64a47	fc74d967-3a8c-4e4b-a441-3fc96c1cc30f	79dd0b33-8051-499b-9e32-1aba2d7e8a12	48487858-647b-4a20-83f0-83489bc2bf87	2111e90a-c565-4db8-a03c-d96c01cd0fe4	2592000	f	900	t	f	9fe56abe-be8c-45d8-be97-78fc807644b3	0	f	0	0	b9781f4d-1f73-4b9c-9386-d4e1c1703a1d
f751882b-adae-4e57-96a2-61fcd0497761	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	ca13f022-86a6-4d5a-98d6-0f96164f7250	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	7b61880c-3f9d-4a22-a4e7-2ac2802d642a	3f17f9eb-fc0b-45ed-a2cf-34191d7f7da3	726b8320-8b73-4ca3-86b5-d114d3f11812	730b542f-91a3-4708-ac65-7ca3b0375f6b	65bba1fb-f7c8-46be-bead-a96f6dce7773	2592000	f	900	t	f	a8953591-c0c7-42ad-aede-03f4a162451a	0	f	0	0	5a78721b-02ef-46e7-acd4-bf2eba624d5a
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
bruteForceProtected	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	false
permanentLockout	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	false
maxFailureWaitSeconds	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	900
minimumQuickLoginWaitSeconds	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	60
waitIncrementSeconds	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	60
quickLoginCheckMilliSeconds	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	1000
maxDeltaTimeSeconds	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	43200
failureFactor	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	30
actionTokenGeneratedByAdminLifespan	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	43200
actionTokenGeneratedByUserLifespan	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	300
defaultSignatureAlgorithm	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	RS256
oauth2DeviceCodeLifespan	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	600
oauth2DevicePollingInterval	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	5
offlineSessionMaxLifespanEnabled	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	false
offlineSessionMaxLifespan	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	5184000
clientOfflineSessionIdleTimeout	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	0
clientOfflineSessionMaxLifespan	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	0
clientSessionIdleTimeout	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	0
clientSessionMaxLifespan	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	0
realmReusableOtpCode	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	false
webAuthnPolicyRpEntityName	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	keycloak
webAuthnPolicySignatureAlgorithms	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	ES256
webAuthnPolicyRpId	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	
webAuthnPolicyAttestationConveyancePreference	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	not specified
webAuthnPolicyAuthenticatorAttachment	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	not specified
webAuthnPolicyRequireResidentKey	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	not specified
webAuthnPolicyUserVerificationRequirement	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	not specified
webAuthnPolicyCreateTimeout	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	0
webAuthnPolicyAvoidSameAuthenticatorRegister	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	false
webAuthnPolicyRpEntityNamePasswordless	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	ES256
webAuthnPolicyRpIdPasswordless	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	
webAuthnPolicyAttestationConveyancePreferencePasswordless	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	not specified
webAuthnPolicyRequireResidentKeyPasswordless	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	not specified
webAuthnPolicyCreateTimeoutPasswordless	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	false
client-policies.profiles	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	{"profiles":[]}
client-policies.policies	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	{"policies":[]}
cibaAuthRequestedUserHint	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	login_hint
cibaBackchannelTokenDeliveryMode	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	poll
cibaExpiresIn	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	120
oauth2DeviceCodeLifespan	f751882b-adae-4e57-96a2-61fcd0497761	600
oauth2DevicePollingInterval	f751882b-adae-4e57-96a2-61fcd0497761	5
cibaBackchannelTokenDeliveryMode	f751882b-adae-4e57-96a2-61fcd0497761	poll
cibaExpiresIn	f751882b-adae-4e57-96a2-61fcd0497761	120
cibaInterval	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	5
parRequestUriLifespan	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	60
_browser_header.contentSecurityPolicyReportOnly	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	
_browser_header.xContentTypeOptions	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	nosniff
_browser_header.xRobotsTag	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	none
_browser_header.xFrameOptions	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	SAMEORIGIN
_browser_header.contentSecurityPolicy	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	frame-src 'self'; frame-ancestors 'self' https://localhost:5000 https://concerto.local:5000; object-src 'none';
_browser_header.xXSSProtection	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	1; mode=block
_browser_header.strictTransportSecurity	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	max-age=31536000; includeSubDomains
_browser_header.contentSecurityPolicy	f751882b-adae-4e57-96a2-61fcd0497761	frame-src 'self'; frame-ancestors 'self' https://localhost https://concerto.local; object-src 'none';
offlineSessionMaxLifespanEnabled	f751882b-adae-4e57-96a2-61fcd0497761	false
offlineSessionMaxLifespan	f751882b-adae-4e57-96a2-61fcd0497761	5184000
clientOfflineSessionIdleTimeout	f751882b-adae-4e57-96a2-61fcd0497761	0
clientOfflineSessionMaxLifespan	f751882b-adae-4e57-96a2-61fcd0497761	0
clientSessionIdleTimeout	f751882b-adae-4e57-96a2-61fcd0497761	0
clientSessionMaxLifespan	f751882b-adae-4e57-96a2-61fcd0497761	0
realmReusableOtpCode	f751882b-adae-4e57-96a2-61fcd0497761	false
webAuthnPolicyRpEntityName	f751882b-adae-4e57-96a2-61fcd0497761	keycloak
displayName	f751882b-adae-4e57-96a2-61fcd0497761	Keycloak
displayNameHtml	f751882b-adae-4e57-96a2-61fcd0497761	<div class="kc-logo-text"><span>Keycloak</span></div>
bruteForceProtected	f751882b-adae-4e57-96a2-61fcd0497761	false
permanentLockout	f751882b-adae-4e57-96a2-61fcd0497761	false
maxFailureWaitSeconds	f751882b-adae-4e57-96a2-61fcd0497761	900
minimumQuickLoginWaitSeconds	f751882b-adae-4e57-96a2-61fcd0497761	60
waitIncrementSeconds	f751882b-adae-4e57-96a2-61fcd0497761	60
quickLoginCheckMilliSeconds	f751882b-adae-4e57-96a2-61fcd0497761	1000
maxDeltaTimeSeconds	f751882b-adae-4e57-96a2-61fcd0497761	43200
failureFactor	f751882b-adae-4e57-96a2-61fcd0497761	30
actionTokenGeneratedByAdminLifespan	f751882b-adae-4e57-96a2-61fcd0497761	43200
actionTokenGeneratedByUserLifespan	f751882b-adae-4e57-96a2-61fcd0497761	300
defaultSignatureAlgorithm	f751882b-adae-4e57-96a2-61fcd0497761	RS256
webAuthnPolicySignatureAlgorithms	f751882b-adae-4e57-96a2-61fcd0497761	ES256
webAuthnPolicyRpId	f751882b-adae-4e57-96a2-61fcd0497761	
webAuthnPolicyAttestationConveyancePreference	f751882b-adae-4e57-96a2-61fcd0497761	not specified
webAuthnPolicyAuthenticatorAttachment	f751882b-adae-4e57-96a2-61fcd0497761	not specified
webAuthnPolicyRequireResidentKey	f751882b-adae-4e57-96a2-61fcd0497761	not specified
webAuthnPolicyUserVerificationRequirement	f751882b-adae-4e57-96a2-61fcd0497761	not specified
webAuthnPolicyCreateTimeout	f751882b-adae-4e57-96a2-61fcd0497761	0
webAuthnPolicyAvoidSameAuthenticatorRegister	f751882b-adae-4e57-96a2-61fcd0497761	false
webAuthnPolicyRpEntityNamePasswordless	f751882b-adae-4e57-96a2-61fcd0497761	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	f751882b-adae-4e57-96a2-61fcd0497761	ES256
webAuthnPolicyRpIdPasswordless	f751882b-adae-4e57-96a2-61fcd0497761	
webAuthnPolicyAttestationConveyancePreferencePasswordless	f751882b-adae-4e57-96a2-61fcd0497761	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	f751882b-adae-4e57-96a2-61fcd0497761	not specified
webAuthnPolicyRequireResidentKeyPasswordless	f751882b-adae-4e57-96a2-61fcd0497761	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	f751882b-adae-4e57-96a2-61fcd0497761	not specified
webAuthnPolicyCreateTimeoutPasswordless	f751882b-adae-4e57-96a2-61fcd0497761	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	f751882b-adae-4e57-96a2-61fcd0497761	false
client-policies.profiles	f751882b-adae-4e57-96a2-61fcd0497761	{"profiles":[]}
client-policies.policies	f751882b-adae-4e57-96a2-61fcd0497761	{"policies":[]}
cibaAuthRequestedUserHint	f751882b-adae-4e57-96a2-61fcd0497761	login_hint
cibaInterval	f751882b-adae-4e57-96a2-61fcd0497761	5
parRequestUriLifespan	f751882b-adae-4e57-96a2-61fcd0497761	60
_browser_header.contentSecurityPolicyReportOnly	f751882b-adae-4e57-96a2-61fcd0497761	
_browser_header.xContentTypeOptions	f751882b-adae-4e57-96a2-61fcd0497761	nosniff
_browser_header.xRobotsTag	f751882b-adae-4e57-96a2-61fcd0497761	none
_browser_header.xFrameOptions	f751882b-adae-4e57-96a2-61fcd0497761	SAMEORIGIN
_browser_header.xXSSProtection	f751882b-adae-4e57-96a2-61fcd0497761	1; mode=block
_browser_header.strictTransportSecurity	f751882b-adae-4e57-96a2-61fcd0497761	max-age=31536000; includeSubDomains
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
f751882b-adae-4e57-96a2-61fcd0497761	jboss-logging
6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	f751882b-adae-4e57-96a2-61fcd0497761
password	password	t	t	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.redirect_uris (client_id, value) FROM stdin;
e74587da-c704-485d-9717-1bd7df7f05fd	/realms/master/account/*
2783b436-a88e-4b71-97dc-7bd3898f39d0	/realms/master/account/*
edd1bb01-6648-440a-aa92-b1c51b766aad	/admin/master/console/*
39b034e8-297a-4e48-adc3-0d53c0797cb7	/realms/concerto/account/*
7bfaf0df-680c-4fb7-8b75-62b58880d428	/realms/concerto/account/*
07a8e7af-80f6-4672-abef-5786c95e7867	/admin/concerto/console/*
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	https://concerto.local:5000/authentication/login-callback
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	https://concerto.local:5000
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	https://concerto.local:5000/authentication/login-callback
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	https://concerto.local:5000
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	*
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	https://concerto.local:5000/authentication/login-callback
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	https://concerto.local:5000/authentication/login-callback
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
461ad677-fcb4-4a98-b58f-2f5c68530a6e	VERIFY_EMAIL	Verify Email	f751882b-adae-4e57-96a2-61fcd0497761	t	f	VERIFY_EMAIL	50
415772ce-a236-4bf5-bc9f-d4340b1e073e	UPDATE_PROFILE	Update Profile	f751882b-adae-4e57-96a2-61fcd0497761	t	f	UPDATE_PROFILE	40
9f4e3070-7e98-4b62-9a46-69082a8d71b5	CONFIGURE_TOTP	Configure OTP	f751882b-adae-4e57-96a2-61fcd0497761	t	f	CONFIGURE_TOTP	10
baa032a1-cdcd-4dbd-8f29-801acb45b0ce	UPDATE_PASSWORD	Update Password	f751882b-adae-4e57-96a2-61fcd0497761	t	f	UPDATE_PASSWORD	30
677bf3a3-471d-43b0-bc4a-65bcedc0afed	TERMS_AND_CONDITIONS	Terms and Conditions	f751882b-adae-4e57-96a2-61fcd0497761	f	f	TERMS_AND_CONDITIONS	20
0d4e4afc-e50a-43d5-975d-b02369e148e1	delete_account	Delete Account	f751882b-adae-4e57-96a2-61fcd0497761	f	f	delete_account	60
87b277f4-1743-43e1-9a59-861cd13d89aa	update_user_locale	Update User Locale	f751882b-adae-4e57-96a2-61fcd0497761	t	f	update_user_locale	1000
b3771c21-38bf-48f1-8769-f9bf6b17280a	webauthn-register	Webauthn Register	f751882b-adae-4e57-96a2-61fcd0497761	t	f	webauthn-register	70
ec5eb4ab-4813-42a1-8e11-22ba55ac5028	webauthn-register-passwordless	Webauthn Register Passwordless	f751882b-adae-4e57-96a2-61fcd0497761	t	f	webauthn-register-passwordless	80
67962e04-e79f-471a-8843-4cab1efbab11	VERIFY_EMAIL	Verify Email	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	t	f	VERIFY_EMAIL	50
4588461c-afba-43f1-89d6-530ff08f356d	UPDATE_PROFILE	Update Profile	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	t	f	UPDATE_PROFILE	40
76e8be0e-a347-425b-9687-9b0217b19d63	CONFIGURE_TOTP	Configure OTP	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	t	f	CONFIGURE_TOTP	10
2a76015a-46b9-4d0e-81a7-3b5be165a3d9	UPDATE_PASSWORD	Update Password	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	t	f	UPDATE_PASSWORD	30
50c41fc5-ab42-4ade-a2f4-ef9fba48da66	TERMS_AND_CONDITIONS	Terms and Conditions	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	f	f	TERMS_AND_CONDITIONS	20
a2f583f1-2b00-48c3-b6c0-bfe20cd01cba	delete_account	Delete Account	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	f	f	delete_account	60
68788597-c75f-491b-b1a3-7e9665c4a4a4	update_user_locale	Update User Locale	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	t	f	update_user_locale	1000
012b8530-e5d5-4f4f-9cd8-f643ce904976	webauthn-register	Webauthn Register	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	t	f	webauthn-register	70
07844bc5-6326-4b24-badc-9ec41ade7bb7	webauthn-register-passwordless	Webauthn Register Passwordless	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	t	f	webauthn-register-passwordless	80
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
2783b436-a88e-4b71-97dc-7bd3898f39d0	88cc4c7e-378e-404a-9ac2-4d6c23243f21
2783b436-a88e-4b71-97dc-7bd3898f39d0	a644d7c4-3b78-425f-a77d-e4a686ac5e9d
7bfaf0df-680c-4fb7-8b75-62b58880d428	dc032b67-388c-4d2a-8368-4a12e9806c3f
7bfaf0df-680c-4fb7-8b75-62b58880d428	5edb82e7-0493-489a-99d0-c69800603a45
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
655242f8-bc15-4119-87c6-b9d242495178	\N	f8fc7a4c-da5c-4e73-9ac2-46b5db11b213	t	t	\N	admin123	admin	f751882b-adae-4e57-96a2-61fcd0497761	admin	1744140266968	\N	0
4ee930b1-8b92-4b65-ab45-c069b2122c87	\N	7d70788e-2b0c-4d81-9d75-5e4826e6a7dd	f	t	\N	\N	\N	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	service-account-concerto-server	1746561452249	9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	0
1b47e0c0-668d-4020-959c-412c241fdd05	admin@admin.com	admin@admin.com	t	t	\N	admin	admin	6c0e74d5-b41b-4b05-88b8-8ec92691d7dc	admin	1744141694037	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
c8177640-fb95-4469-b43e-23d79048ee0e	1b47e0c0-668d-4020-959c-412c241fdd05
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
5a78721b-02ef-46e7-acd4-bf2eba624d5a	655242f8-bc15-4119-87c6-b9d242495178
15a55f35-fac7-45f5-9140-0340dcf01335	655242f8-bc15-4119-87c6-b9d242495178
79a314fc-3dff-496f-8911-f8acc7c4f293	655242f8-bc15-4119-87c6-b9d242495178
070c4c17-5df3-4933-bda9-b041fb9be884	655242f8-bc15-4119-87c6-b9d242495178
0444b156-a10e-49b7-afb5-f92756d4990c	655242f8-bc15-4119-87c6-b9d242495178
b232bb34-d681-47e6-b118-5cb5881076e9	655242f8-bc15-4119-87c6-b9d242495178
d0f0f072-b528-4a90-bdba-841d1a813442	655242f8-bc15-4119-87c6-b9d242495178
f0369cfd-47a9-4b96-81b9-288955e4e57c	655242f8-bc15-4119-87c6-b9d242495178
c0cc5abc-5eb2-4485-90f8-9645d30c8266	655242f8-bc15-4119-87c6-b9d242495178
9444c855-7d27-4eb4-bd74-ab5656a4827f	655242f8-bc15-4119-87c6-b9d242495178
5debe47a-2e6f-4924-ae72-0a3e7baddc9a	655242f8-bc15-4119-87c6-b9d242495178
9e4f59f3-2ff0-46b3-9a9a-b390dd4013fb	655242f8-bc15-4119-87c6-b9d242495178
570d908f-ce06-443c-8864-d4271c7e88b6	655242f8-bc15-4119-87c6-b9d242495178
e050ed2a-fad7-4f42-b748-8a20b83fb8eb	655242f8-bc15-4119-87c6-b9d242495178
8b568a8a-a4fb-4520-b0a0-639202dedc63	655242f8-bc15-4119-87c6-b9d242495178
7b23ab01-6972-47b9-b9af-76b369fc956d	655242f8-bc15-4119-87c6-b9d242495178
61be5a39-1c27-4351-9219-101f0a2690aa	655242f8-bc15-4119-87c6-b9d242495178
2c1a2318-2cd1-4832-a1de-3e17e9fff41f	655242f8-bc15-4119-87c6-b9d242495178
fd949fed-f0bb-4327-a651-fcc82add21eb	655242f8-bc15-4119-87c6-b9d242495178
c986eb84-abb6-4442-bee5-8de6f5d6c71c	1b47e0c0-668d-4020-959c-412c241fdd05
b9781f4d-1f73-4b9c-9386-d4e1c1703a1d	1b47e0c0-668d-4020-959c-412c241fdd05
b9781f4d-1f73-4b9c-9386-d4e1c1703a1d	4ee930b1-8b92-4b65-ab45-c069b2122c87
2e74cdb7-a64c-4ddc-b80b-762751a78e92	4ee930b1-8b92-4b65-ab45-c069b2122c87
73243003-8057-4c01-9686-829106fdfeaf	4ee930b1-8b92-4b65-ab45-c069b2122c87
05609404-8455-4aa4-bf4a-0dab4444da1d	4ee930b1-8b92-4b65-ab45-c069b2122c87
7da31553-bdc7-4aad-b425-f70d1f5bbccb	4ee930b1-8b92-4b65-ab45-c069b2122c87
5edb82e7-0493-489a-99d0-c69800603a45	4ee930b1-8b92-4b65-ab45-c069b2122c87
9e99c727-da71-406f-be24-c1aee990b0df	4ee930b1-8b92-4b65-ab45-c069b2122c87
07c61deb-f62e-43d0-90ab-8b0b7d2c4f3c	4ee930b1-8b92-4b65-ab45-c069b2122c87
dc032b67-388c-4d2a-8368-4a12e9806c3f	4ee930b1-8b92-4b65-ab45-c069b2122c87
99465dfc-b1fc-4c51-a7d6-3df5a35dd3b3	4ee930b1-8b92-4b65-ab45-c069b2122c87
9e3fb3e5-2504-4f73-86b1-73a077678740	4ee930b1-8b92-4b65-ab45-c069b2122c87
69939b1a-59ef-42e0-88d4-52d40fa49167	4ee930b1-8b92-4b65-ab45-c069b2122c87
b4b13c66-4bec-4f26-8d62-7ac7cce29260	4ee930b1-8b92-4b65-ab45-c069b2122c87
1d3063ad-7fa2-4715-8da0-4452990c84c5	4ee930b1-8b92-4b65-ab45-c069b2122c87
f2d3f2f8-b453-40ab-ac68-700313e0818a	4ee930b1-8b92-4b65-ab45-c069b2122c87
50aa8776-b226-4f8e-95c0-f097edc3105a	4ee930b1-8b92-4b65-ab45-c069b2122c87
0b18b669-5c09-49e2-9f40-30fb7295d822	4ee930b1-8b92-4b65-ab45-c069b2122c87
b0a3d6ce-ab84-4026-bbbf-33bd83c3b3b5	4ee930b1-8b92-4b65-ab45-c069b2122c87
cee750b6-7bb5-4f07-a882-1facca4099d4	4ee930b1-8b92-4b65-ab45-c069b2122c87
bb9d4102-8f1b-4a6a-8ad3-eb0d623db75e	4ee930b1-8b92-4b65-ab45-c069b2122c87
32563e37-878f-4cac-8f2a-6290e5e83154	4ee930b1-8b92-4b65-ab45-c069b2122c87
936aa81e-00f9-4b41-9114-4977932d7857	4ee930b1-8b92-4b65-ab45-c069b2122c87
9c53af67-8227-46bc-b3e1-b06fa9ef1cc9	4ee930b1-8b92-4b65-ab45-c069b2122c87
6521fc9c-5cfd-482d-9f51-7c1bdd1e9afc	4ee930b1-8b92-4b65-ab45-c069b2122c87
f0811660-df00-475f-af67-d5f64fea0818	4ee930b1-8b92-4b65-ab45-c069b2122c87
1ce87057-a8cb-4ccc-9790-662eca5855f1	4ee930b1-8b92-4b65-ab45-c069b2122c87
a18d4170-eb19-4b02-b402-e66c6884cfbb	4ee930b1-8b92-4b65-ab45-c069b2122c87
a4487379-937e-450e-8e76-2e2b05d60067	4ee930b1-8b92-4b65-ab45-c069b2122c87
082b57f5-48cb-4aba-9dd1-ac0f0c0e0df6	4ee930b1-8b92-4b65-ab45-c069b2122c87
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.web_origins (client_id, value) FROM stdin;
edd1bb01-6648-440a-aa92-b1c51b766aad	+
07a8e7af-80f6-4672-abef-5786c95e7867	+
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	*
dd1c588b-e8d2-4eb6-91ba-b74964d31b4a	+
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	*
05cccd8c-0c4b-400c-a7fd-f40a42b9f60b	+
8ab49cf2-6f70-438e-81a3-6b679dd04c7f	+
9cbf04e8-c1d5-41cd-b02c-444c87f1a78d	+
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_css_preload; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_offline_css_preload ON public.offline_client_session USING btree (client_id, offline_flag);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_offline_uss_by_usersess; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_offline_uss_by_usersess ON public.offline_user_session USING btree (realm_id, offline_flag, user_session_id);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_offline_uss_preload; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_offline_uss_preload ON public.offline_user_session USING btree (offline_flag, created_on, user_session_id);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

