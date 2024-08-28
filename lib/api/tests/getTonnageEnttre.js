const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { sql, poolPromise } = require('../config');

const app = express();
const PORT = process.env.PORT || 1450;

app.use(bodyParser.json());
app.use(cors());

app.post('/tonnageEntreeCours', async (req, res) => {
    try {
        const { heureDebut, heureFin } = req.body;

        if (!heureDebut || !heureFin) {
            return res.status(400).json({ error: 'heureDebut et heureFin sont requis' });
        }

        const pool = await poolPromise;

        const query = `
            SELECT SUM(poidsNet) AS totalPoidsNet
            FROM DECHARGERTABLE
            UNION ALL
            SELECT SUM(poidsNet) AS totalPoidsNet
            FROM DECHARGERCOURS
            WHERE DATEPART(HOUR, dateHeureDecharg) BETWEEN DATEPART(HOUR, @heureDebut) AND DATEPART(HOUR, @heureFin);
        `;

        const result = await pool.request()
            .input('heureDebut', sql.NVarChar, heureDebut)
            .input('heureFin', sql.NVarChar, heureFin)
            .query(query);

        const stockEntree = result.recordset.reduce((acc, row) => acc + (row.totalPoidsNet || 0), 0);

        res.json({ stockEntree });
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.post('/tonnageBroyerTable', async (req, res) => {
    try {
        const { heureDebut, heureFin } = req.body;

        if (!heureDebut || !heureFin) {
            return res.status(400).json({ error: 'heureDebut et heureFin sont requis' });
        }

        const pool = await poolPromise;

        const query = `
            SELECT SUM(poidsNet) AS totalPoidsNet
            FROM DECHARGERTABLE
            WHERE DATEPART(HOUR, dateHeureDecharg) BETWEEN DATEPART(HOUR, @heureDebut) AND DATEPART(HOUR, @heureFin)
            UNION ALL
            SELECT SUM(TonnageCanneBroyerParTas) AS totalTonnageBroyer
            FROM TABLECANNE;
        `;

        const result = await pool.request()
            .input('heureDebut', sql.NVarChar, heureDebut)
            .input('heureFin', sql.NVarChar, heureFin)
            .query(query);

        const stockBroyer = result.recordset.reduce((acc, row) => acc + (row.totalPoidsNet || 0) + (row.totalTonnageBroyer || 0), 0);

        res.json({ stockBroyer });
    } catch (err) {
        console.error('SQL error:', err.message);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
