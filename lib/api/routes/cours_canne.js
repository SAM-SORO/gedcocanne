const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données


/****************************************
DECHARGEMENT COURS
***************************************/

// Route pour obtenir les camions déchargés dans la cour des 15 derniers jours
router.get('/camionsDechargerCours', async (req, res) => {
  try {
    const pool = await poolPromise;
    const query = `
      SELECT 
        id, veCode, poidsP1, poidsTare, poidsP2, 
        poidsNet, dateHeureP1, dateHeureDecharg, dateHeureP2, 
        parcelle, techCoupe, agentMatricule, etatBroyage, ligneLibele
      FROM 
        DECHARGERCOURS
      WHERE 
        dateHeureDecharg >= DATEADD(DAY, -1, GETDATE()) -- Dernières 24 heures
      ORDER BY 
        dateHeureDecharg DESC;
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
      etatBroyage: row.etatBroyage,
      ligneLibele: row.ligneLibele
    }));

    res.json(camions);
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Route pour obtenir les camions déchargés dans la cour des 5 dernières heures avec etatBroyage = 0
router.get('/camionsDechargerCoursDerniereHeure', async (req, res) => {
  try {
    const pool = await poolPromise;
    const query = `
      SELECT 
        id, veCode, poidsP1, poidsTare, poidsP2, 
        poidsNet, dateHeureP1, dateHeureDecharg, dateHeureP2, 
        parcelle, techCoupe, agentMatricule, etatBroyage, ligneLibele
      FROM 
        DECHARGERCOURS
      WHERE 
        dateHeureDecharg >= DATEADD(DAY, -1, GETDATE()) -- Dernières 24 heures
        AND etatBroyage = 0
      ORDER BY 
        dateHeureDecharg DESC;
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
      etatBroyage: row.etatBroyage,
      ligneLibele: row.ligneLibele
    }));

    res.json(camions);
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


