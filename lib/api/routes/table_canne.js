const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données

// const express = require('express');
// const sql = require('mssql');
// const { poolPromise } = require('./db'); // Assurez-vous que poolPromise est correctement exporté depuis votre fichier de configuration de base de données

// const router = express();
// router.use(express.json());

/****************************************
DECHARGEMENT TABLE
***************************************/


// Obtenir les camions déchargés dans la table (pour les 15 derniers jours)
router.get('/camionsDechargerTable', async (req, res) => {
  try {
    const pool = await poolPromise;
    const query = `
      SELECT dt.*, tc.TN_LIBELE AS libelleTypeCanne
      FROM DECHARGERTABLE dt
      LEFT JOIN F_TYPECANNE tc ON dt.TN_CODE = tc.TN_CODE
      WHERE dt.dateHeureDecharg >= DATEADD(DAY, -15, GETDATE())
      ORDER BY dt.dateHeureDecharg DESC;
    `;

    const result = await pool.request().query(query);

    const camions = result.recordset.map(row => ({
      id: row.id,
      veCode: row.veCode,
      poidsP1: row.poidsP1,
      poidsTare: row.poidsTare,
      poidsP2: row.poidsP2,
      poidsNet: row.poidsNet,
      dateHeureP1: row.dateHeureP1,
      dateHeureDecharg: row.dateHeureDecharg,
      dateHeureP2: row.dateHeureP2,
      parcelle: row.parcelle,
      techCoupe: row.techCoupe,
      agentMatricule: row.agentMatricule,
      TN_CODE: row.TN_CODE,  // Ajoute le code du type de canne
      libelleTypeCanne: row.libelleTypeCanne  // Libellé du type de canne joint
    }));

    res.json(camions);
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Obtenir les camions déchargés dans la table (pour la dernière heure)
router.get('/camionsDechargerTableDerniereHeure', async (req, res) => {
  try {
    const pool = await poolPromise;
    const query = `
      SELECT dt.*, tc.TN_LIBELE AS libelleTypeCanne
      FROM DECHARGERTABLE dt
      LEFT JOIN F_TYPECANNE tc ON dt.TN_CODE = tc.TN_CODE
      WHERE dt.dateHeureDecharg >= DATEADD(HOUR, -15, GETDATE())  -- Dernière heure
      ORDER BY dt.dateHeureDecharg DESC;
    `;

    const result = await pool.request().query(query);

    const camions = result.recordset.map(row => ({
      id: row.id,
      veCode: row.veCode,
      poidsP1: row.poidsP1,
      poidsTare: row.poidsTare,
      poidsP2: row.poidsP2,
      poidsNet: row.poidsNet,
      dateHeureP1: row.dateHeureP1,
      dateHeureDecharg: row.dateHeureDecharg,
      dateHeureP2: row.dateHeureP2,
      parcelle: row.parcelle,
      techCoupe: row.techCoupe,
      agentMatricule: row.agentMatricule,
      TN_CODE: row.TN_CODE,  // Code du type de canne
      libelleTypeCanne: row.libelleTypeCanne  // Libellé du type de canne
    }));

    res.json(camions);
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Enregistrer un camion déchargé dans la table
router.post('/enregistrerDechargementTable', async (req, res) => {
  try {
    const {
      veCode,
      poidsP1,
      techCoupe,
      parcelle,
      dateHeureP1,
      poidsTare,
      matriculeAgent,
      codeCanne
    } = req.body;

    // Calculer le poids net (si applicable) ou vous pouvez le faire ailleurs selon votre logique métier
    const poidsNet = poidsP1 - poidsTare;

    // Connexion à la base de données et exécution de la requête d'insertion
    const pool = await poolPromise;

    const query = `
      INSERT INTO DECHARGERTABLE (veCode, poidsP1, poidsTare, poidsNet, dateHeureP1, dateHeureDecharg, parcelle, techCoupe, agentMatricule,TN_CODE)

      VALUES (@veCode, @poidsP1, @poidsTare, @poidsNet, @dateHeureP1, GETDATE(), @parcelle, @techCoupe, @matriculeAgent, @codeCanne);
    `;

    await pool.request()
      .input('veCode', sql.NVarChar, veCode)
      .input('poidsP1', sql.Decimal(10, 2), poidsP1)
      .input('poidsTare', sql.Decimal(10, 2), poidsTare)
      .input('poidsNet', sql.Decimal(10, 2), poidsNet)
      .input('dateHeureP1', sql.DateTime, dateHeureP1)
      .input('parcelle', sql.NVarChar, parcelle)
      .input('techCoupe', sql.NVarChar, techCoupe)
      .input('matriculeAgent', sql.NVarChar, matriculeAgent)
      .input('codeCanne', sql.NVarChar, codeCanne)
      .query(query);

    res.status(201).json({ message: 'Camion déchargé enregistré avec succès' });
  } catch (err) {
    console.error('Erreur lors de l\'enregistrement du camion :', err);
    res.status(500).json({ error: 'Erreur interne du serveur' });
  }
});


// Supprimer un camion déchargé de la table
router.delete('/deleteCamionDechargerTable', async (req, res) => {
  try {
    const { veCode, dateHeureDecharg } = req.body;

    const pool = await poolPromise;
    const query = `
      DELETE FROM DECHARGERTABLE
      WHERE veCode = @veCode AND dateHeureDecharg = @dateHeureDecharg
    `;

    const result = await pool.request()
      .input('veCode', sql.NVarChar, veCode)
      .input('dateHeureDecharg', sql.DateTime, dateHeureDecharg)
      .query(query);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json({ message: 'Camion supprimé avec succès' });
    } else {
      res.status(404).json({ error: 'Camion non trouvé' });
    }
  } catch (err) {
    console.error('Erreur lors de la suppression du camion:', err);
    res.status(500).json({ error: 'Erreur interne du serveur' });
  }
});

module.exports = router;
