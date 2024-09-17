
const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../config'); // Importer la configuration de la base de données

/***********************************
 BROYAGE
 ***************************/


// Route pour mettre à jour l'état du tas, ajouter la date, l'heure et le matricule de l'agent
router.put('/addTasInTableCanne', async (req, res) => {
  try {
    const { tasId, agentMatricule } = req.body;

    if (!tasId || !agentMatricule) {
      return res.status(400).json({ error: 'Invalid request parameters' });
    }

    const pool = await poolPromise;

    // Obtenir la date et l'heure actuelles
    const now = new Date();
    const dateBroyage = now.toISOString().split('T')[0];  // Format YYYY-MM-DD
    const heureBroyage = now.getHours();  // Heure (format 24h)

    // Mise à jour de l'état, de la date, de l'heure, et du matricule de l'agent
    const query = `
      UPDATE TAS
      SET etat = 1, 
          dateBroyage = @dateBroyage, 
          heureBroyage = @heureBroyage, 
          agentBroyage = @agentMatricule  -- Utilisation de agentBroyage pour mettre à jour le matricule de l'agent
      WHERE id = @tasId;
    `;

    await pool.request()
      .input('dateBroyage', sql.Date, dateBroyage)
      .input('heureBroyage', sql.Int, heureBroyage)
      .input('agentMatricule', sql.NVarChar, agentMatricule)  // Utiliser agentMatricule reçu dans la requête
      .input('tasId', sql.Int, tasId)
      .query(query);

    res.json({ success: true });
  } catch (err) {
    console.error('SQL error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

  

// Route pour retirer un tas de TableCanne (annuler la coche)
// Route pour retirer un tas de TableCanne (annuler la coche)
router.put('/retraitTasDeTableCanne', async (req, res) => {
  try {
    const { tasId, agentMatricule } = req.body;

    // Vérification des paramètres
    if (!tasId || !agentMatricule) {
      return res.status(400).json({ error: 'Paramètres de requête invalides' });
    }

    const pool = await poolPromise;

    // Si le matricule est "admin", ignorer la vérification de l'agent
    if (agentMatricule !== 'admin') {
      // Vérifier que le tas existe avec cet agent et avec l'état 1
      const checkTasQuery = `
        SELECT id 
        FROM TAS 
        WHERE id = @tasId AND agentBroyage = @agentMatricule AND etat = 1;
      `;

      const checkTasResult = await pool.request()
        .input('tasId', sql.Int, tasId)
        .input('agentMatricule', sql.NVarChar, agentMatricule)
        .query(checkTasQuery);

      // Si aucun tas n'est trouvé ou si l'agent ne correspond pas
      if (checkTasResult.recordset.length === 0) {
        return res.status(403).json({ non_autorise: true, message: 'Non autorisé ou tas introuvable.' });
      }
    }

    // Mettre à jour l'état du tas à 0, réinitialiser la date, l'heure de broyage et l'agentBroyage
    const updateTasQuery = `
      UPDATE TAS
      SET etat = 0,
          dateBroyage = NULL,
          heureBroyage = NULL,
          agentBroyage = NULL
      WHERE id = @tasId;
    `;

    await pool.request()
      .input('tasId', sql.Int, tasId)
      .query(updateTasQuery);

    res.json({ success: true, message: 'Tas mis à jour avec succès.' });
  } catch (err) {
    console.error('Erreur SQL:', err.message);
    res.status(500).json({ error: 'Erreur interne du serveur.' });
  }
});



  
// Route pour vérifier si tous les tas d'une ligne ont leur état à 1
router.get('/verifierTousTasCoches/:ligneId', async (req, res) => {
  try {
    const { ligneId } = req.params;

    // Connexion à la base de données
    const pool = await poolPromise;

    // Requête pour vérifier s'il existe au moins un tas avec état = 0 pour la ligne donnée
    const result = await pool.request()
      .input('ligneId', sql.Int, ligneId)
      .query(`
        IF EXISTS (
          SELECT 1 
          FROM TAS 
          WHERE ligneId = @ligneId 
            AND etat = 0
        )
        SELECT 1
        ELSE
        SELECT 0
      `);

    // Vérifier le résultat de la requête
    const estTousCoches = result.recordset[0][''] === 0;

    res.json({ estTousCoches });
  } catch (err) {
    console.error('Error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


  
// Route pour mettre à jour le nombre de tas dans la table LIGNE
router.post('/updateNombreTas', async (req, res) => {
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
          .input('etat', sql.Int, 0) // Etat initial à 0 (non broyé)
          .input('dateBroyage', sql.Date, null) // Date de broyage NULL
          .input('heureBroyage', sql.Int, null) // Heure de broyage NULL
          .input('agentBroyage', sql.NVarChar, null) // Agent de broyage NULL
          .query(`
            INSERT INTO TAS (ligneId, poids, etat, dateBroyage, heureBroyage, agentBroyage) 
            VALUES (@ligneId, @poids, @etat, @dateBroyage, @heureBroyage, @agentBroyage)
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
            SELECT TOP (@limit) id 
            FROM TAS 
            WHERE ligneId = @ligneId AND etat = 0 
            ORDER BY id DESC
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
        WHERE ligneId = @ligneId AND etat = 0
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
});


  
  
//Cette route met à jour l'état de broyage de tous les camions associés à une ligne donnée à 1.
router.post('/updateEtatBroyageOfCamionAffecte', async (req, res) => {
  try {
    const { ligneId } = req.body;

    //console.log(ligneId);

    if (!ligneId) {
      return res.status(400).json({ message: "L'identifiant de la ligne est requis" });
    }

    const pool = await poolPromise; // Assurez-vous que poolPromise est bien défini et utilisé

    // Mise à jour de l'état de broyage pour tous les camions de la ligne donnée
    await pool.request()
      .input('ligneId', sql.Int, ligneId)  // Liaison du paramètre ligneId à la requête
      .query(
        'UPDATE DECHARGERCOURS SET etatBroyage = 1 WHERE ligneId = @ligneId'
      );

    res.status(200).json({ message: 'État de broyage mis à jour avec succès pour la ligne' });
  } catch (error) {
    console.error("Erreur lors de la mise à jour de l'état de broyage:", error);
    res.status(500).json({ message: "Erreur lors de la mise à jour de l'état de broyage" });
  }
});



module.exports = router;

  