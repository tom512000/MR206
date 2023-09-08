-- R1 : Liste des clients habitant une ville dont le nom ne commence pas par le mot « Reims », et ayant eu affaire à un employé de sexe féminin au cours d’un mois de septembre (peu importe l’année). Tri décroissant dur l’année de contrat, puis sur le nom du client.
SELECT E.NOM||' '||E.PRNM "Employé",
    TO_CHAR(Co.datCTR, 'YYYY') "Année Contrat",
    DECODE(Cl.CDSX, 'Monsieur', 'Madame')||' '||Cl.NOM||' '||Cl.PRNM "Client",
    Cl.LOCALITE "Localité"
FROM LOCVEC.EMPLOYE E, LOCVEC.CONTRAT Co, LOCVEC.CLIENT Cl
WHERE E.cdEmp = Co.cdEmp
AND Co.cdCli = Cl.cdCli
AND UPPER(Cl.LOCALITE) NOT LIKE 'REIMS%'
AND E.CDSX = '2'
AND TO_CHAR(Co.datCTR, 'MM') = '09'
ORDER BY 2 DESC, 3;

-- R2 : Liste des véhicules empruntés en septembre 2018 (datctr) par des clients aujourd’hui ayant plus de 10 ans de permis (datprms). Tri par marque puis par nom du client.
SELECT Cl.NOM||' '||Cl.PRNM "Client",
    M.MARQUE||' - '||M.TPMDL "Modèle",
    V.IMTRCL "Immatriculation"
FROM LOCVEC.CLIENT Cl, LOCVEC.CONTRAT Co, LOCVEC.VEHICULE V, LOCVEC.MODELE M
WHERE Cl.cdCli = Co.cdCli
AND Co.cdVhc = V.cdVhc
AND V.cdMdl = M.cdMdl
AND TO_CHAR(Co.datCTR, 'MM/YYYY') = '09/2018'
AND ROUND(MONTHS_BETWEEN(SYSDATE, datprms)/12) > 10;

-- R3 : Liste des véhicules du parc de location de la catégorie « standard », triés date de mise en circulation.
-- a) A faire d’abord en utilisant uniquement des jointures.
SELECT DISTINCT M.MARQUE||' - '||M.TPMDL "Modèle",
    V.IMTRCL "Immatriculation",
    TO_CHAR(V.datPMC, 'YYYY') "Année Mise en circulation"
FROM LOCVEC.VEHICULE V, LOCVEC.MODELE M, LOCVEC.CATEGORIE Ca
WHERE V.cdMdl = M.cdMdl
AND M.cdCtg = Ca.cdCtg
AND UPPER(Ca.intCtg) = 'STANDARD'
ORDER BY 3;

-- b) A faire ensuite en utilisant une sous-requête lorsque cela est possible.
SELECT DISTINCT M.MARQUE||' - '||M.TPMDL "Modèle",
    V.IMTRCL "Immatriculation",
    TO_CHAR(V.datPMC, 'YYYY') "Année Mise en circulation"
FROM LOCVEC.MODELE M, LOCVEC.VEHICULE V
WHERE V.cdMdl = M.cdMdl
AND M.cdCtg IN (SELECT cdCtg
                FROM LOCVEC.CATEGORIE
                WHERE UPPER(intCtg) = 'STANDARD')
ORDER BY 3;

-- R4 : Liste des clients âgés de 50 à 60 ans qui ont déjà souscrit un contrat de type forfaitaire (dont l’intitulé » du type de contrat contient le mot « FORFAITAIRE »).
-- a) A faire d’abord en utilisant uniquement des jointures.
SELECT DISTINCT Cl.NOM||' '||Cl.PRNM "Client",
    DECODE(SUBSTR(Cl.CP,1,2),'51','MARNE','AUTRE') "Département"
FROM LOCVEC.CLIENT Cl, LOCVEC.CONTRAT Co, LOCVEC.TYPECONTRAT Tp
WHERE Cl.cdCli = Co.cdCli
AND Co.cdTpCtr = Tp.cdTpCtr
AND ROUND(MONTHS_BETWEEN(SYSDATE, Cl.datns)/12) BETWEEN 50 AND 60
AND UPPER(Tp.intTpCtr) LIKE '%FORFAITAIRE%';

-- b) A faire ensuite en utilisant une sous-requête lorsque cela est possible.
SELECT DISTINCT Cl.NOM||' '||Cl.PRNM "Client",
    DECODE(SUBSTR(Cl.CP,1,2),'51','MARNE','AUTRE') "Département"
FROM LOCVEC.CLIENT Cl, LOCVEC.CONTRAT Co
WHERE Cl.cdCli = Co.cdCli
AND ROUND(MONTHS_BETWEEN(SYSDATE, Cl.datns)/12) BETWEEN 50 AND 60
AND cdTpCtr IN (SELECT cdTpCtr
                FROM LOCVEC.TYPECONTRAT Tp
                WHERE UPPER(Tp.intTpCtr) LIKE '%FORFAITAIRE%');

