-- Exercice 1 : Création de table – Manipulation de données : Table PARTICIPATION
-- a) La table PARTICIPATION n’a pas encore été créée. Ecrire la requête qui créé la table PARTICIPATION à partir de la table MINIGOLF.PARTICIPER grâce à la commande suivante (en renommant la colonne cdPers en cdMemb).
DROP TABLE REGLT_COTISATION CASCADE CONSTRAINTS;

-- a) Création de la table PARTICIPATION
/*==============================================================*/
/* Table : PARTICIPATION                                        */
/*==============================================================*/
CREATE TABLE PARTICIPATION AS (
    SELECT 
    FROM MINIGOLF.PARTICIPER
    );