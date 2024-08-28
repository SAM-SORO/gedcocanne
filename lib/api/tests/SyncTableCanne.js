// api SyncTableCanne.js

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { sql, poolPromise } = require('../config');

const app = express();
const PORT = process.env.PORT || 144;

app.use(bodyParser.json());
app.use(cors());

app.post('/sync-table-cvfanne', async (req, res) => {
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

      const heureDechargInt = parseInt(canne.heureDecharg); // Convertir l'heure en entier
      console.log( canne.TonnageTasDeverse);
      console.log( canne.AnneeTableCanne);
      console.log( canne.dateDecharg);
      console.log( canne.dateDecharg);

      if (canne.etatSynchronisation) {
        // Mise à jour des entrées existantes
        await request
          .input('TonnageCanneBroyerParTas', sql.Decimal(18, 4), canne.TonnageTasDeverse)
          .input('AnneeTableCanne', sql.Int, canne.AnneeTableCanne)
          .input('dateDecharg', sql.Date, canne.dateDecharg)
          .input('heureDecharg', sql.Int, heureDechargInt)
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
          .input('TonnageCanneBroyerParTas', sql.Decimal(18, 4), canne.TonnageTasDeverse)
          .input('AnneeTableCanne', sql.Int, canne.AnneeTableCanne)
          .input('dateDecharg', sql.Date, canne.dateDecharg)
          .input('heureDecharg', sql.Int, heureDechargInt)
          .query(`
            INSERT INTO TABLECANNE (TonnageCanneBroyerParTas, AnneeTableCanne, dateDecharg, heureDecharg)
            VALUES (@TonnageCanneBroyerParTas, @AnneeTableCanne, @dateDecharg, @heureDecharg)
          `);
      }
    }

    await transaction.commit();
    res.status(200).json({ message: 'TABLECANNE synchronized successfully' });
  } catch (err) {
    console.error('SQL error', err);
    if (transaction) {
      await transaction.rollback();
    }
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
