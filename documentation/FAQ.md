# ❓ FAQ Technique WP Commander

## 🔌 Problèmes de Connexion

### Q: L'app ne peut pas se connecter à mon site
**R:** Vérifiez:
1. L'URL est correcte (https://)
2. La clé API est valide
3. Le plugin est activé
4. Votre site est accessible

### Q: Erreur "API Key Invalid"
**R:** 
1. Allez dans *Réglages > WP Commander*
2. Regénérez la clé API
3. Mettez à jour dans l'app

## 📱 Problèmes App Mobile

### Q: L'app se ferme brusquement
**R:**
1. Vérifiez la version Flutter
2. Clear app data
3. Réinstallez l'app

### Q: Données non mises à jour
**R:**
1. Forcez la synchronisation
2. Vérifiez la connexion internet
3. Redémarrez l'app

## 🔧 Problèmes WordPress

### Q: Le plugin ne s'active pas
**R:**
1. Vérifiez PHP 7.4+
2. Vérifiez WordPress 6.0+
3. Vérifiez les permissions fichiers

### Q: Endpoints API non accessibles
**R:**
1. Vérifiez les permaliens
2. Testez l'URL: `/wp-json/wp-commander/v1/site-info`
3. Vérifiez les restrictions .htaccess
