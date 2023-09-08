-- R38 : Liste des employés embauchés la même année que leur supérieur.
SELECT nom||' '||prnm "Employé"
FROM LOCVEC.EMPLOYE Em1
WHERE EXTRACT(YEAR FROM datemb) = (SELECT EXTRACT(YEAR FROM datEmb) 
									FROM LOCVEC.EMPLOYE Em2
                                    WHERE Em1.cdsup = Em2.cdemp);

-- R39 : Liste, pour chaque qualification de l’employé ayant le salaire le plus élevé. Tri par salaire décroissant.
SELECT qualif "Qualification",
    nom||' '||prnm "Employé",
    salaire "Salaire"
FROM LOCVEC.EMPLOYE Em1
WHERE salaire = (SELECT MAX(salaire)
                    FROM LOCVEC.EMPLOYE Em2
                    WHERE Em1.qualif = Em2.qualif
                    GROUP BY qualif)
ORDER BY 3 DESC;

-- R40 : Liste des employés de sexe masculin ayant établi au moins un contrat.
-- a) en n’utilisant une jointure
SELECT DISTINCT nom||' '||prnm "Employé",
    qualif "Qualification"
FROM LOCVEC.EMPLOYE Em, LOCVEC.CONTRAT Co
WHERE cdsx = 1
AND  Co.cdemp = Em.cdemp;

-- b) en n’utilisant une sous-requête (opérateur IN)
SELECT DISTINCT nom||' '||prnm "Employé",
    qualif "Qualification"
FROM LOCVEC.EMPLOYE 
WHERE cdsx = 1
AND cdemp IN (SELECT cdemp
                FROM LOCVEC.CONTRAT);

-- c) en n’utilisant une sous-requête (opérateur EXISTS).
SELECT DISTINCT nom||' '||prnm "Employé",
    qualif "Qualification"
FROM LOCVEC.EMPLOYE Em
WHERE cdsx = 1
AND EXISTS (SELECT NULL
                FROM LOCVEC.CONTRAT Co
                WHERE Co.cdemp = Em.cdemp);

-- R41 : Liste des véhicules de marque OPEL, RENAULT ou PEUGEOT qui ont déjà été loués.
SELECT imtrcl "Immatriculation",
    ROUND((sysdate - datpmc)/365.25)||' ans' "Ancienneté",
    kmactl "Kilométrage"
FROM LOCVEC.VEHICULE Ve
WHERE EXISTS (SELECT NULL 
                FROM LOCVEC.MODELE Mo
                WHERE marque IN ('RENAULT','OPEL','PEUGEOT')
                AND Mo.cdmdl = Ve.cdmdl)
AND EXISTS (SELECT NULL
            FROM LOCVEC.CONTRAT Co
            WHERE Ve.cdvhc = Co.cdvhc)
ORDER BY 2 ;

-- R42 : Liste des modèles pour lesquels il n’existe pas de véhicule.
