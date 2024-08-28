// api getPoidsP2.js

// Importer les modules nécessaires
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données depuis config.js

// Initialiser l'application Express
const app = express();
const PORT = process.env.PORT || 1445; // Utiliser un port configurable via les variables d'environnement ou le port 1445 par défaut

// Middleware pour parser les requêtes JSON
app.use(bodyParser.json());
// Middleware pour activer CORS (Cross-Origin Resource Sharing)
app.use(cors());

// Route pour obtenir le poids P2 des camions
app.post('/poidsP2', async (req, res) => {
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
      const { veCode, dateHeureP1 } = camion;

      const result = await pool.request()
        .input('veCode', sql.VarChar, veCode)
        .input('dateHeureP1', sql.DateTime, new Date(dateHeureP1)) // Conversion de la chaîne de date en objet Date
        .query(`
          SELECT VE_CODE, DATEHEUREP1, PS_POIDSP2
          FROM F_PESEE
          WHERE VE_CODE = @veCode
            AND DATEHEUREP1 = @dateHeureP1
        `);

      // Ajouter les résultats à la liste si des données sont trouvées
      if (result.recordset.length > 0) {
        poidsP2Data.push({
          veCode: result.recordset[0].VE_CODE,
          dateHeureP1: result.recordset[0].DATEHEUREP1,
          poidsP2: result.recordset[0].PS_POIDSP2
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

// Démarrer le serveur et écouter sur le port spécifié
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
