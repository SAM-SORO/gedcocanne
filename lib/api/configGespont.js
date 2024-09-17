// code du fichier configGespont.js

// Importer le module mssql avec le pilote msnodesqlv8 pour se connecter à SQL Server
const sql = require('mssql/msnodesqlv8');

// Configuration de la connexion à la base de données SQL Server
// const dbConfig = {
//     server: 'HP-SORO\\SQLEXPRESS',  // Nom du serveur et de l'instance SQL Server
//     database: 'DB_GESPONT_FK',             // Nom de la base de données
//     driver: 'msnodesqlv8',           // Utiliser le pilote msnodesqlv8
//     options: {
//         trustedConnection: true,     // Utiliser l'authentification Windows
//         // Utiliser SSL pour la connexion si nécessaire
//         //trustServerCertificate: true // Ignorer les erreurs de certificat SSL si nécessaire
//     }
// };

//si on a des erreurs de source de donnee ODBC on peut simplement utiliser ça
const dbConfig = {
    connectionString: 'Driver={ODBC Driver 17 for SQL Server};Server=HP-SORO\\SQLEXPRESS;Database=DB_GESPONT_FK;Trusted_Connection=yes'
};

// const dbConfig= {
//     connectionString: 'Driver={ODBC Driver 17 for SQL Server};Server=HP-SORO\\SQLEXPRESS;Database=gedcocanne;UID=dsf;PWD=dsqcdvqsfs;Trusted_Connection=no'
// };


// Création d'un pool de connexions promis pour gérer les connexions à la base de données
const poolPromise = new sql.ConnectionPool(dbConfig)
    .connect()
    .then(pool => {
        console.log('Connected to gespont'); // Message de succès de la connexion
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
