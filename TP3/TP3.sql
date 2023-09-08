-- R21 : Afficher, pour chaque localité de la MARNE (dont le code postal commence par 51), le nombre de contrats par type de contrat. Ne prendre en compte que les types de contrat dont l’intitulé contient le mot « forfait ».
SELECT Cl.CP "Code Postal",
    Cl.localite "Localité",
    Tp.intTpCtr "Type contrat",
    COUNT(Co.cdCtr) "Nb Contrats"
FROM LOCVEC.CLIENT Cl, LOCVEC.CONTRAT Co, LOCVEC.TYPECONTRAT Tp
WHERE Cl.cdCli = Co.cdCli
AND Co.cdTpCtr = Tp.cdTpCtr
AND Cl.CP LIKE '51%'
AND UPPER(Tp.inttpctr) LIKE '%FORFAIT%'
GROUP BY Cl.CP, Cl.localite, Tp.inttpctr
ORDER BY 2, 3;

-- R22 : Afficher le nombre de contrats pour chaque employé dont la qualification est « commercial ». Afficher tous les commerciaux même ceux qui n’ont établi aucun contrat.
SELECT Em.nom||' '||Em.prnm "Employé",
    COUNT(Co.cdCtr) "Nb Contrats"
FROM LOCVEC.EMPLOYE Em, LOCVEC.CONTRAT Co
WHERE Em.cdEmp = Co.cdEmp(+)
AND UPPER(Em.qualif) = 'COMMERCIAL'
GROUP BY Em.cdEmp, Em.nom, Em.prnm;

-- R23 : Afficher pour chaque modèle (Marque-Type) correspondant à au moins deux véhicules, le nombre de véhicules et le nombre moyen du kilométrage actuel des véhicules correspondants.
SELECT Ca.intCtg "Catégorie",
    Mo.marque||'-'||Mo.tpMdl "Modèle",
    COUNT(Ve.cdVhc) "Nb Véhicules",
    ROUND(AVG(Ve.kmActl)) "Nb moyen de km"
FROM LOCVEC.CATEGORIE Ca, LOCVEC.MODELE Mo, LOCVEC.VEHICULE Ve
WHERE Ca.cdCtg = Mo.cdCtg
AND Mo.cdMdl = Ve.cdMdl
GROUP BY Ca.intCtg, Mo.marque, Mo.tpMdl
HAVING COUNT(Ve.cdVhc) > 1
ORDER BY 3 DESC;

-- R24 : Liste des véhicules de la catégorie MONOSPACE avec leur modèle (marque + tpMdl) pour lesquels plus de 1000 km sont parcourus en moyenne par contrat. Arrondir la moyenne à l’unité.
SELECT Mo.marque||'-'||Mo.tpMdl "Modèle",
    Ve.imtrcl "Immatriculation",
    AVG(Co.kmRtr - Co.kmDpt) "Nb Km Moyen"
FROM LOCVEC.CATEGORIE Ca, LOCVEC.MODELE Mo, LOCVEC.VEHICULE Ve, LOCVEC.CONTRAT Co
WHERE Ca.cdCtg = Mo.cdCtg
AND Mo.cdMdl = Ve.cdMdl
AND Ve.cdVhc = Co.cdVhc
AND UPPER(Ca.intCtg) = 'MONOSPACE'
GROUP BY Mo.marque, Mo.tpMdl, Ve.imtrcl
HAVING AVG(Co.kmRtr - Co.kmDpt) > 1000
ORDER BY 3 DESC;

-- R25 : Pour chaque véhicule des marques OPEL et RENAULT, afficher le nombre de contrats, le nombre de jours de location, la moyenne de jours de location par contrat, la somme des kilomètres parcourus, la moyenne des kilomètres parcourus par contrat.
SELECT Mo.marque||'-'||Mo.tpMdl "Modèle",
    Ve.imtrcl "Immatriculation",
    COUNT(Co.cdCtr) "Nb Contrats",
    SUM(Co.datRtr - Co.datDpt) "Nb Jours",
    ROUND(AVG(Co.datRtr - Co.datDpt)) "Moy. Jours",
    SUM(Co.kmRtr - Co.kmDpt) "Nb Km",
    ROUND(AVG(Co.kmRtr - Co.kmDpt)) "Moy. km"