///////ENREGSTRER UN DECHARGEMENT DANS LA COURS
// Route pour enregistrer un camion déchargé dans la cour
router.post('/enregistrerDechargementCours', async (req, res) => {
  try {
    const {
      veCode,
      poidsP1,
      poidsTare,
      techCoupe,
      parcelle,
      dateHeureP1,
      ligneLibele,
      ligneId,  // Nouveau champ ajouté
      matriculeAgent,
      etatBroyage,
      codeCanne
    } = req.body;

    // Vérifier la présence de tous les champs requis
    if (!veCode || !poidsP1 || !poidsTare || !techCoupe || !parcelle || !dateHeureP1 || !ligneLibele || !ligneId || !matriculeAgent || etatBroyage === undefined) {
      return res.status(400).send({ success: false, message: 'Champs requis manquants.' });
    }

    // Calculer le poidsNet
    const poidsNet = poidsP1 - poidsTare;

    // Connexion à la base de données
    const pool = await poolPromise;

    // Requête SQL modifiée pour inclure ligneId
    const query = `
      INSERT INTO DECHARGERCOURS (veCode, poidsP1, poidsTare, poidsP2, poidsNet, dateHeureP1, dateHeureDecharg, dateHeureP2, parcelle, techCoupe, agentMatricule, etatBroyage, ligneLibele, ligneId, TN_CODE)
      VALUES (@veCode, @poidsP1, @poidsTare, NULL, @poidsNet, @dateHeureP1, GETDATE(), NULL, @parcelle, @techCoupe, @agentMatricule, @etatBroyage, @ligneLibele, @ligneId, @codeCanne);
    `;

    // Exécution de la requête SQL
    await pool.request()
      .input('veCode', sql.NVarChar, veCode)
      .input('poidsP1', sql.Decimal(10, 2), poidsP1)
      .input('poidsTare', sql.Decimal(10, 2), poidsTare)
      .input('poidsNet', sql.Decimal(10, 2), poidsNet)
      .input('dateHeureP1', sql.DateTime, dateHeureP1)
      .input('parcelle', sql.NVarChar, parcelle)
      .input('techCoupe', sql.NVarChar, techCoupe)
      .input('agentMatricule', sql.NVarChar, matriculeAgent)
      .input('etatBroyage', sql.Bit, etatBroyage)
      .input('ligneLibele', sql.NVarChar, ligneLibele) // Utilisation du libellé pour référence
      .input('ligneId', sql.Int, ligneId) // Nouveau champ ligneId ajouté
      .input('codeCanne', sql.NVarChar, codeCanne)
      .query(query);

    res.status(201).send({ success: true, message: 'Camion enregistré dans la cour.' });

  } catch (error) {
    console.error('Erreur lors de l\'enregistrement:', error); // Ajout de logs pour les erreurs
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

/***********************************
AFFECTATION
***************************/

// Route pour récupérer les camions affectés à une ligne spécifique

// Route pour récupérer les camions affectés à une ligne spécifique

router.post('/getCamionsOfLigne', async (req, res) => {
  try {
    const { ligneId } = req.body;

    if (!ligneId) {
      return res.status(400).json({ error: 'Invalid request parameters' });
    }

    const pool = await poolPromise;

    const query = `
      SELECT dc.*, tc.TN_LIBELE AS libelleTypeCanne
      FROM DECHARGERCOURS dc
      LEFT JOIN F_TYPECANNE tc ON dc.TN_CODE = tc.TN_CODE
      WHERE dc.ligneId = @ligneId AND dc.etatBroyage = 0
      ORDER BY dc.dateHeureDecharg DESC;
    `;

    const result = await pool.request()
      .input('ligneId', sql.Int, ligneId)
      .query(query);

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'No camions found for the given ligneId' });
    }

    // Renvoie toute la liste des camions avec le libellé du type de canne
    res.status(200).json(result.recordset);

  } catch (err) {
    //console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// router.post('/getCamionsOfLigne', async (req, res) => {
//   try {
//     const {ligneId} = req.body;  

//     if (!ligneId) {
//       return res.status(400).json({ error: 'Invalid request parameters' });
//     }

//     const pool = await poolPromise;

//     const query = `
//       SELECT *
//       FROM DECHARGERCOURS
//       WHERE ligneId = @ligneId AND etatBroyage = 0;
//     `;

//     const result = await pool.request()
//       .input('ligneId', sql.Int, ligneId)  
//       .query(query);

//     if (result.recordset.length === 0) {
//       return res.status(404).json({ error: 'No camions found for the given ligneId' });
//     }

//     // Renvoie toute la liste des camions
//     res.status(200).json(result.recordset);  

//   } catch (err) {
//     //console.error('SQL error:', err.message);
//     res.status(500).json({ error: 'Internal Server Error' });
//   }
// });



// Route pour supprimer un camion de la table DECHARGERCOURS
router.delete('/deleteCamionDechargerCours', async (req, res) => {
  try {
    const { veCode, dateHeureP1 } = req.body;

    if (!veCode || !dateHeureP1) {
      return res.status(400).json({ error: 'Invalid request parameters' });
    }

    const pool = await poolPromise;

    //supprimer le camions
    const deleteQuery = `
      DELETE FROM DECHARGERCOURS 
      WHERE veCode = @veCode AND dateHeureP1 = @dateHeureP1;
    `;

    const result = await pool.request()
      .input('veCode', sql.NVarChar, veCode)
      .input('dateHeureP1', sql.DateTime, dateHeureP1)
      .query(deleteQuery);

    if (result.rowsAffected[0] > 0) {
      res.status(200).json({ success: true, message: 'Camion supprimé avec succès.' });
    } else {
      res.status(404).json({ error: 'Camion non trouvé.' });
    }
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



router.post('/verifierAffectationLigne', async (req, res) => {
  try {
    
    const { ligneId } = req.body;   

    // Obtenir une connexion à la base de données à partir du pool
    const pool = await poolPromise;

    // Requête SQL pour vérifier s'il existe au moins un camion avec etatBroyage = 0 pour la ligne donnée
    const result = await pool.request()
    .input('ligneId', sql.Int, ligneId)
    .query(`
      IF EXISTS (
        SELECT 1 
        FROM DECHARGERCOURS 
        WHERE ligneId = @ligneId 
          AND etatBroyage = 0
      )
      SELECT 1 AS hasCamions
      ELSE
      SELECT 0 AS hasCamions
    `);

    // Renvoyer true si un camion est trouvé, sinon false
    const hasCamions = result.recordset[0]['hasCamions'] === 1;
      
    res.status(200).json(hasCamions);
  } catch (error) {
    console.error('Erreur lors de la vérification de l\'affectation de la ligne:', error);
    res.status(500).json(false);
  }
});



// Route pour vérifier l'affectation de camions à une ligne spécifique
// router.post('/verifierAffectationLigne', async (req, res) => {
//   try {
//     const { ligneLibele } = req.body;

//     // Obtenir une connexion à la base de données à partir du pool
//     const pool = await poolPromise;
    
//     // Requête SQL pour vérifier s'il existe des camions avec etatBroyage = 0 pour la ligne donnée
//     const result = await pool.request()
//       .input('ligneLibele', sql.VarChar, ligneLibele)
//       .query('SELECT COUNT(*) AS count FROM DECHARGERCOURS WHERE ligneLibele = @ligneLibele AND etatBroyage = 0');

//     // Si le nombre de camions est supérieur à 0, renvoyer true, sinon false
//     const hasCamions = result.recordset[0].count > 0;
//     res.status(200).json(hasCamions);
//   } catch (error) {
//     console.error('Erreur lors de la vérification de l\'affectation de la ligne:', error);
//     res.status(500).json(false);
//   }
// });


module.exports = router;
