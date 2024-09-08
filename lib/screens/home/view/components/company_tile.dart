part of '../home_screen.view.dart';

class CompanyTile extends StatelessWidget {
  const CompanyTile({
    super.key,
    required this.company,
  });

  final Company company;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: AppTheme.getScheme().secondary,
      leading: SvgPicture.asset(AppImages.companyIcon),
      contentPadding: const EdgeInsets.all(24),
      title: Text(
        "${company.name} ${AppStrings.unit}",
        style: AppTheme.getTextTheme().displayMedium?.copyWith(
              color: AppTheme.getScheme().onSecondary,
            ),
      ),
    );
  }
}
