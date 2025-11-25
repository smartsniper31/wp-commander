# 🚀 WP Commander - Guide d'Installation

## 📱 Application Mobile Flutter

### Prérequis
- Flutter SDK 3.0+
- Android Studio / VS Code
- Appareil Android/iOS ou emulateur

### Installation
1. **Télécharger le code source**
```bash
git clone [lien-du-projet]
cd wp_commander
```
2. **Installer les dépendances**
```bash
flutter pub get
```
3. **Configurer les variables d'environnement**
Créez le fichier `.env` :

```env
APP_NAME=WP Commander
APP_VERSION=1.0.0
ENCRYPTION_KEY=your_secure_key_here
```
4. **Générer les adapters Hive**
```bash
flutter packages pub run build_runner build
```
5. **Lancer l'application**
```bash
flutter run
```
6. **Build de Production**
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🔌 Plugin WordPress

### Installation
1. **Télécharger le plugin** depuis CodeCanyon
2. **Uploader dans WordPress**
   - Allez dans `Extensions > Ajouter > Uploader`
   - Uploader le fichier `wp-commander.zip`
3. **Activer le plugin**

### Configuration
1. Allez dans `Réglages > WP Commander`
2. Copiez votre **clé API** générée automatiquement
3. Activez l'accès mobile

### Configuration API
- **URL de base** : `https://votresite.com/wp-json`
- **Namespace** : `/wp-commander/v1`
- **Authentification** : Clé API dans le header `X-WPC-API-KEY`

## 🔗 Configuration de l'Application

1. **Lancer l'application mobile**
2. **Ajouter votre premier site**
   - **Nom du site** : Votre nom de site
   - **URL** : `https://votresite.com`
   - **Clé API** : Collez la clé depuis les réglages WordPress
3. **Test de connexion**
   - L'app va tester la connexion automatiquement
   - Si réussite, vous verrez les statistiques du site

## 🛠️ Dépannage

### Erreurs courantes
- **Clé API invalide** : Regénérez la clé dans WordPress
- **URL incorrecte** : Utilisez l'URL complète avec `https://`
- **CORS errors** : Vérifiez la configuration SSL

### Support
- **Documentation complète** : [lien-documentation]
- **Support technique** : [email-support]
- **Forum communautaire** : [lien-forum]
