const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données

// Les camions dans la table DECHARGERCOURS dont le poids de la deuxième pesée n'est pas encore disponible
router.get('/camionsP2NullCours', async (req, res) => {
  try {
    const pool = await poolPromise;

    // Requête pour récupérer les camions avec poidsP2 NULL dans DECHARGERCOURS  on aurra besoin de l'Id de la linggne
    const result = await pool.request()
      .query(`
        SELECT veCode, dateHeureP1, poidsP1, ligneId
        FROM DECHARGERCOURS
        WHERE poidsP2 IS NULL
      `);

    res.json(result.recordset);
  } catch (err) {
    console.error('SQL error', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Les camions dans la table DECHARGERTABLE dont le poids de la deuxième pesée n'est pas encore disponible
router.get('/camionsP2NullTable', async (req, res) => {
  try {
    const pool = await poolPromise;

    // Requête pour récupérer les camions avec poidsP2 NULL dans DECHARGERTABLE
    const result = await pool.request()
      .query(`
        SELECT veCode, dateHeureP1, poidsP1
        FROM DECHARGERTABLE
        WHERE poidsP2 IS NULL
      `);

    res.json(result.recordset);
  } catch (err) {
    console.error('SQL error', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Mettre à jour le poids P2 (poids de la deuxième pesée) dans DECHARGERCOURS
router.post('/updatePoidsP2Cours', async (req, res) => {
  try {
    const { camions } = req.body;

    if (!camions || !Array.isArray(camions)) {
      return res.status(400).json({ error: 'Invalid input' });
    }

    const pool = await poolPromise;

    // Collecte des IDs de lignes distinctes
    const ligneIds = new Set();

    const updatePromises = camions.map(camion => {
      const { veCode, dateHeureP1, poidsP2, ligneId } = camion;
      //console.log(ligneId, typeof(ligneId));
      ligneIds.add(ligneId);

      // Mise à jour du poidsP2 et recalcul du poidsNet
      return pool.request()
        .input('veCode', sql.VarChar, veCode)
        .input('dateHeureP1', sql.DateTime, new Date(dateHeureP1))
        .input('poidsP2', sql.Decimal, poidsP2)
        .query(`
          UPDATE DECHARGERCOURS
          SET poidsP2 = @poidsP2, 
              poidsNet = poidsP1 - @poidsP2
          WHERE veCode = @veCode AND dateHeureP1 = @dateHeureP1
        `);
    });

    //console.log('ffx');


    await Promise.all(updatePromises);
    
    // Mise à jour des lignes distinctes et répartition du tonnage
    const ligneUpdatePromises = Array.from(ligneIds).map(async ligneId => {
      // Calculer le tonnage total de la ligne
      const result = await pool.request()
        .input('ligneId', sql.Int, ligneId)
        .query(`
          SELECT SUM(poidsNet) AS totalTonnage
          FROM DECHARGERCOURS
          WHERE ligneId = @ligneId
        `);

      const totalTonnage = result.recordset[0].totalTonnage || 0;

      //console.log(totalTonnage);

      // Mettre à jour le tonnage de la ligne
      await pool.request()
        .input('ligneId', sql.Int,ligneId)
        .input('tonnageLigne', sql.Decimal, totalTonnage)
        .query(`
          UPDATE LIGNE
          SET tonnageLigne = @tonnageLigne
          WHERE id = @ligneId
        `);

      // Répartir le poids total de la ligne sur les tas
      const tasResult = await pool.request()
        .input('ligneId', sql.Int,ligneId)
        .query(`
          SELECT id FROM TAS WHERE ligneId = @ligneId
        `);

      const tasList = tasResult.recordset;
      const poidsParTas = totalTonnage / tasList.length;

      const tasUpdatePromises = tasList.map(async tas => {
        await pool.request()
          .input('tasId', sql.Int, tas.id)
          .input('poids', sql.Decimal(10,2), poidsParTas)
          .query(`
            UPDATE TAS
            SET poids = @poids
            WHERE id = @tasId
          `);
      });

      await Promise.all(tasUpdatePromises);
    });

    await Promise.all(ligneUpdatePromises);

    res.status(200).json({ updated: true });
  } catch (err) {
    console.error('SQL error', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Mettre à jour le poids P2 (poids de la deuxième pesée) dans DECHARGERTABLE
router.post('/updatePoidsP2Table', async (req, res) => {
  try {
    const { camions } = req.body;

    if (!camions || !Array.isArray(camions)) {
      return res.status(400).json({ error: 'Invalid input' });
    }

    const pool = await poolPromise;
    const updatePromises = camions.map(camion => {
      const { veCode, dateHeureP1, poidsP2 } = camion;

      // Mise à jour du poidsP2 et recalcul du poidsNet
      return pool.request()
        .input('veCode', sql.VarChar, veCode)
        .input('dateHeureP1', sql.DateTime, new Date(dateHeureP1))
        .input('poidsP2', sql.Decimal, poidsP2)
        .query(`
          UPDATE DECHARGERTABLE
          SET poidsP2 = @poidsP2, 
              poidsNet = poidsP1 - @poidsP2  -- Calcul du poidsNet
          WHERE veCode = @veCode AND dateHeureP1 = @dateHeureP1
        `);
    });

    await Promise.all(updatePromises);

    res.status(200).json({ updated: true });
  } catch (err) {
    console.error('SQL error', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Vérifier s'il y a des camions pour lesquels le poids de la deuxième pesée n'est pas disponible
router.get('/checkPoidsP2Null', async (req, res) => {
  try {
    const pool = await poolPromise;
    const resultCours = await pool.request()
      .query('SELECT TOP 1 1 AS found FROM DECHARGERCOURS WHERE poidsP2 IS NULL');

    const resultTables = await pool.request()
    .query('SELECT TOP 1 1 AS found FROM DECHARGERTABLE WHERE poidsP2 IS NULL');

    const needsUpdate = resultCours.recordset.length > 0 || resultTables.recordset.length > 0 ;

    res.status(200).json({ needsUpdate: needsUpdate });
  } catch (err) {
    console.error('SQL error', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


module.exports = router;




// Mettre à jour le poids P2, tonnage des lignes et répartition des poids des tas
// router.post('/updatePoidsP2Cours', async (req, res) => {
//   try {
//     const { camions } = req.body;

//     if (!camions || !Array.isArray(camions)) {
//       return res.status(400).json({ error: 'Invalid input' });
//     }

//     const pool = await poolPromise;

//     // Mise à jour des poidsP2 et recalcul du poidsNet pour chaque camion
//     const updatePromises = camions.map(async camion => {
//       const { veCode, dateHeureP1, poidsP2, ligneId } = camion;

//       // Mettre à jour le poidsP2 et recalculer le poidsNet
//       await pool.request()
//         .input('veCode', sql.VarChar, veCode)
//         .input('dateHeureP1', sql.DateTime, new Date(dateHeureP1))
//         .input('poidsP2', sql.Decimal, poidsP2)
//         .query(`
//           UPDATE DECHARGERCOURS
//           SET poidsP2 = @poidsP2, 
//               poidsNet = poidsP1 - @poidsP2
//           WHERE veCode = @veCode AND dateHeureP1 = @dateHeureP1
//         `);

//       // Calculer le tonnage total de la ligne
//       const result = await pool.request()
//         .input('ligneId', sql.Int, ligneId)
//         .query(`
//           SELECT SUM(poidsNet) AS totalTonnage
//           FROM DECHARGERCOURS
//           WHERE ligneId = @ligneId
//         `);

//       const totalTonnage = result.recordset[0].totalTonnage || 0;

//       // Mettre à jour le tonnage de la ligne
//       await pool.request()
//         .input('ligneId', sql.Int, ligneId)
//         .input('tonnageLigne', sql.Decimal, totalTonnage)
//         .query(`
//           UPDATE LIGNE
//           SET tonnageLigne = @tonnageLigne
//           WHERE id = @ligneId
//         `);

//       // Répartir le poids total de la ligne sur les tas
//       const tasResult = await pool.request()
//         .input('ligneId', sql.Int, ligneId)
//         .query(`
//           SELECT id FROM TAS WHERE ligneId = @ligneId
//         `);

//       const tasList = tasResult.recordset;
//       const poidsParTas = totalTonnage / tasList.length;

//       const tasUpdatePromises = tasList.map(async tas => {
//         await pool.request()
//           .input('tasId', sql.Int, tas.id)
//           .input('poids', sql.Decimal, poidsParTas)
//           .query(`
//             UPDATE TAS
//             SET poids = @poids
//             WHERE id = @tasId
//           `);
//       });

//       await Promise.all(tasUpdatePromises);
//     });

//     await Promise.all(updatePromises);

//     res.status(200).json({ updated: true });
//   } catch (err) {
//     console.error('SQL error', err);
//     res.status(500).json({ error: 'Internal Server Error' });
//   }
// });
