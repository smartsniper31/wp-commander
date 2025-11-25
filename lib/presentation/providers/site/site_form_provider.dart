import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

@immutable
class SiteFormState {
  const SiteFormState({
    this.name = '',
    this.url = '',
    this.apiKey = '',
    this.errorMessage,
  });

  final String name;
  final String url;
  final String apiKey;
  final String? errorMessage;

  SiteFormState copyWith({
    String? name,
    String? url,
    String? apiKey,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SiteFormState(
      name: name ?? this.name,
      url: url ?? this.url,
      apiKey: apiKey ?? this.apiKey,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SiteFormNotifier extends StateNotifier<SiteFormState> {
  SiteFormNotifier() : super(const SiteFormState());

  void updateName(String name) {
    state = state.copyWith(name: name, clearError: true);
  }

  void updateUrl(String url) {
    state = state.copyWith(url: url, clearError: true);
  }

  void updateApiKey(String apiKey) {
    state = state.copyWith(apiKey: apiKey, clearError: true);
  }

  bool validate() {
    if (state.name.trim().isEmpty || state.url.trim().isEmpty || state.apiKey.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Veuillez remplir tous les champs.');
      return false;
    }
    if (!Uri.tryParse(state.url.trim())!.isAbsolute) {
      state = state.copyWith(errorMessage: 'L\'URL du site n\'est pas valide.');
      return false;
    }
    return true;
  }
  
  void reset() {
    state = const SiteFormState();
  }
}

final siteFormProvider = StateNotifierProvider<SiteFormNotifier, SiteFormState>((ref) {
  return SiteFormNotifier();
});
