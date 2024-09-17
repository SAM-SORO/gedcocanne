// code du fichier config.js

// Importer le module mssql avec le pilote msnodesqlv8 pour se connecter à SQL Server
const sql = require('mssql/msnodesqlv8');

// Configuration de la connexion à la base de données SQL Server 
//on peut rencontrer des erreurs de pilotes ODBC
// const dbConfig = {
//     server: 'HP-SORO\\SQLEXPRESS',  // Nom du serveur et de l'instance SQL Server
//     database: 'gedcocanne',             // Nom de la base de données
//     driver: 'msnodesqlv8',           // Utiliser le pilote msnodesqlv8
//     options: {
//         trustedConnection: true,     // Utiliser l'authentification Windows
//         // Utiliser SSL pour la connexion si nécessaire
//         //trustServerCertificate: true // Ignorer les erreurs de certificat SSL si nécessaire
//     }
// };

//si on a des erreurs de source de donnee ODBC
const dbConfig = {
    connectionString: 'Driver={ODBC Driver 17 for SQL Server};Server=HP-SORO\\SQLEXPRESS;Database=gedcocanne;Trusted_Connection=yes'
};


// const dbconfig = {
//     connectionString: 'Driver={ODBC Driver 17 for SQL Server};Server=HP-SORO\\SQLEXPRESS;Database=gedcocanne;UID=dsf;PWD=dsqcdvqsfs;Trusted_Connection=no'
// };

// C'est un paramètre qui contrôle comment les ressources d'un serveur peuvent être accédées par des pages web hébergées sur un autre domaine.
// const corsOptions = {
//     origin: 'http://example.com',  // Autorise cette origine spécifique
//     methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],      // Méthodes HTTP autorisées
//     allowedHeaders: ['Content-Type', 'Authorization'],  // En-têtes autorisés
//     credentials: true,  // Autorise l'envoi de cookies et autres informations d'authentification
//     optionsSuccessStatus: 204      // Statut de réponse pour les requêtes pré-vol (preflight)
// };



// Création d'un pool de connexions promis pour gérer les connexions à la base de données
const poolPromise = new sql.ConnectionPool(dbConfig)
    .connect()
    .then(pool => {
        console.log('Connected to gedcocanne'); // Message de succès de la connexion
        return pool;                      // Retourner le pool de connexions
    })
    .catch(err => {
        console.error('Database connection failed:', err.message); // Message d'erreur en cas d'échec de connexion
        process.exit(1);                  // Terminer le processus en cas d'échec
    });

//voici ce qui allait etre fait sans pool de connecion 
// sql.connect(dbconfig).then(() => {
//     console.log('Connected to gedcocanne'); // Message de succès de la connexion
// }).catch ((err) =>{
//     console.error('Database connection failed:', err.message); // Message d'erreur en cas d'é
// });

// Exporter le module sql et le pool de connexions promis pour les utiliser dans d'autres fichiers
module.exports = {
    sql,
    poolPromise
};
