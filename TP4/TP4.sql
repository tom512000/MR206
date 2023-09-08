-- R30 : Liste des clients ayant la même profession que le client Marcelle LECOMTE ou n’ayant pas de profession. Tri dans l’ordre alphabétique des clients.
-- a) En utilisant l’opérateur UNION
SELECT Cl1.nom ||' '||Cl1.prnm "Personne",
	 Cl1.prfs "Profession"
FROM LOCVEC.CLIENT Cl1, LOCVEC.CLIENT Cl2
WHERE Cl1.prfs = Cl2.prfs
AND UPPER(Cl2.nom) = 'LECOMTE'
AND UPPER(Cl2.prnm) = 'MARCELLE'
UNION
SELECT nom||' '||prnm,
    'INCONNUE'
FROM LOCVEC.CLIENT
WHERE prfs IS NULL
ORDER BY 1;

-- b) En utilisant que des jointures et la fonction NVL
SELECT Cl1.nom ||' '||Cl1.prnm "Personne",
	 NVL(Cl1.prfs,'Inconnue') "Profession"
FROM LOCVEC.CLIENT Cl1, LOCVEC.CLIENT Cl2
WHERE UPPER(Cl2.nom) = 'LECOMTE'
AND UPPER(Cl2.prnm) = 'MARCELLE'
AND (Cl1.prfs = Cl2.prfs
OR Cl1.prfs IS NULL)
ORDER BY 1;

-- R31 : Liste de toutes les personnes, employé ou client, nés avant 1960. Tri par profession puis par âge croissant.
SELECT nom ||' '||prnm "Personne",
	 datns "Date de naissance",
	 qualif "Profession",
	 'EMPLOYE' "statut"
FROM LOCVEC.EMPLOYE
WHERE EXTRACT(YEAR FROM datns) < 1960
UNION	
SELECT nom ||' '||prnm,
    datns,
    prfs,
    'CLIENT'
FROM LOCVEC.CLIENT
WHERE EXTRACT(YEAR FROM datns) < 1960
ORDER BY 3,2 DESC;

-- R32 : Liste des modèles avec leur catégorie pour lesquels l’agence ne possède pas encore de véhicule.
SELECT Mo.marque||' '||Mo.tpmdl "Modèle",
    Ca.intctg "Catégorie"
FROM LOCVEC.CATEGORIE Ca
INNER JOIN LOCVEC.MODELE Mo ON Ca.cdctg = Mo.cdctg
MINUS
SELECT Mo.marque||' '||Mo.tpmdl,
    Ca.intctg
FROM LOCVEC.CATEGORIE Ca
INNER JOIN LOCVEC.MODELE Mo ON Ca.cdctg = Mo.cdctg
INNER JOIN LOCVEC.VEHICULE Ve ON Mo.cdmdl = Ve.cdmdl;

-- R33 : Liste des employés dont la qualification est « commercial » et qui n’ont établi aucun contrat.
-- a) en utilisant une jointure
SELECT Em.nom||' '||Em.prnm "Employé"
FROM LOCVEC.EMPLOYE Em, LOCVEC.CONTRAT Co
WHERE Em.cdEmp = Co.cdEmp(+)
AND Co.cdEmp IS NULL
AND UPPER(Em.qualif) = 'COMMERCIAL';

-- b) en utilisant une sous-requête
SELECT nom||' '||prnm "Employé"
FROM LOCVEC.EMPLOYE
WHERE UPPER(qualif) = 'COMMERCIAL'
AND cdEmp NOT IN (SELECT cdEmp
                    FROM LOCVEC.CONTRAT);

-- c) en utilisant un opérateur ensembliste.
SELECT nom||' '||prnm "Employé"
FROM LOCVEC.EMPLOYE
WHERE UPPER(qualif) = 'COMMERCIAL'
MINUS
SELECT Em.nom||' '||Em.prnm
FROM LOCVEC.EMPLOYE Em, LOCVEC.CONTRAT Co
WHERE Em.cdEmp = Co.cdEmp(+)
AND Co.cdEmp IS NOT NULL;

