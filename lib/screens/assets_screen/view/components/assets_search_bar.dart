part of '../assets_screen.view.dart';

class AssetsSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool disabled;

  const AssetsSearchBar({
    super.key,
    this.onChanged,
    this.controller,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      enabled: !disabled,
      onChanged: onChanged,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      elevation: const WidgetStatePropertyAll(0),
      hintText: AppStrings.searchAssets,
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      backgroundColor: WidgetStatePropertyAll(
        AppColors.materialGrey[100],
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Icon(
          Icons.search,
          color: AppColors.materialGrey[500],
        ),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.fromLTRB(8, 4, 16, 4),
      ),
      textStyle: WidgetStatePropertyAll(
        AppTheme.getTextTheme().bodyMedium?.copyWith(
              color: AppColors.materialGrey[500],
            ),
      ),
    );
  }
}
