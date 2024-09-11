const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données



// Obtenir les camions en attente
router.get('/camionsEnAttente', async (req, res) => {
    try {
      const pool = await poolPromise;
      const query = `
        SELECT VE_CODE, PS_CODE, PS_POIDSP1, DATEHEUREP1, TECH_COUPE
        FROM F_PREMPESEE
        ORDER BY DATEHEUREP1 ASC;
      `;
      const result = await pool.request().query(query);
  
      const camionsEnAttente = result.recordset.map(row => ({
        VE_CODE: row.VE_CODE,
        PS_CODE: row.PS_CODE,
        PS_POIDSP1: row.PS_POIDSP1,
        DATEHEUREP1: row.DATEHEUREP1,
        TECH_COUPE: row.TECH_COUPE
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
        const { veCode, dateHeureP1 } = req.query;
  
        if (!veCode || !dateHeureP1) {
            return res.status(400).json({ error: 'veCode et dateHeureP1 sont requis' });
        }
  
        const pool = await poolPromise;
  
        const query = `
            SELECT TOP 1 PS_POIDSTare
            FROM F_PESEE
            WHERE VE_CODE = @veCode AND PR_CODE = '01' AND DATEHEUREP1 = @dateHeureP1
        `;
  
        const result = await pool.request()
            .input('veCode', sql.VarChar, veCode)
            .input('dateHeureP1', sql.DateTime, new Date(dateHeureP1))  // Convertir la date en type DateTime SQL
            .query(query);
  
        if (result.recordset.length > 0) {
            return res.status(200).json({ PS_POIDSTare: result.recordset[0].PS_POIDSTare });
        } else {
            return res.status(404).json({ error: 'PoidsTare introuvable' });
        }
    } catch (error) {
        console.error('Erreur lors de la récupération du poidsTare:', error);
        res.status(500).json({ error: 'Erreur interne du serveur' });
    }
});
 

module.exports = router;
