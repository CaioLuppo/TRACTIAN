part of '../assets_screen.view.dart';

class FilterHeader extends StatelessWidget {
  final AssetsScreenViewModel viewModel;
  final VoidCallback onFinishSearch;

  const FilterHeader({
    super.key,
    required this.viewModel,
    required this.onFinishSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterButton(
          text: AppStrings.energySensor,
          iconPath: AppImages.boltOutlined,
          filterType: FilterType.energySensor,
          viewModel: viewModel,
          onFinishSearch: onFinishSearch,
        ),
        const SizedBox(width: 8),
        FilterButton(
          text: AppStrings.critical,
          iconPath: AppImages.criticalIcon,
          filterType: FilterType.critical,
          viewModel: viewModel,
          onFinishSearch: onFinishSearch,
        ),
      ],
    );
  }
}
