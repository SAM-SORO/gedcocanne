//Presente les autres methodes que je pouvait utiliser

//un exemple (on ne l'a pas utiliser c'est pour juste voir la maniere de proceder elle ne donne pas le resultat exact)
router.post('/agentTopBroyage', async (req, res) => {
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

        // Construction de la requête SQL
        let query = `
            SELECT TOP 1
                agentBroyage AS matricule,
                SUM(poids) AS totalPoids
            FROM TAS
            WHERE 
                etat = 1
                AND heureBroyage BETWEEN @heureDebut AND @heureFin
                AND dateBroyage = CAST(@dateNow AS DATE)
            GROUP BY agentBroyage
            ORDER BY totalPoids DESC;
        `;

        const result = await pool.request()
            .input('dateNow', sql.DateTime, dateNow)
            .input('heureDebut', sql.Int, heureDebut)
            .input('heureFin', sql.Int, heureFin)
            .query(query);

        if (result.recordset.length === 0) {
            return res.status(404).json({ error: 'Aucun tas broyé dans la plage horaire spécifiée' });
        }

        // Récupération de l'agent ayant broyé le plus
        const topAgent = result.recordset[0];

        res.json({
            matricule: topAgent.matricule,
            totalPoids: topAgent.totalPoids
        });
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

//un exemple (on ne l'a pas utiliser c'est pour juste voir la maniere de proceder elle ne donne pas le resultat exact)
router.post('/agentTopBroyage', async (req, res) => {
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
        const dateNow = new Date(); // Date actuelle

        // Requête SQL pour obtenir la somme des poids broyés dans TAS et DECHARGERTABLE
        const query = `
            SELECT TOP 1
                agentBroyage AS matricule,
                (SUM(T.poids) + ISNULL(SUM(D.poidsNet), 0)) AS totalPoids
            FROM TAS T
            LEFT JOIN DECHARGERTABLE D ON T.agentBroyage = D.agentMatricule 
            WHERE 
                T.etat = 1
                AND T.heureBroyage BETWEEN @heureDebut AND @heureFin
                AND T.dateBroyage = CAST(@dateNow AS DATE)
                AND (D.dateHeureDecharg IS NULL OR (D.dateHeureDecharg BETWEEN @heureDebut AND @heureFin))
            GROUP BY T.agentBroyage
            ORDER BY totalPoids DESC;
        `;

        const result = await pool.request()
            .input('dateNow', sql.DateTime, dateNow)
            .input('heureDebut', sql.Int, heureDebut)
            .input('heureFin', sql.Int, heureFin)
            .query(query);

        if (result.recordset.length === 0) {
            return res.status(404).json({ error: 'Aucun agent n\'a broyé de tas ou déchargé de camions dans la plage horaire spécifiée' });
        }

        // Récupération de l'agent ayant broyé le plus
        const topAgent = result.recordset[0];

        res.json({
            matricule: topAgent.matricule,
            totalPoids: topAgent.totalPoids
        });
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

//un exemple (on ne l'a pas utiliser c'est pour juste voir la maniere de proceder elle ne donne pas le resultat exact)
router.post('/agentTopBroyage', async (req, res) => {
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
        const dateNow = new Date(); // Date actuelle

        // Requête SQL pour obtenir la somme des poids broyés dans TAS et DECHARGERTABLE
        const query = `
            SELECT TOP 1
                agentBroyage AS matricule,
                (SUM(T.poids) + ISNULL(SUM(D.poidsNet), 0)) AS totalPoids
            FROM TAS T
            LEFT JOIN DECHARGERTABLE D ON T.agentBroyage = D.agentMatricule 
            WHERE 
                T.etat = 1
                AND T.heureBroyage BETWEEN @heureDebut AND @heureFin
                AND T.dateBroyage = CAST(@dateNow AS DATE)
                AND (D.dateHeureDecharg IS NULL OR (D.dateHeureDecharg BETWEEN @heureDebut AND @heureFin))
            GROUP BY T.agentBroyage
            ORDER BY totalPoids DESC;
        `;

        const result = await pool.request()
            .input('dateNow', sql.DateTime, dateNow)
            .input('heureDebut', sql.Int, heureDebut)
            .input('heureFin', sql.Int, heureFin)
            .query(query);

        if (result.recordset.length === 0) {
            return res.status(404).json({ error: 'Aucun agent n\'a broyé de tas ou déchargé de camions dans la plage horaire spécifiée' });
        }

        // Récupération de l'agent ayant broyé le plus
        const topAgent = result.recordset[0];

        res.json({
            matricule: topAgent.matricule,
            totalPoids: topAgent.totalPoids
        });
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

//un exemple (on ne l'a pas utiliser c'est pour juste voir la maniere de proceder elle ne donne pas le resultat exact)
router.post('/agentMinBroyage', async (req, res) => {
    try {
        const { heureDebut, heureFin } = req.body;

        // Validation des paramètres
        if (typeof heureDebut !== 'number' || typeof heureFin !== 'number' || heureDebut < 0 || heureDebut > 23 || heureFin < 0 || heureFin > 23) {
            return res.status(400).json({ error: 'heureDebut et heureFin doivent être des nombres entre 0 et 23' });
        }

        const pool = await poolPromise;
        const dateNow = new Date();

        let query = '';

        if (heureDebut <= heureFin) {
            // Même journée
            query = `
                SELECT agentBroyage, SUM(poids) AS totalPoids
                FROM TAS
                WHERE etat = 0
                AND CAST(dateBroyage AS DATE) = CAST(@dateNow AS DATE)
                AND heureBroyage BETWEEN @heureDebut AND @heureFin
                GROUP BY agentBroyage
                ORDER BY totalPoids ASC
                OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
            `;
        } else {
            // Débordement sur le jour suivant
            query = `
                SELECT agentBroyage, SUM(poids) AS totalPoids
                FROM TAS
                WHERE etat = 0
                AND (
                    (CAST(dateBroyage AS DATE) = CAST(@dateNow AS DATE) AND heureBroyage >= @heureDebut)
                    OR
                    (CAST(dateBroyage AS DATE) = DATEADD(DAY, 1, @dateNow) AND heureBroyage <= @heureFin)
                )
                GROUP BY agentBroyage
                ORDER BY totalPoids ASC
                OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
            `;
        }

        const result = await pool.request()
            .input('dateNow', sql.DateTime, dateNow)
            .input('heureDebut', sql.Int, heureDebut)
            .input('heureFin', sql.Int, heureFin)
            .query(query);

        if (result.recordset.length > 0) {
            const agentMinBroyage = result.recordset[0];
            res.json({
                matricule: agentMinBroyage.agentBroyage,
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


//(peut etre utiliser)
// Route pour récupérer le tonnage total de canne entrée entre deux dates
router.get('/getTonnageCanneEntreeEntreDates', async (req, res) => {
    try {
        const { dateDebut, dateFin } = req.query;

        if (!dateDebut || !dateFin) {
            return res.status(400).json({ error: 'Les paramètres dateDebut et dateFin sont requis' });
        }

        const pool = await poolPromise;

        // Requête pour récupérer la somme des poids nets dans DECHARGERCOURS entre les deux dates
        const queryCours = `
            SELECT SUM(poidsNet) AS totalPoidsNetCours
            FROM DECHARGERCOURS
            WHERE dateHeureDecharg BETWEEN @dateDebut AND @dateFin;
        `;

        // Requête pour récupérer la somme des poids nets dans DECHARGERTABLE entre les deux dates
        const queryTable = `
            SELECT SUM(poidsNet) AS totalPoidsNetTable
            FROM DECHARGERTABLE
            WHERE dateHeureDecharg BETWEEN @dateDebut AND @dateFin;
        `;

        // Exécuter les deux requêtes en parallèle
        const [resultCours, resultTable] = await Promise.all([
            pool.request()
                .input('dateDebut', sql.DateTime, new Date(dateDebut))
                .input('dateFin', sql.DateTime, new Date(dateFin))
                .query(queryCours),
            pool.request()
                .input('dateDebut', sql.DateTime, new Date(dateDebut))
                .input('dateFin', sql.DateTime, new Date(dateFin))
                .query(queryTable),
        ]);

        const totalPoidsNetCours = resultCours.recordset[0].totalPoidsNetCours || 0;
        const totalPoidsNetTable = resultTable.recordset[0].totalPoidsNetTable || 0;

        // Calculer le tonnage total
        const tonnageTotal = totalPoidsNetCours + totalPoidsNetTable;

        // Retourner le résultat en JSON
        res.json({ tonnageTotal });
    } catch (error) {
        console.error('Erreur lors de la récupération du tonnage de canne entrée entre deux dates:', error);
        res.status(500).json({ error: 'Erreur interne du serveur' });
    }
});

//(peut etre utiliser)
// Route pour obtenir l'agent qui a broyé le plus entre deux dates
router.post('/agentTopBroyageEntreDates', async (req, res) => {
    try {
        let { dateDebut, dateFin } = req.body;

        // Validation des dates
        if (!dateDebut || !dateFin) {
            return res.status(400).json({ error: 'Les paramètres dateDebut et dateFin sont requis' });
        }

        const pool = await poolPromise;

        // Requête SQL pour obtenir la somme des poids broyés dans TAS et DECHARGERTABLE
        const query = `
            SELECT TOP 1
                agentBroyage AS matricule,
                (SUM(T.poids) + ISNULL(SUM(D.poidsNet), 0)) AS totalPoids
            FROM TAS T
            LEFT JOIN DECHARGERTABLE D ON T.agentBroyage = D.agentMatricule 
            WHERE 
                T.etat = 1
                AND T.dateBroyage BETWEEN @dateDebut AND @dateFin
                AND (D.dateHeureDecharg IS NULL OR D.dateHeureDecharg BETWEEN @dateDebut AND @dateFin)
            GROUP BY T.agentBroyage
            ORDER BY totalPoids DESC;
        `;

        const result = await pool.request()
            .input('dateDebut', sql.DateTime, new Date(dateDebut))
            .input('dateFin', sql.DateTime, new Date(dateFin))
            .query(query);

        if (result.recordset.length === 0) {
            return res.status(404).json({ error: 'Aucun agent n\'a broyé de tas ou déchargé de camions dans la plage de dates spécifiée' });
        }

        // Récupération de l'agent ayant broyé le plus
        const topAgent = result.recordset[0];

        res.json({
            matricule: topAgent.matricule,
            totalPoids: topAgent.totalPoids
        });
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Erreur interne du serveur' });
    }
});

//(peut etre utiliser)
// Endpoint pour récupérer le tonnage broyé directement à partir de la table DECHARGERTABLE Entre deux dates
router.post('/tonnageBroyerDirectDates', async (req, res) => {
    try {
        let { dateDebut, dateFin } = req.body;

        // Validation des dates
        if (!dateDebut || !dateFin) {
            return res.status(400).json({ error: 'dateDebut et dateFin sont requis' });
        }

        const pool = await poolPromise;

        const query = `
            SELECT SUM(poidsNet) AS totalPoidsNet
            FROM DECHARGERTABLE
            WHERE 
            CAST(dateHeureDecharg AS DATE) BETWEEN @dateDebut AND @dateFin;
        `;

        const result = await pool.request()
            .input('dateDebut', sql.Date, dateDebut)
            .input('dateFin', sql.Date, dateFin)
            .query(query);

        const stockBroyerDirect = result.recordset[0].totalPoidsNet || 0;

        res.json({ stockBroyerDirect });
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

//(peut etre utiliser)
// Endpoint pour récupérer le tonnage broyé par tas entre deux dates
router.post('/tonnageBroyerParTasDates', async (req, res) => {
    try {
        let { dateDebut, dateFin } = req.body;

        // Validation des dates
        if (!dateDebut || !dateFin) {
            return res.status(400).json({ error: 'dateDebut et dateFin sont requis' });
        }

        const pool = await poolPromise;

        const query = `
            SELECT SUM(poids) AS totalPoidsTas
            FROM TAS
            WHERE 
            etat = 1  -- Le tas est broyé (etat = 1)
            AND CAST(dateBroyage AS DATE) BETWEEN @dateDebut AND @dateFin;
        `;

        const result = await pool.request()
            .input('dateDebut', sql.Date, dateDebut)
            .input('dateFin', sql.Date, dateFin)
            .query(query);

        const tonnageBroyerParTas = result.recordset[0].totalPoidsTas || 0;

        res.json({ tonnageBroyerParTas });
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


// Route pour récupérer le tonnage total de canne entrée pour l'année en cours 
router.get('/getTonnageCanneEntree', async (req, res) => {
    try {
        const pool = await poolPromise;
        const currentYear = new Date().getFullYear();

        // Requête pour récupérer la somme des poids nets dans DECHARGERCOURS pour l'année en cours
        const queryCours = `
            SELECT SUM(poidsNet) AS totalPoidsNetCours
            FROM DECHARGERCOURS
            WHERE YEAR(dateHeureDecharg) = @currentYear;
        `;

        // Requête pour récupérer la somme des poids nets dans DECHARGERTABLE pour l'année en cours
        const queryTable = `
            SELECT SUM(poidsNet) AS totalPoidsNetTable
            FROM DECHARGERTABLE
            WHERE YEAR(dateHeureDecharg) = @currentYear;
        `;

        // Exécuter les deux requêtes en parallèle
        const [resultCours, resultTable] = await Promise.all([
            pool.request().input('currentYear', sql.Int, currentYear).query(queryCours),
            pool.request().input('currentYear', sql.Int, currentYear).query(queryTable),
        ]);

        const totalPoidsNetCours = resultCours.recordset[0].totalPoidsNetCours || 0;
        const totalPoidsNetTable = resultTable.recordset[0].totalPoidsNetTable || 0;

        // Calculer le tonnage total
        const tonnageTotal = totalPoidsNetCours + totalPoidsNetTable;

        // Retourner le résultat en JSON
        res.json({ tonnageTotal });
    } catch (error) {
        console.error('Erreur lors de la récupération du tonnage de canne entrée:', error);
        res.status(500).json({ error: 'Erreur interne du serveur' });
    }
});


// Route pour récupérer le tonnage total de canne entrée pour le jour (on respecte les contraintes de quart)
router.get('/getTonnageCanneEntree', async (req, res) => {
    try {
        const pool = await poolPromise;

        // Calculer la date et l'heure actuelles
        const maintenant = new Date();

        // Déterminer le début de la période à 06:00 aujourd'hui
        let debutPeriode = new Date(maintenant);
        debutPeriode.setHours(6, 0, 0, 0); // Début de la période à 06:00

        // Si l'heure actuelle est avant 06:00, ajuster le début de la période à 06:00 hier
        if (maintenant < debutPeriode) {
            debutPeriode.setDate(debutPeriode.getDate() - 1); // Commencer à 06:00 le jour précédent
        }

        // Déterminer la fin de la période à 06:00 le lendemain
        const finPeriode = new Date(debutPeriode);
        finPeriode.setDate(finPeriode.getDate() + 1); // Fin de la période à 06:00 le jour suivant

        // Requête pour récupérer la somme des poids nets dans DECHARGERCOURS
        const requeteCours = `
            SELECT SUM(poidsNet) AS totalPoidsNetCours
            FROM DECHARGERCOURS
            WHERE dateHeureDecharg >= @debutPeriode AND dateHeureDecharg < @finPeriode;
        `;

        // Requête pour récupérer la somme des poids nets dans DECHARGERTABLE
        const requeteTable = `
            SELECT SUM(poidsNet) AS totalPoidsNetTable
            FROM DECHARGERTABLE
            WHERE dateHeureDecharg >= @debutPeriode AND dateHeureDecharg < @finPeriode;
        `;

        // Exécuter les deux requêtes en parallèle
        const [resultatCours, resultatTable] = await Promise.all([
            pool.request()
                .input('debutPeriode', sql.DateTime, debutPeriode)
                .input('finPeriode', sql.DateTime, finPeriode)
                .query(requeteCours),
            pool.request()
                .input('debutPeriode', sql.DateTime, debutPeriode)
                .input('finPeriode', sql.DateTime, finPeriode)
                .query(requeteTable),
        ]);

        // Extraire les résultats des requêtes
        const totalPoidsNetCours = resultatCours.recordset[0].totalPoidsNetCours || 0;
        const totalPoidsNetTable = resultatTable.recordset[0].totalPoidsNetTable || 0;

        // Calculer le tonnage total
        const tonnageTotal = totalPoidsNetCours + totalPoidsNetTable;

        // Retourner le résultat en JSON
        res.json({ tonnageTotal });
    } catch (error) {
        console.error('Erreur lors de la récupération du tonnage de canne entrée:', error);
        res.status(500).json({ error: 'Erreur interne du serveur' });
    }
});

