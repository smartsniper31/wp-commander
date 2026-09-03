# 🚀 WP Commander - Feuille de Route de Production

**Document**: Roadmap Officielle - WP Commander  
**Version**: 1.0.0  
**Date Créée**: September 3, 2026  
**Dernière Mise à Jour**: September 3, 2026  
**Statut**: IN PROGRESS  
**Target Release Date**: Semaine 7 (October 21, 2026)

---

## 📊 Vue d'Ensemble

Cette feuille de route détaille tous les efforts requis pour transformer WP Commander de **pre-alpha (4.2/10)** à **production-ready (7.5-8/10)** en 6 semaines.

**Basée sur**: Audit CEO complet du projet (voir [AUDIT_CEO.md](./docs/AUDIT_CEO.md))

---

## 🎯 Objectifs Clés

- ✅ **Résoudre 5 blockers critiques** (sécurité, assets, compliance, tests)
- ✅ **Atteindre 70% test coverage** (minimum industry standard)
- ✅ **Publier sur CodeCanyon** (plateforme de monétisation)
- ✅ **Listing WordPress.org** (distribution plugin)
- ✅ **Production-ready release** (prêt pour clients)

---

## 📅 Phases et Timeline

```
SEMAINE 1 (Sept 3-9):  PHASE 0 - Blockers Critiques
SEMAINE 2 (Sept 10-16): PHASE 0 - Blockers + Config
SEMAINES 3-5 (Sept 17-Oct 7): PHASE 1 - Quality & Polish
SEMAINE 6 (Oct 8-14): PHASE 2 - Launch Prep
SEMAINE 7 (Oct 15-21): PHASE 3 - Launch
POST-LAUNCH (Oct 22+): PHASE 4 - Scale & Enhance
```

---

# 🔴 PHASE 0: BLOCKERS CRITIQUES
**Timeline**: Semaines 1-2 (Priority MAXIMUM)

## I. SÉCURITÉ API

### Task #1: Implémenter Authentication Réelle (JWT + Rate Limiting)
- **Status**: [ ] NOT STARTED
- **Owner**: TBD
- **Deadline**: September 9, 2026 (Fin Semaine 1)
- **Effort**: 2-3 jours

**Description**:
Remplacer la classe `WP_Commander_API_Authentication` vide par implémentation complète.

**Requirements**:
- [ ] JWT token generation (RS256 ou HS256)
- [ ] Token validation et signature verification
- [ ] Token expiration (30 jours)
- [ ] Refresh token mechanism
- [ ] Rate limiting (100 req/min par API key)
- [ ] Rate limit headers (X-RateLimit-Remaining, X-RateLimit-Reset)
- [ ] Logging toutes les tentatives d'auth (success/failure)
- [ ] Session management (logout, simultaneous sessions limit)

**Files to Modify**:
```
wp_plugin/wp-commander/includes/security/class-api-authentication.php
wp_plugin/wp-commander/includes/security/class-jwt-handler.php (NEW)
wp_plugin/wp-commander/includes/security/class-rate-limiter.php (NEW)
wp_plugin/wp-commander/includes/api/class-base-controller.php (add middleware)
```

**Testing**:
- [ ] Unit tests: JWT generation/validation
- [ ] Integration tests: Rate limit enforcement
- [ ] Manual tests: API key rotation

**Acceptance Criteria**:
✅ Valid JWT token générés avec expiration  
✅ Invalid tokens rejetés avec 401 Unauthorized  
✅ Rate limiting actif et loggé  
✅ Backward compatibility avec API keys existantes  

**GitHub Issue Template**:
```
Title: [PHASE 0] Implement JWT Authentication & Rate Limiting
Labels: security, phase-0, blocker
Milestone: Phase 0 - Blockers
```

---

## II. ASSETS VISUELS

### Task #2: Générer Screenshots (5-8 Images)
- **Status**: [ ] NOT STARTED
- **Owner**: TBD
- **Deadline**: September 9, 2026 (Fin Semaine 1)
- **Effort**: 2-3 jours

**Description**:
Capturer screenshots professionnels de chaque écran principal pour CodeCanyon et marketing.

