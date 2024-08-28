// auth.js (nouveau fichier pour gérer les routes d'authentification)
const express = require('express');
const router = express.Router();
const { poolPromise } = require('../config');
const crypto = require('crypto');

// Fonction pour hacher les mots de passe
const hashPassword = (password) => {
    return crypto.createHash('sha256').update(password).digest('hex');
};

// Route pour l'authentification
router.post('/authenticate', async (req, res) => {
    const { matricule, password } = req.body;

    if (!matricule || !password) {
        return res.status(400).json({ message: 'Matricule et mot de passe requis' });
    }

    try {
        const pool = await poolPromise;
        const hashedPassword = hashPassword(password);

        // Requête SQL pour vérifier les informations d'identification
        const result = await pool.request()
            .input('matricule', sql.VarChar, matricule)
            .input('password', sql.VarChar, hashedPassword)
            .query('SELECT * FROM Agents WHERE Matricule = @matricule AND Password = @password');

        if (result.recordset.length > 0) {
            res.status(200).json({ message: 'Authentification réussie' });
        } else {
            res.status(401).json({ message: 'Matricule ou mot de passe incorrect' });
        }
    } catch (error) {
        console.error('Erreur d\'authentification:', error.message);
        res.status(500).json({ message: 'Erreur serveur' });
    }
});

module.exports = router;
