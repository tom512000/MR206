-- Requete 36
-- Liste des mod�les de la m�me cat�gorie que le mod�le RENAULT CLIO
 
--a)
-- JOINTURES : 5 lignes
SELECT m.marque|| ' '||m.tpmdl modele
FROM modele m, modele r
WHERE m.cdctg = r.cdctg
AND UPPER(r.marque) = 'RENAULT'
AND UPPER(r.tpmdl) = 'CLIO';

--b)
--SOUS REQUETES
SELECT marque|| ' '||tpmdl modele
FROM modele
WHERE cdctg = (SELECT cdctg
				FROM modele 
				WHERE UPPER(marque) = 'RENAULT'
				AND UPPER(tpmdl) = 'CLIO');
--c)
-- SOUS requetes synchronis�es : 4Lignes
SELECT m.marque|| ' '||m.tpmdl modele
FROM modele m, modele r
WHERE m.cdctg = r.cdctg
AND UPPER(r.marque) = 'RENAULT'
AND UPPER(r.tpmdl) = 'CLIO'
AND m.cdmdl <> r.cdmdl;

SELECT marque|| ' '||tpmdl modele
FROM modele m
WHERE cdctg = (SELECT cdctg
				FROM modele r
				WHERE UPPER(marque) = 'RENAULT'
				AND UPPER(tpmdl) = 'CLIO'
				AND m.cdmdl <> r.cdmdl);

--R37
-- Requete 37 
-- Liste des clients de m�me profession et de m�me localit� que le client nomm� � Marcelle LECOMTE �.
-- 3 lignes r�sultats
--a
SELECT c.nom ||' ' ||c.prnm
FROM client c, client m
WHERE c.prfs = m.prfs
AND c.localite = m.localite
AND UPPER(m.prnm||m.nom) = 'MARCELLELECOMTE'
AND c.cdcli != m.cdCli;

--b
SELECT nom ||' ' ||prnm
FROM client c
WHERE (prfs, localite) = (SELECT prfs, localite
                          FROM client m
                          WHERE UPPER(prnm||nom) = 'MARCELLELECOMTE'
                          AND c.cdcli != m.cdCli);

--R38
--Liste des employ�s embauch�s la m�me ann�e que leur sup�rieur. 

SELECT nom ||' '||prnm Employ�
FROM LOCVEC.Employe e
WHERE EXTRACT(YEAR FROM datemb) = (SELECT EXTRACT(YEAR FROM datEmb) 
									FROM LOCVEC.Employe s
                                      WHERE e.cdsup = s.cdemp);
 
--R non d�mand� 

SELECT nom||' '||prnm AS employ�, qualif qualification
FROM LOCVEC.employe e
WHERE salaire > (SELECT salaire 
                 FROM LOCVEC.employe s
                 WHERE e.cdsup = s.cdemp);

--R39
-- Afficher pour chaque qualification, l'employ� ayant le salaire le plus �lev�
SELECT  qualif Qualification,
        nom||' '||prnm AS employ�,
        salaire
FROM LOCVEC.employe e
WHERE salaire = (SELECT MAX(salaire)
                    FROM LOCVEC.employe s
                    WHERE e.qualif = s.qualif
                    GROUP BY qualif)
ORDER BY 3 DESC;



--R40
--un seul : Laurent ADNOT
SELECT DISTINCT nom||' '||prnm AS employ�, qualif qualification
FROM LOCVEC.employe e, LOCVEC.contrat c
WHERE cdsx = 1
AND  c.cdemp = e.cdemp;
                
                
SELECT DISTINCT nom||' '||prnm AS employ�, qualif qualification
FROM LOCVEC.employe 
WHERE cdsx = 1
AND cdemp IN (SELECT cdemp
                FROM LOCVEC.contrat);
				
SELECT DISTINCT nom||' '||prnm AS employ�, qualif qualification
FROM LOCVEC.employe e
WHERE cdsx = 1
AND EXISTS (SELECT NULL
                FROM LOCVEC.contrat c
                WHERE c.cdemp = e.cdemp);

-- R41
-- 10 v�hicules

SELECT  imtrcl immatriculation,
        trunc((sysdate - datpmc)/365.25) || ' ans'  "Anciennet�",
		kmactl "Kilom�trage"
 FROM LOCVEC.vehicule v
WHERE EXISTS (SELECT NULL 
                FROM LOCVEC.modele m
                WHERE marque IN ('RENAULT','OPEL','PEUGEOT')
                AND m.cdmdl = v.cdmdl)
AND EXISTS (SELECT NULL
              FROM LOCVEC.contrat c
              WHERE v.cdvhc = c.cdvhc)
ORDER BY 2 ;

-- R42
-- 22 v�hicules

SELECT marque||' '||tpmdl modele,
			intctg categorie
FROM LOCVEC.categorie c, LOCVEC.modele m
WHERE c.cdctg = m.cdctg
AND NOT EXISTS (SELECT NULL
                FROM LOCVEC.vehicule v
                WHERE v.cdmdl = m.cdmdl)
ORDER BY marque	;

-- R43
-- Requ�te 30 ----------------------
--10 lignes
-- a) penser au DISTINCT dans cette version sinon les clients ayent plusieurs contrats apparaissent plusieurs fois

SELECT DISTINCT nom|| ' '||prnm Client, NVL(prfs,'SANS PROFESSION') PROFESSION
FROM LOCVEC.client cl
        JOIN LOCVEC.contrat c ON cl.cdcli = c.cdcli
        JOIN LOCVEC.typeContrat tp ON c.cdtpctr = tp.cdtpctr
        JOIN LOCVEC.vehicule v ON c.cdvhc = v.cdvhc
        JOIN LOCVEC.modele m ON  v.cdmdl = m.cdmdl
        JOIN LOCVEC.categorie c ON m.cdctg = c.cdctg
