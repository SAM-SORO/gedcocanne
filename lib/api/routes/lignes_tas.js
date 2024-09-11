const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données


// Route pour créer une ligne
router.post('/creerLigne', async (req, res) => {
  try {
    const {libele, agentMatricule } = req.body;  // Suppression de agentId

    const pool = await poolPromise;

    // Insérer la nouvelle ligne sans agentId, mais avec agentMatricule
    const ligneQuery = `
      INSERT INTO LIGNE (libele, agentMatricule, tonnageLigne, statutVerouillage, statutLiberation)
      OUTPUT INSERTED.id
      VALUES (@libele, @agentMatricule, 0.0, 0, 0);
    `;

    const ligneResult = await pool.request()
      .input('libele', sql.NVarChar, libele)
      .input('agentMatricule', sql.NVarChar, agentMatricule)  // Utilisation de agentMatricule uniquement
      .query(ligneQuery);

    const ligneId = ligneResult.recordset[0].id;

    // Créer les tas associés à cette ligne (5 tas par défaut)
    const tasQuery = `
      INSERT INTO TAS (ligneId, ligneLibele, poids, etat, dateBroyage, heureBroyage, agentBroyage)
      VALUES (@ligneId, @ligneLibele, @poids, @etat, @dateBroyage, @heureBroyage, @agentBroyage);
    `;

    for (let i = 0; i < 5; i++) { // Création de 5 tas par défaut
      await pool.request()
        .input('ligneId', sql.Int, ligneId)
        .input('ligneLibele', sql.NVarChar, libele)  // Utilisation de libele comme ligneLibele
        .input('poids', sql.Decimal, 0.0)
        .input('etat', sql.Int, 0)
        .input('dateBroyage', sql.Date, null) // Valeur par défaut NULL
        .input('heureBroyage', sql.Int, null)  // Valeur par défaut NULL
        .input('agentBroyage', sql.NVarChar, null) // Agent de broyage NULL par défaut
        .query(tasQuery);
    }

    res.status(201).json({ message: 'Ligne créée avec succès', ligneId });
  } catch (err) {
    console.error('Erreur lors de la création de la ligne :', err.message);
    res.status(500).json({ error: 'Erreur interne du serveur' });
  }
});

