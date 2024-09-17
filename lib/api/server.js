//code du fichier server/js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

// les fichiers de routes constitue des modules il faut les Importer 

const dechargerTableRoutes = require('./routes/table_canne');
const dechargerCoursRoutes = require('./routes/cours_canne');
const authentificationRoutes = require('./routes/auth');
const gespontRoutes = require('./routes/data_gespont');
const lignesAndTasRoutes = require('./routes/lignes_tas');
const broyageRoutes = require('./routes/broyage');
const synchronisationRoutes = require('./routes/synchro');
const updatePoidsP2Routes = require('./routes/updatePoidsP2');
const bilanTonnageRutes = require('./routes/bilan');

// Initialiser l'application Express
const app = express();
const port = process.env.PORT || 80;

app.get('/', (req, res) => {
    res.send('Hello World!');
});


// Middleware
app.use(cors()); // Pour gérer les requêtes CORS
app.use(bodyParser.json()); // Pour parser les requêtes JSON

// Routes
app.use('/api', dechargerTableRoutes);
app.use('/api', dechargerCoursRoutes);
app.use('/api', authentificationRoutes);
app.use('/api', gespontRoutes);
app.use('/api', lignesAndTasRoutes);
app.use('/api', broyageRoutes);
app.use('/api', synchronisationRoutes);
app.use('/api', updatePoidsP2Routes);
app.use('/api', bilanTonnageRutes);


// Démarrer le serveur
app.listen(port, () => {
    console.log(`Serveur en cours d'exécution sur le port ${port}`);
});
