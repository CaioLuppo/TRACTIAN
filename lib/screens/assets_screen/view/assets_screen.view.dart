library assets_screen_view;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tractian/model/asset.model.dart';
import 'package:tractian/model/company_asset.model.dart';
import 'package:tractian/screens/assets_screen/model/store/search_store.dart';
import 'package:tractian/screens/assets_screen/view_model/assets_screen.viewmodel.dart';
import 'package:tractian/screens/global_resources/arrow_back.dart';
import 'package:tractian/screens/global_resources/loading_widget.dart';
import 'package:tractian/screens/home_screen/view/home_screen.view.dart';
import 'package:tractian/src/app_colors.dart';
import 'package:tractian/src/app_images.dart';
import 'package:tractian/src/app_strings.dart';
import 'package:tractian/src/app_theme.dart';

part 'components/assets_search_bar.dart';
part 'components/filter_button.dart';
part 'components/filter_header.dart';
part 'components/tree_node_widget.dart';

class AssetsScreen extends StatelessWidget {
  final String companyId;

  const AssetsScreen({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = AssetsScreenViewModel(companyId, context);
    viewModel.loadData();

    return Scaffold(
      appBar: AppBar(
        leading: const ArrowBack(),
        title: Text(
          AppStrings.assets,
          style: AppTheme.getTextTheme().displayMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            header,
            const SizedBox(height: 8),
            Expanded(
              child: Observer(
                builder: (context) {
                  if (viewModel.isLoading == true) {
                    return const LoadingWidget(
                      message: AppStrings.loadingAssets,
                    );
                  } else if (viewModel.isLoading == null ||
                      viewModel.tree == null) {
                    return const TryAgainWidget(
                      message: AppStrings.errorLoadingAssets,
                    );
                  } else if (viewModel.tree!.isEmpty) {
                    return const Center(child: Text(AppStrings.noAssetsFound));
                  }

                  return ListView.builder(
                    itemCount: viewModel.tree!.length,
                    itemBuilder: (context, index) {
                      final node = viewModel.tree![index];
                      return TreeNodeWidget(node: node);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get header => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssetsSearchBar(),
          SizedBox(height: 16),
          FilterHeader(),
        ],
      );
}
