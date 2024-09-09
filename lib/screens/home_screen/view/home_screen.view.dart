library home_screen;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tractian/model/company.model.dart';
import 'package:tractian/screens/assets_screen/view/assets_screen.view.dart';
import 'package:tractian/screens/global_resources/loading_widget.dart';
import 'package:tractian/screens/home_screen/view_model/home_screen.viewmodel.dart';
import 'package:tractian/src/app_images.dart';
import 'package:tractian/src/app_strings.dart';
import 'package:tractian/src/app_theme.dart';

part 'components/try_again_widget.dart';
part 'components/company_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = HomeScreenViewModel();

    return Scaffold(
      appBar: AppBar(title: SvgPicture.asset(AppImages.logo)),
      body: FutureBuilder(
        future: viewModel.getCompanies(),
        builder: (context, AsyncSnapshot<List<Company>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: AppStrings.loadingUnits);
          } else if (snapshot.hasError || snapshot.data == null) {
            return TryAgainWidget(
              message: AppStrings.errorLoadingUnits,
              onTryAgain: () => setState(() {}),
            );
          }

          final companies = snapshot.data!;

          if (companies.isEmpty) {
            return const Center(child: Text(AppStrings.noUnitsFound));
          }

          return ListView.separated(
            itemCount: companies.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            separatorBuilder: (context, index) => const SizedBox(height: 40),
            itemBuilder: (context, index) {
              final company = companies[index];
              return CompanyTile(company: company);
            },
          );
        },
      ),
    );
  }
}
