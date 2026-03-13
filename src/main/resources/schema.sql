CREATE SCHEMA IF NOT EXISTS securecapita;

SET NAMES 'UTF8MB4';
SET TIME_ZONE = '+2:00'; -- Cairo, Egypt +2 timezone for the current time stamp

USE securecapita;

-- Drop children first (those that reference others)
DROP TABLE IF EXISTS UserEvents;
DROP TABLE IF EXISTS Verifications;
DROP TABLE IF EXISTS UserRoles;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users
(
    user_id         BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100) NOT NULL,
    password        VARCHAR(255) DEFAULT NULL,
    phone           VARCHAR(20) DEFAULT NULL,
    address         VARCHAR(255) DEFAULT NULL,
    title           VARCHAR(50) DEFAULT NULL,
    bio             VARCHAR(255) DEFAULT NULL,
    enabled         BOOLEAN DEFAULT FALSE,
    non_locked      BOOLEAN DEFAULT TRUE,
    using_mfa       BOOLEAN DEFAULT FALSE,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    image_url       VARCHAR(255) DEFAULT 'https://cdn-icons-png.flaticon.com/512/3135/3135768.png',
    CONSTRAINT UQ_Users_Email UNIQUE (email)
);

CREATE TABLE Roles
(
    role_id             BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name                VARCHAR(50) NOT NULL,
    permission          VARCHAR(255) NOT NULL, -- permissions will be comma seperated string
    CONSTRAINT UQ_Roles_Name UNIQUE (name)
);

CREATE TABLE UserRoles
(
    user_role_id                BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_id                     BIGINT UNSIGNED NOT NULL,
    role_id                     BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    -- a user cannot be roleless so cannot delete a role when it references users
    FOREIGN KEY (role_id) REFERENCES Roles (role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT UQ_UserRoles_User_Id UNIQUE (user_id) -- user can have only one role
);

CREATE TABLE Events
(
    event_id                BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    type                    VARCHAR(50) NOT NULL CHECK ( type IN ('LOGIN_ATTEMPT', 'LOGIN_ATTEMPT_FAILURE', 'LOGIN_ATTEMPT_SUCCESS', 'PROFILE_PICTURE_UPDATE', 'ROLE_UPDATE', 'ACCOUNT_SETTING_UPDATE', 'PASSWORD_UPDATE', 'MFA_UPDATE') ),
    description             VARCHAR(255) NOT NULL,
    CONSTRAINT UQ_Events_Type UNIQUE (type)
);

CREATE TABLE UserEvents
(
    user_event_id                   BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_id                         BIGINT UNSIGNED NOT NULL,
    event_id                        BIGINT UNSIGNED NOT NULL,
    ip_address                      VARCHAR(100) DEFAULT NULL ,
    device                          VARCHAR(100) DEFAULT NULL ,
    browser                         VARCHAR(100) DEFAULT NULL ,
    created_at                      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Events (event_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Verifications -- as long as an entry exist for a user this mean his account is not enabled
(
    verification_id                 BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    user_id                         BIGINT UNSIGNED NOT NULL,
    url                             VARCHAR(255) NOT NULL , -- will also be used for code confirmation for 2fa
    expiry_date                     DATETIME NOT NULL ,
    type                            VARCHAR(100) NOT NULL CHECK ( type IN ( 'ACCOUNT_VERIFICATION' , 'PASSWORD_RESET' , '2FA')) ,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_Verifications_User_Id UNIQUE (user_id), -- user can only have one link
    CONSTRAINT UQ_Verifications_Url UNIQUE (url)
);













