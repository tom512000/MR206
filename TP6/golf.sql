/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 11g                            */
/* Date de création :  04/03/2023 09:39:06                      */
/*==============================================================*/

/* Suppression des éventuelles tables avant création */
drop table MEMBRE cascade constraints;
drop table MONITEUR cascade constraints;
drop table STAGE cascade constraints;
drop table STAGE_ETALE cascade constraints;
drop table STAGE_GROUPE cascade constraints;

/*==============================================================*/
/* Table : MONITEUR                                             */
/*==============================================================*/
create table MONITEUR 
(
   cdMono             CHAR(5)     ,
   nom                VARCHAR2(15),
   prnm               VARCHAR2(15),
   adr                VARCHAR2(30),
   ville              VARCHAR2(30),
   CP                 CHAR(5),
   responsable        CHAR(5),
   statut             CHAR(1)              not null
      constraint CKC_STATUT check (statut in ('1','2')),
   ind             INTEGER              not null
      constraint CKC_IND_MONITEUR check (ind between 0 and 5),
   constraint PK_MONITEUR primary key (cdMono)
);

/*==============================================================*/
/* Table : STAGE                                                */
/*==============================================================*/
create table STAGE 
(
   cdStage            CHAR(5)              not null,
   cdTpStage          CHAR(1)              not null,
   cdMono             CHAR(5)              not null,
   dateDeb            DATE,
   hDeb               INTEGER,
   tarifStage         NUMBER(8,2),
   constraint PK_STAGE primary key (cdStage),
   constraint FK_STAGE_CORRESPON_TYPESTAG foreign key (cdTpStage)
         references TYPESTAGE (cdTpStage),
   constraint FK_STAGE_ANIMER__D_MONITEUR foreign key (cdMono)
         references MONITEUR (cdMono)
);

/*==============================================================*/
/* Table : MEMBRE                                               */
/*==============================================================*/
create table MEMBRE 
(
   cdMemb             CHAR(5)              not null,
   nom                VARCHAR2(15),
   prnm               VARCHAR2(15),
   adr                VARCHAR2(30),
   ville              VARCHAR2(30),
   CP                   CHAR(5),
   tpMemb             CHAR(1)              not null
      constraint CKC_TPMEMB_MEMBRE check (tpMemb in ('1','2')),
   nbCourSuivis       INTEGER             
      constraint CKC_NBCOURSUIVIS_MEMBRE check (nbCourSuivis is null or (nbCourSuivis >= 0)),
   ind            INTEGER              not null
      constraint CKC_INDEX_MEMBRE check (ind between 0 and 36),
   constraint PK_MEMBRE primary key (cdMemb)
);


/*==============================================================*/
/* Table : STAGE_ETALE                                          */
/*==============================================================*/
create table STAGE_ETALE 
(
   cdStage            CHAR(5)              not null,
   nbH                INTEGER,
   nbSem              INTEGER,
   numJour            INTEGER,
   constraint PK_STAGE_ETALE primary key (cdStage),
   constraint FK_STAGE_ET_HERITAGE__STAGE foreign key (cdStage)
         references STAGE (cdStage)
);

/*==============================================================*/
/* Table : STAGE_GROUPE                                         */
/*==============================================================*/
create table STAGE_GROUPE 
(
   cdStage            CHAR(5)              not null,
   datefin           DATE,
   hFin              INTEGER,
   constraint PK_STAGE_GROUPE primary key (cdStage),
   constraint FK_STAGE_GR_HERITAGE__STAGE foreign key (cdStage)
         references STAGE (cdStage)
);

