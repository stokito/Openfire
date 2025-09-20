CREATE TABLE ofUser (
  username              NVARCHAR(64)    NOT NULL,
  storedKey             VARCHAR(32),
  serverKey             VARCHAR(32),
  salt                  VARCHAR(32),
  iterations            INTEGER,
  plainPassword         NVARCHAR(32),
  encryptedPassword     NVARCHAR(255),
  name                  NVARCHAR(100),
  email                 VARCHAR(100),
  creationDate          CHAR(15)        NOT NULL,
  modificationDate      CHAR(15)        NOT NULL,
  CONSTRAINT ofUser_pk PRIMARY KEY (username)
);
CREATE INDEX ofUser_cDate_idx ON ofUser (creationDate ASC);


CREATE TABLE ofUserProp (
  username              NVARCHAR(64)    NOT NULL,
  name                  NVARCHAR(100)   NOT NULL,
  propValue             TEXT            NOT NULL,
  CONSTRAINT ofUserProp_pk PRIMARY KEY (username, name)
);


CREATE TABLE ofUserFlag (
  username              NVARCHAR(64)    NOT NULL,
  name                  NVARCHAR(100)   NOT NULL,
  startTime             CHAR(15),
  endTime               CHAR(15),
  CONSTRAINT ofUserFlag_pk PRIMARY KEY (username, name)
);
CREATE INDEX ofUserFlag_sTime_idx ON ofUserFlag (startTime ASC);
CREATE INDEX ofUserFlag_eTime_idx ON ofUserFlag (endTime ASC);


CREATE TABLE ofOffline (
  username              NVARCHAR(64)    NOT NULL,
  messageID             BIGINT          NOT NULL,
  creationDate          CHAR(15)        NOT NULL,
  messageSize           INTEGER         NOT NULL,
  stanza                TEXT            NOT NULL,
  CONSTRAINT ofOffline_pk PRIMARY KEY (username, messageID)
);


CREATE TABLE ofPresence (
  username              NVARCHAR(64)    NOT NULL,
  offlinePresence       TEXT,
  offlineDate           CHAR(15)        NOT NULL,
  CONSTRAINT ofPresence_pk PRIMARY KEY (username)
);


CREATE TABLE ofRoster (
  rosterID              BIGINT          NOT NULL,
  username              NVARCHAR(64)    NOT NULL,
  jid                   NVARCHAR(1024)   NOT NULL,
  sub                   INTEGER         NOT NULL,
  ask                   INTEGER         NOT NULL,
  recv                  INTEGER         NOT NULL,
  nick                  NVARCHAR(255),
  stanza                TEXT,
  CONSTRAINT ofRoster_pk PRIMARY KEY (rosterID)
);
CREATE INDEX ofRoster_username_idx ON ofRoster (username ASC);
CREATE INDEX ofRoster_jid_idx ON ofRoster (jid ASC);


CREATE TABLE ofRosterGroups (
  rosterID              BIGINT          NOT NULL,
  rank                  INTEGER         NOT NULL,
  groupName             NVARCHAR(255)   NOT NULL,
  CONSTRAINT ofRosterGroups_pk PRIMARY KEY (rosterID, rank)
);
CREATE INDEX ofRosterGroups_rosterid_idx ON ofRosterGroups (rosterID ASC);
ALTER TABLE ofRosterGroups ADD CONSTRAINT ofRosterGroups_rosterID_fk FOREIGN KEY (rosterID) REFERENCES ofRoster;


CREATE TABLE ofVCard (
  username              NVARCHAR(64)    NOT NULL,
  vcard                 TEXT            NOT NULL,
  CONSTRAINT ofVCard_pk PRIMARY KEY (username)
);


CREATE TABLE ofGroup (
  groupName             NVARCHAR(50)   NOT NULL,
  description           NVARCHAR(255),
  CONSTRAINT ofGroup_pk PRIMARY KEY (groupName)
);


CREATE TABLE ofGroupProp (
   groupName            NVARCHAR(50)   NOT NULL,
   name                 NVARCHAR(100)  NOT NULL,
   propValue            TEXT           NOT NULL,
   CONSTRAINT ofGroupProp_pk PRIMARY KEY (groupName, name)
);


CREATE TABLE ofGroupUser (
  groupName             NVARCHAR(50)    NOT NULL,
  username              NVARCHAR(100)   NOT NULL,
  administrator         INTEGER         NOT NULL,
  CONSTRAINT ofGroupUser_pk PRIMARY KEY (groupName, username, administrator)
);


