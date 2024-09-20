-- Cr�ation de la base de donn�es si elle n'existe pas
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DB_GESPONT_FK')
BEGIN
    CREATE DATABASE DB_GESPONT_FK;
END
GO

USE DB_GESPONT_FK;


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

-------------------------------------------------------------- F_PREMPESEE

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'F_PREMPESEE')
BEGIN
    CREATE TABLE F_PREMPESEE (
        ID INT IDENTITY(1,1) PRIMARY KEY, -- Colonne identifiant auto-incr�ment�
        VE_CODE VARCHAR(20) NULL, -- Camion
        PR_CODE VARCHAR(20) NULL, -- Parcelle (doit �tre � 1 lors de l'insertion)
        TN_CODE VARCHAR(1) NULL, -- Type de canne (1: Canne industrielle, 2: Canne villageoise, 3: Canne priv�e)
        PS_CODE VARCHAR(30) NULL, -- Parcelle
        PS_TECH_COUPE VARCHAR(250) NULL, -- Technique de coupe
        PS_POIDSP1 NUMERIC(10, 0) NULL, -- Poids de la premi�re pes�e
        PS_DATEHEUREP1 DATETIME NULL -- Date et heure de la premi�re pes�e
    );
END
GO

-- Ajout d'index sur VE_CODE, PS_POIDSP1, PS_DATEHEUREP1
CREATE INDEX IDX_VE_CODE ON F_PREMPESEE (VE_CODE);
CREATE INDEX IDX_PS_POIDSP1 ON F_PREMPESEE (PS_POIDSP1);
CREATE INDEX IDX_TN_CODE ON F_PREMPESEE (TN_CODE);
CREATE INDEX IDX_PS_DATEHEUREP1 ON F_PREMPESEE (PS_DATEHEUREP1);
GO


-- V�rifie si la table F_PREMPESEE est vide
IF NOT EXISTS (SELECT 1 FROM F_PREMPESEE)
BEGIN
    -- Insertion des donn�es avec correction des colonnes PR_CODE et TN_CODE
    INSERT INTO F_PREMPESEE (VE_CODE, PR_CODE, TN_CODE, PS_CODE, PS_TECH_COUPE, PS_POIDSP1, PS_DATEHEUREP1)
    VALUES 
        ('xx1', '1', '1', 'PC1', 'RV', 10, CONVERT(DATETIME, '2025-08-24 10:30:00', 120)),
        ('xx2', '1', '1', 'PC2', 'MV', 10, CONVERT(DATETIME, '2025-08-24 11:15:00', 120)),
        ('xx3', '1', '2', 'PC3', 'RB', 10, CONVERT(DATETIME, '2025-08-24 08:45:00', 120)),
        ('xx4', '1', '3', 'PC4', 'MV', 10, CONVERT(DATETIME, '2025-08-24 12:00:00', 120)),
        ('xx5', '1', '2', 'PC5', 'MB', 10, CONVERT(DATETIME, '2025-08-24 14:30:00', 120)),
        ('xx6', '1', '1', 'PC6', 'RV', 10, CONVERT(DATETIME, '2025-08-24 08:20:00', 120)),
        ('xx7', '1', '3', 'PC7', 'RB', 10, CONVERT(DATETIME, '2025-08-24 13:15:00', 120)),
        ('xx8', '1', '2', 'PC8', 'MB', 10, CONVERT(DATETIME, '2025-08-24 07:45:00', 120)),
        ('xx9', '1', '3', 'PC9', 'MV', 10, CONVERT(DATETIME, '2025-08-24 15:00:00', 120)),
        ('xx10', '1', '1', 'PC10', 'MV', 10, CONVERT(DATETIME, '2025-08-24 16:00:00', 120)),
        ('xx11', '1', '1', 'PC11', 'MV', 10, CONVERT(DATETIME, '2025-08-24 16:10:00', 120)),
        ('xx12', '1', '1', 'PC12', 'MB', 10, CONVERT(DATETIME, '2025-08-24 16:25:00', 120)),
        ('xx13', '1', '1', 'PC13', 'MV', 10, CONVERT(DATETIME, '2025-08-24 16:35:00', 120)),
        ('xx14', '1', '1', 'PC14', 'MB', 10, CONVERT(DATETIME, '2025-08-24 16:45:00', 120)),
        ('xx15', '1', '1', 'PC15', 'MB', 10, CONVERT(DATETIME, '2025-08-24 16:55:00', 120));
END
GO


------------------------------------------------------------------ F_PESEEE

-- Cr�ation de la table F_PESEE
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'F_PESEE')
BEGIN
    CREATE TABLE F_PESEE (
        ID INT IDENTITY(1,1) PRIMARY KEY, -- Colonne identifiant auto-incr�ment�
        VE_CODE VARCHAR(20) NULL, -- camion
        PR_CODE VARCHAR(20) NULL, -- il s'agit d'une canne
        TN_CODE VARCHAR(1) NULL,  -- type de canne
        PS_CODE NVARCHAR(30) NULL, -- parcelle, avec une valeur par d�faut
        PS_TECH_COUPE VARCHAR(250) NULL, -- technique de coupe
        PS_POIDSP1 NUMERIC(10, 0) NULL, -- poids de la premi�re pes�e
        PS_DATEHEUREP1 DATETIME NULL, -- date et heure de la premi�re pes�e
        PS_POIDSP2 NUMERIC(10, 0) NULL -- poids de la deuxi�me pes�e
    );

    -- Cr�ation d'index sur les champs VE_CODE, PS_POIDSP1, PS_DATEHEUREP1, PS_POIDSP2
    CREATE INDEX IDX_F_PESEE_VE_CODE ON F_PESEE (VE_CODE);
    CREATE INDEX IDX_F_PESEE_PS_POIDSP1 ON F_PESEE (PS_POIDSP1);
    CREATE INDEX IDX_F_PESEE_PS_DATEHEUREP1 ON F_PESEE (PS_DATEHEUREP1);
    CREATE INDEX IDX_F_PESEE_PS_POIDSP2 ON F_PESEE (PS_POIDSP2);
