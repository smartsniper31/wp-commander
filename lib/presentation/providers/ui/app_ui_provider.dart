import 'package:flutter_riverpod/flutter_riverpod.dart';

// État global de l'interface utilisateur
class AppUIState {
  final int currentBottomNavIndex;
  final bool isDrawerOpen;
  final Map<String, bool> expandedSections;
  final String? currentSiteId;
  final bool isLoading;
  final String? loadingMessage;

  const AppUIState({
    this.currentBottomNavIndex = 0,
    this.isDrawerOpen = false,
    this.expandedSections = const {},
    this.currentSiteId,
    this.isLoading = false,
    this.loadingMessage,
  });

  AppUIState copyWith({
    int? currentBottomNavIndex,
    bool? isDrawerOpen,
    Map<String, bool>? expandedSections,
    String? currentSiteId,
    bool? isLoading,
    String? loadingMessage,
  }) {
    return AppUIState(
      currentBottomNavIndex: currentBottomNavIndex ?? this.currentBottomNavIndex,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      expandedSections: expandedSections ?? this.expandedSections,
      currentSiteId: currentSiteId ?? this.currentSiteId,
      isLoading: isLoading ?? this.isLoading,
      loadingMessage: loadingMessage ?? this.loadingMessage,
    );
  }

  // Helpers
  bool isSectionExpanded(String sectionId) {
    return expandedSections[sectionId] ?? false;
  }
}

// Notifier pour l'état de l'UI
class AppUINotifier extends StateNotifier<AppUIState> {
  AppUINotifier() : super(const AppUIState());

  // Navigation
  void setBottomNavIndex(int index) {
    state = state.copyWith(currentBottomNavIndex: index);
  }

  // Drawer
  void openDrawer() {
    state = state.copyWith(isDrawerOpen: true);
  }

  void closeDrawer() {
    state = state.copyWith(isDrawerOpen: false);
  }

  void toggleDrawer() {
    state = state.copyWith(isDrawerOpen: !state.isDrawerOpen);
  }

  // Sections expansibles
  void toggleSection(String sectionId) {
    final currentExpanded = state.isSectionExpanded(sectionId);
    final updatedSections = Map<String, bool>.from(state.expandedSections);
    updatedSections[sectionId] = !currentExpanded;
    
    state = state.copyWith(expandedSections: updatedSections);
  }

  void expandSection(String sectionId) {
    final updatedSections = Map<String, bool>.from(state.expandedSections);
    updatedSections[sectionId] = true;
    
    state = state.copyWith(expandedSections: updatedSections);
  }

  void collapseSection(String sectionId) {
    final updatedSections = Map<String, bool>.from(state.expandedSections);
    updatedSections[sectionId] = false;
    
    state = state.copyWith(expandedSections: updatedSections);
  }

  // Site courant
  void setCurrentSite(String siteId) {
    state = state.copyWith(currentSiteId: siteId);
  }

  void clearCurrentSite() {
    state = state.copyWith(currentSiteId: null);
  }

  // Loading states
  void showLoading([String? message]) {
    state = state.copyWith(
      isLoading: true,
      loadingMessage: message,
    );
  }

  void hideLoading() {
    state = state.copyWith(
      isLoading: false,
      loadingMessage: null,
    );
  }

  // Reset complet
  void reset() {
    state = const AppUIState();
  }
}

// Provider global pour l'UI
final appUIProvider = StateNotifierProvider<AppUINotifier, AppUIState>((ref) {
  return AppUINotifier();
});

// Providers sélecteurs pour l'optimisation
final currentBottomNavIndexProvider = Provider<int>((ref) {
  return ref.watch(appUIProvider).currentBottomNavIndex;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(appUIProvider).isLoading;
});

final loadingMessageProvider = Provider<String?>((ref) {
  return ref.watch(appUIProvider).loadingMessage;
});