CREATE TABLE ofID (
  idType                INTEGER         NOT NULL,
  id                    BIGINT          NOT NULL,
  CONSTRAINT ofID_pk PRIMARY KEY (idType)
);


CREATE TABLE ofProperty (
  name         NVARCHAR(100) NOT NULL,
  propValue    TEXT NOT NULL,
  encrypted    INTEGER,
  iv           CHAR(24),
  CONSTRAINT ofProperty_pk PRIMARY KEY (name)
);


CREATE TABLE ofVersion (
  name     NVARCHAR(50) NOT NULL,
  version  INTEGER  NOT NULL,
  CONSTRAINT ofVersion_pk PRIMARY KEY (name)
);

CREATE TABLE ofExtComponentConf (
  subdomain             NVARCHAR(255)    NOT NULL,
  wildcard              INTEGER          NOT NULL,
  secret                NVARCHAR(255),
  permission            NVARCHAR(10)     NOT NULL,
  CONSTRAINT ofExtComponentConf_pk PRIMARY KEY (subdomain)
);

CREATE TABLE ofRemoteServerConf (
  xmppDomain            NVARCHAR(255)    NOT NULL,
  remotePort            INTEGER,
  permission            NVARCHAR(10)     NOT NULL,
  CONSTRAINT ofRemoteServerConf_pk PRIMARY KEY (xmppDomain)
);

CREATE TABLE ofPrivacyList (
  username              NVARCHAR(64)    NOT NULL,
  name                  NVARCHAR(100)   NOT NULL,
  isDefault             INTEGER         NOT NULL,
  list                  TEXT            NOT NULL,
  CONSTRAINT ofPrivacyList_pk PRIMARY KEY (username, name)
);
CREATE INDEX ofPrivacyList_default_idx ON ofPrivacyList (username, isDefault);

CREATE TABLE ofSecurityAuditLog (
  msgID                 BIGINT          NOT NULL,
  username              NVARCHAR(64)    NOT NULL,
  entryStamp            BIGINT         NOT NULL,
  summary               NVARCHAR(255)   NOT NULL,
  node                  NVARCHAR(255)   NOT NULL,
  details               TEXT,
  CONSTRAINT ofSecurityAuditLog_pk PRIMARY KEY (msgID)
);
CREATE INDEX ofSecurityAuditLog_tstamp_idx ON ofSecurityAuditLog (entryStamp);
CREATE INDEX ofSecurityAuditLog_uname_idx ON ofSecurityAuditLog (username);

-- MUC tables

CREATE TABLE ofMucService (
  serviceID           BIGINT        NOT NULL,
  subdomain           NVARCHAR(255) NOT NULL,
  description         NVARCHAR(255),
  isHidden            INTEGER       NOT NULL,
  CONSTRAINT ofMucService_pk PRIMARY KEY (subdomain)
);
CREATE INDEX ofMucService_serviceid_idx ON ofMucService(serviceID);

CREATE TABLE ofMucServiceProp (
  serviceID           BIGINT        NOT NULL,
  name                NVARCHAR(100) NOT NULL,
  propValue           TEXT          NOT NULL,
  CONSTRAINT ofMucServiceProp_pk PRIMARY KEY (serviceID, name)
);

CREATE TABLE ofMucRoom (
  serviceID           BIGINT        NOT NULL,
  roomID              BIGINT        NOT NULL,
  creationDate        CHAR(15)      NOT NULL,
  modificationDate    CHAR(15)      NOT NULL,
  name                NVARCHAR(50)  NOT NULL,
  naturalName         NVARCHAR(255) NOT NULL,
  description         NVARCHAR(255),
  lockedDate          CHAR(15)      NOT NULL,
  emptyDate           CHAR(15),
  canChangeSubject    INTEGER       NOT NULL,
  maxUsers            INTEGER       NOT NULL,
  publicRoom          INTEGER       NOT NULL,
  moderated           INTEGER       NOT NULL,
  membersOnly         INTEGER       NOT NULL,
  canInvite           INTEGER       NOT NULL,
  roomPassword        NVARCHAR(50),
  canDiscoverJID      INTEGER       NOT NULL,
  logEnabled          INTEGER       NOT NULL,
  retireOnDeletion    INTEGER       NOT NULL,
  preserveHistOnDel   INTEGER       NOT NULL,
  subject             NVARCHAR(100),
  rolesToBroadcast    INTEGER       NOT NULL,
  useReservedNick     INTEGER       NOT NULL,
  canChangeNick       INTEGER       NOT NULL,
  canRegister         INTEGER       NOT NULL,
  allowpm             INTEGER,
  fmucEnabled         INTEGER,
  fmucOutboundNode    NVARCHAR(255),
  fmucOutboundMode    INTEGER,
  fmucInboundNodes    NVARCHAR(2000),
  CONSTRAINT ofMucRoom_pk PRIMARY KEY (serviceID, name)
);
CREATE INDEX ofMucRoom_roomid_idx ON ofMucRoom(roomID);
CREATE INDEX ofMucRoom_serviceid_idx ON ofMucRoom(serviceID);

