
-- Création de la base de données si elle n'existe pas
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'gedcocanne')
BEGIN
    CREATE DATABASE gedcocanne;
END
GO

USE gedcocanne; -- Sélectionne la base de données gedcocanne
GO

-------------------------------------------------------------- F_PREMPESSE


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'F_PREMPESEE')
BEGIN
    CREATE TABLE F_PREMPESEE (
        ID INT IDENTITY(1,1) PRIMARY KEY, -- Colonne identifiant auto-incrémenté
        VE_CODE NVARCHAR(50) NOT NULL,
        PS_CODE NVARCHAR(50) NOT NULL, -- Ajout de la colonne PS_CODE
        PS_POIDSP1 DECIMAL(10, 2) NOT NULL,
        DATEHEUREP1 DATETIME NOT NULL,
        TECH_COUPE NVARCHAR(50) NOT NULL
    );
END
GO

-- Vérifie si la table F_PREMPESEE est vide
IF NOT EXISTS (SELECT 1 FROM F_PREMPESEE)
BEGIN
    -- Insère les données dans F_PREMPESEE si la table est vide
    INSERT INTO F_PREMPESEE (VE_CODE, PS_CODE, PS_POIDSP1, DATEHEUREP1, TECH_COUPE)
    VALUES 
        ('xx1', 'PC1', 10.00, CONVERT(DATETIME, '2025-10-20 10:30:00', 120), 'RV'),
        ('xx2', 'PC2', 10.00, CONVERT(DATETIME, '2025-10-20 11:15:00', 120), 'MV'),
        ('xx3', 'PC3', 10.00, CONVERT(DATETIME, '2025-10-20 09:45:00', 120), 'RV'),
        ('xx4', 'PC4', 10.00, CONVERT(DATETIME, '2025-10-20 12:00:00', 120), 'MV'),
        ('xx5', 'PC5', 10.00, CONVERT(DATETIME, '2025-10-20 14:30:00', 120), 'RV'),
        ('xx6', 'PC6', 10.00, CONVERT(DATETIME, '2025-10-20 08:20:00', 120), 'RV'),
        ('xx7', 'PC7', 10.00, CONVERT(DATETIME, '2025-10-20 13:15:00', 120), 'MV'),
        ('xx8', 'PC8', 10.00, CONVERT(DATETIME, '2025-10-20 07:45:00', 120), 'RV'),
        ('xx9', 'PC9', 10.00, CONVERT(DATETIME, '2025-10-20 15:00:00', 120), 'MV'),
        ('xx10', 'PC10', 10.00, CONVERT(DATETIME, '2025-10-20 16:45:00', 120), 'RV');
END
GO


------------------------------------------------------------ F_PESEE

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'F_PESEE')
BEGIN
    CREATE TABLE F_PESEE (
        ID INT IDENTITY(1,1) PRIMARY KEY, -- Colonne identifiant auto-incrémenté
        VE_CODE NVARCHAR(50) NOT NULL,
        PS_POIDSP1 DECIMAL(10, 2) NOT NULL,
        PS_POIDSP2 DECIMAL(10, 2) NULL,
        PR_CODE INT NOT NULL DEFAULT 01, -- Valeur par défaut pour PR_CODE
        PS_POIDSTare DECIMAL(10, 2) NULL, -- peut être null
        DATEHEUREP1 DATETIME NOT NULL,
        TECH_COUPE NVARCHAR(50) NOT NULL,
        PS_CODE NVARCHAR(50) NOT NULL  -- Ajout du champ PS_CODE
    );
END
GO

-- Vérifie si la table F_PESEE est vide
IF NOT EXISTS (SELECT 1 FROM F_PESEE)
BEGIN
    -- Insère les données dans F_PESEE si la table est vide
    INSERT INTO F_PESEE (VE_CODE, PS_POIDSP1, PS_POIDSP2, PS_POIDSTare, DATEHEUREP1, TECH_COUPE, PS_CODE)
    VALUES 
        ('xx1', 10.00, 5.00, 4.00, CONVERT(DATETIME, '2025-10-20 10:30:00', 120), 'RV', 'P1'),
        ('xx2', 10.00, 5.00, 4.00, CONVERT(DATETIME, '2025-10-20 11:15:00', 120), 'MV', 'P2'),
        ('xx3', 10.00, 5.00, 4.00, CONVERT(DATETIME, '2025-10-20 09:45:00', 120), 'RV', 'P3'),
        ('xx4', 10.00, 5.00, 4.00, CONVERT(DATETIME, '2025-10-20 12:00:00', 120), 'MV', 'P4'),
        ('xx5', 10.00, 5.00, 4.00, CONVERT(DATETIME, '2025-10-20 14:30:00', 120), 'RV', 'P5'),
        ('xx6', 10.00, 5.00, 4.00, CONVERT(DATETIME, '2025-10-20 08:20:00', 120), 'RV', 'P6'),
        ('xx7', 10.00, 5.00, 4.00, CONVERT(DATETIME, '2025-10-20 13:15:00', 120), 'MV', 'P7'),
        ('xx8', 10.00, 5.00, 4.00, CONVERT(DATETIME, '2025-10-20 07:45:00', 120), 'RV', 'P8'),
        ('xx9', 10.00, 5.00, 4.00, CONVERT(DATETIME, '2025-10-20 15:00:00', 120), 'MV', 'P9'),
        ('xx10', 10.00, 5.00, 4.00, CONVERT(DATETIME, '2025-10-20 16:45:00', 120), 'RV', 'P10');
