-- Cr�ation de la base de donn�es si elle n'existe pas
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'gedcocanne')
BEGIN
    CREATE DATABASE gedcocanne;
END
GO

USE gedcocanne;
GO

-- Cr�ation de la table si elle n'existe pas
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'F_PREMPESEE')
BEGIN
    CREATE TABLE F_PREMPESEE (
        ID INT IDENTITY(1,1) PRIMARY KEY, -- Colonne identifiant auto-incr�ment�
        VE_CODE NVARCHAR(50) NOT NULL,
        PS_CODE NVARCHAR(50) NOT NULL, -- Ajout de la colonne PS_CODE
        PS_POIDSP1 DECIMAL(10, 2) NOT NULL,
        DATEHEUREP1 DATETIME NOT NULL,
        TECH_COUPE NVARCHAR(50) NOT NULL
    );
END
GO

-- Insertion des donn�es avec PS_CODE
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
GO
