import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';

import '../../providers/ui/app_ui_provider.dart';
import '../../providers/site/site_list_provider.dart';
import '../../widgets/animations/fade_in_animation.dart';
import '../../widgets/common/animated_card.dart';
import '../../widgets/forms/custom_text_field.dart';
import '../../widgets/forms/api_key_input.dart';
import '../../widgets/animations/staggered_fade_in_animation.dart';

class AddSitePage extends ConsumerStatefulWidget {
  const AddSitePage({super.key});

  @override
  ConsumerState<AddSitePage> createState() => _AddSitePageState();
}

class _AddSitePageState extends ConsumerState<AddSitePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _apiKeyController = TextEditingController();

  String? _validationError;

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(appUIProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un site'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: uiState.isLoading ? null : () => {}, // context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Formulaire
              Expanded(
                child: ListView(
                  children: [
                    _buildAnimatedForm(),

                    // Message d'erreur
                    if (_validationError != null) ...[
                      const SizedBox(height: 16),
                      _buildErrorDisplay(),
                    ],

                    // Informations
                    const SizedBox(height: 24),
                    FadeInAnimation(
                      child: _buildInfoCard(),
                    ),
                  ],
                ),
              ),

              // Bouton d'action
              SizedBox(
                width: double.infinity,
                child: AnimatedButton(
                  onPressed: _addSite,
                  enabled: !uiState.isLoading,
                  child: const Text('Ajouter le site'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedForm() {
    return StaggeredFadeInAnimation(
      delayBetween: const Duration(milliseconds: 100),
      children: [
        CustomTextField(
          label: 'Nom du site',
          hint: 'Mon Site WordPress',
          controller: _nameController,
          required: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'URL du site',
          hint: 'https://monsite.com',
          controller: _urlController,
          keyboardType: TextInputType.url,
          required: true,
        ),
        const SizedBox(height: 16),
        ApiKeyInput(
          controller: _apiKeyController,
          showStrength: true,
        ),
      ],
    );
  }

  Widget _buildErrorDisplay() {
    return FadeInAnimation(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _validationError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Informations requises',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Pour connecter votre site WordPress, vous avez besoin de :\n\n'
              '• L\'URL complète de votre site\n'
              '• Une clé API générée depuis le plugin WP Commander sur votre site\n'
              '• Un nom pour identifier votre site dans l\'application',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addSite() async {
    if (ref.read(appUIProvider).isLoading) return;
    final uiNotifier = ref.read(appUIProvider.notifier);

    final name = _nameController.text.trim();
    final url = _urlController.text.trim();
    final apiKey = _apiKeyController.text.trim();

    if (name.isEmpty || url.isEmpty || apiKey.isEmpty) {
      setState(() {
        _validationError = 'Veuillez remplir tous les champs.';
      });
      return;
    }

    setState(() {
      _validationError = null;
    });

    uiNotifier.showLoading('Vérification de la clé API...');

    final isValid = await ref
        .read(siteListProvider.notifier)
        .validateApiKey(url: url, apiKey: apiKey);

    if (!isValid) {
      uiNotifier.hideLoading();
      setState(() {
        _validationError = 'La clé API ou l\'URL est invalide.';
      });
      return;
    }

    uiNotifier.showLoading('Ajout du site en cours...');

    final site = SiteEntity(
      id: DateTime.now().toIso8601String(),
      name: name,
      url: url,
      apiKey: apiKey,
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(siteListProvider.notifier).addSite(site);
      uiNotifier.hideLoading();
      if (mounted) {
        // context.pop();
      }
    } catch (e) {
      uiNotifier.hideLoading();
      setState(() {
        _validationError = 'Erreur lors de l\'ajout du site: ${e.toString()}';
      });
    }
  }
}
