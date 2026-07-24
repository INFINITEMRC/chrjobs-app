# CHR Jobs — App iOS

Application iPhone / iPad (WKWebView) équivalente à l’app Android **CHRJobsV1**.

- URL : https://chrsd-ca487.web.app  
- Bundle ID : `com.chrjobs.jobs`  
- Bannière + interstitiel AdMob  

> **Important :** ce projet se compile uniquement sur un **Mac avec Xcode**.  
> Windows ne peut pas lancer le simulateur iPhone.

---

## 1. Ouvrir sur Mac

1. Copiez le dossier `ios/CHRJobs` sur le Mac (USB, iCloud, Git, etc.).
2. Installez **Xcode** depuis le Mac App Store.
3. Double-cliquez `CHRJobs.xcodeproj`.
4. Attendez que Xcode télécharge le package **GoogleMobileAds** (Swift Package Manager).
5. En haut : choisissez un simulateur (ex. iPhone 16) ou un iPhone branché.
6. Cliquez **Run** (▶).

### Première fois — signature

1. Sélectionnez la cible **CHRJobs**.
2. Onglet **Signing & Capabilities**.
3. Cochez **Automatically manage signing**.
4. Choisissez votre **Team** (compte Apple).
5. Si besoin, créez un Apple ID gratuit pour tester sur simulateur ; pour App Store / iPhone réel → **Apple Developer** (99 USD/an).

### Icône

Ajoutez une image **1024×1024** dans :
`CHRJobs/Assets.xcassets/AppIcon.appiconset`

---

## 2. AdMob iOS (obligatoire avant publication)

Les IDs dans `AdConfig.swift` sont des **IDs de test Google**. À remplacer avant l’App Store.

1. [AdMob](https://admob.google.com) → **Applications** → **Ajouter une application**.
2. Plateforme : **iOS**.
3. Nom : `CHR jobs`.
4. Bundle ID : `com.chrjobs.jobs`.
5. Créez 2 blocs :
   - **Bannière** → copiez l’ID
   - **Interstitiel** → copiez l’ID
6. Ouvrez `CHRJobs/AdConfig.swift` et remplacez :

```swift
static let bannerUnitID = "ca-app-pub-VOTRE/BANNIERE"
static let interstitialUnitID = "ca-app-pub-VOTRE/INTERSTITIEL"
```

7. Si AdMob vous donne un **ID d’application iOS** différent, mettez-le aussi dans :
   - `AdConfig.applicationID`
   - `Info.plist` → clé `GADApplicationIdentifier`

Créez aussi `app-ads.txt` (déjà sur le site web) — le site développeur App Store doit pointer vers `https://chrsd-ca487.web.app`.

---

## 3. Publier sur l’App Store

1. Compte [Apple Developer](https://developer.apple.com) actif.
2. Xcode → menu **Product** → **Archive**.
3. **Distribute App** → App Store Connect.
4. Sur [App Store Connect](https://appstoreconnect.apple.com) :
   - Créez l’app (bundle `com.chrjobs.jobs`)
   - Captures d’écran iPhone
   - Description FR / AR
   - URL confidentialité : `https://chrsd-ca487.web.app/privacy.html`
   - URL support / marketing : `https://chrsd-ca487.web.app`
   - Déclaration confidentialité (tracking ads / AdMob)
5. Soumettez pour examen.

---

## Contenu du projet

| Fichier | Rôle |
|---------|------|
| `CHRJobsApp.swift` | Point d’entrée + init AdMob + ATT |
| `ContentView.swift` | Layout WebView + bannière |
| `WebViewContainer.swift` | WKWebView (JS, géoloc, WhatsApp/tel/mailto) |
| `AdManager.swift` | Bannière adaptative + interstitiel |
| `AdConfig.swift` | URL, IDs AdMob |
| `Info.plist` | Permissions, GAD App ID, SKAdNetwork |

Parité Android : JavaScript, géolocalisation, liens `tel` / `mailto` / WhatsApp, bannière en bas, interstitiel toutes les 4 pages.

---

## Dépannage

| Problème | Solution |
|----------|----------|
| Package GoogleMobileAds introuvable | File → Packages → Reset Package Caches, puis Resolve |
| Signing error | Ajoutez votre Team dans Signing & Capabilities |
| Pubs « Test Ad » | Normal en debug ; mettez vos vrais IDs pour la prod |
| Géoloc refusée | Settings iOS → CHR Jobs → Localisation |
| Site ne charge pas | Vérifiez internet + URL `https://chrsd-ca487.web.app` |
