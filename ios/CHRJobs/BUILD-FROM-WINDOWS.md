# Codemagic — build iOS depuis Windows (sans Mac local)

Ce guide permet de compiler **CHR Jobs iOS** et l’envoyer sur App Store Connect
**depuis ton PC Windows**, via des Macs cloud.

---

## Option A — Codemagic (recommandé, le plus simple)

### 1. Compte
1. Va sur https://codemagic.io → **Sign up** (avec GitHub / Google)
2. Plan gratuit : ~500 min Mac / mois (assez pour tester)

### 2. Mettre le code sur GitHub
Sur Windows, dans PowerShell :

```powershell
cd C:\Users\HP\chrp
git status
```

Si le dossier `ios/CHRJobs` n’est pas encore poussé :
1. Crée un repo GitHub (ex. `chrjobs-ios`)
2. Pousse le projet (ou tout le repo `chrp`)

### 3. Clé API App Store Connect (depuis Windows, dans le navigateur)
1. https://appstoreconnect.apple.com → **Users and Access**
2. Onglet **Integrations** → **App Store Connect API**
3. **Generate API Key**
   - Name : `Codemagic`
   - Access : **Admin** (ou App Manager)
4. **Download** le fichier `.p8` (une seule fois — garde-le)
5. Note :
   - **Issuer ID**
   - **Key ID**

### 4. Brancher Codemagic
1. Codemagic → **Add application** → choisis ton repo GitHub
2. Type : **iOS App**
3. Project path : `ios/CHRJobs` (si monorepo chrp)
4. Dans **Environment variables** / **Code signing**, ajoute :
   - `APP_STORE_CONNECT_ISSUER_ID`
   - `APP_STORE_CONNECT_KEY_IDENTIFIER`
   - `APP_STORE_CONNECT_PRIVATE_KEY` (contenu du `.p8`)
5. Active **Automatic code signing** avec ton Apple Team
6. Clique **Start new build**

### 5. Après le build réussi
1. App Store Connect → **CHR Jobs** → version **1.0** → section **Build**
2. Le build apparaît (parfois après 5–15 min)
3. Sélectionne-le → **Add for Review**

Fichier de config déjà dans le projet : `ios/CHRJobs/codemagic.yaml`

---

## Option B — Louer un Mac distant (si Codemagic bloque)

| Service | Lien | Idée |
|---------|------|------|
| MacinCloud | https://www.macincloud.com | Mac à distance ~$20–30/mois |
| MacStadium | https://www.macstadium.com | Pro |
| AWS EC2 Mac | Amazon | Plus technique |

Tu te connectes au Mac distant → ouvres Xcode → Archive comme sur un vrai Mac.

---

## Option C — Demander à quelqu’un avec un Mac

1. Envoie le dossier `C:\Users\HP\chrp\ios\CHRJobs`
2. Il ouvre `CHRJobs.xcodeproj` dans Xcode
3. Signing = ton Apple Team (il faut l’inviter dans App Store Connect → Users)
4. **Product → Archive → Distribute**

---

## Ce que tu peux déjà faire sur Windows (sans Mac)

- Fiche App Store (description, screenshots, privacy URL)
- Bundle ID, copyright, catégorie
- Clé API App Store Connect
- Compte Codemagic + repo GitHub

## Ce qui est impossible sur Windows seul

- Compiler l’app iOS localement
- Lancer le simulateur iPhone
- Faire Archive Xcode sur ton PC

---

## Checklist rapide

1. [ ] Repo GitHub avec `ios/CHRJobs`
2. [ ] Compte Codemagic
3. [ ] Clé API `.p8` + Issuer ID + Key ID
4. [ ] Premier build Codemagic
5. [ ] Sélectionner le Build dans App Store Connect
6. [ ] Add for Review
