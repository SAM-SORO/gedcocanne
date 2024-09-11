const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données


/***********************************
AUTHENTIFICATION
***************************/


// Route pour l'authentification
router.post('/authenticate', async (req, res) => {
    const { matricule, password } = req.body;
  
    if (!matricule || !password) {
      return res.status(400).json({ message: 'Matricule et mot de passe requis' });
    }
  
    try {
      const pool = await poolPromise;
  
      // Requête SQL pour vérifier les informations d'identification
      const result = await pool.request()
          .input('matricule', sql.VarChar, matricule)
          .input('password', sql.VarChar, password)
          .query('SELECT * FROM AGENT WHERE matricule = @matricule AND password = @password');
  
      if (result.recordset.length > 0) {
  
        const agent = result.recordset[0];
        res.status(200).json({ success: true, data: {
            password: agent.password, // Remplacez par l'identifiant réel de l'agent
            matricule: agent.matricule,
            role: agent.role // Assurez-vous que le nom de la colonne est correct
        }});
  
      } else {
        res.status(401).json({ success: false, message: 'Matricule ou mot de passe incorrect' });
      }
    } catch (err) {
      console.error(err);
      res.status(500).json({ success: false, message: 'Erreur de connexion' });
    }
});


module.exports = router;
  