**Requirements**:
Screenshots requis (format 1080x1920px, PNG):
- [ ] 1-dashboard.jpg - Dashboard avec statistiques multi-sites
- [ ] 2-health.jpg - Site Health Monitoring avec scores
- [ ] 3-comments.jpg - Comment Management interface
- [ ] 4-actions.jpg - Quick Actions (cache, maintenance)
- [ ] 5-settings.jpg - Settings et configuration
- [ ] 6-dark-theme.jpg - Thème sombre (contrainte CodeCanyon)
- [ ] 7-mobile.jpg - Vue responsive
- [ ] 8-tablet.jpg - Vue tablette (optional)

**Process**:
- [ ] Lancer app en mode dev/staging
- [ ] Configurer test data (multi-sites, comments, health metrics)
- [ ] Capturer via emulator ou device physique
- [ ] Optimiser images (compression, brightness, contrast)
- [ ] Sauvegarder en `marketing/screenshots/`

**Quality Checklist**:
- [ ] UI clarity (no glitches, complete rendering)
- [ ] Consistent branding (colors, fonts match theme)
- [ ] Readable text (no tiny fonts or cut-off)
- [ ] High resolution (1080x1920 minimum)
- [ ] Professional appearance (no debug UI)

**GitHub Issue Template**:
```
Title: [PHASE 0] Generate Marketing Screenshots
Labels: marketing, phase-0, blocker
Milestone: Phase 0 - Blockers
```

---

### Task #3: Créer App Icon (512x512px)
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Design)
- **Deadline**: September 9, 2026 (Fin Semaine 1)
- **Effort**: 1-2 jours

**Description**:
Concevoir et générer launcher icon pour app Flutter (Android + iOS).

**Requirements**:
- [ ] Master icon 512x512px (PNG with transparency)
- [ ] App icon variations (all required sizes via flutter_launcher_icons)
- [ ] iOS support (AppIcon.appiconset)
- [ ] Android support (mipmap-*dpi folders)
- [ ] Logo reflect brand identity
- [ ] Professional appearance

**Tools**:
- Option 1: Figma (create design, export multiples)
- Option 2: Adobe XD / Sketch
- Option 3: Canva Pro (template-based)

**Deliverables**:
- [ ] `assets/icon/icon.png` (512x512)
- [ ] iOS icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- [ ] Android icons in `android/app/src/main/res/mipmap-*/`
- [ ] Verify flutter_launcher_icons config in pubspec.yaml

**GitHub Issue Template**:
```
Title: [PHASE 0] Create App Launcher Icon
Labels: design, phase-0, blocker
Milestone: Phase 0 - Blockers
```

---

## III. COMPLIANCE LÉGALE

### Task #4: Créer LICENSE (GPL v2)
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Legal)
- **Deadline**: September 9, 2026 (Fin Semaine 1)
- **Effort**: 1-2 jours

**Description**:
Ajouter fichier LICENSE à la racine du projet avec licence GPL v2 standard.

**Requirements**:
- [ ] LICENSE file at project root
- [ ] GPL v2 full text (standard template)
- [ ] Copyright notice (your company/name)
- [ ] Commercial use disclaimer (si applicable)
- [ ] Include in README.md reference

**File**: `LICENSE` (no extension)

**Content Template**:
```
WP Commander - WordPress Mobile Manager
Copyright (c) [2026] [Your Name/Company]

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License v2 or later.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See LICENSE file or https://www.gnu.org/licenses/gpl-2.0.html
```

**Verification**:
- [ ] File exists at `./LICENSE`
- [ ] GPL v2 text is complete and accurate
- [ ] CodeCanyon accepts license type
- [ ] WordPress.org compatibility verified

**GitHub Issue Template**:
```
Title: [PHASE 0] Add GPL v2 LICENSE
Labels: legal, phase-0, blocker, compliance
Milestone: Phase 0 - Blockers
```

---

### Task #5: Créer PRIVACY_POLICY.md
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Legal)
- **Deadline**: September 16, 2026 (Fin Semaine 2)
- **Effort**: 2-3 jours

**Description**:
Politique de confidentialité complète conforme RGPD/CCPA.

**Requirements**:
- [ ] Data collection disclosure (what data collected)
- [ ] Processing explanation (how data used)
- [ ] User rights (access, delete, export)
- [ ] RGPD compliance (Art. 13/14 requirements)
- [ ] CCPA compliance (California users)
- [ ] Third-party services (analytics, etc)
- [ ] Data retention policy
- [ ] Contact information for privacy inquiries