-- R34 : Liste des professions communes aux employés et aux clients.
SELECT qualif "Profession"
FROM LOCVEC.EMPLOYE
INTERSECT
SELECT prfs
FROM LOCVEC.CLIENT;

-- R35 : Liste des tarifs de la catégorie A en fonction du type de contrat : pour chaque type de contrat, 1 ligne pour le tarif de base, 1 ligne pour le tarif km et 1 ligne pour le tarif des options (Pour cela utiliser 2 UNION).
SELECT Tc.intTpCtr "Type de contrat", 'tarifBase' "Type de tarif", Ta.tarif_Base "Tarif"
FROM LOCVEC.TYPECONTRAT Tc, LOCVEC.TARIF Ta
WHERE Tc.cdTpCtr = Ta.cdTpCtr
AND Ta.cdCtg = 'A'
UNION
SELECT Tc.intTpCtr, 'tarifKm', Ta.tarif_Km
FROM LOCVEC.TYPECONTRAT Tc, LOCVEC.TARIF Ta
WHERE Tc.cdTpCtr = Ta.cdTpCtr
AND Ta.cdCtg = 'A'
UNION
SELECT Tc.intTpCtr, 'tarifOptions', Ta.TARIF_CA + Ta.TARIF_ARF + Ta.TARIF_ATM
FROM LOCVEC.TYPECONTRAT Tc, LOCVEC.TARIF Ta
WHERE Tc.cdTpCtr = Ta.cdTpCtr
AND Ta.cdCtg = 'A';

-- 36 : R36 : Liste des modèles qui sont de la même catégorie que le modèle de marque RENAULT et de tpmdl CLIO.
-- a) Avec jointure
SELECT Mo1.marque||' '||Mo1.tpmdl "Modèle"
FROM LOCVEC.MODELE Mo1, LOCVEC.MODELE Mo2
WHERE Mo1.cdctg = Mo2.cdctg
AND UPPER(Mo2.marque) = 'RENAULT'
AND UPPER(Mo2.tpmdl) = 'CLIO';

-- b) Avec sous-requête (opérateur IN ou =)
SELECT marque||' '||tpmdl "Modèle"
FROM LOCVEC.MODELE
WHERE cdctg = (SELECT cdctg
                FROM LOCVEC.MODELE 
				WHERE UPPER(marque) = 'RENAULT'
				AND UPPER(tpmdl) = 'CLIO');

-- c) Utiliser une synchronisation dans les deux requêtes précédentes pour ne pas afficher le modèle RENAULT CLIO dans la liste des résultats
SELECT Mo1.marque||' '||Mo1.tpmdl "Modèle"
FROM LOCVEC.MODELE Mo1, LOCVEC.MODELE Mo2
WHERE Mo1.cdctg = Mo2.cdctg
AND UPPER(Mo2.marque) = 'RENAULT'
AND UPPER(Mo2.tpmdl) = 'CLIO'
AND Mo1.cdmdl <> Mo2.cdmdl;

SELECT marque||' '||tpmdl "Modèle"
FROM LOCVEC.MODELE Mo1
WHERE cdctg = (SELECT cdctg
				FROM LOCVEC.MODELE Mo2
				WHERE UPPER(marque) = 'RENAULT'
				AND UPPER(tpmdl) = 'CLIO'
				AND Mo1.cdmdl <> Mo2.cdmdl);

-- R37 : Liste des clients de même profession et de même localité que le client nommé « Marcelle LECOMTE». Ne pas afficher Marcelle LECOMTE.
SELECT nom ||' ' ||prnm
FROM LOCVEC.CLIENT Cl1
WHERE (prfs, localite) = (SELECT prfs, localite
                          FROM LOCVEC.CLIENT Cl2
                          WHERE UPPER(prnm||nom) = 'MARCELLELECOMTE'
                          AND Cl1.cdcli != Cl2.cdCli);
