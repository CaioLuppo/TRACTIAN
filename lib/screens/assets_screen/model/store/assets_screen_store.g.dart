// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AssetsScreenStore on AssetsScreenStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'AssetsScreenStoreBase.isLoading', context: context);

  @override
  bool? get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool? value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$companyAssetsAtom =
      Atom(name: 'AssetsScreenStoreBase.companyAssets', context: context);

  @override
  ObservableList<CompanyAsset> get companyAssets {
    _$companyAssetsAtom.reportRead();
    return super.companyAssets;
  }

  @override
  set companyAssets(ObservableList<CompanyAsset> value) {
    _$companyAssetsAtom.reportWrite(value, super.companyAssets, () {
      super.companyAssets = value;
    });
  }

  late final _$locationsAtom =
      Atom(name: 'AssetsScreenStoreBase.locations', context: context);

  @override
  ObservableList<Location> get locations {
    _$locationsAtom.reportRead();
    return super.locations;
  }

  @override
  set locations(ObservableList<Location> value) {
    _$locationsAtom.reportWrite(value, super.locations, () {
      super.locations = value;
    });
  }

  late final _$AssetsScreenStoreBaseActionController =
      ActionController(name: 'AssetsScreenStoreBase', context: context);

  @override
  void setIsLoading(bool? value) {
    final _$actionInfo = _$AssetsScreenStoreBaseActionController.startAction(
        name: 'AssetsScreenStoreBase.setIsLoading');
    try {
      return super.setIsLoading(value);
    } finally {
      _$AssetsScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCompanyAssets(List<CompanyAsset> value) {
    final _$actionInfo = _$AssetsScreenStoreBaseActionController.startAction(
        name: 'AssetsScreenStoreBase.setCompanyAssets');
    try {
      return super.setCompanyAssets(value);
    } finally {
      _$AssetsScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLocations(List<Location> value) {
    final _$actionInfo = _$AssetsScreenStoreBaseActionController.startAction(
        name: 'AssetsScreenStoreBase.setLocations');
    try {
      return super.setLocations(value);
    } finally {
      _$AssetsScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void dispose() {
    final _$actionInfo = _$AssetsScreenStoreBaseActionController.startAction(
        name: 'AssetsScreenStoreBase.dispose');
    try {
      return super.dispose();
    } finally {
      _$AssetsScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
companyAssets: ${companyAssets},
locations: ${locations}
    ''';
  }
}
