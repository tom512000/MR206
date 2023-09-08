-- R11 : Nombre d’employés, nombre d’employés partis, nombre d’employés présents (ceux qui n’ont pas quitté l’entreprise), nombre de titulaires (ceux qui ont été embauchés) et nombre de qualifications différentes.
SELECT COUNT(Em.cdemp) "Nb employés",
    COUNT(Em.datDpt) "Nb Partis",
    COUNT(Em.cdemp) - COUNT(Em.datDpt) "Nb présents", 
    COUNT(Em.datemb) "Nb Titulaires",
    COUNT(DISTINCT Em.qualif) "Nb qualifs"
FROM LOCVEC.EMPLOYE Em;

-- R12 : Donner la somme des salaires, le salaire moyen (arrondi à 2 décimales) et le salaire le plus élevé des employés titulaires.
SELECT SUM(Em.salaire) "Somme salaire",
    ROUND(AVG(Em.salaire),2) "Moyenne salaire",
    MAX(Em.salaire) "Salaire Max"
FROM LOCVEC.EMPLOYE Em
WHERE Em.datEmb IS NOT NULL;

-- R13 : Donner le salaire le plus élevé.
SELECT MAX(Em.salaire) "Salaire Maxi"
FROM LOCVEC.EMPLOYE Em;

-- R14 : Donner le nom de l’employé qui a le salaire le plus élevé.
SELECT Em.NOM||' - '||Em.PRNM "Employe le mieux payé",
    Em.qualif  "Qualification",
    Em.salaire "SALAIRE"
FROM LOCVEC.EMPLOYE Em
WHERE Em.salaire = (SELECT MAX(salaire)
                FROM LOCVEC.EMPLOYE);

-- R15 : Donner le modèle (marque-tpmdl) et l’immatriculation du véhicule mis en circulation en 2005 (datpmc) et ayant le plus grand nombre de kilomètres actuels (kmactl).
SELECT Mo.marque||'-'||Mo.tpmdl "Modèle",
    Ve.imtrcl "Immatriculation"
FROM LOCVEC.MODELE Mo, LOCVEC.VEHICULE Ve
WHERE Mo.cdMdl = Ve.cdMdl
AND EXTRACT(YEAR FROM Ve.datpmc) = 2005
AND Ve.kmactl = (SELECT MAX(kmactl) 
                FROM LOCVEC.VEHICULE
                WHERE EXTRACT(YEAR FROM datpmc) = 2005);

-- R16 : Donner le client ayant parcouru le plus grand nombre de km au cours d’un contrat d’un type contenant le mot « semaine ». 
SELECT Cl.NOM||' '||Cl.PRNM "Client",
    Tp.intTpCtr "Type contrat",
    Mo.marque||' '||Mo.tpmdl "Modèle",
    Ve.imtrcl "Immatriculation",
    Co.kmRtr - Co.kmDpt "Nb km parcourus"
FROM LOCVEC.MODELE Mo, LOCVEC.VEHICULE Ve, LOCVEC.CONTRAT Co, LOCVEC.TYPECONTRAT Tp, LOCVEC.CLIENT Cl
WHERE Mo.cdMdl = Ve.cdMdl
AND Ve.cdVhc = Co.cdVhc
AND Co.cdCli = Cl.cdCli
AND Co.cdTpCtr = Tp.cdTpCtr
AND UPPER(Tp.intTpCtr) LIKE '%SEMAINE%'
AND (Co.kmRtr - Co.kmDpt) = (SELECT MAX(Co2.kmrtr - Co2.kmdpt) 
                            FROM LOCVEC.CONTRAT Co2, LOCVEC.TYPECONTRAT Tp2
                            WHERE Co2.cdTpCtr = Tp2.cdTpCtr
                            AND UPPER(Tp2.inttpctr) LIKE '%SEMAINE%');

-- R17 : Nombre d’employés et salaire moyen (arrondi à la centaine d’euros) par qualification. Tri par ordre alphabétique des qualifications.
SELECT Em.qualif "Qualification",
    COUNT(Em.cdEmp) "Nb Employés",
    ROUND(AVG(EM.salaire),2) "Salaire Moyen"
FROM LOCVEC.EMPLOYE Em
GROUP BY Em.qualif
ORDER BY 1;

-- R18 : Donner par employé le nombre de contrats par type de contrat. Tri en majeur sur le nom de l’employé en mineur sur le nombre de contrats décroissant.
SELECT Em.nom||' '||Em.prnm "Employé",
    Tp.inttpctr "Type contrat",
    COUNT(Co.cdctr) "Nb contrats"
FROM LOCVEC.EMPLOYE Em, LOCVEC.CONTRAT Co, LOCVEC.TYPECONTRAT Tp
WHERE Em.cdEmp = Co.cdEmp
AND Co.cdTpCtr = Tp.cdTpCtr
GROUP BY Em.cdemp, Em.nom, Em.prnm, Tp.inttpctr
ORDER BY 1, 3 DESC;

-- R19 : Donner par catégorie le nombre de modèles de marque OPEL, PEUGEOT ou RENAULT. Tri par nombre de modèles décroissant.
SELECT Ca.intCtg "Catégorie",
    DECODE(Ca.tpvhc, '1', 'Tourisme', '2', 'Utilitaire', '3', 'Exception') "Type",
    COUNT(Mo.cdMdl) "Nb Modèles"
FROM LOCVEC.CATEGORIE Ca, LOCVEC.MODELE Mo
WHERE Ca.cdCtg = Mo.cdCtg
AND UPPER(Mo.marque) IN ('OPEL','PEUGEOT','RENAULT')
GROUP BY Ca.intCtg, Ca.tpVhc
ORDER BY 3 DESC;
