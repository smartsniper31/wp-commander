import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';

part 'sites_state.freezed.dart';

@freezed
abstract class SitesState with _$SitesState {
  const factory SitesState.initial() = SitesInitial;
  const factory SitesState.loading() = SitesLoading;
  const factory SitesState.loaded({required List<SiteEntity> sites}) = SitesLoaded;
  const factory SitesState.error({required String message}) = SitesError;
}
