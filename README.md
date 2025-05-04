# DOMjudge Auto-Setup avec Docker, Bash & Multi-Judgehost

Ce projet propose une solution automatisée pour l'installation et la configuration de **DOMjudge** via **Docker**, avec prise en charge de plusieurs *judgehosts* configurables dynamiquement. Il inclut également des **exemples de problèmes** pour tester l'installation.


## ⚙️ Fonctionnalités

- 🐳 **Déploiement complet de DOMjudge avec Docker**
- 🔁 **Script interactif pour automatiser la configuration**
- ⚖️ **Support dynamique du nombre de judgehosts**
- 📁 **Dossier `examples/`** contenant des problèmes prêts à être utilisés sur DOMjudge
- 👥 **Dossier `Teams/`** permettant l’automatisation de la création des équipes à partir d’un fichier Excel :
  - Les utilisateurs (équipes) sont automatiquement créés sur DOMjudge.
  - Un mot de passe aléatoire est généré pour chaque utilisateur.
  - Un fichier texte est généré, contenant chaque nom d’utilisateur avec son mot de passe associé.
