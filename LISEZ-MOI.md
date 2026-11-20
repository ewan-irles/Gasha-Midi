# Tarpaing Faim : installer l'app sur ton téléphone

Ce dossier est une **PWA** (Progressive Web App) : une web app qui s'installe comme une vraie appli, avec une icône, en plein écran et utilisable hors ligne.

## 1. Mettre le dossier en ligne (gratuit, 5 min) avec GitHub Pages

1. Sur github.com, crée un dépôt public, par exemple `gachamidi`.
2. **Add file > Upload files** : glisse **tout le contenu** de ce dossier (`index.html`, `manifest.webmanifest`, `sw.js`, le dossier `icons`), puis **Commit changes**.
3. **Settings > Pages > Build and deployment** : Source = *Deploy from a branch*, Branch = `main`, dossier `/ (root)`, puis **Save**.
4. Une à deux minutes plus tard, ton app est en ligne sur `https://TON-PSEUDO.github.io/gachamidi/`.

Il faut obligatoirement du **https** pour que l'installation et le mode hors ligne marchent. GitHub Pages le fait tout seul.

## 2. Installer sur Android (Chrome)

1. Ouvre l'adresse dans **Chrome**.
2. Menu **⋮ > Installer l'application** (ou « Ajouter à l'écran d'accueil »).
3. Tarpaing Faim apparaît dans tes applis, avec son icône.

Sur iPhone : ouvre l'adresse dans Safari, puis **Partager > Sur l'écran d'accueil**.

## 3. (Optionnel) Avoir un vrai fichier .apk

1. Va sur **https://www.pwabuilder.com** et colle l'adresse de ton app.
2. **Package for stores > Android > Generate Package**.
3. Le zip téléchargé contient un **.apk** à installer directement (autorise « Sources inconnues » pour Chrome ou ton gestionnaire de fichiers) et un **.aab** pour le Play Store (compte développeur payant, inutile pour toi).

## 4. Récupérer tes données

L'app installée a son propre stockage, séparé de la version ouverte dans Claude.
Dans la version Claude : **Réglages > Copier la sauvegarde**. Puis dans l'app installée : **Réglages**, colle le texte, **Importer le texte collé**.

## Différences avec la version Claude

| | Dans Claude | App installée |
|---|---|---|
| Boosters, pity, budget, son, thème Cycle | ✅ | ✅ |
| Hors ligne | ❌ | ✅ |
| GPS « Utiliser ma position » | ❌ (bloqué) | ✅ |
| Partage JPG | Bouton Enregistrer | Menu de partage Android |
| Vibrations | Selon le navigateur | ✅ sur Android |
| Explorer : analyse IA | ✅ | ❌ (remplacée par la recherche Maps) |

## Mettre à jour l'app

Remplace `index.html` dans ton dépôt GitHub. `index.html` se met à jour tout seul sur le téléphone. Si tu modifies les icônes ou le manifeste, change aussi le nom du cache en haut de `sw.js` (par exemple `tarpaing-v3` → `tarpaing-v4`).
