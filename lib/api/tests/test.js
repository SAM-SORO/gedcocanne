/*
const express = require('express');
const sql = require('mssql/msnodesqlv8');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = process.env.PORT || 1444;

const dbConfig = {
    server: 'HP-SORO\\SQLEXPRESS',
    database: 'gedcocanne',
    driver: 'msnodesqlv8',
    options: {
      trustedConnection: true,
      encrypt: true, // Utiliser SSL pour la connexion si nécessaire
      //trustServerCertificate: true // Ignorer les erreurs de certificat SSL
    }
};

app.use(bodyParser.json());
app.use(cors());

sql.connect(dbConfig, (err) => {
  if (err) {
    console.log('Database connection failed:', err);
  } else {
    console.log('Connected to MSSQL');
  }
});

// Définir une route pour obtenir les camions en attente
app.get('/camionsEnAttente', async (req, res) => {
  try {
    const pool = await sql.connect(dbConfig);
    // Préparer une requête SQL pour récupérer les camions en attente
    const query = `
      SELECT VE_CODE, PS_POIDSP1, PS_POIDSTare, DATEHEUREP1, TECH_COUPE
      FROM F_PREMPESEE
      WHERE STATUT = 'EN ATTENTE' -- Ajouter une condition pour filtrer les camions en attente
    `;

    // Exécuter la requête SQL
    const result = await pool.request().query(query);

    // Mapper les résultats pour les renvoyer dans un format JSON
    const camionsEnAttente = result.recordset.map(row => ({
      VE_CODE: row.VE_CODE, // Code du véhicule
      PS_POIDSP1: row.PS_POIDSP1, // Poids P1
      PS_POIDSTare: row.PS_POIDSTare, // Poids à vide
      DATEHEUREP1: row.DATEHEUREP1, // Date et heure de la pesée P1
      TECH_COUPE: row.TECH_COUPE // Technique de coupe
    }));

    // Envoyer les résultats au client
    res.json(camionsEnAttente);
  } catch (err) {
    // En cas d'erreur, afficher l'erreur et envoyer une réponse d'erreur au client
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Démarrer le serveur et écouter sur le port spécifié
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});


*/