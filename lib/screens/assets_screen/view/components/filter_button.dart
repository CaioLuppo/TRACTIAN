part of '../assets_screen.view.dart';

class FilterButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final FilterType filterType;

  const FilterButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<SearchStore>(context);

    return Observer(
      builder: (context) {
        bool isSelected = false;
        if (store.energyFilterEnabled &&
            filterType == FilterType.energySensor) {
          isSelected = true;
        } else if (store.alertFilterEnabled &&
            filterType == FilterType.critical) {
          isSelected = true;
        }

        return ElevatedButton(
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: isSelected
                ? WidgetStatePropertyAll(AppTheme.getScheme().secondary)
                : null,
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
            side: isSelected
                ? WidgetStatePropertyAll(
                    BorderSide(
                      color: AppColors.materialGrey[200]!,
                      width: 1,
                    ),
                  )
                : null,
          ),
          onPressed: () {
            if (filterType == FilterType.energySensor) {
              store.toggleEnergyFilter();
            } else if (filterType == FilterType.critical) {
              store.toggleAlertFilter();
            }
          },
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                colorFilter: isSelected
                    ? ColorFilter.mode(
                        AppTheme.getScheme().onSecondary,
                        BlendMode.srcIn,
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.getScheme().onSecondary
                      : AppColors.bodyTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