-- R5 : Liste des véhicules de marque OPEL, RENAULT ou PEUGEOT qui ont déjà été loués au moins une fois.
-- a) A faire d’abord en utilisant uniquement des jointures.
SELECT DISTINCT Ve.imtrcl "Immatriculation",
    ROUND(MONTHS_BETWEEN(SYSDATE, Ve.datPMC)/12)||' ans' "Ancienneté",
    Ve.kmActl "Kilométrage"
FROM LOCVEC.VEHICULE Ve, LOCVEC.MODELE Mo, LOCVEC.CONTRAT Co
WHERE Ve.cdMdl = Mo.cdMdl
AND Co.cdvhc = Ve.cdvhc
AND UPPER(Mo.marque) IN ('OPEL','RENAULT','PEUGEOT');

-- b) A faire ensuite en utilisant une sous-requête lorsque cela est possible.
SELECT Ve.imtrcl "Immatriculation",
    ROUND(MONTHS_BETWEEN(SYSDATE, Ve.datPMC)/12)||' ans' "Ancienneté",
    Ve.kmActl "Kilométrage"
FROM LOCVEC.VEHICULE Ve
WHERE Ve.cdmdl IN (SELECT Mo.cdmdl 
                FROM LOCVEC.modele Mo
                WHERE Mo.marque IN ('RENAULT','OPEL','PEUGEOT'))
AND Ve.cdvhc IN (SELECT Co.cdvhc 
              FROM LOCVEC.CONTRAT Co);

-- R6 : Liste de toutes les catégories de type utilitaire (tpvhc 2) avec leurs différents modèles. Afficher toutes les catégories même celles pour lesquelles il n’existe aucun modèle.
SELECT intctg "Catégorie",
	NVL2(Mo.marque,Mo.marque||' '||Mo.tpmdl,'Pas de modele') "Modèle"
FROM LOCVEC.CATEGORIE Ca, LOCVEC.MODELE Mo
WHERE  Ca.cdctg = Mo.cdctg(+)
AND Ca.tpvhc = 2;

-- R7 : Liste des clients pour lesquels on n’a enregistré aucun contrat.
-- a) En utilisant une jointure.
SELECT Cl.nom||' '||Cl.prnm "Client"
FROM LOCVEC.CLIENT Cl, LOCVEC.CONTRAT Co
WHERE Cl.cdcli = Co.cdcli(+)
AND Co.cdctr IS NULL;

-- b) En utilisant une sous-requête.
SELECT Cl.nom||' '||Cl.prnm "Client"
FROM LOCVEC.CLIENT Cl
WHERE Cl.cdCli NOT IN (SELECT Co.cdCli
                        FROM LOCVEC.CONTRAT Co);

-- R8 : Liste des modèles avec leur catégorie pour lesquels l’agence ne possède pas encore de véhicule.
-- a) Avec sous requête.
SELECT Mo.marque||' '||Mo.tpmdl "Modèle",
	Ca.intctg "Catégorie"
FROM LOCVEC.CATEGORIE Ca, LOCVEC.MODELE Mo
WHERE Ca.cdctg = Mo.cdctg
AND Mo.cdmdl NOT IN (SELECT Ve.cdmdl
                        FROM LOCVEC.VEHICULE Ve);

-- b) Avec jointure.
SELECT Mo.marque||' '||Mo.tpmdl "Modèle",
	Ca.intctg "Catégorie"
FROM LOCVEC.CATEGORIE Ca, LOCVEC.MODELE Mo, LOCVEC.VEHICULE Ve
WHERE Ca.cdctg = Mo.cdctg
AND Mo.cdmdl = Ve.cdmdl(+)
AND Ve.cdvhc IS NULL;

-- R9 : Liste des employés ayant un supérieur. Tri en majeur sur le nom du supérieur, en mineur sur l’identité de l’employé.
SELECT Em.nom||'-'||Em.prnm "Employé",
    Em.qualif "Qualif Employé",
    NVL2(Su.cdemp,Su.nom||'-'||Su.prnm,'**************') "Supérieur",
    NVL(Su.qualif, NVL2(Em.datdpt,'Ancien Employé','Directeur de l''agence')) "Qualif Supérieur"
FROM LOCVEC.EMPLOYE Em, LOCVEC.EMPLOYE Su
WHERE Em.cdsup = Su.cdemp
ORDER BY 3, 1;

-- R10 : Liste de tous les employés.
SELECT Em.nom||'-'||Em.prnm "Employé",
    Em.qualif "Qualif Employé",
    NVL2(Su.cdemp,Su.nom||'-'||Su.prnm,'**************') "Supérieur",
    NVL(Su.qualif, NVL2(Em.datdpt,'Ancien Employé','Directeur de l''agence')) "Qualif Supérieur"
FROM LOCVEC.EMPLOYE Em, LOCVEC.EMPLOYE Su
WHERE Em.cdsup = Su.cdemp(+)
ORDER BY 3, 1;