**File**: `PRIVACY_POLICY.md`

**Content Sections**:
1. Introduction
2. What Data We Collect
3. How We Use Data
4. Data Security
5. User Rights (RGPD)
6. Data Retention
7. Cookies & Tracking
8. Third-Party Services
9. Children's Privacy
10. Changes to Policy
11. Contact Us

**Verification**:
- [ ] Reviewed by legal counsel
- [ ] RGPD-compliant language
- [ ] Updated README with link to policy
- [ ] CodeCanyon submission requirements met

**GitHub Issue Template**:
```
Title: [PHASE 0] Create Privacy Policy (RGPD/CCPA Compliant)
Labels: legal, phase-0, blocker, compliance
Milestone: Phase 0 - Blockers
```

---

### Task #6: Créer TERMS_OF_SERVICE.md
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Legal)
- **Deadline**: September 16, 2026 (Fin Semaine 2)
- **Effort**: 2-3 jours

**Description**:
Conditions d'utilisation standard SaaS avec disclaimers.

**Requirements**:
- [ ] Service description
- [ ] User responsibilities
- [ ] Warranty disclaimer
- [ ] Limitation of liability
- [ ] Termination clause
- [ ] Modifications to terms
- [ ] Dispute resolution
- [ ] Governing law

**File**: `TERMS_OF_SERVICE.md`

**Content Sections**:
1. Acceptance of Terms
2. Service Description
3. User Obligations
4. Intellectual Property
5. Warranties & Disclaimers
6. Limitation of Liability
7. Indemnification
8. Termination
9. Modifications to Service
10. Governing Law & Jurisdiction
11. Contact for Legal Notices

**Verification**:
- [ ] Reviewed by legal counsel
- [ ] SaaS-specific language included
- [ ] CodeCanyon submission requirements met
- [ ] Reference in README added

**GitHub Issue Template**:
```
Title: [PHASE 0] Create Terms of Service (SaaS Model)
Labels: legal, phase-0, blocker, compliance
Milestone: Phase 0 - Blockers
```

---

## IV. TESTS & QUALITÉ

### Task #7: Ajouter 30% Coverage (Critical Paths)
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (QA)
- **Deadline**: September 16, 2026 (Fin Semaine 2)
- **Effort**: 3-4 jours

**Description**:
Implémenter tests unitaires pour chemins critiques (authentication, API calls, state management).

**Requirements**:
- [ ] 30% minimum code coverage
- [ ] Unit tests for Riverpod providers
- [ ] Unit tests for API services
- [ ] Unit tests for critical usecases
- [ ] Mock fixtures for test data
- [ ] Coverage reports generated

**Files to Create/Modify**:
```
test/domain/usecases/auth_usecase_test.dart (NEW)
test/data/repositories/site_repository_test.dart (NEW)
test/core/providers/app_providers_test.dart (NEW)
test/presentation/providers/dashboard_provider_test.dart (NEW)
test/mocks.dart (UPDATE with more mocks)
test/test_helper.dart (UPDATE utilities)
```

**Testing Strategy**:
- [ ] Riverpod provider tests (state management)
- [ ] API service tests (HTTP mocking with Dio)
- [ ] Repository tests (data layer)
- [ ] Usecase tests (business logic)
- [ ] Widget tests (critical UI components)

**Tools**:
- `flutter test` (local)
- `coverage` package (generate reports)
- `mocktail` (mocking)

**Verification**:
```bash
flutter test --coverage
lcov --list coverage/lcov.info
# Verify >= 30% coverage
```

**GitHub Issue Template**:
```
Title: [PHASE 0] Add 30% Test Coverage (Critical Paths)
Labels: testing, phase-0, quality
Milestone: Phase 0 - Blockers
```

---

## V. CONFIGURATION

### Task #8: Créer .env.example Template
- **Status**: [ ] NOT STARTED
- **Owner**: TBD
- **Deadline**: September 9, 2026 (Fin Semaine 1)
- **Effort**: 1 jour

**Description**:
Template pour variables d'environnement (documentation pour nouveaux développeurs).

**File**: `.env.example`

