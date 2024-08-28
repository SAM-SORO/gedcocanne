USE COCAGES;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DECHARGERTABLE')
BEGIN
    CREATE TABLE DECHARGERTABLE (
        id INT IDENTITY(1,1) PRIMARY KEY,
        veCode NVARCHAR(50),
        poidsP1 DECIMAL(10, 2),
        poidsTare DECIMAL(10, 2),
        poidsP2 DECIMAL(10, 2),
        poidsNet DECIMAL(10, 2),
        dateHeureP1 DATETIME,
        dateHeureDecharg DATETIME,
		dateHeureP2 DATETIME,
        parcelle NVARCHAR(50),
        techCoupe NVARCHAR(50),
        agentMatricule NVARCHAR(50)
    );

    CREATE INDEX idx_veCode ON DECHARGERTABLE(veCode);
    CREATE INDEX idx_dateHeureP1 ON DECHARGERTABLE(dateHeureP1);
    CREATE INDEX idx_dateHeureDecharg ON DECHARGERTABLE(dateHeureDecharg);
    CREATE INDEX idx_poidsP2 ON DECHARGERTABLE(poidsP2);
	CREATE INDEX idx_poidsNet ON DECHARGERTABLE(poidsNet);
END
