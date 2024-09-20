const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../configGespont'); // Importer la configuration de la base de données



// Obtenir les camions en attente
router.get('/camionsEnAttente', async (req, res) => {
    try {
        const pool = await poolPromise;
        const query = `
            SELECT 
                f.VE_CODE, 
                f.PR_CODE, 
                f.TN_CODE, 
                t.TN_LIBELE, -- Libellé du type de canne
                f.PS_CODE, 
                f.PS_TECH_COUPE, 
                f.PS_POIDSP1, 
                f.PS_DATEHEUREP1
            FROM F_PREMPESEE f
            JOIN F_TYPECANNE t ON f.TN_CODE = t.TN_CODE -- Jointure avec la table F_TYPECANNE
            WHERE f.PR_CODE = '1'
            ORDER BY f.PS_DATEHEUREP1 ASC;
        `;
        const result = await pool.request().query(query);

        const camionsEnAttente = result.recordset.map(row => ({
            VE_CODE: row.VE_CODE,
            PR_CODE: row.PR_CODE,
            TN_CODE: row.TN_CODE,
            TN_LIBELE: row.TN_LIBELE, // Ajout du libellé du type de canne
            PS_CODE: row.PS_CODE,
            PS_TECH_COUPE: row.PS_TECH_COUPE,
            PS_POIDSP1: row.PS_POIDSP1,
            PS_DATEHEUREP1: row.PS_DATEHEUREP1
        }));

        res.json(camionsEnAttente);

    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});




// Route pour récupérer le poidsTare d'un camion spécifique
router.get('/getPoidsTare', async (req, res) => {
    try {
        const { veCode } = req.query;

        if (!veCode) {
            return res.status(400).json({ error: 'veCode est requis' });
        }

        const pool = await poolPromise;

        const query = `
            SELECT TOP 1 PS_POIDSP2 FROM F_PESEE WHERE VE_CODE = @veCode AND PR_CODE = 1 AND PS_POIDSP2 IS NOT NULL
            ORDER BY PS_DATEHEUREP1 DESC;
        `;

        const result = await pool.request()
            .input('veCode', sql.VarChar, veCode)
            .query(query);

        if (result.recordset.length > 0) {
            return res.status(200).json({ PS_POIDSP2: result.recordset[0].PS_POIDSP2 });
        } else {
            return res.status(404).json({ error: 'Poids de la dernière tare introuvable' });
        }
    

    } catch (error) {
        console.error('Erreur lors de la récupération du poids de la derniere tare:', error);
        res.status(500).json({ error: 'Erreur interne du serveur' });
    }
});
 


// Route pour obtenir le poids P2 des camions
router.post('/getPoidsP2', async (req, res) => {
    // Récupérer la liste des camions depuis le corps de la requête
    const camions = req.body.camions;

    // Vérifier que la liste des camions est valide
    if (!camions || !Array.isArray(camions)) {
        return res.status(400).json({ error: 'Invalid input' });
    }

    try {
        // Obtenir le pool de connexions à la base de données
        const pool = await poolPromise;
        const poidsP2Data = [];

        // Préparer et exécuter les requêtes SQL pour chaque camion
        for (const camion of camions) {
            const { veCode, dateHeureP1, ligneId } = camion;
            
            // Conversion de la date en ISO 8601
            const formattedDate = new Date(dateHeureP1).toISOString();

            const result = await pool.request()
                .input('veCode', sql.VarChar, veCode)
                .input('dateHeureP1', sql.DateTime, formattedDate) // Utiliser la date en format ISO 8601
                .query(`
                    SELECT VE_CODE, PS_DATEHEUREP1, PS_POIDSP2
                    FROM F_PESEE
                    WHERE VE_CODE = @veCode AND PR_CODE = 01
                      AND PS_DATEHEUREP1 = @dateHeureP1
                `);

            // Ajouter les résultats à la liste si des données sont trouvées
            if (result.recordset.length > 0) {
                poidsP2Data.push({
                    veCode: result.recordset[0].VE_CODE,
                    dateHeureP1: result.recordset[0].PS_DATEHEUREP1,
                    poidsP2: result.recordset[0].PS_POIDSP2,
                    ligneId: ligneId,
                });
            }
        }
        // Envoyer les résultats au client
        res.json(poidsP2Data);
    } catch (err) {
        // En cas d'erreur SQL, afficher l'erreur dans la console et renvoyer une réponse d'erreur 500
        console.error('SQL error', err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


module.exports = router;
