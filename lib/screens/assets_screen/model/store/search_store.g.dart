// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchStore on SearchStoreBase, Store {
  late final _$energyFilterEnabledAtom =
      Atom(name: 'SearchStoreBase.energyFilterEnabled', context: context);

  @override
  bool get energyFilterEnabled {
    _$energyFilterEnabledAtom.reportRead();
    return super.energyFilterEnabled;
  }

  @override
  set energyFilterEnabled(bool value) {
    _$energyFilterEnabledAtom.reportWrite(value, super.energyFilterEnabled, () {
      super.energyFilterEnabled = value;
    });
  }

  late final _$alertFilterEnabledAtom =
      Atom(name: 'SearchStoreBase.alertFilterEnabled', context: context);

  @override
  bool get alertFilterEnabled {
    _$alertFilterEnabledAtom.reportRead();
    return super.alertFilterEnabled;
  }

  @override
  set alertFilterEnabled(bool value) {
    _$alertFilterEnabledAtom.reportWrite(value, super.alertFilterEnabled, () {
      super.alertFilterEnabled = value;
    });
  }

  late final _$searchEntryAtom =
      Atom(name: 'SearchStoreBase.searchEntry', context: context);

  @override
  String? get searchEntry {
    _$searchEntryAtom.reportRead();
    return super.searchEntry;
  }

  @override
  set searchEntry(String? value) {
    _$searchEntryAtom.reportWrite(value, super.searchEntry, () {
      super.searchEntry = value;
    });
  }

  late final _$SearchStoreBaseActionController =
      ActionController(name: 'SearchStoreBase', context: context);

  @override
  void toggleEnergyFilter() {
    final _$actionInfo = _$SearchStoreBaseActionController.startAction(
        name: 'SearchStoreBase.toggleEnergyFilter');
    try {
      return super.toggleEnergyFilter();
    } finally {
      _$SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleAlertFilter() {
    final _$actionInfo = _$SearchStoreBaseActionController.startAction(
        name: 'SearchStoreBase.toggleAlertFilter');
    try {
      return super.toggleAlertFilter();
    } finally {
      _$SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchEntry(String value) {
    final _$actionInfo = _$SearchStoreBaseActionController.startAction(
        name: 'SearchStoreBase.setSearchEntry');
    try {
      return super.setSearchEntry(value);
    } finally {
      _$SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void dispose() {
    final _$actionInfo = _$SearchStoreBaseActionController.startAction(
        name: 'SearchStoreBase.dispose');
    try {
      return super.dispose();
    } finally {
      _$SearchStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
energyFilterEnabled: ${energyFilterEnabled},
alertFilterEnabled: ${alertFilterEnabled},
searchEntry: ${searchEntry}
    ''';
  }
}
