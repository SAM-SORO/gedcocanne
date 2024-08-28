// config.js

// Importer le module mssql avec le pilote msnodesqlv8 pour se connecter à SQL Server
const sql = require('mssql/msnodesqlv8');

// Configuration de la connexion à la base de données SQL Server
const dbConfig = {
    server: 'HP-SORO\\SQLEXPRESS',  // Nom du serveur et de l'instance SQL Server
    database: 'cocages',             // Nom de la base de données
    driver: 'msnodesqlv8',           // Utiliser le pilote msnodesqlv8
    options: {
        trustedConnection: true,     // Utiliser l'authentification Windows
        // Utiliser SSL pour la connexion si nécessaire
        //trustServerCertificate: true // Ignorer les erreurs de certificat SSL si nécessaire
    }
};

// Création d'un pool de connexions promis pour gérer les connexions à la base de données
const poolPromise = new sql.ConnectionPool(dbConfig)
    .connect()
    .then(pool => {
        console.log('Connected to MSSQL'); // Message de succès de la connexion
        return pool;                      // Retourner le pool de connexions
    })
    .catch(err => {
        console.error('Database connection failed:', err.message); // Message d'erreur en cas d'échec de connexion
        process.exit(1);                  // Terminer le processus en cas d'échec
    });

// Exporter le module sql et le pool de connexions promis pour les utiliser dans d'autres fichiers
module.exports = {
    sql,
    poolPromise
};