**Content**:
```env
# Application Configuration
APP_NAME=WP Commander
APP_VERSION=1.0.0
ENVIRONMENT=development

# API Configuration
API_TIMEOUT=30000
API_BASE_URL=https://example.com
API_PROTOCOL=https

# Security
ENCRYPTION_KEY=your_encryption_key_here
JWT_SECRET=your_jwt_secret_here

# Database (optional, for future)
DB_HOST=localhost
DB_PORT=3306
DB_NAME=wp_commander
DB_USER=root
DB_PASSWORD=

# Analytics (optional)
ANALYTICS_ENABLED=false
GOOGLE_ANALYTICS_ID=

# Third-party Services
SENTRY_DSN=
FIREBASE_PROJECT_ID=
```

**Verification**:
- [ ] All required variables documented
- [ ] Comments explain each variable
- [ ] Safe defaults provided
- [ ] Added to README setup section

**GitHub Issue Template**:
```
Title: [PHASE 0] Create .env.example Configuration Template
Labels: config, phase-0
Milestone: Phase 0 - Blockers
```

---

### Task #9: Sécuriser .env dans .gitignore
- **Status**: [ ] NOT STARTED
- **Owner**: TBD
- **Deadline**: September 9, 2026 (Fin Semaine 1)
- **Effort**: 1 jour

**Description**:
Vérifier que `.env` est dans `.gitignore` (éviter commit accidentel de secrets).

**Verification**:
- [ ] `.gitignore` exists
- [ ] Contains `.env` entry
- [ ] `.env` file exists but not tracked
- [ ] History cleaned if previously committed

**Command to Check**:
```bash
git check-ignore .env
# Should return: .env
```

**If `.env` Was Previously Committed**:
```bash
git rm --cached .env
git commit -m "Remove .env from tracking (security)"
git push
```

**GitHub Issue Template**:
```
Title: [PHASE 0] Ensure .env Security in .gitignore
Labels: security, phase-0, config
Milestone: Phase 0 - Blockers
```

---

# 🟠 PHASE 1: QUALITY & POLISH
**Timeline**: Semaines 3-5

## I. TESTS & COVERAGE

### Task #10: Augmenter à 70% Coverage
- **Status**: [ ] NOT STARTED
- **Owner**: TBD
- **Deadline**: October 7, 2026 (Fin Semaine 5)
- **Effort**: 5-7 jours

**Description**:
Compléter suite de tests jusqu'à 70% coverage (standard industrie).

**Additions Required**:
- [ ] Integration tests (end-to-end API flows)
- [ ] Performance tests (benchmark critical paths)
- [ ] Widget tests (UI components)
- [ ] Error scenario tests (exception handling)

**Target Coverage**:
```
✅ Domain layer: 95%+ (entities, usecases)
✅ Data layer: 80%+ (repositories, datasources)
✅ Core layer: 85%+ (providers, utilities)
⚠️ Presentation layer: 50%+ (hard to test, visual components)
```

---

## II. CI/CD PIPELINE

### Task #11: Setup GitHub Actions - Flutter Build
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (DevOps)
- **Deadline**: October 7, 2026 (Fin Semaine 5)
- **Effort**: 2-3 jours

**Description**:
Créer workflow GitHub Actions pour Flutter build, test, coverage.

**File**: `.github/workflows/flutter.yml`

**Workflow Steps**:
1. Checkout code
2. Setup Flutter SDK
3. Get dependencies (`flutter pub get`)
4. Run linter (`flutter analyze`)
5. Run tests with coverage (`flutter test --coverage`)
6. Upload coverage to Codecov
7. Build APK (optional)
8. Artifact retention

**Trigger Events**:
- [ ] On push to main/develop
- [ ] On pull request
- [ ] Manual trigger option

**Artifact Outputs**:
- [ ] Coverage report (LCOV)
- [ ] Build artifacts (if APK build enabled)

---

### Task #12: Setup GitHub Actions - PHP Lint
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (DevOps)
- **Deadline**: October 7, 2026 (Fin Semaine 5)
- **Effort**: 1-2 jours

**Description**:
Workflow GitHub Actions pour linting PHP plugin WordPress.

**File**: `.github/workflows/php.yml`

**Workflow Steps**:
1. Checkout code
2. Setup PHP 7.4+
3. Install composer
4. Install PHPCS (PHP CodeSniffer)
5. Run linting against WordPress coding standards
6. Report violations

**Standards**:
- [ ] WordPress Coding Standards (PHPCS)
- [ ] Security sniffs (no SQL injection risks)
- [ ] Deprecated function checks

---

## III. SÉCURITÉ

