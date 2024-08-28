const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { sql, poolPromise } = require('./config'); // Fichier de configuration de la base de données

// Initialiser l'application Express
const app = express();
const PORT = process.env.PORT || 1445; // Port sur lequel l'application écoutera

// Utiliser body-parser pour parser les requêtes JSON
app.use(bodyParser.json());
// Utiliser cors pour activer CORS
app.use(cors());

// Définir une route pour obtenir les camions en attente
app.get('/camionsEnAttente', async (req, res) => {
  try {
      const pool = await poolPromise;
      const query = `
          SELECT VE_CODE, PS_CODE , PS_POIDSP1, DATEHEUREP1, TECH_COUPE
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

// Route pour obtenir le poids P2 des camions
app.post('/poidsP2', async (req, res) => {
  // Récupérer la liste des camions depuis le corps de la requête
  const camions = req.body.camions;

  // Vérifier que la liste des camions est valide
  if (!camions || !Array.isArray(camions)) {
    return res.status(400).json({ error: 'Invalid input' });
  }

  try {
    // Obtenir le pool de connexions à la base de données
    const pool = await poolPromise;
    const poidsP2Data = [];

    // Préparer et exécuter les requêtes SQL pour chaque camion
    for (const camion of camions) {
      const { veCode, dateHeureP1 } = camion;

      const result = await pool.request()
        .input('veCode', sql.VarChar, veCode)
        .input('dateHeureP1', sql.DateTime, new Date(dateHeureP1)) // Conversion de la chaîne de date en objet Date
        .query(`
          SELECT VE_CODE, DATEHEUREP1, PS_POIDSP2
          FROM F_PESEE
          WHERE VE_CODE = @veCode AND PR_CODE = 01
            AND DATEHEUREP1 = @dateHeureP1
        `);

      // Ajouter les résultats à la liste si des données sont trouvées
      if (result.recordset.length > 0) {
        poidsP2Data.push({
          veCode: result.recordset[0].VE_CODE,
          dateHeureP1: result.recordset[0].DATEHEUREP1,
          poidsP2: result.recordset[0].PS_POIDSP2
        });
      }
    }

    // Envoyer les résultats au client
    res.json(poidsP2Data);
  } catch (err) {
    // En cas d'erreur SQL, afficher l'erreur dans la console et renvoyer une réponse d'erreur 500
    console.error('SQL error', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Route pour récupérer le poidsTare d'un camion spécifique
app.get('/poidsTare', async (req, res) => {
  try {
      // Obtenir les paramètres veCode et dateHeureP1 depuis la requête
      const { veCode, dateHeureP1 } = req.query;

      // Assurer que veCode et dateHeureP1 sont fournis
      if (!veCode || !dateHeureP1) {
          return res.status(400).json({ error: 'veCode et dateHeureP1 sont requis' });
      }

      const pool = await poolPromise; // Attendre que le pool de connexions soit disponible

      // Requête SQL pour récupérer le dernier poidsTare
      const query = `
          SELECT TOP 1 PS_POIDSTare
          FROM F_PESEE
          WHERE VE_CODE = @veCode AND PR_CODE = 01
          ORDER BY DATEHEUREP1 DESC;
      `;

      // Préparer et exécuter la requête
      const result = await pool.request()
          .input('veCode', sql.NVarChar, veCode)
          .query(query);

      // Vérifier si un résultat a été trouvé
      if (result.recordset.length > 0) {
          const poidsTare = result.recordset[0].PS_POIDSTare;
          res.json({ PS_POIDSTare: poidsTare });
      } else {
          res.status(404).json({ error: 'PoidsTare non trouvé pour ce camion' });
      }
  } catch (err) {
      // En cas d'erreur, afficher l'erreur et envoyer une réponse d'erreur au client
      console.error('SQL error:', err.message);
      res.status(500).json({ error: 'Internal Server Error' });
  }
});
// Route pour synchroniser les agents
app.post('/syncAgents', async (req, res) => {
  //console.log('tentative');
  const agents = req.body.agents;
  if (!agents || !Array.isArray(agents)) {
    return res.status(400).json({ error: 'Invalid input' });
  }

  let transaction;
  try {
    const pool = await poolPromise;
    transaction = new sql.Transaction(pool);
    await transaction.begin();

    for (const agent of agents) {
      const request = new sql.Request(transaction);

      //console.log('etatSynchronisation:', agent.etatSynchronisation, typeof agent.etatSynchronisation);
      //console.log('etatModification:', agent.etatModification, typeof agent.etatModification);

      if (agent.etatSynchronisation) {

        //console.log(agent.matricule);

        // Mise à jour des agents existants
        await request
          .input('matricule', sql.NVarChar, agent.matricule)
          .input('password', sql.NVarChar, agent.password)
          .input('role', sql.NVarChar, agent.role)
          .query(`
            UPDATE AGENT
            SET password = @password, role = @role
            WHERE matricule = @matricule
          `);
      } else {
        //console.log("la");

        // Insertion de nouveaux agents
        await request
          .input('matricule', sql.NVarChar, agent.matricule)
          .input('password', sql.NVarChar, agent.password)
          .input('role', sql.NVarChar, agent.role)
          .query(`
            INSERT INTO AGENT (matricule, password, role)
            VALUES (@matricule, @password, @role)
          `);
      }
    }

    await transaction.commit();
    res.status(200).json({ message: 'Agents synchronized successfully' });
  } catch (err) {
    console.error('SQL error', err);
    if (transaction) {
      await transaction.rollback();
    }
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Route POST pour la synchronisation des déchargements dans la cours
app.post('/sync-decharg-cours', async (req, res) => {
    const camions = req.body.camions;
  
    if (!camions || !Array.isArray(camions)) {
      return res.status(400).json({ error: 'Invalid input' });
    }
  
    let transaction;
    try {
      const pool = await poolPromise;
      transaction = new sql.Transaction(pool);
      await transaction.begin();
  
      for (const camion of camions) {
        const request = new sql.Request(transaction);
  
        if (camion.etatSynchronisation) {
          // Mise à jour des déchargements existants
          await request
            .input('veCode', sql.NVarChar, camion.veCode)
            .input('poidsP2', sql.Decimal(10, 2), camion.poidsP2 || null)
            .input('poidsNet', sql.Decimal(10, 2), camion.poidsNet) 
            .input('dateHeureP2', sql.DateTime, camion.dateHeureP2 || null)
            .input('etatBroyage', sql.Bit, camion.etatBroyage)
            .input('dateHeureDecharg', sql.DateTime, camion.dateHeureDecharg)
            .query(`
              UPDATE DECHARGERCOURS
              SET poidsP2 = @poidsP2, dateHeureP2 = @dateHeureP2, etatBroyage = @etatBroyage, poidsNet = @poidsNet
              WHERE veCode = @veCode AND dateHeureDecharg = @dateHeureDecharg
            `);
        } else {
          // Insertion de nouveaux déchargements
          await request
            .input('veCode', sql.NVarChar, camion.veCode)
            .input('poidsP1', sql.Decimal(10, 2), camion.poidsP1)
            .input('poidsTare', sql.Decimal(10, 2), camion.poidsTare || null)
            .input('poidsP2', sql.Decimal(10, 2), camion.poidsP2 || null)
            .input('poidsNet', sql.Decimal(10, 2), camion.poidsNet)
            .input('dateHeureP1', sql.DateTime, camion.dateHeureP1)
            .input('dateHeureDecharg', sql.DateTime, camion.dateHeureDecharg)
            .input('dateHeureP2', sql.DateTime, camion.dateHeureP2 || null)
            .input('techCoupe', sql.NVarChar, camion.techCoupe)
            .input('parcelle', sql.NVarChar, camion.parcelle)
            .input('etatBroyage', sql.Bit, camion.etatBroyage)
            .input('matriculeAgent', sql.NVarChar, camion.matriculeAgent || null)  
            .query(`
              INSERT INTO DECHARGERCOURS (veCode, poidsP1, poidsTare, poidsP2, poidsNet, dateHeureP1, dateHeureDecharg, dateHeureP2, techCoupe, parcelle, agentMatricule, etatBroyage)
              VALUES (@veCode, @poidsP1, @poidsTare, @poidsP2, @poidsNet, @dateHeureP1, @dateHeureDecharg, @dateHeureP2, @techCoupe, @parcelle, @matriculeAgent, @etatBroyage)
            `);
            
        }
      }
  
      await transaction.commit();
      res.status(200).json({ message: 'Dechargement table synchronized successfully' });
    } catch (err) {
      console.error('SQL error', err);
      if (transaction) {
        await transaction.rollback();
      }
      res.status(500).json({ error: 'Internal Server Error' });
    }
});
  

// Route POST pour la synchronisation des déchargements effectuer dans la table
app.post('/sync-decharg-table', async (req, res) => {

    const camions = req.body.camions;
  
    if (!camions || !Array.isArray(camions)) {
      return res.status(400).json({ error: 'Invalid input' });
    }
  
    let transaction;
    try {
      const pool = await poolPromise;
      transaction = new sql.Transaction(pool);
      await transaction.begin();
  
      for (const camion of camions) {
        const request = new sql.Request(transaction);
        
        if (camion.etatSynchronisation) {
          // Mise à jour des enregistrements existants
          await request
            .input('veCode', sql.NVarChar, camion.veCode)
            .input('poidsP2', sql.Float, camion.poidsP2 || null)
            .input('dateHeureP2', sql.DateTime, camion.dateHeureP2 || null)
            .input('poidsNet', sql.Float, camion.poidsNet || null)
            .input('dateHeureDecharg', sql.DateTime, camion.dateHeureDecharg)
            .query(`
              UPDATE DECHARGERTABLE
              SET poidsP2 = @poidsP2, dateHeureP2 = @dateHeureP2, poidsNet = @poidsNet
              WHERE veCode = @veCode AND dateHeureDecharg = @dateHeureDecharg
            `);
        } else {
          const request = new sql.Request(transaction);
          //console.log(camion.matriculeAgent);
          await request
            .input('veCode', sql.NVarChar, camion.veCode)
            .input('poidsP1', sql.Decimal(10, 2), camion.poidsP1)
            .input('poidsTare', sql.Decimal(10, 2), camion.poidsTare || null)
            .input('poidsP2', sql.Decimal(10, 2), camion.poidsP2 || null)
            .input('poidsNet', sql.Decimal(10, 2), camion.poidsNet)
            .input('dateHeureP1', sql.DateTime, camion.dateHeureP1)
            .input('dateHeureP2', sql.DateTime, camion.dateHeureP2 || null)
            .input('dateHeureDecharg', sql.DateTime, camion.dateHeureDecharg)
            .input('techCoupe', sql.NVarChar, camion.techCoupe)
            .input('parcelle', sql.NVarChar, camion.parcelle || null)
            .input('matriculeAgent', sql.NVarChar, camion.matriculeAgent || null)
            .query(`
              INSERT INTO DECHARGERTABLE (veCode, poidsP1, poidsTare, poidsP2, poidsNet, dateHeureP1, dateHeureP2, dateHeureDecharg, techCoupe, parcelle, agentMatricule)
              VALUES (@veCode, @poidsP1, @poidsTare, @poidsP2, @poidsNet, @dateHeureP1, @dateHeureP2, @dateHeureDecharg, @techCoupe, @parcelle, @matriculeAgent)
            `);
        }
      }
  
      await transaction.commit();
      res.status(200).json({ message: 'Dechargement table synchronized successfully' });
    } catch (err) {
      console.error('SQL error', err);
      if (transaction) {
        await transaction.rollback();
      }
      res.status(500).json({ error: 'Internal Server Error' });
    }

});
  

app.post('/sync-table-canne', async (req, res) => {
  const cannes = req.body.cannes;

  if (!cannes || !Array.isArray(cannes)) {
      return res.status(400).json({ error: 'Invalid input' });
  }


  let transaction;
    try {
        const pool = await poolPromise;
        transaction = new sql.Transaction(pool);
        await transaction.begin();

        for (const canne of cannes) {
          const request = new sql.Request(transaction);
  
          // Définir les paramètres SQL
          const tonnage = parseFloat(canne.tonnageTasDeverse);
          const annee = parseInt(canne.anneeTableCanne);
          const date = canne.dateDecharg;  // Date au format 'yyyy-MM-dd'
          const heure = parseInt(canne.heureDecharg);

          if (canne.etatSynchronisation) {
              // Mise à jour des entrées existantes
              await request
                  .input('TonnageCanneBroyerParTas', sql.Decimal(18, 4), tonnage)
                  .input('AnneeTableCanne', sql.Int, annee)
                  .input('dateDecharg', sql.Date, date)
                  .input('heureDecharg', sql.Int, heure)
                  .query(`
                      UPDATE TABLECANNE
                      SET TonnageCanneBroyerParTas = @TonnageCanneBroyerParTas
                      WHERE AnneeTableCanne = @AnneeTableCanne
                        AND dateDecharg = @dateDecharg
                        AND heureDecharg = @heureDecharg
                  `);
          } else {
              // Insertion de nouvelles entrées
              await request
                  .input('TonnageCanneBroyerParTas', sql.Decimal(18, 4), tonnage)
                  .input('AnneeTableCanne', sql.Int, annee)
                  .input('dateDecharg', sql.Date, date)
                  .input('heureDecharg', sql.Int, heure)
                  .query(`
                      INSERT INTO TABLECANNE (TonnageCanneBroyerParTas, AnneeTableCanne, dateDecharg, heureDecharg)
                      VALUES (@TonnageCanneBroyerParTas, @AnneeTableCanne, @dateDecharg, @heureDecharg)
                  `);
          }

       }

      await transaction.commit();
      res.status(200).json({ message: 'Synchronisation réussie' });
  } catch (err) {
      if (transaction) await transaction.rollback();
      res.status(500).json({ error: 'Erreur lors de la synchronisation', details: err.message });
  }
});




//calculer du tonnage

// Endpoint pour récupérer le tonnage d'entrée dans la cour
app.post('/tonnageEntreeCours', async (req, res) => {
  try {
    // Extraction des heures de début et de fin à partir de la requête POST
    const { heureDebut, heureFin } = req.body;

    // Vérification que les deux paramètres sont bien fournis
    if (!heureDebut || !heureFin) {
      return res.status(400).json({ error: 'heureDebut et heureFin sont requis' });
    }

    const pool = await poolPromise;

    let query = '';

    // Conversion des heures de début et de fin en entiers pour comparaison
    if (parseInt(heureDebut) <= parseInt(heureFin)) {
      // Cas où l'heure de début est inférieure ou égale à l'heure de fin
      // (Exemple: début à 05:00 et fin à 15:00, tout dans la même journée)

      query = `
        SELECT SUM(poidsNet) AS totalPoidsNet
        FROM DECHARGERCOURS
        WHERE 
          --Filtrer les enregistrements où la date correspond à la date actuelle
          CAST(dateHeureDecharg AS DATE) = CAST(GETDATE() AS DATE) 
          --Et où l'heure de déchargement est comprise entre l'heure de début et l'heure de fin
          AND DATEPART(HOUR, dateHeureDecharg) BETWEEN @heureDebut AND @heureFin;
      `;
    } else {
      // Cas où l'heure de fin est techniquement "le jour suivant" par rapport à l'heure de début
      // (Exemple: début à 20:00 et fin à 04:00, le déchargement se poursuit après minuit)

      query = `
        SELECT SUM(poidsNet) AS totalPoidsNet
        FROM DECHARGERCOURS
        WHERE 
          (
            --Première condition: le déchargement s'est produit le jour même après l'heure de début
            (CAST(dateHeureDecharg AS DATE) = CAST(GETDATE() AS DATE) 
             AND DATEPART(HOUR, dateHeureDecharg) >= @heureDebut)
            OR
            --Seconde condition: le déchargement s'est produit le jour suivant avant l'heure de fin
            (CAST(dateHeureDecharg AS DATE) = DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) 
             AND DATEPART(HOUR, dateHeureDecharg) <= @heureFin)
          );
      `;
    }

    // Exécution de la requête SQL avec les heures passées en paramètre
    const result = await pool.request()
      .input('heureDebut', sql.Int, parseInt(heureDebut))
      .input('heureFin', sql.Int, parseInt(heureFin))
      .query(query);

    // Récupération du résultat: la somme totale des poids nets, ou 0 si aucune donnée n'est trouvée
    const stockEntree = result.recordset[0].totalPoidsNet || 0;

    // Envoi du résultat au client
    res.json({ stockEntree });
  } catch (err) {
    // Gestion des erreurs SQL ou autres, avec log pour le diagnostic
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



// Endpoint pour récupérer le tonnage broyé directement à partir de la table DECHARGERTABLE
app.post('/tonnageBroyerDirect', async (req, res) => {
  try {
    // Extraction des heures de début et de fin à partir de la requête POST
    const { heureDebut, heureFin } = req.body;

    // Vérification que les deux paramètres sont bien fournis
    if (!heureDebut || !heureFin) {
      return res.status(400).json({ error: 'heureDebut et heureFin sont requis' });
    }

    const pool = await poolPromise;

    let query = '';

    // Conversion des heures de début et de fin en entiers pour comparaison
    if (parseInt(heureDebut) <= parseInt(heureFin)) {
      // Cas où l'heure de début est inférieure ou égale à l'heure de fin
      // (Exemple: début à 05:00 et fin à 15:00, tout dans la même journée)

      query = `
        SELECT SUM(poidsNet) AS totalPoidsNet
        FROM DECHARGERTABLE
        WHERE 
          --Filtrer les enregistrements où la date correspond à la date actuelle
          CAST(dateHeureDecharg AS DATE) = CAST(GETDATE() AS DATE) 
          --Et où l'heure de déchargement est comprise entre l'heure de début et l'heure de fin
          AND DATEPART(HOUR, dateHeureDecharg) BETWEEN @heureDebut AND @heureFin;
      `;
    } else {
      // Cas où l'heure de fin est techniquement "le jour suivant" par rapport à l'heure de début
      // (Exemple: début à 20:00 et fin à 04:00, le déchargement se poursuit après minuit)

      query = `
        SELECT SUM(poidsNet) AS totalPoidsNet
        FROM DECHARGERTABLE
        WHERE 
          (
            --Première condition: le déchargement s'est produit le jour même après l'heure de début
            (CAST(dateHeureDecharg AS DATE) = CAST(GETDATE() AS DATE) 
             AND DATEPART(HOUR, dateHeureDecharg) >= @heureDebut)
            OR
            --Seconde condition: le déchargement s'est produit le jour suivant avant l'heure de fin
            (CAST(dateHeureDecharg AS DATE) = DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) 
             AND DATEPART(HOUR, dateHeureDecharg) <= @heureFin)
          );
      `;
    }

    // Exécution de la requête SQL avec les heures passées en paramètre
    const result = await pool.request()
      .input('heureDebut', sql.Int, parseInt(heureDebut))
      .input('heureFin', sql.Int, parseInt(heureFin))
      .query(query);

    // Récupération du résultat: la somme totale des poids nets, ou 0 si aucune donnée n'est trouvée
    const stockBroyerDirect = result.recordset[0].totalPoidsNet || 0;

    // Envoi du résultat au client
    res.json({ stockBroyerDirect });
  } catch (err) {
    // Gestion des erreurs SQL ou autres, avec log pour le diagnostic
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



// Endpoint pour récupérer le tonnage broyé par tas
app.post('/tonnageBroyerParTas', async (req, res) => {
  try {
    // Extraction des heures de début et de fin à partir de la requête POST
    const { heureDebut, heureFin } = req.body;

    // Vérification que les deux paramètres sont bien fournis
    if (!heureDebut || !heureFin) {
      return res.status(400).json({ error: 'heureDebut et heureFin sont requis' });
    }

    const pool = await poolPromise;

    let query = '';

    // Conversion des heures de début et de fin en entiers pour comparaison
    if (parseInt(heureDebut) <= parseInt(heureFin)) {
      // Cas où l'heure de début est inférieure ou égale à l'heure de fin (même journée)
      query = `
        SELECT SUM(TonnageCanneBroyerParTas) AS totalTonnage
        FROM TABLECANNE
        WHERE 
          -- Filtrer les enregistrements où la date correspond à la date actuelle
          CAST(dateDecharg AS DATE) = CAST(GETDATE() AS DATE) 
          -- Et où l'heure de déchargement est comprise entre l'heure de début et l'heure de fin
          AND heureDecharg BETWEEN @heureDebut AND @heureFin;
      `;
    } else {
      // Cas où l'heure de fin est techniquement "le jour suivant" par rapport à l'heure de début
      query = `
        SELECT SUM(TonnageCanneBroyerParTas) AS totalTonnage
        FROM TABLECANNE
        WHERE 
          (
            -- Première condition: le déchargement s'est produit le jour même après l'heure de début
            (CAST(dateDecharg AS DATE) = CAST(GETDATE() AS DATE) 
             AND heureDecharg >= @heureDebut)
            OR
            -- Seconde condition: le déchargement s'est produit le jour suivant avant l'heure de fin
            (CAST(dateDecharg AS DATE) = DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) 
             AND heureDecharg <= @heureFin)
          );
      `;
    }

    // Exécution de la requête SQL avec les heures passées en paramètre
    const result = await pool.request()
      .input('heureDebut', sql.Int, parseInt(heureDebut))
      .input('heureFin', sql.Int, parseInt(heureFin))
      .query(query);

    // Récupération du résultat: la somme totale des tonnages broyés par tas, ou 0 si aucune donnée n'est trouvée
    const totalTonnage = result.recordset[0].totalTonnage || 0;

    // Envoi du résultat au client
    res.json({ totalTonnage });
  } catch (err) {
    // Gestion des erreurs SQL ou autres, avec log pour le diagnostic
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});














/////authentification


// Route pour l'authentification
app.post('/authenticate', async (req, res) => {
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


// Démarrer le serveur et écouter sur le port spécifié
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
