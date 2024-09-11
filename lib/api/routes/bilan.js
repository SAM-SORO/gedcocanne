
const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données


// Endpoint pour récupérer le tonnage d'entrée dans la cour
router.post('/tonnageDechargerCours', async (req, res) => {
    try {
        let { heureDebut, heureFin } = req.body;

        // Conversion des heures de chaînes en nombres entiers
        heureDebut = parseInt(heureDebut, 10);
        heureFin = parseInt(heureFin, 10);

        // Validation des paramètres après conversion
        if (isNaN(heureDebut) || isNaN(heureFin) || heureDebut < 0 || heureDebut > 23 || heureFin < 0 || heureFin > 23) {
            return res.status(400).json({ error: 'heureDebut et heureFin doivent être des nombres entre 0 et 23' });
        }

        const pool = await poolPromise;
        const dateNow = new Date();  // Date actuelle

        let query = '';

        if (heureDebut <= heureFin) {
            // Même journée
            query = `
                SELECT SUM(poidsNet) AS totalPoidsNet
                FROM DECHARGERCOURS
                WHERE 
                CAST(dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE) 
                AND DATEPART(HOUR, dateHeureDecharg) BETWEEN @heureDebut AND @heureFin;
            `;
        } else {
            // Débordement sur le jour suivant
            query = `
                SELECT SUM(poidsNet) AS totalPoidsNet
                FROM DECHARGERCOURS
                WHERE 
                (
                    (CAST(dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE) 
                    AND DATEPART(HOUR, dateHeureDecharg) >= @heureDebut)
                    OR
                    (CAST(dateHeureDecharg AS DATE) = DATEADD(DAY, 1, @dateNow) 
                    AND DATEPART(HOUR, dateHeureDecharg) <= @heureFin)
                );
            `;
        }

        const result = await pool.request()
            .input('dateNow', sql.DateTime, dateNow)
            .input('heureDebut', sql.Int, heureDebut)
            .input('heureFin', sql.Int, heureFin)
            .query(query);

        const stockEntree = result.recordset[0].totalPoidsNet || 0;

        //console.log(`Stock Entrée: ${stockEntree}`);

        res.json({ stockEntree });
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});



// Endpoint pour récupérer le tonnage broyé directement à partir de la table DECHARGERTABLE Entre deux heure
router.post('/tonnageBroyerDirect', async (req, res) => {
    try {
        let { heureDebut, heureFin } = req.body;

        // Conversion des heures de chaînes en nombres
        heureDebut = parseInt(heureDebut, 10);
        heureFin = parseInt(heureFin, 10);

        // Validation des paramètres
        if (isNaN(heureDebut) || isNaN(heureFin) || heureDebut < 0 || heureFin > 23 || heureFin < 0 || heureDebut > 23) {
            return res.status(400).json({ error: 'heureDebut et heureFin doivent être des nombres entre 0 et 23' });
        }

        const pool = await poolPromise;
        const dateNow = new Date();  // Date actuelle

        let query = '';

        if (heureDebut <= heureFin) {
            query = `
                SELECT SUM(poidsNet) AS totalPoidsNet
                FROM DECHARGERTABLE
                WHERE 
                CAST(dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE) 
                AND DATEPART(HOUR, dateHeureDecharg) BETWEEN @heureDebut AND @heureFin;
            `;
        } else {
            query = `
                SELECT SUM(poidsNet) AS totalPoidsNet
                FROM DECHARGERTABLE
                WHERE 
                (
                    (CAST(dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE) 
                    AND DATEPART(HOUR, dateHeureDecharg) >= @heureDebut)
                    OR
                    (CAST(dateHeureDecharg AS DATE) = DATEADD(DAY, 1, @dateNow) 
                    AND DATEPART(HOUR, dateHeureDecharg) <= @heureFin)
                );
            `;
        }

        const result = await pool.request()
            .input('dateNow', sql.DateTime, dateNow)
            .input('heureDebut', sql.Int, heureDebut)
            .input('heureFin', sql.Int, heureFin)
            .query(query);

        const stockBroyerDirect = result.recordset[0].totalPoidsNet || 0;

        //console.log(stockBroyerDirect);

        res.json({ stockBroyerDirect });
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


// Endpoint pour récupérer le tonnage broyé par tas entre deux heure
router.post('/tonnageBroyerParTas', async (req, res) => {
    try {
        // Extraction des heures de début et de fin à partir de la requête POST
        const { heureDebut, heureFin } = req.body;

        // Vérification que les deux paramètres sont bien fournis
        if (!heureDebut || !heureFin) {
            return res.status(400).json({ error: 'heureDebut et heureFin sont requis' });
        }


        const pool = await poolPromise;

        let query = '';

        // Conversion des heures de début et de fin en entiers pour comparaison
        if (parseInt(heureDebut) <= parseInt(heureFin)) {
            // Cas où l'heure de début est inférieure ou égale à l'heure de fin
            // (Exemple: début à 05:00 et fin à 15:00, tout dans la même journée)

            query = `
                SELECT SUM(poids) AS totalPoidsTas
                FROM TAS
                WHERE 
                -- Le tas est broyé (etat = 1)
                etat = 1
                -- La date de broyage correspond à la date actuelle
                AND CAST(dateBroyage AS DATE) = CAST(GETDATE() AS DATE)
                -- L'heure de broyage est comprise entre l'heure de début et l'heure de fin
                AND heureBroyage BETWEEN @heureDebut AND @heureFin;
            `;
        } else {
            // Cas où l'heure de fin est techniquement "le jour suivant" par rapport à l'heure de début
            // (Exemple: début à 20:00 et fin à 04:00, le broyage se poursuit après minuit)

            query = `
                SELECT SUM(poids) AS totalPoidsTas
                FROM TAS
                WHERE 
                -- Le tas est broyé (etat = 1)
                etat = 1
                AND (
                    -- Première condition: le broyage s'est produit le jour même après l'heure de début
                    (CAST(dateBroyage AS DATE) = CAST(GETDATE() AS DATE) 
                    AND heureBroyage >= @heureDebut)
                    OR
                    -- Seconde condition: le broyage s'est produit le jour suivant avant l'heure de fin
                    (CAST(dateBroyage AS DATE) = DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) 
                    AND heureBroyage <= @heureFin)
                );
            `;
        }

        // Exécution de la requête SQL avec les heures passées en paramètre
        const result = await pool.request()
            .input('heureDebut', sql.Int, parseInt(heureDebut))
            .input('heureFin', sql.Int, parseInt(heureFin))
            .query(query);

        // Récupération du résultat: la somme totale des poids des tas broyés, ou 0 si aucune donnée n'est trouvée
        const tonnageBroyerParTas = result.recordset[0].totalPoidsTas || 0;

        // Envoi du résultat au client
        res.json({ tonnageBroyerParTas });
    } catch (err) {
        // Gestion des erreurs SQL ou autres, avec log pour le diagnostic
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


//La route tonnageRestantCourt calculera la somme des poids des camions dans la cour (table DECHARGERCOURS) dont l'état de broyage est 0 (non broyé), et dont l'heure de déchargement respecte les contraintes spécifiées par l'utilisateur.

// Endpoint pour récupérer le tonnage restant dans la cour
router.post('/tonnageRestantCourt', async (req, res) => {
    try {
        const pool = await poolPromise;

        // Requête SQL simplifiée pour obtenir la somme des poids des tas avec état = 0
        const query = `
            SELECT SUM(poids) AS totalPoidsRestant
            FROM TAS
            WHERE 
            -- Le tas n'a pas encore été broyé (etat = 0)
            etat = 0;
        `;

        // Exécution de la requête SQL
        const result = await pool.request().query(query);

        // Récupération du résultat: la somme totale des poids des tas non broyés, ou 0 si aucune donnée n'est trouvée
        const tonnageRestant = result.recordset[0].totalPoidsRestant || 0;

        // Envoi du résultat au client
        res.json({ tonnageRestant });
    } catch (err) {
        // Gestion des erreurs SQL ou autres, avec log pour le diagnostic
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});



// Route pour récupérer le tonnage de canne entrée entre deux heures spécifiées
router.post('/getTonnageCanneEntree', async (req, res) => {
    try {
        // Extraction des heures de début et de fin depuis le corps de la requête
        let { heureDebut, heureFin } = req.body;

        // Conversion des heures de chaînes en entiers
        heureDebut = parseInt(heureDebut, 10);
        heureFin = parseInt(heureFin, 10);

        // Validation des paramètres pour s'assurer qu'ils sont des nombres valides dans la plage 0-23
        if (isNaN(heureDebut) || isNaN(heureFin) || heureDebut < 0 || heureFin > 23 || heureFin < 0 || heureDebut > 23) {
            return res.status(400).json({ error: 'heureDebut et heureFin doivent être des nombres entre 0 et 23' });
        }

        // Connexion à la base de données
        const pool = await poolPromise;
        // Obtention de la date actuelle
        const dateNow = new Date();

        // Préparation de la requête pour récupérer la somme des poids nets dans DECHARGERCOURS
        let queryCours = '';
        if (heureDebut <= heureFin) {
            // Si l'heure de début est inférieure ou égale à l'heure de fin
            queryCours = `
                SELECT SUM(poidsNet) AS totalPoidsNetCours
                FROM DECHARGERCOURS
                WHERE 
                CAST(dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE)  -- Date actuelle
                AND DATEPART(HOUR, dateHeureDecharg) BETWEEN @heureDebut AND @heureFin;  -- Plage horaire
            `;
        } else {
            // Si l'heure de début est supérieure à l'heure de fin (chevauchement de jour)
            queryCours = `
                SELECT SUM(poidsNet) AS totalPoidsNetCours
                FROM DECHARGERCOURS
                WHERE 
                (
                    (CAST(dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE) 
                    AND DATEPART(HOUR, dateHeureDecharg) >= @heureDebut)  -- Première partie de la journée
                    OR
                    (CAST(dateHeureDecharg AS DATE) = DATEADD(DAY, 1, CAST(@dateNow AS DATE)) 
                    AND DATEPART(HOUR, dateHeureDecharg) <= @heureFin)  -- Seconde partie de la journée
                );
            `;
        }

        // Préparation de la requête pour récupérer la somme des poids nets dans DECHARGERTABLE
        let queryTable = '';
        if (heureDebut <= heureFin) {
            // Si l'heure de début est inférieure ou égale à l'heure de fin
            queryTable = `
                SELECT SUM(poidsNet) AS totalPoidsNetTable
                FROM DECHARGERTABLE
                WHERE 
                CAST(dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE)  -- Date actuelle
                AND DATEPART(HOUR, dateHeureDecharg) BETWEEN @heureDebut AND @heureFin;  -- Plage horaire
            `;
        } else {
            // Si l'heure de début est supérieure à l'heure de fin (chevauchement de jour)
            queryTable = `
                SELECT SUM(poidsNet) AS totalPoidsNetTable
                FROM DECHARGERTABLE
                WHERE 
                (
                    (CAST(dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE) 
                    AND DATEPART(HOUR, dateHeureDecharg) >= @heureDebut)  -- Première partie de la journée
                    OR
                    (CAST(dateHeureDecharg AS DATE) = DATEADD(DAY, 1, CAST(@dateNow AS DATE)) 
                    AND DATEPART(HOUR, dateHeureDecharg) <= @heureFin)  -- Seconde partie de la journée
                );
            `;
        }

        // Exécution des deux requêtes en parallèle
        const [resultCours, resultTable] = await Promise.all([
            pool.request()
                .input('dateNow', sql.DateTime, dateNow)  // Passage de la date actuelle
                .input('heureDebut', sql.Int, heureDebut)  // Passage de l'heure de début
                .input('heureFin', sql.Int, heureFin)  // Passage de l'heure de fin
                .query(queryCours),  // Exécution de la requête pour DECHARGERCOURS
            pool.request()
                .input('dateNow', sql.DateTime, dateNow)  // Passage de la date actuelle
                .input('heureDebut', sql.Int, heureDebut)  // Passage de l'heure de début
                .input('heureFin', sql.Int, heureFin)  // Passage de l'heure de fin
                .query(queryTable),  // Exécution de la requête pour DECHARGERTABLE
        ]);

        // Extraction des résultats des requêtes
        const totalPoidsNetCours = resultCours.recordset[0].totalPoidsNetCours || 0;
        const totalPoidsNetTable = resultTable.recordset[0].totalPoidsNetTable || 0;

        // Calcul du tonnage total
        const tonnageTotal = totalPoidsNetCours + totalPoidsNetTable;

        // Retour du résultat au client en format JSON
        res.json({ tonnageTotal });
    } catch (error) {
        // Gestion des erreurs
        console.error('Erreur lors de la récupération du tonnage de canne entrée:', error);
        res.status(500).json({ error: 'Erreur interne du serveur' });
    }
});





////////////AUTRES BILAN Qu'ON POURRAIT AVOIR


//Route pour obtenir l'agent ayant broyer le plus de canne dans une plage horaire
router.post('/agentTopBroyage', async (req, res) => {
    try {
        const { heureDebut, heureFin } = req.body;

        // Validation des paramètres pour s'assurer qu'ils sont des nombres dans la plage 0-23
        if (typeof heureDebut !== 'number' || typeof heureFin !== 'number' || heureDebut < 0 || heureDebut > 23 || heureFin < 0 || heureFin > 23) {
            return res.status(400).json({ error: 'heureDebut et heureFin doivent être des nombres entre 0 et 23' });
        }

        const pool = await poolPromise;
        const dateNow = new Date();

        let query = '';

        // Si l'heure de début est inférieure ou égale à l'heure de fin, la période est dans la même journée
        if (heureDebut <= heureFin) {
            //La fonction COALESCE est utilisée pour sélectionner l'agent à partir de DECHARGERTABLE ou TAS, selon la table où l'agent existe. Cela permet de garantir que l'agent est inclus même si ses données proviennent uniquement d'une des deux tables.
            query = `
                SELECT TOP 1
                    A.matricule,  -- Matricule de l'agent
                    ISNULL(SUM(T.poids), 0) + ISNULL(SUM(D.poidsNet), 0) AS totalPoids  -- Somme des poids broyés dans TAS et DECHARGERTABLE
                FROM AGENT A
                LEFT JOIN TAS T ON A.matricule = T.agentBroyage
                    AND T.etat = 1  -- Filtre pour les tas broyés
                    AND T.heureBroyage BETWEEN @heureDebut AND @heureFin
                    AND CAST(T.dateBroyage AS DATE) = CAST(@dateNow AS DATE)  -- Même jour que la date actuelle
                LEFT JOIN DECHARGERTABLE D ON A.matricule = D.agentMatricule
                    AND DATEPART(HOUR, D.dateHeureDecharg) BETWEEN @heureDebut AND @heureFin
                    AND CAST(D.dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE)  -- Même jour que la date actuelle
                GROUP BY A.matricule
                ORDER BY totalPoids DESC  -- Trier par poids total décroissant
                --OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;  -- Limite à un seul résultat
                --TOP ne peut pas etre utilise dans la meme requete ou sous-requete que OFFSET.
            `;

        } else {
            // Si l'heure de début est supérieure à l'heure de fin, la période couvre deux jours
            // La fonction COALESCE est utilisée pour sélectionner l'agent à partir de DECHARGERTABLE ou TAS, selon la table où l'agent existe. Cela permet de garantir que l'agent est inclus même si ses données proviennent uniquement d'une des deux tables.

            query = `
                SELECT TOP 1
                    A.matricule,  -- Matricule de l'agent
                    ISNULL(SUM(T.poids), 0) + ISNULL(SUM(D.poidsNet), 0) AS totalPoids  -- Somme des poids broyés dans TAS et DECHARGERTABLE
                FROM AGENT A
                LEFT JOIN TAS T ON A.matricule = T.agentBroyage
                    AND T.etat = 1  -- Filtre pour les tas broyés
                    AND (
                        (T.heureBroyage >= @heureDebut AND CAST(T.dateBroyage AS DATE) = CAST(@dateNow AS DATE))
                        OR
                        (T.heureBroyage <= @heureFin AND CAST(T.dateBroyage AS DATE) = DATEADD(DAY, 1, @dateNow))
                    )
                LEFT JOIN DECHARGERTABLE D ON A.matricule = D.agentMatricule
                    AND (
                        (DATEPART(HOUR, D.dateHeureDecharg) >= @heureDebut AND CAST(D.dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE))
                        OR
                        (DATEPART(HOUR, D.dateHeureDecharg) <= @heureFin AND CAST(D.dateHeureDecharg AS DATE) = DATEADD(DAY, 1, @dateNow))
                    )
                GROUP BY A.matricule
                ORDER BY totalPoids DESC  -- Trier par poids total décroissant
                --OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;  -- Limite à un seul résultat
                --TOP ne peut pas etre utilise dans la meme requete ou sous-requete que OFFSET.
            `;

        }

        // Exécution de la requête
        const result = await pool.request()
            .input('dateNow', sql.DateTime, dateNow)
            .input('heureDebut', sql.Int, heureDebut)
            .input('heureFin', sql.Int, heureFin)
            .query(query);

        if (result.recordset.length > 0) {
            const topAgent = result.recordset[0];
            res.json({
                matricule: topAgent.matricule,
                totalPoids: topAgent.totalPoids
            });
        } else {
            res.status(404).json({ error: 'Aucun agent n\'a broyé de tas ou déchargé de camions dans la plage horaire spécifiée' });
        }
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

//Route pour obtenir l'agent ayant broyer le moins de canne dans une plage horaire
router.post('/agentMinBroyage', async (req, res) => {
    try {
        const { heureDebut, heureFin } = req.body;

        // Validation des paramètres pour s'assurer qu'ils sont des nombres dans la plage 0-23
        if (typeof heureDebut !== 'number' || typeof heureFin !== 'number' || heureDebut < 0 || heureDebut > 23 || heureFin < 0 || heureFin > 23) {
            return res.status(400).json({ error: 'heureDebut et heureFin doivent être des nombres entre 0 et 23' });
        }

        const pool = await poolPromise;
        const dateNow = new Date();

        let query = '';

        // Si l'heure de début est inférieure ou égale à l'heure de fin, la période est dans la même journée
        if (heureDebut <= heureFin) {
            query = `
                SELECT TOP 1
                    A.matricule,  -- Matricule de l'agent
                    ISNULL(SUM(T.poids), 0) + ISNULL(SUM(D.poidsNet), 0) AS totalPoids  -- Somme des poids broyés dans TAS et DECHARGERTABLE
                FROM AGENT A
                LEFT JOIN TAS T ON A.matricule = T.agentBroyage
                    AND T.etat = 1  -- Filtre pour les tas broyés
                    AND T.heureBroyage BETWEEN @heureDebut AND @heureFin
                    AND CAST(T.dateBroyage AS DATE) = CAST(@dateNow AS DATE)  -- Même jour que la date actuelle
                LEFT JOIN DECHARGERTABLE D ON A.matricule = D.agentMatricule
                    AND DATEPART(HOUR, D.dateHeureDecharg) BETWEEN @heureDebut AND @heureFin
                    AND CAST(D.dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE)  -- Même jour que la date actuelle
                GROUP BY A.matricule
                ORDER BY totalPoids ASC  -- Trier par poids total croissant
                --OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;  -- Limite à un seul résultat
                --TOP ne peut pas etre utilise dans la meme requete ou sous-requete que OFFSET.
            `;
        } else {
            // Si l'heure de début est supérieure à l'heure de fin, la période couvre deux jours
            query = `
                SELECT TOP 1
                    A.matricule,  -- Matricule de l'agent
                    ISNULL(SUM(T.poids), 0) + ISNULL(SUM(D.poidsNet), 0) AS totalPoids  -- Somme des poids broyés dans TAS et DECHARGERTABLE
                FROM AGENT A
                LEFT JOIN TAS T ON A.matricule = T.agentBroyage
                    AND T.etat = 1  -- Filtre pour les tas broyés
                    AND (
                        (T.heureBroyage >= @heureDebut AND CAST(T.dateBroyage AS DATE) = CAST(@dateNow AS DATE))
                        OR
                        (T.heureBroyage <= @heureFin AND CAST(T.dateBroyage AS DATE) = DATEADD(DAY, 1, @dateNow))
                    )
                LEFT JOIN DECHARGERTABLE D ON A.matricule = D.agentMatricule
                    AND (
                        (DATEPART(HOUR, D.dateHeureDecharg) >= @heureDebut AND CAST(D.dateHeureDecharg AS DATE) = CAST(@dateNow AS DATE))
                        OR
                        (DATEPART(HOUR, D.dateHeureDecharg) <= @heureFin AND CAST(D.dateHeureDecharg AS DATE) = DATEADD(DAY, 1, @dateNow))
                    )
                GROUP BY A.matricule
                ORDER BY totalPoids ASC  -- Trier par poids total croissant
                --OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;  -- Limite à un seul résultat
                --TOP ne peut pas etre utilise dans la meme requete ou sous-requete que OFFSET.
            `;
        }

        // Exécution de la requête
        const result = await pool.request()
            .input('dateNow', sql.DateTime, dateNow)
            .input('heureDebut', sql.Int, heureDebut)
            .input('heureFin', sql.Int, heureFin)
            .query(query);

        if (result.recordset.length > 0) {
            const agentMinBroyage = result.recordset[0];
            res.json({
                matricule: agentMinBroyage.matricule,
                totalPoids: agentMinBroyage.totalPoids
            });
        } else {
            res.status(404).json({ error: 'Aucun agent n\'a broyé des tas dans cette plage horaire' });
        }
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


// Route pour obtenir le matricule et le tonnage de l'agent qui a broyé le plus sur l'année en cours
router.get('/agentTopBroyageAnnee', async (req, res) => {
    try {
        const pool = await poolPromise;
        const dateNow = new Date();
        const currentYear = dateNow.getFullYear();  // Récupère l'année actuelle

        let query = `
            SELECT TOP 1
                A.matricule,  
                ISNULL(SUM(T.poids), 0) + ISNULL(SUM(D.poidsNet), 0) AS totalPoids  -- Somme des poids broyés
            FROM AGENT A
            LEFT JOIN TAS T ON A.matricule = T.agentBroyage
                AND T.etat = 1  -- Filtre pour les tas broyés
                AND YEAR(T.dateBroyage) = @currentYear  -- Filtrer par l'année actuelle
            LEFT JOIN DECHARGERTABLE D ON A.matricule = D.agentMatricule
                AND YEAR(D.dateHeureDecharg) = @currentYear  -- Filtrer par l'année actuelle
            GROUP BY A.matricule
            ORDER BY totalPoids DESC  -- Trier par le tonnage total décroissant
        `;

        // Exécution de la requête
        const result = await pool.request()
            .input('currentYear', sql.Int, currentYear)  // Passer l'année actuelle en paramètre
            .query(query);

        if (result.recordset.length > 0) {
            const topAgent = result.recordset[0];
            res.json({
                matricule: topAgent.matricule,
                totalPoids: topAgent.totalPoids
            });
        } else {
            res.status(404).json({ error: 'Aucun agent n\'a broyé de tas ou déchargé de camions cette année' });
        }
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


//Route pour récupérer le matricule et le tonnage de l'agent qui a broyé le plus sur l'année
router.get('/agentTopBroyageAnnee', async (req, res) => {
    try {
        const pool = await poolPromise;
        const dateNow = new Date();
        const currentYear = dateNow.getFullYear();  // Récupère l'année actuelle

        let query = `
            SELECT TOP 1
                A.matricule,  
                ISNULL(SUM(T.poids), 0) + ISNULL(SUM(D.poidsNet), 0) AS totalPoids  -- Somme des poids broyés
            FROM AGENT A
            LEFT JOIN TAS T ON A.matricule = T.agentBroyage
                AND T.etat = 1  -- Filtre pour les tas broyés
                AND YEAR(T.dateBroyage) = @currentYear  -- Filtrer par l'année actuelle
            LEFT JOIN DECHARGERTABLE D ON A.matricule = D.agentMatricule
                AND YEAR(D.dateHeureDecharg) = @currentYear  -- Filtrer par l'année actuelle
            GROUP BY A.matricule
            ORDER BY totalPoids DESC  -- Trier par le tonnage total décroissant
        `;

        // Exécution de la requête
        const result = await pool.request()
            .input('currentYear', sql.Int, currentYear)  // Passer l'année actuelle en paramètre
            .query(query);

        if (result.recordset.length > 0) {
            const topAgent = result.recordset[0];
            res.json({
                matricule: topAgent.matricule,
                totalPoids: topAgent.totalPoids
            });
        } else {
            res.status(404).json({ error: 'Aucun agent n\'a broyé de tas ou déchargé de camions cette année' });
        }
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


//Route pour récupérer le matricule et le tonnage de l'agent qui a broyé le plus sur l'année
router.get('/agentMinBroyageAnnee', async (req, res) => {
    try {
        const pool = await poolPromise;
        const currentYear = new Date().getFullYear();

        const query = `
            SELECT TOP 1
                A.matricule,  -- Matricule de l'agent
                ISNULL(SUM(T.poids), 0) + ISNULL(SUM(D.poidsNet), 0) AS totalPoids  -- Somme des poids broyés dans TAS et DECHARGERTABLE
            FROM AGENT A
            LEFT JOIN TAS T ON A.matricule = T.agentBroyage
                AND T.etat = 1  -- Filtre pour les tas broyés
                AND YEAR(T.dateBroyage) = @currentYear  -- Année actuelle
            LEFT JOIN DECHARGERTABLE D ON A.matricule = D.agentMatricule
                AND YEAR(D.dateHeureDecharg) = @currentYear  -- Année actuelle
            GROUP BY A.matricule
            ORDER BY totalPoids ASC  -- Trier par poids total croissant pour obtenir le plus bas
        `;

        const result = await pool.request()
            .input('currentYear', sql.Int, currentYear)
            .query(query);

        if (result.recordset.length > 0) {
            const bottomAgent = result.recordset[0];
            res.json({
                matricule: bottomAgent.matricule,
                totalPoids: bottomAgent.totalPoids
            });
        } else {
            res.status(404).json({ error: 'Aucun agent n\'a broyé de tas ou déchargé de camions cette année.' });
        }
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});




module.exports = router;