### Task #13: Encryption Audit
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Security)
- **Deadline**: October 7, 2026 (Fin Semaine 5)
- **Effort**: 2-3 jours

**Description**:
Code review complet du chiffrement (end-to-end, local cache, API transport).

**Audit Checklist**:
- [ ] Verify `encrypt` library usage (v5.0.1)
- [ ] Verify `crypto` library usage (v3.0.3)
- [ ] Check API key encryption in transit
- [ ] Check local cache encryption (Hive)
- [ ] Check credentials handling
- [ ] Verify no secrets in logs
- [ ] Check SSL/TLS enforcement

**Report Structure**:
```
docs/SECURITY_AUDIT.md
├── Encryption Implementation Review
├── Key Management Practices
├── Data-in-Transit Protection
├── Data-at-Rest Protection
├── Findings & Recommendations
└── Remediation Plan
```

---

## IV. DOCUMENTATION

### Task #14: API Reference Documentation
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Tech Writer)
- **Deadline**: October 7, 2026 (Fin Semaine 5)
- **Effort**: 3-4 jours

**Description**:
Documentation complète de tous les endpoints API REST.

**File**: `documentation/API_REFERENCE.md`

**Content for Each Endpoint**:
1. Endpoint path & method (GET, POST, etc)
2. Authentication requirements
3. Parameters (query, body, headers)
4. Request example (cURL, JSON)
5. Response example (success & error)
6. Status codes (200, 400, 401, 404, 500, etc)
7. Rate limit info
8. Error handling

**Endpoints to Document**:
```
POST   /wp-json/wp-commander/v1/auth/token
GET    /wp-json/wp-commander/v1/dashboard-stats
GET    /wp-json/wp-commander/v1/site-info
GET    /wp-json/wp-commander/v1/comments
POST   /wp-json/wp-commander/v1/comments/{id}/approve
POST   /wp-json/wp-commander/v1/comments/{id}/spam
DELETE /wp-json/wp-commander/v1/comments/{id}
GET    /wp-json/wp-commander/v1/health
POST   /wp-json/wp-commander/v1/actions/cache-clear
POST   /wp-json/wp-commander/v1/actions/maintenance
POST   /wp-json/wp-commander/v1/actions/optimize-db
```

---

### Task #15: Developer Guide
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Tech Writer)
- **Deadline**: October 7, 2026 (Fin Semaine 5)
- **Effort**: 2-3 jours

**Description**:
Guide technique complet pour contributeurs et développeurs.

**File**: `documentation/DEVELOPER_GUIDE.md`

**Sections**:
1. Architecture Overview (Clean Architecture explanation)
2. Project Structure
3. Setup & Environment
4. Running Locally
5. Testing
6. Code Style & Conventions
7. Contributing Guidelines
8. Debugging Tips
9. Performance Considerations
10. Security Best Practices

---

### Task #16: Deployment Guide
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (DevOps/Tech Writer)
- **Deadline**: October 7, 2026 (Fin Semaine 5)
- **Effort**: 2-3 jours

**Description**:
Guide production pour déploiement et setup serveur.

**File**: `documentation/DEPLOYMENT.md`

**Sections**:
1. Server Requirements
2. Environment Setup
3. Database Configuration
4. WordPress Plugin Installation
5. SSL/TLS Setup
6. Performance Tuning
7. Monitoring & Logging
8. Backup Strategy
9. Disaster Recovery
10. Scaling Considerations

---

# 🟡 PHASE 2: LAUNCH PREPARATION
**Timeline**: Semaine 6

### Task #17: Finalize CodeCanyon Description
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Marketing)
- **Deadline**: October 14, 2026 (Fin Semaine 6)

**Requirements**:
- [ ] Update item title
- [ ] Complete feature description
- [ ] Keywords optimization
- [ ] Screenshots referenced
- [ ] Requirements verified

---

### Task #18: Create CodeCanyon Thumbnail
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Design)
- **Deadline**: October 14, 2026 (Fin Semaine 6)

**Specifications**:
- [ ] Dimension: 1500x1000px (3:2 ratio)
- [ ] Format: PNG or JPG
- [ ] Professional appearance
- [ ] Brand consistency

---

### Task #19: Beta Testing Setup
- **Status**: [ ] NOT STARTED
- **Owner**: TBD
- **Deadline**: October 14, 2026 (Fin Semaine 6)

