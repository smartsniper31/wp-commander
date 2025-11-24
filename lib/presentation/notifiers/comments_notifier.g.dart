// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentsNotifierHash() => r'f7a3a8f808999ffe2a16dd0d6cf03a5ea42be692';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CommentsNotifier
    extends BuildlessAsyncNotifier<List<CommentEntity>> {
  late final String siteId;

  FutureOr<List<CommentEntity>> build(
    String siteId,
  );
}

/// See also [CommentsNotifier].
@ProviderFor(CommentsNotifier)
const commentsNotifierProvider = CommentsNotifierFamily();

/// See also [CommentsNotifier].
class CommentsNotifierFamily extends Family<AsyncValue<List<CommentEntity>>> {
  /// See also [CommentsNotifier].
  const CommentsNotifierFamily();

  /// See also [CommentsNotifier].
  CommentsNotifierProvider call(
    String siteId,
  ) {
    return CommentsNotifierProvider(
      siteId,
    );
  }

  @override
  CommentsNotifierProvider getProviderOverride(
    covariant CommentsNotifierProvider provider,
  ) {
    return call(
      provider.siteId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'commentsNotifierProvider';
}

/// See also [CommentsNotifier].
class CommentsNotifierProvider
    extends AsyncNotifierProviderImpl<CommentsNotifier, List<CommentEntity>> {
  /// See also [CommentsNotifier].
  CommentsNotifierProvider(
    String siteId,
  ) : this._internal(
          () => CommentsNotifier()..siteId = siteId,
          from: commentsNotifierProvider,
          name: r'commentsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commentsNotifierHash,
          dependencies: CommentsNotifierFamily._dependencies,
          allTransitiveDependencies:
              CommentsNotifierFamily._allTransitiveDependencies,
          siteId: siteId,
        );

  CommentsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.siteId,
  }) : super.internal();

  final String siteId;

  @override
  FutureOr<List<CommentEntity>> runNotifierBuild(
    covariant CommentsNotifier notifier,
  ) {
    return notifier.build(
      siteId,
    );
  }

  @override
  Override overrideWith(CommentsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommentsNotifierProvider._internal(
        () => create()..siteId = siteId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        siteId: siteId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<CommentsNotifier, List<CommentEntity>>
      createElement() {
    return _CommentsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentsNotifierProvider && other.siteId == siteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, siteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CommentsNotifierRef on AsyncNotifierProviderRef<List<CommentEntity>> {
  /// The parameter `siteId` of this provider.
  String get siteId;
}

class _CommentsNotifierProviderElement
    extends AsyncNotifierProviderElement<CommentsNotifier, List<CommentEntity>>
    with CommentsNotifierRef {
  _CommentsNotifierProviderElement(super.provider);

  @override
  String get siteId => (origin as CommentsNotifierProvider).siteId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