END
GO

-- Insertion des donn�es dans F_PESEE
IF NOT EXISTS (SELECT 1 FROM F_PESEE)
BEGIN
    -- Utilisation des m�mes donn�es que F_PREMPESEE avec PS_CODE ajout�
	INSERT INTO F_PESEE (VE_CODE, PR_CODE, TN_CODE, PS_CODE, PS_TECH_COUPE, PS_POIDSP1, PS_POIDSP2, PS_DATEHEUREP1)
	VALUES 
		('xx1', '1', '1', 'PC1', 'RV', 10, 5, CONVERT(DATETIME, '2025-08-24 10:30:00', 120)),
		('xx2', '1', '1', 'PC2', 'MV', 10, 5, CONVERT(DATETIME, '2025-08-24 11:15:00', 120)),
		('xx3', '1', '2', 'PC3', 'RB', 10, 5, CONVERT(DATETIME, '2025-08-24 08:45:00', 120)),
		('xx4', '1', '3', 'PC4', 'MV', 10, 5, CONVERT(DATETIME, '2025-08-24 12:00:00', 120)),
		('xx5', '1', '2', 'PC5', 'MB', 10, 5, CONVERT(DATETIME, '2025-08-24 14:30:00', 120)),
		('xx6', '1', '1', 'PC6', 'RV', 10, 5, CONVERT(DATETIME, '2025-08-24 08:20:00', 120)),
		('xx7', '1', '3', 'PC7', 'RB', 10, 5, CONVERT(DATETIME, '2025-08-24 13:15:00', 120)),
		('xx8', '1', '2', 'PC8', 'MB', 10, 5, CONVERT(DATETIME, '2025-08-24 07:45:00', 120)),
		('xx9', '1', '3', 'PC9', 'MV', 10, 5, CONVERT(DATETIME, '2025-08-24 15:00:00', 120)),
		('xx10', '1', '1', 'PC10', 'MV', 10, 5, CONVERT(DATETIME, '2025-08-24 16:45:00', 120)),
		('xx11', '1', '1', 'PC11', 'MV', 10, 5, CONVERT(DATETIME, '2025-08-24 16:45:00', 120)),
		('xx12', '1', '1', 'PC12', 'MB', 10, 5, CONVERT(DATETIME, '2025-08-24 16:45:00', 120)),
		('xx13', '1', '1', 'PC13', 'MV', 10, 5, CONVERT(DATETIME, '2025-08-24 16:45:00', 120)),
		('xx14', '1', '1', 'PC14', 'MB', 10, 5, CONVERT(DATETIME, '2025-08-24 16:45:00', 120)),
		('xx15', '1', '1', 'PC15', 'MB', 10, 5, CONVERT(DATETIME, '2025-08-24 16:45:00', 120));

END
GO

