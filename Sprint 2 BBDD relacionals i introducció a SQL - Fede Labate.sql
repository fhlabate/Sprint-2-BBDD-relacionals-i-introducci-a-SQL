-- Tasca S2.01. "Nocions bàsiques SQL"

-- ####### Nivell 1 #######
-- Exercici 1
SELECT *
FROM company;
SELECT *
FROM transaction;

-- Exercici 2
-- Utilitzant JOIN realitzaràs les següents consultes:
-- Llistat dels països que estan fent compres.
SELECT DISTINCT country AS "Països que estan fent compres"
FROM company c
RIGHT JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0
ORDER BY country ASC;

-- Des de quants països es realitzen les compres.
SELECT count(DISTINCT country) AS "Països es realitzen les compres"
FROM company c
RIGHT JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0
ORDER BY country ASC;
#Rta: 15 països.

-- Identifica la companyia amb la mitjana més gran de vendes.
SELECT c.company_name AS "Companya", round(AVG(amount),0) AS "Mitjana més gran de vendes [€]"
FROM transaction t
JOIN company c
ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.company_name
ORDER BY AVG(amount) DESC
LIMIT 1;
#Rta: Eget Ipsum Ltd | 482 €

-- Exercici 3
-- Utilitzant només subconsultes (sense utilitzar JOIN):
-- Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT * 
FROM transaction
WHERE company_id IN
					(
                    SELECT id
					FROM company
					WHERE country = "Germany"
                    );
#Rta: 118 transaccions 		
	             
-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT DISTINCT company_name AS "Empreses que han realitzat transaccions per un amount superior a la mitjana"
FROM company
WHERE id IN (
			SELECT company_id 
			FROM transaction
			WHERE amount > (
							SELECT avg(amount)
							FROM transaction
							)
			)
ORDER BY company_name ASC;

-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT DISTINCT company_name AS "Empreses que no tenen transaccions registrades"
FROM company
WHERE NOT EXISTS (
				  SELECT company_id 
				  FROM transaction
				  );
                  
-- ####### Nivell 2 #######
-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.
SELECT DATE(timestamp) AS "Data de cada transacció" , round(sum(amount),0) AS "Total de les vendes (€)"
FROM transaction
WHERE declined = 0
GROUP BY DATE(timestamp)
ORDER BY sum(amount) DESC
LIMIT 5;

-- Exercici 2
-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
SELECT c.country AS "País", round(avg(amount),0) AS "Mitjana de vendes (€)"
FROM transaction t
JOIN company c
ON t.company_id = c.id
WHERE t.declined = 0
GROUP BY c.country
ORDER BY avg(amount) DESC;

-- Exercici 3
-- En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.
--  Mostra el llistat aplicant JOIN i subconsultes.
SELECT company_name AS "Company", t.*
FROM transaction t
JOIN company c
ON t.company_id = c.id
WHERE country = (
					SELECT country 
					FROM company
					WHERE company_name = "Non Institute"
				   ) AND company_name <> "Non Institute";
                   
-- Mostra el llistat aplicant solament subconsultes.
SELECT (SELECT company_name FROM company c WHERE c.id=t.company_id) AS "Company", (SELECT country FROM company c WHERE c.id=t.company_id) AS "Country", t.*
FROM transaction t
WHERE company_id IN (
					SELECT id 
					FROM company
					WHERE country = (
									SELECT country 
									FROM company
									WHERE company_name = "Non Institute"
				     ) AND company_name <> "Non Institute"
										);
                                        
-- ####### Nivell 3 #######
-- Exercici 1
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.
SELECT c.company_name AS "Nom", c.phone AS "Telèfon", c.country AS "País", DATE(t.timestamp) AS "Data", t.amount AS "Amount (€)"
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.amount BETWEEN 100 and 200 AND DATE(t.timestamp) IN (
															"2021-04-29", "2021-07-20", "2022-03-13"
															)
ORDER BY Amount DESC;
			          
-- Exercici 2
-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.
SELECT company_name AS "Nom",
CASE 
WHEN COUNT(t.id) > 4 THEN "Més"
ELSE "Menys"
END AS "Tenen més de 4 transaccions o menys"
FROM transaction t
JOIN company c
ON t.company_id = c.id
GROUP BY company_name
ORDER BY Nom ASC;