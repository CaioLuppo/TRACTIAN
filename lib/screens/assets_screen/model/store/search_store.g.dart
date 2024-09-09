// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchStore on SearchStoreBase, Store {
  late final _$filterTypeAtom =
      Atom(name: 'SearchStoreBase.filterType', context: context);

  @override
  FilterType? get filterType {
    _$filterTypeAtom.reportRead();
    return super.filterType;
  }

  @override
  set filterType(FilterType? value) {
    _$filterTypeAtom.reportWrite(value, super.filterType, () {
      super.filterType = value;
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
  void setFilter(FilterType? value) {
    final _$actionInfo = _$SearchStoreBaseActionController.startAction(
        name: 'SearchStoreBase.setFilter');
    try {
      return super.setFilter(value);
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
  String toString() {
    return '''
filterType: ${filterType},
searchEntry: ${searchEntry}
    ''';
  }
}
