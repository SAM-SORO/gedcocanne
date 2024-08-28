// api getPoidsTare.js

const express = require('express');      // Framework web pour Node.js
const cors = require('cors');            // Middleware pour activer CORS (Cross-Origin Resource Sharing)
const bodyParser = require('body-parser'); // Middleware pour parser les requêtes HTTP
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données depuis config.js

// Initialisation de l'application Express
const app = express();
const PORT = process.env.PORT || 1450;  // Port sur lequel l'application écoutera

// Utiliser body-parser pour parser les requêtes JSON
app.use(bodyParser.json());
// Utiliser cors pour activer CORS
app.use(cors());

// Route pour récupérer le poidsTare d'un camion spécifique
app.get('/poidsTare', async (req, res) => {
    try {
        // Obtenir les paramètres veCode et dateHeureP1 depuis la requête
        const { veCode, dateHeureP1 } = req.query;

        // Assurer que veCode et dateHeureP1 sont fournis
        if (!veCode || !dateHeureP1) {
            return res.status(400).json({ error: 'veCode et dateHeureP1 sont requis' });
        }

        const pool = await poolPromise; // Attendre que le pool de connexions soit disponible

        // Requête SQL pour récupérer le dernier poidsTare
        const query = `
            SELECT TOP 1 PS_POIDSTare
            FROM F_PESEE
            WHERE VE_CODE = @veCode
            ORDER BY DATEHEUREP1 DESC;
        `;

        // Préparer et exécuter la requête
        const result = await pool.request()
            .input('veCode', sql.NVarChar, veCode)
            .query(query);

        // Vérifier si un résultat a été trouvé
        if (result.recordset.length > 0) {
            const poidsTare = result.recordset[0].PS_POIDSTare;
            res.json({ PS_POIDSTare: poidsTare });
        } else {
            res.status(404).json({ error: 'PoidsTare non trouvé pour ce camion' });
        }
    } catch (err) {
        // En cas d'erreur, afficher l'erreur et envoyer une réponse d'erreur au client
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

// Démarrer le serveur et écouter sur le port spécifié
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
