import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';

import '../../providers/site/site_form_provider.dart';
import '../../providers/site/site_list_provider.dart';
import '../../widgets/animations/fade_in_animation.dart';
import '../../widgets/common/animated_button.dart';
import '../../widgets/forms/custom_text_field.dart';
import '../../widgets/forms/api_key_input.dart';
import '../../widgets/animations/staggered_fade_in_animation.dart';

class AddSitePage extends ConsumerWidget {
  const AddSitePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(siteFormProvider);
    final formNotifier = ref.read(siteFormProvider.notifier);

    // Listen for state changes in the siteListProvider to handle side-effects
    // like navigation or showing snackbars after an operation.
    ref.listen<AsyncValue<List<SiteEntity>>>(
      siteListProvider,
      (previous, next) {
        // We are only interested in the transition from a loading state.
        if (previous?.isLoading ?? false) {
          next.when(
            data: (_) {
              // Operation succeeded
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Site ajouté avec succès!')),
              );
              formNotifier.reset();
              Navigator.of(context).pop();
            },
            error: (err, __) {
              // Operation failed
              if (!context.mounted) return;
              final message =
                  err is Exception ? err.toString() : 'Une erreur est survenue.';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            loading: () {
              // Still loading, do nothing.
            },
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un site'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildAnimatedForm(formNotifier, formState),
                  if (formState.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    _buildErrorDisplay(context, formState.errorMessage!),
                  ],
                  const SizedBox(height: 24),
                  const FadeInAnimation(
                    child: _InfoCard(),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: AnimatedButton(
                // The button is disabled when the list is in a loading state,
                // preventing double submissions.
                onPressed: ref.watch(siteListProvider).isLoading
                    ? null
                    : () {
                        if (formNotifier.validate()) {
                          final site = SiteEntity(
                            id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
                            name: formState.name,
                            url: formState.url,
                            apiKey: formState.apiKey,
                            createdAt: DateTime.now(),
                          );
                          // Calling addSite will trigger the state change
                          // which is handled by the ref.listen above.
                          ref.read(siteListProvider.notifier).addSite(site);
                        }
                      },
                child: const Text('Ajouter le site'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedForm(SiteFormNotifier notifier, SiteFormState state) {
    return StaggeredFadeInAnimation(
      delayBetween: const Duration(milliseconds: 100),
      children: [
        CustomTextField(
          label: 'Nom du site',
          hint: 'Mon Site WordPress',
          initialValue: state.name,
          onChanged: notifier.updateName,
          required: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'URL du site',
          hint: 'https://monsite.com',
          initialValue: state.url,
          onChanged: notifier.updateUrl,
          keyboardType: TextInputType.url,
          required: true,
        ),
        const SizedBox(height: 16),
        ApiKeyInput(
          initialValue: state.apiKey,
          onChanged: notifier.updateApiKey,
          showStrength: true,
        ),
      ],
    );
  }

  Widget _buildErrorDisplay(BuildContext context, String message) {
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
                message,
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
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
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
}
