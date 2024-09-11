# Gedcocanne

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## commandes pour creer l'api node js
npm init -y
npm install express body-parser mssql
npm install msnodesqlv8
npm install cors

## se connecter a l'instance nommer(se connecter a mon instance sql server)
sqlcmd -S HP-SORO\SQLEXPRESS -U sa -P sorosamuel
1>

### Vérifier le SQL Server Browser
Vérifiez que le service SQL Server Browser est en cours d'exécution:
Ouvrez Services (recherchez "Services" dans le menu Démarrer).
Trouvez SQL Server Browser dans la liste des services.
Assurez-vous que le service est en cours d'exécution. Si ce n'est pas le cas, démarrez-le.
Le service SQL Server Browser permet aux clients de trouver les instances nommées.


### Configurer le Port TCP
Ouvrir SQL Server Configuration Manager:

Recherchez et ouvrez SQL Server Configuration Manager à partir du menu Démarrer.
Configurer le port TCP pour l'instance nommée:

Sous SQL Server Network Configuration, sélectionnez Protocols for SQLEXPRESS.
Double-cliquez sur TCP/IP pour ouvrir les propriétés.
Allez à l'onglet IP Addresses.
Défilez vers le bas jusqu'à IPAll.
Effacez le champ TCP Dynamic Ports (si ce n'est pas déjà fait).
Dans le champ TCP Port, entrez 1433 (ou un autre port de votre choix si 1433 est utilisé par une autre instance).
s'assurerque que TCP/IP est activer



### Utiliser un framework de journalisation : Pour une gestion avancée des logs et une meilleure surveillance.
logger.i (Info) : Utilisé pour enregistrer des messages d'information. Ces messages sont généralement utilisés pour indiquer que des opérations se déroulent correctement ou pour fournir des informations contextuelles utiles.

logger.w (Warning) : Utilisé pour enregistrer des messages d'avertissement. Ces messages signalent des situations qui ne sont pas nécessairement des erreurs, mais qui pourraient indiquer un problème potentiel ou une situation inhabituelle.

logger.e (Error) : Utilisé pour enregistrer des messages d'erreur. Ces messages sont destinés à capturer des erreurs et des exceptions qui se produisent dans le code, fournissant ainsi des informations pour le débogage et la résolution des problèmes.


## debuter avec isar
Avant de débuter, nous devons ajouter quelques dépendances au fichier pubspec.yaml. Nous pouvons utiliser la commande pub pour faire le gros du travail à notre place.

flutter pub add isar isar_flutter_libs
flutter pub add -d isar_generator build_runner

Exécutez la commande suivante pour démarrer le build_runner (permet de generer nos models)

dart run build_runner build


##
Pour un émulateur Android, utilisez 10.0.2.2 pour accéder à localhost de l'hôte.


##le timer : c'est la frequence de synchronisation c'est un muniteur


## Couleurs
Color(0xFF265175), // Bleu
Color(0xFF019998), // Vert
Color(0xFFFBA336), // Orange
Color(0xFF9B5229), // Marron
Color.fromARGB(255, 180, 55, 202) //violet
Colors.purple //violet
background: const Color.fromARGB(218, 76, 175, 79), //vert


###
Désactiver la conversion automatique : Si vous ne voulez pas que Git effectue ces conversions, vous pouvez désactiver cette fonctionnalité en modifiant la configuration globale de Git :

bash
Copier le code
git config --global core.autocrlf false
false : Désactive la conversion automatique.
input : Convertit CRLF en LF lors de l'ajout, mais laisse les LF intacts.
true : Convertit LF en CRLF lors de l'extraction et inversement lors de l'ajout.
LF (Line Feed) : Utilisé principalement sur les systèmes UNIX/Linux et macOS.
CRLF (Carriage Return + Line Feed) : Utilisé principalement sur les systèmes Windows.


### Heberrgement IIS
en plus des configuration donnner dans le doc de configuration
il faut se rendrre dans le repeertoire 
C:\Windows\System32\inetsrv\config
puis dans le fichier applicationHost.config
rechercher
<section name="handlers" overrideModeDefault="Deny" />
Changez la valeur de overrideModeDefault="Deny" à Allow pour débloquer cette section.

Faites la même chose pour d'autres sections comme rewrite ou requestFiltering si nécessaire.


l'erreur qui conduit à cette solution precedente necessite de faire ceci 

Merci pour l'image. L'erreur indiquée dans l'éditeur de configuration précise que la section system.webServer ne peut pas être utilisée à cet emplacement dans le fichier web.config, car elle est verrouillée à un niveau parent.

Solution :
Déverrouillage de la section dans IIS :

Ouvrez le Gestionnaire des services Internet (IIS).
Sélectionnez votre site web ou application dans l'arborescence à gauche.
Dans le volet à droite, sous Gestion, cliquez sur Paramètres de fonctionnalités (ou Configuration Editor en anglais).
Dans la liste déroulante, sélectionnez system.webServer/handlers.
Dans la partie droite, vous verrez s'il y a une restriction sur cette section. Si elle est verrouillée, déverrouillez-la.
Après avoir effectué cette opération, redémarrez IIS.