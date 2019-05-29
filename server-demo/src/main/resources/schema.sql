drop table if exists oauth_client_details;
create table oauth_client_details (
  client_id VARCHAR(191) PRIMARY KEY,
  resource_ids VARCHAR(191),
  client_secret VARCHAR(191),
  scope VARCHAR(191),
  authorized_grant_types VARCHAR(191),
  web_server_redirect_uri VARCHAR(191),
  authorities VARCHAR(191),
  access_token_validity INTEGER,
  refresh_token_validity INTEGER,
  additional_information VARCHAR(191),
  autoapprove VARCHAR(191)
);

INSERT INTO `oauth_client_details` (
	`CLIENT_ID`, `RESOURCE_IDS`, `CLIENT_SECRET`, `SCOPE`, 
	`AUTHORIZED_GRANT_TYPES`, `WEB_SERVER_REDIRECT_URI`, 
	`AUTHORITIES`, `ACCESS_TOKEN_VALIDITY`, `REFRESH_TOKEN_VALIDITY`, 
	`ADDITIONAL_INFORMATION`, `AUTOAPPROVE`) VALUES (
	'ddish-oauth2-client', 'resource-server-rest-api', 
	'$2a$10$2w5ixN4WSmzU4tn1l8.5s.ugPmKybYRPv74BaRIg7TWgkaHr211vW', 
	'read,write', 'password,authorization_code,refresh_token,implicit', NULL, 
	'ROLE_USER', '10800', '2592000', NULL, NULL
);


create table if not exists oauth_client_token (
  token_id VARCHAR(191),
  token BLOB,
  authentication_id VARCHAR(191) PRIMARY KEY,
  user_name VARCHAR(191),
  client_id VARCHAR(191)
);

create table if not exists oauth_access_token (
  token_id VARCHAR(191),
  token BLOB,
  authentication_id VARCHAR(191) PRIMARY KEY,
  user_name VARCHAR(191),
  client_id VARCHAR(191),
  authentication BLOB,
  refresh_token VARCHAR(191)
);

create table if not exists oauth_refresh_token (
  token_id VARCHAR(191),
  token BLOB,
  authentication BLOB
);

create table if not exists oauth_code (
  code VARCHAR(191), authentication BLOB
);

create table if not exists oauth_approvals (
	userId VARCHAR(191),
	clientId VARCHAR(191),
	scope VARCHAR(191),
	status VARCHAR(10),
	expiresAt TIMESTAMP,
	lastModifiedAt TIMESTAMP
);

create table if not exists ClientDetails (
  appId VARCHAR(191) PRIMARY KEY,
  resourceIds VARCHAR(191),
  appSecret VARCHAR(191),
  scope VARCHAR(191),
  grantTypes VARCHAR(191),
  redirectUrl VARCHAR(191),
  authorities VARCHAR(191),
  access_token_validity INTEGER,
  refresh_token_validity INTEGER,
  additionalInformation VARCHAR(191),
  autoApproveScopes VARCHAR(191)
);