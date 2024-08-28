// api getCamionAttente.js

const express = require('express');      // Framework web pour Node.js
const cors = require('cors');            // Middleware pour activer CORS (Cross-Origin Resource Sharing)
const bodyParser = require('body-parser'); // Middleware pour parser les requêtes HTTP
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données depuis config.js

// Initialisation de l'application Express
const app = express();
const PORT = process.env.PORT || 1449;  // Port sur lequel l'application écoutera

// Utiliser body-parser pour parser les requêtes JSON
app.use(bodyParser.json());
// Utiliser cors pour activer CORS
app.use(cors());

// Définir une route pour obtenir les camions en attente
app.get('/camionsEnAttente', async (req, res) => {
    try {
        const pool = await poolPromise;
        const query = `
            SELECT VE_CODE, PS_POIDSP1, PS_POIDSTare, DATEHEUREP1, TECH_COUPE
            FROM F_PREMPESEE
            ORDER BY DATEHEUREP1 ASC;
        `;
        const result = await pool.request().query(query);


        const camionsEnAttente = result.recordset.map(row => ({
            VE_CODE: row.VE_CODE,
            PS_POIDSP1: row.PS_POIDSP1,
            PS_POIDSTare: row.PS_POIDSTare,
            DATEHEUREP1: row.DATEHEUREP1,
            TECH_COUPE: row.TECH_COUPE
        }));

        res.json(camionsEnAttente);
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

// Démarrer le serveur et écouter sur le port spécifié
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
