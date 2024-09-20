
-- Cr�ation de la base de donn�es si elle n'existe pas
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'gedcocanne')
BEGIN
    CREATE DATABASE gedcocanne;
END
GO

USE gedcocanne; -- S�lectionne la base de donn�es gedcocanne
GO
--------------------------------------------------------  AGENT

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

GO  


-- Ins�re l'utilisateur admin par d�faut dans la table AGENT
IF NOT EXISTS (SELECT * FROM AGENT WHERE matricule = 'admin')
BEGIN
    INSERT INTO AGENT (matricule, password, role)
    VALUES 
	('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin'),
    ('soro', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin');
END
GO


------------------------------------------------------- LIGNE

-- Cr�ation de la table LIGNE avec le nouveau champ statut
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LIGNE')
BEGIN
    CREATE TABLE LIGNE (
    id INT IDENTITY(1,1) PRIMARY KEY,
    libele NVARCHAR(100) NOT NULL,
    nbreTas INT NOT NULL DEFAULT 5,
    tonnageLigne DECIMAL(10, 2) NOT NULL DEFAULT 0.0,
    agentMatricule NVARCHAR(30) NULL,  -- Matricule de l'agent responsable, remplace agentId
    statutVerouillage BIT NOT NULL DEFAULT 0,  -- Permet de savoir si tous les tas ont �t� coch�s
    statutLiberation BIT NOT NULL DEFAULT 0,  -- Permet de savoir si la ligne a �t� lib�r�e

    -- Cl� �trang�re facultative : vous pouvez toujours valider le matricule contre une table d'agents
    -- FOREIGN KEY (agentMatricule) REFERENCES AGENT(matricule)
);

-- Ajout d'index pour optimiser les recherches
CREATE INDEX idx_libele ON LIGNE(libele);
CREATE INDEX idx_nbreTas ON LIGNE(nbreTas);  -- Index sur nbreTas
CREATE INDEX idx_tonnageLigne ON LIGNE(tonnageLigne);  -- Index sur tonnageLigne
CREATE INDEX idx_agentMatricule ON LIGNE(agentMatricule);  -- Index sur agentMatricule
CREATE INDEX idx_statutVerouillage ON LIGNE(statutVerouillage);  -- Index sur statut de verrouillage
CREATE INDEX idx_statutLiberation ON LIGNE(statutLiberation);  -- Index sur statut de lib�ration

END

----------------------------------

IF NOT EXISTS (SELECT 1 FROM LIGNE)
BEGIN
    -- Ins�r� une ligne par defaut si la table est vide
    INSERT INTO LIGNE (libele, nbreTas, tonnageLigne, agentMatricule, statutVerouillage, statutLiberation)
    VALUES ('Ligne 1', 5, 0, 'admin', 0, 0);
END
GO


------------------------------------------------------------- TAS

-- Cr�ation de la table TAS avec les nouveaux champs
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TAS')
BEGIN
    CREATE TABLE TAS (
        id INT IDENTITY(1,1) PRIMARY KEY,
        poids DECIMAL(10, 2) NOT NULL DEFAULT 0.0,
        etat INT NOT NULL DEFAULT 0,  -- Champ pour stocker l'�tat du tas
        ligneId INT NOT NULL,  -- Cl� �trang�re vers la table LIGNE
        ligneLibele NVARCHAR(10) NULL,
        dateBroyage DATE NULL,
        heureBroyage INT NULL,
        agentBroyage NVARCHAR(30) NULL,
        FOREIGN KEY (ligneId) REFERENCES LIGNE(id) ON DELETE CASCADE
    );

    -- Ajout d'index pour optimiser les recherches
    CREATE INDEX idx_ligneId ON TAS(ligneId);
    CREATE INDEX idx_poids ON TAS(poids);  -- Index sur poids
    CREATE INDEX idx_etat ON TAS(etat);  -- Index sur �tat
    CREATE INDEX idx_dateBroyage ON TAS(dateBroyage);  -- Index sur dateBroyage
    CREATE INDEX idx_heureBroyage ON TAS(heureBroyage);  -- Index sur heureBroyage
    CREATE INDEX idx_agentBroyage ON TAS(agentBroyage);  -- Index sur agentMatricule
    CREATE INDEX idx_ligneLibele ON TAS(ligneLibele);  -- Index sur ligneLibele
END


IF NOT EXISTS (SELECT 1 FROM TAS)
BEGIN
    -- Ins�re les donn�es dans TAS si la table est vide
    INSERT INTO TAS (poids, etat, ligneId, ligneLibele, dateBroyage, heureBroyage, agentBroyage)
    VALUES 
	('0', 0, 1, 'Ligne 1', NULL, NULL, NULL),
	('0', 0, 1, 'Ligne 1', NULL, NULL, NULL),
	('0', 0, 1, 'Ligne 1', NULL, NULL, NULL),
	('0', 0, 1, 'Ligne 1', NULL, NULL, NULL),
	('0', 0, 1, 'Ligne 1', NULL, NULL, NULL);
END
GO

---------------------------------------------------------------- F_TYPECANNE

--V�rifie si la table F_TYPECANNE existe d�j�
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'F_TYPECANNE')
BEGIN
    CREATE TABLE F_TYPECANNE (
        ID INT IDENTITY(1,1) PRIMARY KEY, -- Colonne identifiant auto-incr�ment�
        TN_CODE VARCHAR(1) NULL, -- Code du type de canne
        TN_LIBELE VARCHAR(200) NULL -- Libell� du type de canne
    );
END
GO

-- V�rifie si la table F_TYPECANNE est vide avant d'ins�rer les donn�es
IF NOT EXISTS (SELECT 1 FROM F_TYPECANNE)
BEGIN
    -- Insertion des types de canne
    INSERT INTO F_TYPECANNE (TN_CODE, TN_LIBELE)
    VALUES
        ('1', 'Canne industrielle'),
        ('2', 'Canne villageoise'),
        ('3', 'Canne priv�e');
END
GO

---------------------------------------------------------- CANNE DECHARGER DANS LA  COURS

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
        ligneId INT,  -- Colonne cl� �trang�re
        ligneLibele NVARCHAR(20),
		TN_CODE VARCHAR(1) NULL,  -- Colonne pour stocker le type de canne

        -- D�finir la contrainte de cl� �trang�re avec suppression en cascade
        CONSTRAINT FK_Ligne FOREIGN KEY (ligneId) REFERENCES LIGNE(id) ON DELETE CASCADE
    );
    
    -- Cr�ation des index
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
        agentMatricule NVARCHAR(50),
		TN_CODE VARCHAR(1) NULL,  -- Colonne pour stocker le type de canne
        
    );

    CREATE INDEX idx_veCode ON DECHARGERTABLE(veCode);
    CREATE INDEX idx_dateHeureP1 ON DECHARGERTABLE(dateHeureP1);
    CREATE INDEX idx_dateHeureDecharg ON DECHARGERTABLE(dateHeureDecharg);
    CREATE INDEX idx_poidsP2 ON DECHARGERTABLE(poidsP2);
	CREATE INDEX idx_poidsNet ON DECHARGERTABLE(poidsNet);
END




