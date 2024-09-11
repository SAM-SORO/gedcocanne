const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { sql, poolPromise } = require('./config'); // Fichier de configuration de la base de données

// Initialiser l'application Express
const app = express();
const PORT = process.env.PORT || 1445; // Port sur lequel l'API écoutera

// Utiliser body-parser pour parser les requêtes JSON
app.use(bodyParser.json());
// Utiliser cors pour activer CORS
app.use(cors());




/****************************************
DECHARGEMENT COURS
***************************************/

//normalement c'est tous les camions decharger dans la cours mais nous on prendra ça que dans les 15 jours
app.get('/camionsDechargerCours', async (req, res) => {
  try {
    const pool = await poolPromise;
    const query = `
      SELECT 
        id, veCode, poidsP1, poidsTare, poidsP2, 
        poidsNet, dateHeureP1, dateHeureDecharg, dateHeureP2, 
        parcelle, techCoupe, agentMatricule, etatBroyage, ligneLibele
      FROM 
        DECHARGERCOURS
      WHERE 
        dateHeureDecharg >= DATEADD(DAY, -15, GETDATE())
      ORDER BY 
        dateHeureDecharg DESC;
    `;
    const result = await pool.request().query(query);

    const camions = result.recordset.map(row => ({
      id: row.id,
      veCode: row.veCode,
      poidsP1: row.poidsP1,
      poidsTare: row.poidsTare,
      poidsP2: row.poidsP2,
      poidsNet: row.poidsNet,
      dateHeureP1: row.dateHeureP1,
      dateHeureDecharg: row.dateHeureDecharg,
      dateHeureP2: row.dateHeureP2,
      parcelle: row.parcelle,
      techCoupe: row.techCoupe,
      agentMatricule: row.agentMatricule,
      etatBroyage: row.etatBroyage,
      ligneLibele: row.ligneLibele  // Ajout de ligneLibele
    }));

    res.json(camions);
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


//normalement c'est tous les camions decharger dans la table mais nous on prendra ça que dans les 15 jours
app.get('/camionsDechargerCoursDerniereHeure', async (req, res) => {
  try {
    const pool = await poolPromise;
    const query = `
      SELECT 
        id, veCode, poidsP1, poidsTare, poidsP2, 
        poidsNet, dateHeureP1, dateHeureDecharg, dateHeureP2, 
        parcelle, techCoupe, agentMatricule, etatBroyage, ligneLibele
      FROM 
        DECHARGERCOURS
      WHERE 
        dateHeureDecharg >= DATEADD(HOUR, -5, GETDATE())
        AND etatBroyage = 0
      ORDER BY 
        dateHeureDecharg DESC;
    `;
    const result = await pool.request().query(query);

    const camions = result.recordset.map(row => ({
      id: row.id,
      veCode: row.veCode,
      poidsP1: row.poidsP1,
      poidsTare: row.poidsTare,
      poidsP2: row.poidsP2,
      poidsNet: row.poidsNet,
      dateHeureP1: row.dateHeureP1,
      dateHeureDecharg: row.dateHeureDecharg,
      dateHeureP2: row.dateHeureP2,
      parcelle: row.parcelle,
      techCoupe: row.techCoupe,
      agentMatricule: row.agentMatricule,
      etatBroyage: row.etatBroyage,
      ligneLibele: row.ligneLibele  // Ajout de ligneLibele
    }));

    res.json(camions);
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Route pour récupérer le poidsTare d'un camion spécifique
app.get('/poidsTare', async (req, res) => {
  try {
      const { veCode, dateHeureP1 } = req.query;

      if (!veCode || !dateHeureP1) {
          return res.status(400).json({ error: 'veCode et dateHeureP1 sont requis' });
      }

      const pool = await poolPromise;

      const query = `
          SELECT TOP 1 PS_POIDSTare
          FROM F_PESEE
          WHERE VE_CODE = @veCode AND PR_CODE = '01'
          ORDER BY DATEHEUREP1 DESC;
      `;

      const result = await pool.request()
          .input('veCode', sql.VarChar, veCode)
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


//route pour enregistrer un camion decharger dans  la cour
app.post('/enregistrerDechargementCours', async (req, res) => {
  try {
    const {
      veCode,
      poidsP1,
      poidsTare,
      techCoupe,
      parcelle,
      dateHeureP1,
      ligneLibele, // Utilisation correcte de ligneLibele
      matriculeAgent,
      etatBroyage
    } = req.body;

    const poidsNet = poidsP1 - poidsTare;

    const pool = await poolPromise;

    const query = `
      INSERT INTO DECHARGERCOURS (veCode, poidsP1, poidsTare, poidsNet, dateHeureP1, dateHeureDecharg, parcelle, techCoupe, ligneLibele, agentMatricule, etatBroyage)
      VALUES (@veCode, @poidsP1, @poidsTare, @poidsNet, @dateHeureP1, GETDATE(), @parcelle, @techCoupe, @ligneLibele, @matriculeAgent, @etatBroyage);
    `;

    await pool.request()
      .input('veCode', sql.NVarChar, veCode)
      .input('poidsP1', sql.Decimal(10, 2), poidsP1)
      .input('poidsTare', sql.Decimal(10, 2), poidsTare)
      .input('poidsNet', sql.Decimal(10, 2), poidsNet)
      .input('dateHeureP1', sql.DateTime, dateHeureP1)
      .input('parcelle', sql.NVarChar, parcelle)
      .input('techCoupe', sql.NVarChar, techCoupe)
      .input('ligneLibele', sql.NVarChar, ligneLibele) // Correction de type
      .input('agentMatricule', sql.NVarChar, matriculeAgent)
      .input('etatBroyage', sql.Bit, etatBroyage);

    res.status(201).send({ success: true, message: 'Camion enregistré dans la cour.' });
  } catch (error) {
    res.status(500).send({ success: false, message: `Erreur: ${error.message}` });
  }
});


/***********************************
AFFECTATION
***************************/

// Route pour récupérer les camions affectés à une ligne spécifique
app.post('/getCamionsOfLigne', async (req, res) => {
  try {
    // Extraction du paramètre ligneId depuis le corps de la requête
    const { ligneId } = req.body;

    // Vérification que le paramètre ligneId est fourni
    if (!ligneId) {
      return res.status(400).json({ error: 'Invalid request parameters' });
    }

    // Connexion à la base de données via le pool de connexions
    const pool = await poolPromise;

    // Requête SQL pour récupérer les camions de la ligne avec etatBroyage = 0
    const query = `
      SELECT veCode, poidsP1, poidsTare, poidsP2, poidsNet, dateHeureP1, dateHeureDecharg, parcelle, techCoupe, agentMatricule
      FROM DECHARGERCOURS
      WHERE ligneLibele = @ligneId AND etatBroyage = 0;
    `;

    // Exécution de la requête SQL
    const result = await pool.request()
      .input('ligneId', sql.NVarChar, ligneId)
      .query(query);

    // Réponse JSON avec la liste des camions
    res.json(result.recordset);
  } catch (err) {
    // Gestion des erreurs SQL et renvoi d'un message d'erreur
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Route pour supprimer un camion de la table DECHARGERCOURS
app.delete('/deleteCamionDechargerCours', async (req, res) => {
  try {
    // Extraction des paramètres de la requête
    const { veCode, dateHeureP1 } = req.body;

    // Vérification que les paramètres requis sont fournis
    if (!veCode || !dateHeureP1) {
      return res.status(400).json({ error: 'Invalid request parameters' });
    }

    // Connexion à la base de données via le pool de connexions
    const pool = await poolPromise;

    // Requête SQL pour supprimer le camion dans la table DECHARGERCOURS
    const deleteQuery = `
      DELETE FROM DECHARGERCOURS 
      WHERE veCode = @veCode AND dateHeureP1 = @dateHeureP1;
    `;

    // Exécution de la requête pour supprimer le camion
    const result = await pool.request()
      .input('veCode', sql.NVarChar, veCode)
      .input('dateHeureP1', sql.DateTime, new Date(dateHeureP1))
      .query(deleteQuery);

    // Vérification du nombre de lignes affectées pour confirmer la suppression
    if (result.rowsAffected[0] > 0) {
      res.json({ success: true, message: 'Camion supprimé avec succès' });
    } else {
      res.status(404).json({ success: false, message: 'Camion non trouvé' });
    }
  } catch (err) {
    // Gestion des erreurs SQL et renvoi d'un message d'erreur
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Route pour vérifier l'affectation de camions à une ligne spécifique
app.post('/verifierAffectationLigne', async (req, res) => {
  try {
    const { ligneLibele } = req.body;

    // Requête pour vérifier s'il existe des camions avec etatBroyage = 0 pour la ligne donnée
    const result = await query(
      'SELECT COUNT(*) AS count FROM DECHARGERCOURS WHERE ligneLibele = ? AND etatBroyage = 0',
      [ligneLibele]
    );

    // Si le nombre de camions est supérieur à 0, renvoyer true, sinon false
    const hasCamions = result[0].count > 0;
    res.status(200).json(hasCamions);
  } catch (error) {
    console.error('Erreur lors de la vérification de l\'affectation de la ligne:', error);
    res.status(500).json(false);
  }
});





/****************************************
DECHARGEMENT TABLE
***************************************/


//  obtenir les camions en attente
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



//normalement c'est tous les camions decharger dans la cours mais nous on prendra ça que dans les 15 jours pour eviter de traiter des donnee volumineuse
app.get('/camionsDechargerTable', async (req, res) => {
  try {
    const pool = await poolPromise;
    const query = `
      SELECT id, veCode, poidsP1, poidsTare, poidsP2, 
             poidsNet, dateHeureP1, dateHeureDecharg, dateHeureP2, 
             parcelle, techCoupe, agentMatricule 
      FROM DECHARGERTABLE
      WHERE dateHeureDecharg >= DATEADD(DAY, -15, GETDATE())
      ORDER BY dateHeureDecharg DESC;
    `;
    const result = await pool.request().query(query);

    const camions= result.recordset.map(row => ({
      id: row.id,
      veCode: row.veCode,
      poidsP1: row.poidsP1,
      poidsTare: row.poidsTare,
      poidsP2: row.poidsP2,
      poidsNet: row.poidsNet,
      dateHeureP1: row.dateHeureP1,
      dateHeureDecharg: row.dateHeureDecharg,
      dateHeureP2: row.dateHeureP2,
      parcelle: row.parcelle,
      techCoupe: row.techCoupe,
      agentMatricule: row.agentMatricule
    }));
    

    res.json(camions);
  } catch (err) {
    console.log(err.message);
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



app.get('/camionsDechargerTableDerniereHeure', async (req, res) => {
  try {
    const pool = await poolPromise;
    const query = `
      SELECT id, veCode, poidsP1, poidsTare, poidsP2, 
             poidsNet, dateHeureP1, dateHeureDecharg, dateHeureP2, 
             parcelle, techCoupe, agentMatricule 
      FROM DECHARGERTABLE
      WHERE dateHeureDecharg >= DATEADD(HOUR, -5, GETDATE())
      ORDER BY dateHeureDecharg DESC;
    `;
    const result = await pool.request().query(query);

    const camions = result.recordset.map(row => ({
      id: row.id,
      veCode: row.veCode,
      poidsP1: row.poidsP1,
      poidsTare: row.poidsTare,
      poidsP2: row.poidsP2,
      poidsNet: row.poidsNet,
      dateHeureP1: row.dateHeureP1,
      dateHeureDecharg: row.dateHeureDecharg,
      dateHeureP2: row.dateHeureP2,
      parcelle: row.parcelle,
      techCoupe: row.techCoupe,
      agentMatricule: row.agentMatricule,
    }));

    res.json(camions);
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


//route pour enregistrer un camion decharger dans la table
app.post('/enregistrerDechargementTable', async (req, res) => {
  try {
      const {
          veCode,
          poidsP1,
          techCoupe,
          parcelle,
          dateHeureP1,
          poidsTare,
          matriculeAgent
      } = req.body;

      // Calculer le poids net (si applicable) ou vous pouvez le faire ailleurs selon votre logique métier
      const poidsNet = poidsP1 - poidsTare;

      // Connexion à la base de données et exécution de la requête d'insertion
      const pool = await poolPromise;

      const query = `
          INSERT INTO DECHARGERTABLE (veCode, poidsP1, poidsTare, poidsNet, dateHeureP1, dateHeureDecharg, parcelle, techCoupe, agentMatricule)
          VALUES (@veCode, @poidsP1, @poidsTare, @poidsNet, @dateHeureP1, GETDATE(), @parcelle, @techCoupe, @matriculeAgent);
      `;

      await pool.request()
          .input('veCode', sql.NVarChar, veCode)
          .input('poidsP1', sql.Decimal(10, 2), poidsP1)
          .input('poidsTare', sql.Decimal(10, 2), poidsTare)
          .input('poidsNet', sql.Decimal(10, 2), poidsNet)
          .input('dateHeureP1', sql.DateTime, dateHeureP1)
          .input('parcelle', sql.NVarChar, parcelle)
          .input('techCoupe', sql.NVarChar, techCoupe)
          .input('matriculeAgent', sql.NVarChar, matriculeAgent)
          .query(query);

      res.status(201).json({ message: 'Camion déchargé enregistré avec succès' });
  } catch (err) {
      console.error('Erreur lors de l\'enregistrement du camion :', err);
      res.status(500).json({ error: 'Erreur interne du serveur' });
  }
});


app.delete('/deleteCamionDechargerTable', async (req, res) => {
  try {
    const { veCode, dateHeureDecharg } = req.body;

    const pool = await poolPromise;
    const query = `
      DELETE FROM DECHARGERTABLE
      WHERE veCode = @veCode AND dateHeureDecharg = @dateHeureDecharg
    `;

    const result = await pool.request()
      .input('veCode', sql.NVarChar, veCode)
      .input('dateHeureDecharg', sql.DateTime, dateHeureDecharg)
      .query(query);

    // console.log('Result:', result); // Log du résultat de la suppression

    if (result.rowsAffected[0] > 0) {
      res.status(200).json({ message: 'Camion supprimé avec succès' });
    } else {
      res.status(404).json({ error: 'Camion non trouvé' });
    }

  } catch (err) {
    console.error('Erreur lors de la suppression du camion:', err);
    res.status(500).json({ error: 'Erreur interne du serveur' });
  }
});






/****************************************
LIGNE & TAS
***************************************/

// Route pour récupérer les données de la ligne
app.get('/allLigne', async (req, res) => {
  try {
    const pool = await poolPromise;
    const query = `
      SELECT 
        L.id AS ligneId, 
        L.libele, 
        L.nbreTas, 
        L.tonnageLigne, 
        L.agentId,
        L.tonnageTasBroye,
        T.id AS tasId,
        T.poids AS tasPoids,
        T.etat AS tasEtat
      FROM 
        LIGNE L
      LEFT JOIN 
        TAS T ON L.id = T.ligneId
      ORDER BY 
        L.id ASC, T.id ASC;
    `;
    const result = await pool.request().query(query);

    // Transformer les résultats en une structure imbriquée
    const lignesMap = new Map();

    result.recordset.forEach(row => {
      const ligneId = row.ligneId;

      if (!lignesMap.has(ligneId)) {
        lignesMap.set(ligneId, {
          ligneId: row.ligneId,
          libele: row.libele,
          nbreTas: row.nbreTas,
          tonnageLigne: row.tonnageLigne,
          agentId: row.agentId,
          tonnageTasBroye: row.tonnageTasBroye,
          tas: []  // Initialiser la liste des tas pour cette ligne
        });
      }

      if (row.tasId) {
        lignesMap.get(ligneId).tas.push({
          tasId: row.tasId,
          tasPoids: row.tasPoids,
          tasEtat: row.tasEtat
        });
      }
    });

    // Initialisation correcte de `lignes`
    const lignes = Array.from(lignesMap.values());

    // Affichage après l'initialisation
    //console.log(lignes);

    res.json(lignes);

  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Route pour supprimer une ligne par son ID
app.delete('/deleteLigne/:id', async (req, res) => {
  const ligneId = req.params.id;

  try {
    const pool = await poolPromise;
    const query = `
      DELETE FROM LIGNE
      WHERE id = @ligneId;
    `;

    await pool.request()
      .input('ligneId', sql.Int, ligneId)
      .query(query);

    res.status(200).json({ message: 'Ligne supprimée avec succès' });
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Erreur lors de la suppression de la ligne' });
  }
});

//obtenir le nombre de ligne
app.get('/getLigneCount', async (req, res) => {
  try {
    const pool = await poolPromise;
    const query = `
      SELECT COUNT(*) AS count FROM LIGNE;
    `;
    const result = await pool.request().query(query);

    const count = result.recordset[0].count;
    res.json({ count });
  } catch (err) {
    console.error('Erreur lors de l\'obtention du nombre de lignes :', err.message);
    res.status(500).json({ error: 'Erreur interne du serveur' });
  }
});

//creation d'une ligne
app.post('/creerLigne', async (req, res) => {
  try {
    const { libelle, agentId } = req.body;

    const pool = await poolPromise;

    // Insérer la nouvelle ligne
    const ligneQuery = `
      INSERT INTO LIGNE (libele, agentId)
      OUTPUT INSERTED.id
      VALUES (@libelle, @agentId);
    `;

    const ligneResult = await pool.request()
      .input('libelle', sql.NVarChar, libelle)
      .input('agentId', sql.Int, agentId)
      .query(ligneQuery);

    const ligneId = ligneResult.recordset[0].id;

    // Créer les tas associés à cette ligne (nbreTas fois)
    const tasQuery = `
      INSERT INTO TAS (ligneId, poids, etat)
      VALUES (@ligneId, 0, 0);
    `;

    for (let i = 0; i < 5; i++) { // Création de 5 tas par défaut
      await pool.request()
        .input('ligneId', sql.Int, ligneId)
        .query(tasQuery);
    }

    res.status(201).json({ message: 'Ligne créée avec succès', ligneId });
  } catch (err) {
    console.error('Erreur lors de la création de la ligne :', err.message);
    res.status(500).json({ error: 'Erreur interne du serveur' });
  }
});


app.post('/deverouillerLigne', async (req, res) => {
  try {
    const { ligneId } = req.body;

    // Remettre les champs de la ligne à leurs valeurs par défaut
    await query(
      'UPDATE LIGNE SET nbreTas = 5, tonnageLigne = 0.0, tonnageTasBroye = 0.0 WHERE id = ?',
      [ligneId]
    );

    // Remettre à zéro l'état et le poids des tas associés à cette ligne
    await query(
      'UPDATE TAS SET etat = 0, poids = 0.0 WHERE ligneId = ?',
      [ligneId]
    );

    res.status(200).json({ message: 'Ligne déverrouillée et tas associés réinitialisés avec succès' });
  } catch (error) {
    console.error('Erreur lors du déverrouillage de la ligne:', error);
    res.status(500).json({ message: 'Erreur lors du déverrouillage de la ligne' });
  }
});




/****************************************
UPDATE CAMIONS POIDS P2
***************************************/


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


//les camions dans la table dechargerCours dont le poids de la deuxieme pessee n'est pas encore disponible
app.get('/camionsP2NullCours', async (req, res) => {
  try {
    const pool = await poolPromise;

    // Requête pour récupérer les camions avec poidsP2 NULL dans DECHARGERCOURS
    const result = await pool.request()
      .query(`
        SELECT veCode, dateHeureP1, poidsP1
        FROM DECHARGERCOURS
        WHERE poidsP2 IS NULL
      `);

    res.json(result.recordset);
  } catch (err) {
    console.error('SQL error', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


//les camions dans la table dechargerTable dont le poids de la deuxieme pessee n'est pas encore disponible
app.get('/camionsP2NullTable', async (req, res) => {
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

//mettre a le poids P2 (poids de la deuxieme pesse)
app.post('/updatePoidsP2Cours', async (req, res) => {
  try {
    const { camions } = req.body;

    if (!camions || !Array.isArray(camions)) {
      return res.status(400).json({ error: 'Invalid input' });
    }

    const pool = await poolPromise;
    const updatePromises = camions.map(camion => {
      const { veCode, dateHeureP1, poidsP2 } = camion;
      //.input('poidsP2', sql.Decimal, poidsP2 !== undefined ? poidsP2 : null) // Gestion explicite de null
      return pool.request()
        .input('veCode', sql.VarChar, veCode)
        .input('dateHeureP1', sql.DateTime, new Date(dateHeureP1))
        .input('poidsP2', sql.Decimal, poidsP2 )
        .query(`
          UPDATE DECHARGERCOURS
          SET poidsP2 = @poidsP2
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

//  mettre a jour le poids P2 (poids de la deuxieme pesse)
app.post('/updatePoidsP2Table', async (req, res) => {
  try {
    const { camions } = req.body;

    if (!camions || !Array.isArray(camions)) {
      return res.status(400).json({ error: 'Invalid input' });
    }

    const pool = await poolPromise;
    const updatePromises = camions.map(camion => {
      const { veCode, dateHeureP1, poidsP2 } = camion;
      return pool.request()
        .input('veCode', sql.VarChar, veCode)
        .input('dateHeureP1', sql.DateTime, new Date(dateHeureP1))
        .input('poidsP2', sql.Decimal, poidsP2)
        .query(`
          UPDATE DECHARGERTABLE
          SET poidsP2 = @poidsP2
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

//voir s'il y'a des camions pour lesquels le poids de la deuxieme pesse n'est pas disponible
app.get('/checkPoidsP2Null', async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request()
      .query('SELECT TOP 1 1 AS found FROM DECHARGERCOURS WHERE poidsP2 IS NULL');

    const needsUpdate = result.recordset.length > 0;

    res.status(200).json({ needsUpdate: needsUpdate });
  } catch (err) {
    console.error('SQL error', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


/***********************************
 BROYAGE
 ***************************/

// Route pour enregistrer les tas broyés avec le matricule de l'agent
app.post('/addTasInTableCanne', async (req, res) => {
  try {
    // Extraction des paramètres de la requête
    const { ligneId, tasPoids, matricule } = req.body;

    // Vérification que les paramètres requis sont fournis
    if (!ligneId || !tasPoids || !matricule) {
      return res.status(400).json({ error: 'Invalid request parameters' });
    }

    // Connexion à la base de données via le pool de connexions
    const pool = await poolPromise;

    // Obtenir la date et l'heure actuelles
    const now = new Date();
    const currentDate = now.toISOString().split('T')[0]; // Format YYYY-MM-DD
    const currentHour = now.getHours(); // Heure actuelle (0-23)

    // Vérifier si un enregistrement existe déjà pour la date, l'heure et le matricule spécifiés
    const checkQuery = `
      SELECT * 
      FROM TABLECANNE 
      WHERE YEAR(dateBroyage) = YEAR(GETDATE()) 
        AND dateBroyage = @currentDate 
        AND heureBroyage = @currentHour
        AND agentMatricule = @matricule;
    `;

    // Exécution de la requête pour vérifier l'existence de l'enregistrement
    const existingRecord = await pool.request()
      .input('currentDate', sql.Date, currentDate)
      .input('currentHour', sql.Int, currentHour)
      .input('matricule', sql.NVarChar(50), matricule)
      .query(checkQuery);

    let query;

    if (existingRecord.recordset.length > 0) {
      // Si l'enregistrement existe déjà, ajouter le poids du tas broyé au tonnageCanneBroyerParTas
      query = `
        UPDATE TABLECANNE 
        SET TonnageCanneBroyerParTas = TonnageCanneBroyerParTas + @tasPoids
        WHERE YEAR(dateBroyage) = YEAR(GETDATE()) 
          AND dateBroyage = @currentDate 
          AND heureBroyage = @currentHour
          AND agentMatricule = @matricule;
      `;
    } else {
      // Si l'enregistrement n'existe pas, insérer un nouvel enregistrement avec la date actuelle
      query = `
        INSERT INTO TABLECANNE (TonnageCanneBroyerParTas, dateBroyage, heureBroyage, agentMatricule)
        VALUES (@tasPoids, @currentDate, @currentHour, @matricule);
      `;
    }

    // Exécution de la requête d'insertion ou de mise à jour
    await pool.request()
      .input('tasPoids', sql.Decimal(10, 2), tasPoids)
      .input('currentDate', sql.Date, currentDate)
      .input('currentHour', sql.Int, currentHour)
      .input('matricule', sql.NVarChar(50), matricule)
      .query(query);

    // Mise à jour du tonnage broyé dans la table LIGNE
    const updateLigneQuery = `
      UPDATE LIGNE
      SET tonnageTasBroye = tonnageTasBroye + @tasPoids
      WHERE id = @ligneId;
    `;

    // Exécution de la requête pour mettre à jour la table LIGNE
    await pool.request()
      .input('tasPoids', sql.Decimal(10, 2), tasPoids)
      .input('ligneId', sql.Int, ligneId)
      .query(updateLigneQuery);

    // Réponse JSON indiquant que l'opération a réussi
    res.json({ success: true });
  } catch (err) {
    // Gestion des erreurs SQL et renvoi d'un message d'erreur
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


//route pour annuler un broyage de tas
app.post('/retraitTasDeTableCanne', async (req, res) => {
  try {
    // Extraction des paramètres de la requête
    const { ligneId, tasPoids } = req.body;

    // Vérification que les paramètres requis sont fournis
    if (!ligneId || !tasPoids) {
      return res.status(400).json({ error: 'Invalid request parameters' });
    }

    // Connexion à la base de données via le pool de connexions
    const pool = await poolPromise;

    // Rechercher le dernier enregistrement dans TABLECANNE avec un tonnage suffisant
    const getLastValidRecordQuery = `
      SELECT TOP 1 * 
      FROM TABLECANNE 
      WHERE TonnageCanneBroyerParTas >= @tasPoids
        AND YEAR(dateBroyage) = YEAR(GETDATE()) 
      ORDER BY dateBroyage DESC, heureBroyage DESC;
    `;

    // Exécuter la requête pour obtenir le dernier enregistrement valide
    const lastRecord = await pool.request()
      .input('tasPoids', sql.Decimal(10, 2), tasPoids)
      .query(getLastValidRecordQuery);

    // Vérifier si un enregistrement valide a été trouvé
    if (lastRecord.recordset.length === 0) {
      return res.status(404).json({ error: 'No valid records found to update' });
    }

    // Extraire le dernier enregistrement valide
    const lastRecordData = lastRecord.recordset[0];
    const currentTonnage = lastRecordData.TonnageCanneBroyerParTas;

    // Calculer le nouveau tonnage après soustraction
    const newTonnage = currentTonnage - tasPoids;

    // Vérifier si la soustraction conduit à un tonnage négatif
    if (newTonnage < 0) {
      return res.status(400).json({ error: 'Operation failed: resulting tonnage would be negative' });
    }

    // Mettre à jour l'enregistrement avec le nouveau tonnage
    const updateQuery = `
      UPDATE TABLECANNE 
      SET TonnageCanneBroyerParTas = @newTonnage
      WHERE id = @lastRecordId;
    `;

    await pool.request()
      .input('newTonnage', sql.Decimal(10, 2), newTonnage)
      .input('lastRecordId', sql.Int, lastRecordData.id)
      .query(updateQuery);

    // Mise à jour du tonnage broyé dans la table LIGNE
    const updateLigneQuery = `
      UPDATE LIGNE
      SET tonnageTasBroye = tonnageTasBroye - @tasPoids
      WHERE id = @ligneId;
    `;

    // Exécution de la requête pour mettre à jour la table LIGNE
    await pool.request()
      .input('tasPoids', sql.Decimal(10, 2), tasPoids)
      .input('ligneId', sql.Int, ligneId)
      .query(updateLigneQuery);

    // Réponse JSON indiquant que l'opération a réussi
    res.json({ success: true });
  } catch (err) {
    // Gestion des erreurs SQL et renvoi d'un message d'erreur
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Route pour vérifier si tous les tas d'une ligne ont leur état à 1
app.get('/verifierTousTasCoches/:ligneId', async (req, res) => {
  try {
    const { ligneId } = req.params;

    // Connexion à la base de données
    const pool = await poolPromise;

    // Requête pour vérifier si tous les tas sont cochés (état = 1)
    const query = `
      SELECT COUNT(*) AS totalTas, 
             SUM(CASE WHEN Etat = 1 THEN 1 ELSE 0 END) AS tasCoches
      FROM TAS
      WHERE ligneId = @ligneId
    `;

    const result = await pool.request()
      .input('ligneId', sql.Int, ligneId)
      .query(query);

    const { totalTas, tasCoches } = result.recordset[0];
    
    // Vérifier si tous les tas sont cochés
    const estTousCoches = totalTas === tasCoches;

    res.json({ estTousCoches });
  } catch (err) {
    console.error('Error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Route pour mettre à jour le nombre de tas dans la table LIGNE
app.post('/updateNombreTas', async (req, res) => {
  try {
    const { ligneId, nouveauNombreTas } = req.body;

    // Vérification que les paramètres requis sont fournis
    if (typeof ligneId !== 'number' || typeof nouveauNombreTas !== 'number') {
      return res.status(400).json({ error: 'Invalid request parameters' });
    }

    // Connexion à la base de données
    const pool = await poolPromise;

    // Récupérer les informations actuelles de la ligne, y compris l'ancien nombre de tas et le tonnage de la ligne
    const result = await pool.request()
      .input('ligneId', sql.Int, ligneId)
      .query(`
        SELECT nbreTas, tonnageLigne 
        FROM LIGNE 
        WHERE id = @ligneId
      `);

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Ligne not found' });
    }

    const ligne = result.recordset[0];
    const ancienNombreTas = ligne.nbreTas;
    const tonnageLigne = ligne.tonnageLigne;

    // Calcul du nouveau poids par tas
    const poidsParTas = tonnageLigne / nouveauNombreTas;

    if (nouveauNombreTas > ancienNombreTas) {
      // Ajouter des tas supplémentaires si le nouveau nombre est supérieur
      for (let i = ancienNombreTas; i < nouveauNombreTas; i++) {
        await pool.request()
          .input('ligneId', sql.Int, ligneId)
          .input('poids', sql.Decimal(10, 2), poidsParTas)
          .query(`
            INSERT INTO TAS (ligneId, poids) 
            VALUES (@ligneId, @poids)
          `);
      }
    } else if (nouveauNombreTas < ancienNombreTas) {
      // Supprimer les tas en excès si le nouveau nombre est inférieur
      await pool.request()
        .input('ligneId', sql.Int, ligneId)
        .input('limit', sql.Int, ancienNombreTas - nouveauNombreTas)
        .query(`
          DELETE FROM TAS 
          WHERE ligneId = @ligneId 
          AND id IN (
            SELECT TOP (@limit) id FROM TAS WHERE ligneId = @ligneId ORDER BY id DESC
          )
        `);
    }

    // Mettre à jour les poids de tous les tas restants pour répartir uniformément le tonnage
    await pool.request()
      .input('ligneId', sql.Int, ligneId)
      .input('poids', sql.Decimal(10, 2), poidsParTas)
      .query(`
        UPDATE TAS 
        SET poids = @poids 
        WHERE ligneId = @ligneId
      `);

    // Mettre à jour le nombre de tas dans la table LIGNE
    await pool.request()
      .input('nouveauNombreTas', sql.Int, nouveauNombreTas)
      .input('ligneId', sql.Int, ligneId)
      .query(`
        UPDATE LIGNE 
        SET nbreTas = @nouveauNombreTas 
        WHERE id = @ligneId
      `);

    // Répondre avec succès
    res.json({ success: true });

  } catch (err) {
    // Gestion des erreurs SQL et renvoi d'un message d'erreur
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }

  /*

  Récupération des données actuelles : La route commence par récupérer le nombre actuel de tas et le tonnage de la ligne.

  Calcul du nouveau poids par tas : Le tonnage total de la ligne est divisé par le nouveau nombre de tas pour calculer le poids de chaque tas.

  Augmentation du nombre de tas : Si le nouveau nombre est supérieur à l'ancien, des tas supplémentaires sont ajoutés avec le poids calculé.

  Diminution du nombre de tas : Si le nouveau nombre est inférieur, des tas sont supprimés en commençant par les plus récents.

  Répartition uniforme du poids : Tous les tas existants sont ensuite mis à jour avec le poids recalculé pour s'assurer que le tonnage est réparti uniformément.

  Mise à jour de LIGNE : Enfin, le nombre de tas est mis à jour dans la table LIGNE.

  */


});


//route pour mettre à jour l'état du tas 
app.put('/updateEtatTas', async (req, res) => {
  try {
    const { ligneId, tasId, nouvelEtat } = req.body;

    if (!ligneId || !tasId || nouvelEtat === undefined) {
      return res.status(400).json({ error: 'Invalid request parameters' });
    }

    const pool = await poolPromise;
    const query = `
      UPDATE TAS
      SET etat = @nouvelEtat
      WHERE id = @tasId AND ligneId = @ligneId;
    `;

    await pool.request()
      .input('nouvelEtat', sql.Int, nouvelEtat)
      .input('tasId', sql.Int, tasId)
      .input('ligneId', sql.Int, ligneId)
      .query(query);

    res.json({ success: true });
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


//Cette route met à jour l'état de broyage de tous les camions associés à une ligne donnée à 1.
app.post('/updateEtatBroyage', async (req, res) => {
  try {
    const { ligneLibele } = req.body;

    // Mise à jour de l'état de broyage pour tous les camions de la ligne donnée
    await query(
      'UPDATE DECHARGERCOURS SET etatBroyage = 1 WHERE ligneLibele = ?',
      [ligneLibele]
    );

    res.status(200).json({ message: 'État de broyage mis à jour avec succès' });
  } catch (error) {
    console.error('Erreur lors de la mise à jour de l\'état de broyage:', error);
    res.status(500).json({ message: 'Erreur lors de la mise à jour de l\'état de broyage' });
  }
});




/***********************************
 SYNCHRONISATION
***************************/


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



/***********************************
 BILAN STOCK
***************************/

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
          AND heureBroyage BETWEEN @heureDebut AND @heureFin;
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
             AND heureBroyage >= @heureDebut)
            OR
            -- Seconde condition: le déchargement s'est produit le jour suivant avant l'heure de fin
            (CAST(dateDecharg AS DATE) = DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) 
             AND heureBroyage <= @heureFin)
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




/***********************************
AUTHENTIFICATION
***************************/


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


