// api SyncAgent.js

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { sql, poolPromise } = require('../config');

const app = express();
const PORT = process.env.PORT || 1444;


// Middleware pour analyser les requêtes JSON
app.use(bodyParser.json());

// Middleware pour permettre les requêtes CORS (Cross-Origin Resource Sharing)
app.use(cors());

// Route POST pour la synchronisation des agents
// Route POST pour la synchronisation des agents
app.post('/sync-agents', async (req, res) => {
    const agents = req.body.agents;
  
    if (!agents || !Array.isArray(agents)) {
      return res.status(400).json({ error: 'Invalid input' });
    }
  
    let transaction;
    try {
      const pool = await poolPromise;
      transaction = new sql.Transaction(pool);
      await transaction.begin();
  
      for (const agent of agents) {
        const request = new sql.Request(transaction);

        //console.log('etatSynchronisation:', agent.etatSynchronisation, typeof agent.etatSynchronisation);
        //console.log('etatModification:', agent.etatModification, typeof agent.etatModification);

        if (agent.etatSynchronisation == true) {

          //console.log(agent.matricule);

          // Mise à jour des agents existants
          await request
            .input('matricule', sql.NVarChar, agent.matricule)
            .input('password', sql.NVarChar, agent.password)
            .input('role', sql.NVarChar, agent.role)
            .query(`
              UPDATE AGENT
              SET password = @password, role = @role
              WHERE matricule = @matricule
            `);
        } else {
          //console.log("la");

          // Insertion de nouveaux agents
          await request
            .input('matricule', sql.NVarChar, agent.matricule)
            .input('password', sql.NVarChar, agent.password)
            .input('role', sql.NVarChar, agent.role)
            .query(`
              INSERT INTO AGENT (matricule, password, role)
              VALUES (@matricule, @password, @role)
            `);
        }
      }
  
      await transaction.commit();
      res.status(200).json({ message: 'Agents synchronized successfully' });
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