FROM LOCVEC.MODELE Mo, LOCVEC.VEHICULE Ve, LOCVEC.CONTRAT Co
WHERE Mo.cdMdl = Ve.cdMdl
AND Ve.cdVhc = Co.cdVhc
AND UPPER(Mo.marque) IN ('OPEL','RENAULT')
GROUP BY Mo.marque, Mo.tpMdl, Ve.imtrcl
HAVING COUNT(Co.cdCtr) > 2 AND SUM(Co.datRtr - Co.datDpt) >= 10
ORDER BY 1;

-- R26 :
-- a. Afficher le nombre maximum de contrats pour un véhicule.
SELECT MAX(COUNT(Co.cdCtr)) "Nb. Max de Contrats"
FROM LOCVEC.CONTRAT Co
GROUP BY cdVhc;

-- b. Modèle (marque + tpMdl) et immatriculation du véhicule ayant le plus grand nombre de contrats.
SELECT Mo.marque ||'-'||Mo.tpMdl "Modèle",
    Ve.imtrcl "Immatriculation"
FROM LOCVEC.MODELE Mo, LOCVEC.VEHICULE Ve, LOCVEC.CONTRAT Co
WHERE Mo.cdMdl = Ve.cdMdl
AND Ve.cdVhc = Co.cdVhc
GROUP BY Mo.marque, Mo.tpMdl, Ve.imtrcl
HAVING COUNT(Co.cdCtr) = (SELECT MAX(COUNT(cdCtr))
                        FROM LOCVEC.CONTRAT
                        GROUP BY cdVhc);

-- R27 : Liste des clients ayant souscrit plus de contrats que la moyenne.
SELECT Cl.nom||'-'||Cl.prnm "Client",
    COUNT(Co.cdCtr) "Nb Contrats"
FROM LOCVEC.CONTRAT Co, LOCVEC.CLIENT Cl
WHERE Co.cdCli = Cl.cdCli
GROUP BY Cl.cdCli, Cl.nom, Cl.prnm
HAVING COUNT(Co.cdCtr) > (SELECT AVG(COUNT(cdCtr))
                        FROM LOCVEC.CONTRAT
                        GROUP BY cdcli);

-- R28 :
-- a. Afficher le nombre de catégories de type 1 (tpVhc).
SELECT COUNT(Ca.cddtg) "Nb. Catg"
FROM LOCVEC.CATEGORIE Ca
WHERE Ca.tpVhc = '1';

-- b. Nombre de catégories distinctes de type 1 par modèle. Tri par nb de catégories décroissante.
SELECT Mo.marque "Marque",
    COUNT(Ca.cdctg) "Nb. Catg"
FROM LOCVEC.CATEGORIE Ca, LOCVEC.MODELE Mo
WHERE Ca.cdCtg = Mo.cdCtg
AND Ca.tpVhc = '1'
GROUP BY Mo.marque
ORDER BY 2 DESC;

-- c.En utilisant les requêtes réalisées précédemment (a et b) afficher, la liste des marques ayant des modèles dans toutes les catégories de type 1 (tpVhc) : Autrement dit, les marques dont le nombre de catégories de type 1 est égal au nombre total de catégorie de type 1.
SELECT Mo.marque "Marque"
FROM LOCVEC.MODELE Mo, LOCVEC.CATEGORIE Ca
WHERE Mo.cdCtg = Ca.cdCtg
AND Ca.tpVhc = '1'
HAVING COUNT(Mo.cdCtg) = (SELECT COUNT(cdctg)
                        FROM LOCVEC.CATEGORIE
                        WHERE tpVhc = '1')
GROUP BY marque;

-- R29 : Liste des clients ayant des contrats de tous les types de contrat existant (division)
SELECT Cl.prnm||' '||Cl.nom "Client"
FROM LOCVEC.CLIENT Cl, LOCVEC.CONTRAT Co, LOCVEC.TYPECONTRAT Tc
WHERE Cl.cdCli = Co.cdCli
AND Co.cdTpCtr = Tc.cdTpCtr
GROUP BY prnm, nom
HAVING COUNT(intTpCtr) = (SELECT COUNT(intTpCtr)
                        FROM LOCVEC.TYPECONTRAT);