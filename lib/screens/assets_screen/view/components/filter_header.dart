part of '../assets_screen.view.dart';

class FilterHeader extends StatelessWidget {
  const FilterHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        FilterButton(
          text: AppStrings.energySensor,
          iconPath: AppImages.boltOutlined,
          filterType: FilterType.energySensor,
        ),
        SizedBox(width: 8),
        FilterButton(
          text: AppStrings.critical,
          iconPath: AppImages.criticalIcon,
          filterType: FilterType.critical,
        ),
      ],
    );
  }
}