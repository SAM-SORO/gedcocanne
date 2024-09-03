USE gedcocanne;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TABLECANNE')
BEGIN
    CREATE TABLE TABLECANNE (
        id INT IDENTITY(1,1) PRIMARY KEY,
        TonnageCanneBroyerParTas DECIMAL(18, 4), -- Pr�cision accrue avec DECIMAL
        AnneeTableCanne INT,
        dateDecharg DATE, 
        heureDecharg INT
    );

    -- Cr�ation des index pour les colonnes pertinentes
    CREATE INDEX idx_AnneeTableCanne ON TABLECANNE(AnneeTableCanne);
    CREATE INDEX idx_dateDecharg ON TABLECANNE(dateDecharg);
    CREATE INDEX idx_heureDecharg ON TABLECANNE(heureDecharg);
END
