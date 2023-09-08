-- a) Insérer le moniteur suivant dans votre table MONITEUR : Le moniteur M2, TORDUE Paul demeurant 20, Rue Nationale à LA NEUVILETTE (51100) de statut 1 et d’index 3. Son responsable est le moniteur M1. 
INSERT INTO MONITEUR VALUES ('M2', 'TORDUE', 'Paul', '20 rue Nationale', 'Neuvilette', '51100', 'M1', '1', 3);

-- b) Dans une feuille de calcul, écrire l’ordre de modification de la table MONITEUR pour ajouter la contrainte de clé étrangère sur la colonne responsable qui fait référence a la clé primaire de la table (ALTER TABLE).
-- Supprimer les données de la table et tenter à nouveau la modification puis l’insertion du moniteur.
ALTER TABLE MONITEUR
   ADD CONSTRAINT FK_MONITEUR_RESPONSABLE FOREIGN KEY (responsable)
      REFERENCES MONITEUR (cdMono);

DELETE FROM MONITEUR;

-- c) Insérer les moniteurs suivants dans votre table MONITEUR, dans cet ordre:
-- Le moniteur M1, DUMAS Arnaud demeurant 14, Bd Gambetta à REIMS (51100), de statut 2 et d’index 1 (sans responsable).
-- Le moniteur M2, TORDUE Paul demeurant 20, Rue Nationale à LA NEUVILETTE (51100) de statut 1 et d’index 3. Son responsable est le moniteur M1.
INSERT INTO MONITEUR VALUES ('M1', 'DUMAS', 'Arnaud', '14 rue Bd Gambetta', 'Reims', '51100', NULL, '2', 1);
INSERT INTO MONITEUR VALUES ('M2', 'TORDUE', 'Paul', '20 rue Nationale', 'Neuvilette', '51100', 'M1', '1', 3);

-- d) Ecrire la requête qui permet d’insérer (INSERT) les membres de la table MINIGOLF.PERSONNE dans votre table MEMBRE précédemment créée : on ne veut insérer que ceux qui ne sont pas de type 3 (tpMemb).
-- Exécuter la requête et vérifier le contenu de votre table MEMBRE.
DELETE FROM MEMBRE;
INSERT INTO MEMBRE (cdMemb, nom, prnm, adr, ville, cp, tpMemb, nbCourSuivis, ind)
SELECT cdPers, nom, prnm, adr, ville, cp, tpMemb, nbCourSuivis, ind
FROM MINIGOLF.PERSONNE
WHERE tpMemb != '3';

-- e) Ecrire la requête de modification (UPDATE) qui passe en majuscules les noms de tous les membres de la table MEMBRE (fonction UPPER). Valider les modification (COMMIT).
UPDATE MEMBRE
SET nom = UPPER(nom);

COMMIT;