// Route pour récupérer les données de la ligne
router.get('/getLignes', async (req, res) => {
  try {
    const pool = await poolPromise;
    
    // Requête SQL pour récupérer toutes les lignes avec statutLiberation = 0 et les tas associés
    const query = `
      SELECT 
        L.id AS ligneId, 
        L.libele, 
        L.nbreTas, 
        L.tonnageLigne, 
        L.agentMatricule,  -- Suppression de agentId, conservation de agentMatricule
        L.statutVerouillage,  -- Inclure le statut de verrouillage
        L.statutLiberation,  -- Inclure le statut de libération
        T.id AS tasId,
        T.poids AS tasPoids,
        T.etat AS tasEtat,
        (SELECT COUNT(*) FROM TAS WHERE ligneId = L.id AND etat = 1) AS nbreTasBroyes,  -- Nombre de tas broyés
        (SELECT SUM(poids) FROM TAS WHERE ligneId = L.id AND etat = 1) AS tonnageTasBroyes  -- Tonnage total broyé
      FROM 
        LIGNE L
      LEFT JOIN 
        TAS T ON L.id = T.ligneId
      WHERE
        L.statutLiberation = 0  -- Filtrer les lignes avec statutLiberation = 0
      ORDER BY 
        L.libele ASC  -- Trier par libele en ordre croissant
    `;
    
    const result = await pool.request().query(query);

    // Transformer les résultats en une structure imbriquée
    const lignesMap = new Map();

    result.recordset.forEach(row => {
      const ligneId = row.ligneId;

      // Si la ligne n'existe pas encore dans le Map, l'ajouter
      if (!lignesMap.has(ligneId)) {
        lignesMap.set(ligneId, {
          ligneId: row.ligneId,
          libele: row.libele,
          nbreTas: row.nbreTas,
          tonnageLigne: row.tonnageLigne,
          agentMatricule: row.agentMatricule,  // Utilisation de agentMatricule seulement
          statutVerouillage: row.statutVerouillage,
          statutLiberation: row.statutLiberation,
          nbreTasBroyes: row.nbreTasBroyes || 0,  // Nombre de tas broyés
          tonnageTasBroyes: row.tonnageTasBroyes || 0.0,  // Tonnage broyé
          tas: []  // Initialiser la liste des tas pour cette ligne
        });
      }

      // Ajouter les tas à la ligne
      if (row.tasId) {
        lignesMap.get(ligneId).tas.push({
          tasId: row.tasId,
          poids: row.tasPoids,
          tasEtat: row.tasEtat
        });
      }
    });

    // Convertir le Map en une liste
    const lignes = Array.from(lignesMap.values());

    res.json(lignes);

  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



// Route pour vérifier s'il est acceptable de supprimer une ligne
router.get('/canDeleteLigne/:libele', async (req, res) => {

  const libele = req.params.libele;

  try {
    const pool = await poolPromise;

    // Requête pour vérifier s'il existe des lignes avec un libele supérieur et un statutLiberation à 0
    //console.log(libele);
    const query = `
      SELECT COUNT(*) as count
      FROM LIGNE
      WHERE libele > @libele AND statutLiberation = 0;
    `;

    const result = await pool.request()
      .input('libele', sql.VarChar, libele) // Adaptez le type en fonction de la colonne libele
      .query(query);

    const count = result.recordset[0].count;

    if (count > 0) {
      
      return res.status(400).json({ error: 'Impossible de supprimer cette ligne. Supprimez d\'abord les lignes avec un libele supérieur ayant un statutLiberation à 0.' });
    } else {
      return res.status(200).json({ message: 'Vous pouvez supprimer cette ligne.' });
    }
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Erreur lors de la vérification de la ligne' });
  }
});


// Route pour supprimer une ligne par son ID
router.delete('/deleteLigne/:id', async (req, res) => {
  const ligneId = req.params.id;
  //const ligneId = parseInt(req.params.id, 10); // Assurez-vous que ligneId est un entier

  try {
    const pool = await poolPromise;
    const deleteCamionsQuery = `
      DELETE FROM DECHARGERCOURS
      WHERE ligneId = @ligneId
        AND etatBroyage = 0;
    `;

    // Supprimer les camions associés à la ligne
    await pool.request()
      .input('ligneId', sql.Int, ligneId)
      .query(deleteCamionsQuery);

    const deleteLigneQuery = `
      DELETE FROM LIGNE
      WHERE id = @ligneId;
    `;

    // Supprimer la ligne
    await pool.request()
      .input('ligneId', sql.Int, ligneId)
      .query(deleteLigneQuery);

    res.status(200).json({ message: 'Ligne et camions associés supprimés avec succès' });
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Erreur lors de la suppression de la ligne et des camions associés' });
  }
});


// Route pour obtenir le nombre de lignes
router.get('/getLigneCount', async (req, res) => {
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


// Route pour mettre à jour le statut de verrouillage d'une ligne
// Route pour mettre à jour le statut de verrouillage d'une ligne
router.put('/updateStatutVerouillage', async (req, res) => {
  try {
    const { ligneId } = req.body;

    // Vérification si ligneId est fourni
    if (!ligneId) {
      return res.status(400).json({ error: 'LigneId est requis' });
    }

    // Connexion à la base de données à partir de poolPromise
    const pool = await poolPromise;

    // Requête SQL pour mettre à jour le statut de verrouillage
    const updateLigneQuery = `
      UPDATE LIGNE
      SET statutVerouillage = 1  -- Marquer la ligne comme verrouillée
      WHERE id = @ligneId;
    `;

    // Exécuter la requête avec le paramètre ligneId
    const result = await pool.request()
      .input('ligneId', sql.Int, ligneId) // Associer l'id de la ligne avec le type Int
      .query(updateLigneQuery);

    // Vérifier si une ligne a été mise à jour
    if (result.rowsAffected[0] > 0) {
      res.status(200).json({ success: true, message: 'Le statut de verrouillage de la ligne a été mis à jour avec succès' });
    } else {
      res.status(404).json({ success: false, message: 'Ligne non trouvée' });
    }

  } catch (err) {
    // Gestion des erreurs
    console.error('Erreur lors de la mise à jour du statut de verrouillage :', err.message);
    res.status(500).json({ error: 'Erreur interne du serveur' });
  }
});


  


// Route pour déverrouiller une ligne (revient a liberer la ligne et a en creer une nouvelle)
router.post('/deverouillerLigne', async (req, res) => {
  try {
    const { ligneId, ligneLibele } = req.body;

    // Vérification des champs obligatoires
    if (!ligneId || !ligneLibele) {
      return res.status(400).json({ error: 'LigneId et ligneLibele sont requis' });
    }

    // console.log(ligneId);
    // console.log(ligneLibele);

    const pool = await poolPromise; // Utilisation de poolPromise pour obtenir la connexion

    // Déverrouiller la ligne en mettant à jour statutVerouillage et statutLiberation
    const updateLigneQuery = `
      UPDATE LIGNE
      SET statutVerouillage = 1, statutLiberation = 1
      WHERE id = @ligneId;
    `;

    const updateResult = await pool.request()
      .input('ligneId', sql.Int, ligneId)
      .query(updateLigneQuery);

    // Vérifier si la mise à jour a affecté une ligne
    if (updateResult.rowsAffected[0] > 0) {
      // Créer une nouvelle ligne avec le même libellé (ligneLibele) après la déverrouillage
      const createNewLigneQuery = `
        INSERT INTO LIGNE (libele, nbreTas, tonnageLigne, statutVerouillage, statutLiberation)
        OUTPUT INSERTED.id
        VALUES (@ligneLibele, 5, 0.0, 0, 0);
      `;

      const createResult = await pool.request()
        .input('ligneLibele', sql.NVarChar, ligneLibele)
        .query(createNewLigneQuery);

      const newLigneId = createResult.recordset[0].id;

      // Création de 5 tas associés à la ligne nouvellement créée
      const tasQuery = `
        INSERT INTO TAS (ligneId, ligneLibele, poids, etat, dateBroyage, heureBroyage, agentBroyage)
        VALUES (@ligneId, @ligneLibele, @poids, @etat, @dateBroyage, @heureBroyage, @agentBroyage);
      `;

      for (let i = 0; i < 5; i++) { // Création de 5 tas par défaut
        await pool.request()
          .input('ligneId', sql.Int, newLigneId)  // Associer le tas à la nouvelle ligne
          .input('ligneLibele', sql.NVarChar, ligneLibele)  // Utilisation de libele comme ligneLibele
          .input('poids', sql.Decimal, 0.0)
          .input('etat', sql.Int, 0)  // Etat par défaut
          .input('dateBroyage', sql.Date, null) // Valeur par défaut NULL
          .input('heureBroyage', sql.Int, null)  // Valeur par défaut NULL
          .input('agentBroyage', sql.NVarChar, null) // Agent de broyage NULL par défaut
          .query(tasQuery);
      }

      // Répondre avec succès et renvoyer le nouvel ID de la ligne
      res.status(200).json({ success: true, message: 'Ligne déverrouillée, nouvelle ligne créée et 5 tas associés ajoutés', newLigneId });
    } else {
      res.status(404).json({ success: false, message: 'Ligne non trouvée' });
    }

  } catch (err) {
    console.error('Erreur lors du déverrouillage de la ligne :', err.message);
    res.status(500).json({ error: 'Erreur interne du serveur' });
  }
});





//Mettre à jour le tonnage de la ligne
router.post('/updateLigneTonnage', async (req, res) => {
  try {
    const { ligneId, ligneLibele } = req.body;

    // Validation des données
    if (!ligneId || !ligneLibele) {
      return res.status(400).send({ success: false, message: 'LigneId et LigneLibele sont requis.' });
    }

    // Connexion à la base de données
    const pool = await poolPromise;

    // Calculer le tonnage total de la ligne en fonction du libellé de la ligne
    const tonnageQuery = `
      SELECT SUM(poidsNet) AS totalTonnage
      FROM DECHARGERCOURS
      WHERE ligneLibele = @ligneLibele AND etatBroyage = 0
    `;

    const result = await pool.request()
      .input('ligneLibele', sql.NVarChar, ligneLibele)
      .query(tonnageQuery);

    // Extraire le tonnage total ou le définir à zéro si aucun résultat
    const tonnageLigne = result.recordset[0]?.totalTonnage || 0;

    // Mise à jour du tonnage de la ligne dans la table LIGNE
    const updateQuery = `
      UPDATE LIGNE
      SET tonnageLigne = @tonnageLigne
      WHERE id = @ligneId
    `;

    await pool.request()
      .input('tonnageLigne', sql.Decimal(10, 2), tonnageLigne)
      .input('ligneId', sql.Int, ligneId)
      .query(updateQuery);

    // Réponse en cas de succès
    res.status(200).send({ success: true, message: 'Tonnage de la ligne mis à jour avec succès.', tonnageLigne });

  } catch (error) {
    console.error('Erreur lors de la mise à jour du tonnage de la ligne:', error);
    res.status(500).send({ success: false, message: `Erreur lors de la mise à jour : ${error.message}` });
  }
});

//  Répartir le Tonnage entre les Tas
router.post('/repartirTonnageTas', async (req, res) => {
  try {
    const { ligneId } = req.body;

    // Validation des données d'entrée
    if (!ligneId) {
      return res.status(400).send({ success: false, message: 'ligneId est requis.' });
    }

    const pool = await poolPromise;

    // Obtenir le nombre de tas pour la ligne
    const tasQuery = `
      SELECT nbreTas
      FROM LIGNE
      WHERE id = @ligneId
    `;

    const tasResult = await pool.request()
      .input('ligneId', sql.Int, ligneId)
      .query(tasQuery);

    const nbreTas = tasResult.recordset[0]?.nbreTas || 5; // Par défaut, 5 tas si aucune donnée

    // Calculer le poids par tas
    const poidsParTasQuery = `
      SELECT tonnageLigne / @nbreTas AS poidsParTas
      FROM LIGNE
      WHERE id = @ligneId
    `;

    const poidsParTasResult = await pool.request()
      .input('nbreTas', sql.Int, nbreTas)
      .input('ligneId', sql.Int, ligneId)
      .query(poidsParTasQuery);

    const poidsParTas = poidsParTasResult.recordset[0]?.poidsParTas || 0;

    // Répartir le poids entre les tas
    const updateTasQuery = `
      UPDATE TAS
      SET poids = @poidsTas
      WHERE ligneId = @ligneId
    `;

    await pool.request()
      .input('poidsTas', sql.Decimal(10, 2), poidsParTas)
      .input('ligneId', sql.Int, ligneId)
      .query(updateTasQuery);

    // Réponse de succès
    res.status(200).send({ success: true, message: 'Le tonnage a été réparti avec succès entre les tas.', poidsParTas });

  } catch (error) {
    console.error('Erreur lors de la répartition du tonnage entre les tas:', error);
    res.status(500).send({ success: false, message: `Erreur lors de la répartition : ${error.message}` });
  }
});



module.exports = router;


