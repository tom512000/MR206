DROP TABLE COMPETITION CASCADE CONSTRAINTS;

-- a) Création de la table COMPETITION
/*==============================================================*/
/* Table : COMPETITION                                          */
/*==============================================================*/
CREATE TABLE COMPETITION 
(
   cdCompet           CHAR(5)               NOT NULL       ,
   libCompet          VARCHAR2(50)          NOT NULL       ,
   dateCompet         DATE                  DEFAULT SYSDATE,
   parcours           NUMBER                               
   CONSTRAINT CKC_PARCOURS CHECK (parcours in (1,2))       ,
   indmax             NUMBER                               
   CONSTRAINT CKC_INDMAX CHECK (indmax BETWEEN 0 AND 36)   ,
   droitsInsc         NUMBER(8,2)                          ,
   CONSTRAINT PK_COMPETITIONS2 PRIMARY KEY (cdCompet)
);

-- b) Requêtes d’insertion
INSERT INTO COMPETITION VALUES ('TE01', 'Compet 1', TO_DATE('03/04/2019', 'DD/MM/YYYY'), 1, 13, 17);
INSERT INTO COMPETITION VALUES ('TE02', 'Compet 2', TO_DATE('05/04/2019', 'DD/MM/YYYY'), 2, 15, 18);
INSERT INTO COMPETITION VALUES ('TE03', 'Compet 3', TO_DATE('10/04/2019', 'DD/MM/YYYY'), 2, 24, 25);
INSERT INTO COMPETITION VALUES ('TE04', 'Compet 4', NULL, 2, 25, 25);
INSERT INTO COMPETITION (cdCompet, libCompet, parcours, indmax, droitSinsc) VALUES ('TE05', 'Compet 5',  1, 13, 17);

-- c) Requête d’insertion
INSERT INTO COMPETITION (cdCompet, libCompet, dateCompet, parcours, indmax, droitSinsc)
SELECT code_Compet, lib_Compet, date_Compet, parcours, ind_max, droits_insc
FROM GOLF.COMPETITION;

-- d) Requête de suppression
DELETE FROM COMPETITION
WHERE cdCompet LIKE 'TE%';

-- e) Requête de modification
UPDATE COMPETITION
SET droitSinsc = droitSinsc*1.1
WHERE parcours = 2;

