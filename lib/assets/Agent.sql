USE gedcocanne;  -- S�lectionne la base de donn�es gedcocanne
GO
-- V�rifie si la table AGENT n'existe pas d�j�
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AGENT')
BEGIN
    -- Cr�e la table AGENT
		CREATE TABLE AGENT (
			id INT IDENTITY(1,1) PRIMARY KEY,             
			matricule NVARCHAR(50), -- Matricule de l'agent
			password NVARCHAR(100), -- Mot de passe de l'agent
			role NVARCHAR(10)        -- R�le de l'agent
		);

    -- Cr�ation des index pour optimiser les requ�tes
    CREATE INDEX IDX_Matricule ON AGENT (matricule);  -- Index sur la colonne matricule
    CREATE INDEX IDX_Password ON AGENT (password);    -- Index sur la colonne password
    CREATE INDEX IDX_Role ON AGENT (role);            -- Index sur la colonne role
END

GO  -- Ex�cute le batch
