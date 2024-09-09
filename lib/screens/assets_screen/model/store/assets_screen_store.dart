import 'package:mobx/mobx.dart';
import 'package:tractian/model/company_asset.model.dart';
import 'package:tractian/model/location.model.dart';

part 'assets_screen_store.g.dart';

class AssetsScreenStore = AssetsScreenStoreBase with _$AssetsScreenStore;

abstract class AssetsScreenStoreBase with Store {
  @observable
  bool? isLoading = false;

  @observable
  ObservableList<CompanyAsset> companyAssets = ObservableList<CompanyAsset>();

  @observable
  ObservableList<Location> locations = ObservableList<Location>();

  @action
  void setIsLoading(bool? value) => isLoading = value;

  @action
  void setCompanyAssets(List<CompanyAsset> value) {
    companyAssets.clear();
    companyAssets.addAll(value);
  }

  @action
  void setLocations(List<Location> value) {
    locations.clear();
    locations.addAll(value);
  }
}
