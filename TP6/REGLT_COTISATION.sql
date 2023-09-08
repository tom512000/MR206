DROP TABLE REGLT_COTISATION CASCADE CONSTRAINTS;

-- a) Création de la table REGLT_COTISATION
/*==============================================================*/
/* Table : REGLT_COTISATION                                     */
/*==============================================================*/
CREATE TABLE REGLT_COTISATION 
(
   cdMemb             CHAR(5)               NOT NULL                     ,
   dateRegltCot       DATE                  NOT NULL                     ,
   mntRegle           INT                   NOT NULL CHECK (mntRegle > 0),
   CONSTRAINT PK_CDMEMB_DATEREGLTCOT PRIMARY KEY (cdMemb, dateRegltCot),
   CONSTRAINT FK_CDMEMB FOREIGN KEY (cdMemb)
    REFERENCES MEMBRE(cdMemb)
);

-- b) Tester les contraintes en insérant des enregistrements erronés :
-- cdMemb inexistant (M000 par exemple)
--INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M000', TO_DATE('2023-01-01', 'DD/MM/YYYY'), 50);
-- Date de règlement nulle
--INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M001', NULL, 50);
-- MontRégle nul ou négatif
--INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M002', TO_DATE('2023-01-01', 'DD/MM/YYYY'), 0);
--INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M003', TO_DATE('2023-01-01', 'DD/MM/YYYY'), -50);

-- c) Insérer (en utilisant des requêtes INSERT) dans la table REGLT_COTISATION des règlements
INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M012', TO_DATE('25/01/2019', 'DD/MM/YYYY'), 40);
INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M020', TO_DATE('30/01/2019 ', 'DD/MM/YYYY'), 20);
INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M005', TO_DATE('30/01/2019 ', 'DD/MM/YYYY'), 20);
INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M006', TO_DATE('30/01/2019 ', 'DD/MM/YYYY'), 50);
INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M012', TO_DATE(SYSDATE, 'DD/MM/YYYY'), 50);
INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M020', TO_DATE(SYSDATE, 'DD/MM/YYYY'), 60);
INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M005', TO_DATE('12/02/2019', 'DD/MM/YYYY'), 60);
-- INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M005', TO_DATE('12/02/2019', 'DD/MM/YYYY'), 20);
INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M011', TRUNC(SYSDATE)-1, 50);
INSERT INTO REGLT_COTISATION (cdMemb, dateRegltCot, mntRegle) VALUES ('M020', TRUNC(SYSDATE)-7, 20);


-- d) Afficher le nom et le prénom des membres ainsi que le montant total déjà payé par les membres (5 lignes à afficher car 5 membres ont payé).
SELECT nom||' '||prnm "MEMBRE",
    SUM(mntRegle)||' €' "Mnt Total"
FROM REGLT_COTISATION r, MEMBRE m
WHERE r.cdMemb = m.cdMemb
GROUP BY nom, prnm;

-- e) Afficher le montant total payé uniquement par les membres habitant la ville de REIMS. On affichera également les habitants qui n’ont encore rien payé comme ci-dessous (6 lignes à afficher). Tri sur le nom des membres.
SELECT nom||' '||prnm "MEMBRE",
    NVL2(SUM(mntRegle), SUM(mntRegle)||' €', 'Rien Payé') "Mnt Total"
FROM REGLT_COTISATION r, MEMBRE m
WHERE r.cdMemb(+) = m.cdMemb
AND UPPER(ville) = 'REIMS'
GROUP BY nom, prnm
ORDER BY nom;

-- f) Afficher le nom et le prénom du membre ayant payé le montant total le plus important.
SELECT nom||' '||prnm "MEMBRE",
    SUM(mntRegle)||' €' "Mnt Total"
FROM REGLT_COTISATION r, MEMBRE m
WHERE r.cdMemb = m.cdMemb
GROUP BY nom, prnm
HAVING SUM(mntRegle) = (SELECT MAX(SUM(mntRegle))
                    FROM REGLT_COTISATION
                    GROUP BY cdMemb);

-- g) Ajouter 10 Euros à tous les montants payés aujourd’hui. Vérifier (2 lignes mises à jour).
UPDATE REGLT_COTISATION
SET mntRegle = mntRegle + 10
WHERE dateregltcot = TO_DATE(SYSDATE, 'DD/MM/YYYY');

-- h) Supprimer tous les règlements des habitants de REIMS. Vérifier (3 lignes supprimées). Valider les modifications.
DELETE FROM REGLT_COTISATION
WHERE cdmemb IN (SELECT cdmemb
                FROM MEMBRE
                WHERE UPPER(ville) = 'REIMS');

COMMIT;