CREATE TABLE ofMucRoomProp (
  roomID                BIGINT          NOT NULL,
  name                  NVARCHAR(100)   NOT NULL,
  propValue             TEXT            NOT NULL,
  CONSTRAINT ofMucRoomProp_pk PRIMARY KEY (roomID, name)
);

CREATE TABLE ofMucRoomRetiree (
  serviceID           BIGINT        NOT NULL,
  name                NVARCHAR(50)  NOT NULL,
  alternateJID        NVARCHAR(2000),
  reason              NVARCHAR(1024),
  retiredAt           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT ofMucRoomRetiree_pk PRIMARY KEY (serviceID, name)
);

CREATE TABLE ofMucAffiliation (
  roomID              BIGINT         NOT NULL,
  jid                 VARCHAR(255)   NOT NULL,
  affiliation         INTEGER        NOT NULL,
  CONSTRAINT ofMucAffiliation_pk PRIMARY KEY (roomID,jid)
);

CREATE TABLE ofMucMember (
  roomID              BIGINT         NOT NULL,
  jid                 NVARCHAR(255)  NOT NULL,
  nickname            NVARCHAR(255),
  firstName           NVARCHAR(100),
  lastName            NVARCHAR(100),
  url                 NVARCHAR(100),
  email               NVARCHAR(100),
  faqentry            NVARCHAR(100),
  CONSTRAINT ofMucMember_pk PRIMARY KEY (roomID,jid)
);

CREATE TABLE ofMucConversationLog (
  roomID              BIGINT         NOT NULL,
  messageID           BIGINT         NOT NULL,
  sender              TEXT           NOT NULL,
  nickname            NVARCHAR(255),
  logTime             CHAR(15)       NOT NULL,
  subject             NVARCHAR(255),
  body                TEXT,
  stanza                TEXT
);
CREATE INDEX ofMucConversationLog_roomtime_idx ON ofMucConversationLog (roomID, logTime);
CREATE INDEX ofMucConversationLog_time_idx ON ofMucConversationLog (logTime);
CREATE INDEX ofMucConversationLog_msg_id ON ofMucConversationLog (messageID);


-- PubSub Tables

CREATE TABLE ofPubsubNode (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  leaf                INTEGER        NOT NULL,
  creationDate        CHAR(15)       NOT NULL,
  modificationDate    CHAR(15)       NOT NULL,
  parent              NVARCHAR(100),
  deliverPayloads     INTEGER        NOT NULL,
  maxPayloadSize      INTEGER,
  persistItems        INTEGER,
  maxItems            INTEGER,
  notifyConfigChanges INTEGER        NOT NULL,
  notifyDelete        INTEGER        NOT NULL,
  notifyRetract       INTEGER        NOT NULL,
  presenceBased       INTEGER        NOT NULL,
  sendItemSubscribe   INTEGER        NOT NULL,
  publisherModel      NVARCHAR(15)   NOT NULL,
  subscriptionEnabled INTEGER        NOT NULL,
  configSubscription  INTEGER        NOT NULL,
  accessModel         NVARCHAR(10)   NOT NULL,
  payloadType         NVARCHAR(100),
  bodyXSLT            NVARCHAR(100),
  dataformXSLT        NVARCHAR(100),
  creator             NVARCHAR(1024) NOT NULL,
  description         NVARCHAR(255),
  language            NVARCHAR(255),
  name                NVARCHAR(50),
  replyPolicy         NVARCHAR(15),
  associationPolicy   NVARCHAR(15),
  maxLeafNodes        INTEGER,
  CONSTRAINT ofPubsubNode_pk PRIMARY KEY (serviceID, nodeID)
);

