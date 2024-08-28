USE COCAGES;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DECHARGERCOURS')
BEGIN
    CREATE TABLE DECHARGERCOURS (
        id INT IDENTITY(1,1) PRIMARY KEY,
        veCode NVARCHAR(50) NOT NULL,
        poidsP1 DECIMAL(10, 2),
        poidsTare DECIMAL(10, 2),
		poidsP2 DECIMAL(10, 2),
        poidsNet DECIMAL(10, 2),
        dateHeureP1 DATETIME,
        dateHeureDecharg DATETIME,
		dateHeureP2 DATETIME,
		parcelle NVARCHAR(50),
        techCoupe NVARCHAR(10),
        agentMatricule NVARCHAR(20),
        etatBroyage BIT
    );

    CREATE INDEX idx_veCode ON DECHARGERCOURS(veCode);
    CREATE INDEX idx_dateHeureP1 ON DECHARGERCOURS(dateHeureP1);
    CREATE INDEX idx_dateHeureDecharg ON DECHARGERCOURS(dateHeureDecharg);
    CREATE INDEX idx_poidsP2 ON DECHARGERCOURS(poidsP2);
    CREATE INDEX idx_etatBroyage ON DECHARGERCOURS(etatBroyage);
	CREATE INDEX idx_poidsNet ON DECHARGERCOURS(poidsNet);
END
