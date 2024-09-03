app.get('/allLigne', async (req, res) => {
    try {
      const pool = await poolPromise;
      const query = `
        SELECT id, libele, nbreTas, poidsTotal, agentId
        FROM LignesTable
        ORDER BY id ASC;
      `;
      const result = await pool.request().query(query);
  
      const lignes = result.recordset.map(row => ({
        id: row.id,
        libele: row.libele,
        nbreTas: row.nbreTas,
        poidsTotal: row.poidsTotal,
        agentId: row.agentId
      }));
  
      res.json(lignes);
      
    } catch (err) {
      console.error('SQL error:', err.message);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });