// api SyncDechargTable.js

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { sql, poolPromise } = require('../config');

const app = express();
const PORT = process.env.PORT || 1451;

// Middleware pour analyser les requêtes JSON
app.use(bodyParser.json());

// Middleware pour permettre les requêtes CORS
app.use(cors());

// Route POST pour la synchronisation des déchargements effectuer dans la table
app.post('/sync-decharg-table', async (req, res) => {
  const camions = req.body.camions;

  if (!camions || !Array.isArray(camions)) {
    return res.status(400).json({ error: 'Invalid input' });
  }

  let transaction;
  try {
    const pool = await poolPromise;
    transaction = new sql.Transaction(pool);
    await transaction.begin();

    for (const camion of camions) {
      const request = new sql.Request(transaction);

      if (camion.etatSynchronisation) {
        // Mise à jour des enregistrements existants
        await request
          .input('veCode', sql.NVarChar, camion.veCode)
          .input('poidsP2', sql.Float, camion.poidsP2 || null)
          .input('dateHeureP2', sql.DateTime, camion.dateHeureP2 || null)
          .input('poidsNet', sql.Float, camion.poidsNet || null)
          .input('dateHeureDecharg', sql.DateTime, camion.dateHeureDecharg)
          .query(`
            UPDATE DECHARGERTABLE
            SET poidsP2 = @poidsP2, dateHeureP2 = @dateHeureP2, poidsNet = @poidsNet
            WHERE veCode = @veCode AND dateHeureDecharg = @dateHeureDecharg
          `);
      } else {
        const request = new sql.Request(transaction);
        console.log(camion.poidsNet);
        console.log(camion.parcelle);
        await request
          .input('veCode', sql.NVarChar, camion.veCode)
          .input('poidsP1', sql.Decimal(10, 2), camion.poidsP1)
          .input('poidsTare', sql.Decimal(10, 2), camion.poidsTare || null)
          .input('poidsP2', sql.Decimal(10, 2), camion.poidsP2 || null)
          .input('poidsNet', sql.Decimal(10, 2), camion.poidsNet)
          .input('dateHeureP1', sql.DateTime, camion.dateHeureP1)
          .input('dateHeureP2', sql.DateTime, camion.dateHeureP2 || null)
          .input('dateHeureDecharg', sql.DateTime, camion.dateHeureDecharg)
          .input('techCoupe', sql.NVarChar, camion.techCoupe)
          .input('parcelle', sql.NVarChar, camion.parcelle || null)
          .input('matriculeAgent', sql.NVarChar, camion.matriculeAgent || null)
          .query(`
            INSERT INTO DECHARGERTABLE (veCode, poidsP1, poidsTare, poidsP2, poidsNet, dateHeureP1, dateHeureP2, dateHeureDecharg, techCoupe, parcelle, agentMatricule)
            VALUES (@veCode, @poidsP1, @poidsTare, @poidsP2, @poidsNet, @dateHeureP1, @dateHeureP2, @dateHeureDecharg, @techCoupe, @parcelle, @matriculeAgent)
          `);
      }
      
    }

    await transaction.commit();
    res.status(200).json({ message: 'Dechargement table synchronized successfully' });
  } catch (err) {
    console.error('SQL error', err);
    if (transaction) {
      await transaction.rollback();
    }
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Démarrage du serveur sur le port spécifié
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
