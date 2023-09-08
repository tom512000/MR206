-- Exercice 1 : Dans l’espace de travail, écrire la requête qui liste du contenu de la table CATEGORIE du schéma LOCVEC
SELECT *
FROM LOCVEC.CATEGORIE;

-- Exercice 2 : Liste des clients (nom-prénom concaténés) dont la localité contient le mot « reims » triés dans l’ordre alphabétique sur le nom.
SELECT NOM||'-'||PRNM "Client"
FROM LOCVEC.CLIENT
WHERE UPPER(LOCALITE) LIKE '%REIMS%';

-- Liste des véhicules (marque, type, immatriculation et kilométrage actuel) dont le kilométrage est supérieur à 90000.
SELECT M.MARQUE "Marque",
    M.TPMDL "Modèle",
    V.IMTRCL "Immatriculation",
    V.KMACTL "Kilométrage actuel"
FROM LOCVEC.VEHICULE V, LOCVEC.MODELE M
WHERE V.cdMdl = M.cdMdl
AND V.KMACTL > 90000;
