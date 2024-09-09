import 'package:mobx/mobx.dart';
part 'search_store.g.dart';

class SearchStore = SearchStoreBase with _$SearchStore;

abstract class SearchStoreBase with Store {
  @observable
  FilterType? filterType;

  @observable
  String? searchEntry;

  @action
  void setFilter(FilterType? value) => filterType = value;

  @action
  void setSearchEntry(String value) {
    if (value.isEmpty) {
      searchEntry = null;
    } else {
      searchEntry = value;
    }
  }
}

enum FilterType { energySensor, critical }
