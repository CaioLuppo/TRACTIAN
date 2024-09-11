import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:tractian/screens/assets_screen/view_model/assets_screen.viewmodel.dart';
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
  void toggleEnergyFilter(AssetsScreenViewModel viewModel, VoidCallback onFinishSearch) {
    energyFilterEnabled = !energyFilterEnabled;
    viewModel.searchAssetsInTreeInIsolate().then((_) => onFinishSearch());
  }

  @action
  void toggleAlertFilter(AssetsScreenViewModel viewModel, VoidCallback onFinishSearch) {
    alertFilterEnabled = !alertFilterEnabled;
    viewModel.searchAssetsInTreeInIsolate().then((_) => onFinishSearch());
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
