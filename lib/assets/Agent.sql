USE COCAGES;  -- Sélectionne la base de données COCAGES
GO
-- Vérifie si la table AGENT n'existe pas déjà
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AGENT')
BEGIN
    -- Crée la table AGENT
		CREATE TABLE AGENT (
			id INT IDENTITY(1,1) PRIMARY KEY,             
			matricule NVARCHAR(50), -- Matricule de l'agent
			password NVARCHAR(100), -- Mot de passe de l'agent
			role NVARCHAR(10)        -- Rôle de l'agent
		);

    -- Création des index pour optimiser les requêtes
    CREATE INDEX IDX_Matricule ON AGENT (matricule);  -- Index sur la colonne matricule
    CREATE INDEX IDX_Password ON AGENT (password);    -- Index sur la colonne password
    CREATE INDEX IDX_Role ON AGENT (role);            -- Index sur la colonne role
END

GO  -- Exécute le batch