END
GO

--------------------------------------------------------  AGENT

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

GO  


-- Insère l'utilisateur admin par défaut dans la table AGENT
IF NOT EXISTS (SELECT * FROM AGENT WHERE matricule = 'admin')
BEGIN
    INSERT INTO AGENT (matricule, password, role)
    VALUES ('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin');
END
GO


------------------------------------------------------- LIGNE

-- Création de la table LIGNE avec le nouveau champ statut
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LIGNE')
BEGIN
    CREATE TABLE LIGNE (
    id INT IDENTITY(1,1) PRIMARY KEY,
    libele NVARCHAR(100) NOT NULL,
    nbreTas INT NOT NULL DEFAULT 5,
    tonnageLigne DECIMAL(10, 2) NOT NULL DEFAULT 0.0,
    agentMatricule NVARCHAR(30) NULL,  -- Matricule de l'agent responsable, remplace agentId
    statutVerouillage BIT NOT NULL DEFAULT 0,  -- Permet de savoir si tous les tas ont été cochés
    statutLiberation BIT NOT NULL DEFAULT 0,  -- Permet de savoir si la ligne a été libérée

    -- Clé étrangère facultative : vous pouvez toujours valider le matricule contre une table d'agents
    -- FOREIGN KEY (agentMatricule) REFERENCES AGENT(matricule)
);

-- Ajout d'index pour optimiser les recherches
CREATE INDEX idx_libele ON LIGNE(libele);
CREATE INDEX idx_nbreTas ON LIGNE(nbreTas);  -- Index sur nbreTas
CREATE INDEX idx_tonnageLigne ON LIGNE(tonnageLigne);  -- Index sur tonnageLigne
CREATE INDEX idx_agentMatricule ON LIGNE(agentMatricule);  -- Index sur agentMatricule
CREATE INDEX idx_statutVerouillage ON LIGNE(statutVerouillage);  -- Index sur statut de verrouillage
CREATE INDEX idx_statutLiberation ON LIGNE(statutLiberation);  -- Index sur statut de libération

END


------------------------------------------------------------- TAS


-- Création de la table TAS avec les nouveaux champs
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TAS')
BEGIN
    CREATE TABLE TAS (
        id INT IDENTITY(1,1) PRIMARY KEY,
        poids DECIMAL(10, 2) NOT NULL DEFAULT 0.0,
        etat INT NOT NULL DEFAULT 0,  -- Champ pour stocker l'état du tas
        ligneId INT NOT NULL,  -- Clé étrangère vers la table LIGNE
        ligneLibele NVARCHAR(10) NULL,
        dateBroyage DATE NULL,
        heureBroyage INT NULL,
        agentBroyage NVARCHAR(30) NULL,
        FOREIGN KEY (ligneId) REFERENCES LIGNE(id) ON DELETE CASCADE
    );

    -- Ajout d'index pour optimiser les recherches
    CREATE INDEX idx_ligneId ON TAS(ligneId);
    CREATE INDEX idx_poids ON TAS(poids);  -- Index sur poids
    CREATE INDEX idx_etat ON TAS(etat);  -- Index sur état
    CREATE INDEX idx_dateBroyage ON TAS(dateBroyage);  -- Index sur dateBroyage
    CREATE INDEX idx_heureBroyage ON TAS(heureBroyage);  -- Index sur heureBroyage
    CREATE INDEX idx_agentBroyage ON TAS(agentBroyage);  -- Index sur agentMatricule
    CREATE INDEX idx_ligneLibele ON TAS(ligneLibele);  -- Index sur ligneLibele
END




---------------------------------------------------------- DECHARGER COURS

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
        etatBroyage BIT,
        ligneId INT,  -- Colonne clé étrangère
        ligneLibele NVARCHAR(20),

        -- Définir la contrainte de clé étrangère avec suppression en cascade
        CONSTRAINT FK_Ligne FOREIGN KEY (ligneId) REFERENCES LIGNE(id) ON DELETE CASCADE
    );
    
    -- Création des index
    CREATE INDEX idx_veCode ON DECHARGERCOURS(veCode);
    CREATE INDEX idx_dateHeureP1 ON DECHARGERCOURS(dateHeureP1);
    CREATE INDEX idx_dateHeureDecharg ON DECHARGERCOURS(dateHeureDecharg);
    CREATE INDEX idx_poidsP2 ON DECHARGERCOURS(poidsP2);
    CREATE INDEX idx_etatBroyage ON DECHARGERCOURS(etatBroyage);
    CREATE INDEX idx_poidsNet ON DECHARGERCOURS(poidsNet);
    CREATE INDEX idx_ligneLibele ON DECHARGERCOURS(ligneLibele);
    CREATE INDEX idx_ligneId ON DECHARGERCOURS(ligneId);
END





---------------------------------------------------------- DECHARGER TABLE


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