**Requirements**:
- [ ] Identify 5-10 WordPress agencies
- [ ] Send invitations + access
- [ ] Collect feedback
- [ ] Document issues

---

### Task #20: Define Revenue Model
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Business)
- **Deadline**: October 14, 2026 (Fin Semaine 6)

**Decisions Required**:
- [ ] Pricing model (one-time vs subscription)
- [ ] Tier definition ($9/$19/$29?)
- [ ] Freemium strategy?
- [ ] Agency licensing?

---

# 🟢 PHASE 3: LAUNCH
**Timeline**: Semaine 7

### Task #21: CodeCanyon Submission
- **Status**: [ ] NOT STARTED
- **Owner**: TBD
- **Deadline**: October 21, 2026 (Fin Semaine 7)

---

### Task #22: WordPress.org Plugin Listing
- **Status**: [ ] NOT STARTED
- **Owner**: TBD
- **Deadline**: October 21, 2026 (Fin Semaine 7)

---

### Task #23: Community Outreach
- **Status**: [ ] NOT STARTED
- **Owner**: TBD (Marketing)
- **Deadline**: October 21, 2026 (Fin Semaine 7)

**Channels**:
- [ ] r/WordPress (Reddit)
- [ ] WordPress.org forums
- [ ] WP Tavern (if accepted)
- [ ] Local WordPress meetups

---

### Task #24: GA4 Analytics Setup
- **Status**: [ ] NOT STARTED
- **Owner**: TBD
- **Deadline**: October 21, 2026 (Fin Semaine 7)

---

# 🔵 PHASE 4: POST-LAUNCH SCALING
**Timeline**: Post-launch (Semaines 8+)

### Task #25-29: Feature Enhancement & Monetization
(Details in roadmap continuation)

---

## 📊 Status Summary

| Phase | Status | Progress | Deadline |
|-------|--------|----------|----------|
| **Phase 0** | [ ] PENDING | 0/9 | Sept 16 |
| **Phase 1** | [ ] PENDING | 0/7 | Oct 7 |
| **Phase 2** | [ ] PENDING | 0/4 | Oct 14 |
| **Phase 3** | [ ] PENDING | 0/4 | Oct 21 |
| **Phase 4** | [ ] PENDING | 0/5 | TBD |

---

## 🔗 Related Documents

- 📋 [AUDIT_CEO.md](./docs/AUDIT_CEO.md) - Full CEO Audit Report
- 📄 [README.md](./README.md) - Project overview
- 🔒 [LICENSE](./LICENSE) - GPL v2 License
- 🏥 [SECURITY_AUDIT.md](./docs/SECURITY_AUDIT.md) - Security findings (TBD)
- 🛠️ [DEVELOPER_GUIDE.md](./documentation/DEVELOPER_GUIDE.md) - Technical guide (TBD)

---

## 👥 Resource Allocation

**Recommended Team**:
- 2x Senior Flutter Developer (PHASE 0-1)
- 1x PHP/WordPress Developer (PHASE 0-1)
- 1x QA/Test Engineer (PHASE 1)
- 1x DevOps/CI-CD Specialist (PHASE 1)
- 1x Security Reviewer (PHASE 1)
- 1x Tech Writer (PHASE 1-2)
- 1x Designer/UX (PHASE 0, 2)
- 1x Legal Consultant (PHASE 0)
- 1x Product Manager (All phases)

**Recommended Budget**:
```
Internal Team (in-house): ~120 man-days
External Contractors:
  - Legal review: $300-500
  - Security audit: $1000-2000
  - Design (screenshots, icon, thumbnail): $500-1000
  - Video production: $500-800
  
Total External Budget: $2300-4300
```

---

## ✅ Checklist Avant Publication

**Pre-Release QA**:
- [ ] All Phase 0 tasks completed
- [ ] Phase 1 quality checks passed
- [ ] Zero critical bugs in staging
- [ ] Legal documents reviewed by counsel
- [ ] Performance benchmarks met
- [ ] Security audit passed
- [ ] Coverage >= 70%
- [ ] Documentation complete
- [ ] Marketing materials ready
- [ ] Beta feedback addressed

---

**Last Updated**: September 3, 2026  
**Next Review**: September 10, 2026

---

*Ce document est maintenu activement et révisé chaque semaine. Les modifications sont trackées via Git.*
