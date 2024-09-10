import 'package:mobx/mobx.dart';
part 'search_store.g.dart';

class SearchStore = SearchStoreBase with _$SearchStore;

abstract class SearchStoreBase with Store {
  @observable
  bool energyFilterEnabled = false;

  @observable
  bool alertFilterEnabled = false;

  @observable
  String? searchEntry;

  @action
  void toggleEnergyFilter() {
    energyFilterEnabled = !energyFilterEnabled;
  }

  @action
  void toggleAlertFilter() {
    alertFilterEnabled = !alertFilterEnabled;
  }

  @action
  void setSearchEntry(String value) {
    if (value.isEmpty) {
      searchEntry = null;
    } else {
      searchEntry = value;
    }
  }

  @action
  void reset() {
    energyFilterEnabled = false;
    alertFilterEnabled = false;
    searchEntry = null;
  }
}

enum FilterType { energySensor, critical }