CREATE TABLE ofPubsubNodeJIDs (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  jid                 NVARCHAR(1024) NOT NULL,
  associationType     NVARCHAR(20)   NOT NULL,
  CONSTRAINT ofPubsubNodeJIDs_pk PRIMARY KEY (serviceID, nodeID, jid)
);

CREATE TABLE ofPubsubNodeGroups (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  rosterGroup         NVARCHAR(100)  NOT NULL
);
CREATE INDEX ofPubsubNodeGroups_idx ON ofPubsubNodeGroups (serviceID, nodeID);

CREATE TABLE ofPubsubAffiliation (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  jid                 NVARCHAR(1024) NOT NULL,
  affiliation         NVARCHAR(10)   NOT NULL,
  CONSTRAINT ofPubsubAffiliation_pk PRIMARY KEY (serviceID, nodeID, jid)
);

CREATE TABLE ofPubsubItem (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  id                  NVARCHAR(100)  NOT NULL,
  jid                 NVARCHAR(1024) NOT NULL,
  creationDate        CHAR(15)       NOT NULL,
  payload             TEXT,
  CONSTRAINT ofPubsubItem_pk PRIMARY KEY (serviceID, nodeID, id)
);

CREATE TABLE ofPubsubSubscription (
  serviceID           NVARCHAR(100)  NOT NULL,
  nodeID              NVARCHAR(100)  NOT NULL,
  id                  NVARCHAR(100)  NOT NULL,
  jid                 NVARCHAR(1024) NOT NULL,
  owner               NVARCHAR(1024) NOT NULL,
  state               NVARCHAR(15)   NOT NULL,
  deliver             INTEGER        NOT NULL,
  digest              INTEGER        NOT NULL,
  digest_frequency    INTEGER        NOT NULL,
  expire              CHAR(15),
  includeBody         INTEGER        NOT NULL,
  showValues          NVARCHAR(30)   NOT NULL,
  subscriptionType    NVARCHAR(10)   NOT NULL,
  subscriptionDepth   INTEGER        NOT NULL,
  keyword             NVARCHAR(200),
  CONSTRAINT ofPubsubSubscription_pk PRIMARY KEY (serviceID, nodeID, id)
);

CREATE TABLE ofPubsubDefaultConf (
  serviceID           NVARCHAR(100) NOT NULL,
  leaf                INTEGER       NOT NULL,
  deliverPayloads     INTEGER       NOT NULL,
  maxPayloadSize      INTEGER       NOT NULL,
  persistItems        INTEGER       NOT NULL,
  maxItems            INTEGER       NOT NULL,
  notifyConfigChanges INTEGER       NOT NULL,
  notifyDelete        INTEGER       NOT NULL,
  notifyRetract       INTEGER       NOT NULL,
  presenceBased       INTEGER       NOT NULL,
  sendItemSubscribe   INTEGER       NOT NULL,
  publisherModel      NVARCHAR(15)  NOT NULL,
  subscriptionEnabled INTEGER       NOT NULL,
  accessModel         NVARCHAR(10)  NOT NULL,
  language            NVARCHAR(255),
  replyPolicy         NVARCHAR(15),
  associationPolicy   NVARCHAR(15)  NOT NULL,
  maxLeafNodes        INTEGER       NOT NULL,
  CONSTRAINT ofPubsubDefaultConf_pk PRIMARY KEY (serviceID, leaf)
);

-- Finally, insert default table values
INSERT INTO ofID (idType, id) VALUES (18, 1);
INSERT INTO ofID (idType, id) VALUES (19, 1);
INSERT INTO ofID (idType, id) VALUES (23, 1);
INSERT INTO ofID (idType, id) VALUES (26, 2);
INSERT INTO ofID (idType, id) VALUES (27, 1);

-- Entry for admin user
INSERT INTO ofUser (username, plainPassword, name, email, creationDate, modificationDate)
    VALUES ('admin', 'admin', 'Administrator', 'admin@example.com', '0', '0');

-- Entry for default conference service
INSERT INTO ofMucService (serviceID, subdomain, isHidden) VALUES (1, 'conference', 0);

-- Do this last, as it is used by a continuous integration check to verify that the entire script was executed successfully.
INSERT INTO ofVersion (name, version) VALUES ('openfire', 37);