WHERE UPPER(inttpctr) ='STANDARD JOUR + KM'
AND UPPER(intctg) = 'STANDARD';

--b)
SELECT nom|| ' '||prnm Client, NVL(prfs,'SANS PROFESSION') PROFESSION
FROM LOCVEC.client
WHERE cdcli IN (SELECT cdcli FROM LOCVEC.contrat
				WHERE cdtpctr = (SELECT cdtpctr 
                                FROM LOCVEC.typeContrat
								WHERE UPPER(inttpctr) ='STANDARD JOUR + KM')
				 AND cdvhc IN (SELECT cdvhc FROM LOCVEC.VEHICULE
								WHERE cdmdl IN (SELECT cdmdl 
                                                FROM LOCVEC.modele
												WHERE cdctg = (SELECT cdctg 
                                                                FROM LOCVEC.categorie
																WHERE UPPER(intctg) = 'STANDARD'))));
-- c)
														
SELECT nom|| ' '||prnm Client, NVL(prfs,'SANS PROFESSION') PROFESSION
FROM LOCVEC.client cl
WHERE EXISTS (SELECT NULL FROM LOCVEC.contrat c
				WHERE cl.cdcli = c.cdcli
				AND EXISTS (SELECT NULL 
                                FROM LOCVEC.typeContrat tp
								WHERE c.cdtpctr = tp.cdtpctr
								AND UPPER(inttpctr) ='STANDARD JOUR + KM')
				 AND EXISTS (SELECT NULL FROM LOCVEC.VEHICULE v
								WHERE c.cdvhc = v.cdvhc
								AND EXISTS (SELECT NULL 
                                                FROM LOCVEC.modele m
												WHERE v.cdmdl = m.cdmdl
												AND EXISTS (SELECT NULL 
                                                                FROM LOCVEC.categorie c
																WHERE m.cdctg = c.cdctg
																AND UPPER(intctg)= 'STANDARD'))));




-- R44

 SELECT nom||'-'||prnm client
 FROM LOCVEC.client cl
 WHERE NOT EXISTS (SELECT NULL 
					FROM LOCVEC.typecontrat t
					WHERE NOT EXISTS (SELECT NULL
										FROM LOCVEC.contrat c
										WHERE c.cdtpctr = t.cdtpctr
										AND c.cdcli = cl.cdcli));

/* ************************** STRUCTURES ARBORESCETES ****************** */

-- R45
SELECT 	LPAD (' ',3*(LEVEL-1),' ')||TO_CHAR(LEVEL) niveau, 
		DECODE(cdsx,'1',' Monsieur ', '2',' Madame ',' Mademoiselle ')||nom||' '||prnm employe,
		qualif
FROM LOCVEC.employe
CONNECT BY cdsup=PRIOR cdemp
START WITH cdsup IS NULL;

-- R46
SELECT 	LPAD (' ',3*(LEVEL-1),' ')||TO_CHAR(LEVEL) niveau, 
		DECODE(cdsx,'1',' Monsieur ', '2',' Madame ',' Mademoiselle ')||nom||' '||prnm employe,
		qualif
FROM LOCVEC.employe
WHERE datdpt IS NULL 
CONNECT BY cdsup=PRIOR cdemp
START WITH cdsup IS NULL;

      
-- R47
SELECT 	LPAD (' ',3*(LEVEL-1),' ')||TO_CHAR(LEVEL) niveau, 
		DECODE(cdsx,'1',' Monsieur ', '2',' Madame ',' Mademoiselle ')||nom||' '||prnm employe,
		qualif
FROM LOCVEC.employe
WHERE datdpt IS NULL 
CONNECT BY cdsup=PRIOR cdemp 
START WITH UPPER(qualif) = 'CHEF D''ATELIER' ;

--48
SELECT 	LPAD (' ',3*(LEVEL-1),' ')||TO_CHAR(LEVEL) niveau, 
		DECODE(cdsx,'1',' Monsieur ', '2',' Madame ',' Mademoiselle ')||nom||' '||prnm employe,
		qualif
FROM LOCVEC.employe
WHERE datdpt IS NULL AND cdsx=2
CONNECT BY cdsup=PRIOR cdemp 
START WITH cdsup IS NULL ;
	  
--R49
SELECT 	LPAD (' ',3*(LEVEL-1),' ')||TO_CHAR(LEVEL) niveau, 
		DECODE(cdsx,'1',' Monsieur ', '2',' Madame ',' Mademoiselle ')||nom||' '||prnm employe,
		qualif
FROM LOCVEC.employe
WHERE datdpt IS NULL AND UPPER(qualif) NOT LIKE 'DIRECTEUR'
CONNECT BY cdsup=PRIOR cdemp AND UPPER(qualif)NOT LIKE 'CHEF%'
START WITH cdsup IS NULL ;

--R50
SELECT Lpad(' ' ,4 * (Level - 1)) || Nom EMPLOYE,
	CDSUP  , Prior Nom "Nom Parent" ,
	Connect_By_Isleaf "Noeud" ,
	Connect_By_Root(Nom) "Racine",
	Sys_Connect_By_Path(cdEmp ,':') "Chemin" 
FROM locvec.employe
Connect By Nocycle Prior cdEmp = cdSup 
Start With cdSup IS NULL 
Order Siblings By nom;
