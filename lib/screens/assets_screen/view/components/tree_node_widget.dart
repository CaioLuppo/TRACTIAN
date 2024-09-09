part of '../assets_screen.view.dart';

class TreeNodeWidget extends StatelessWidget {
  final AssetBase node;

  const TreeNodeWidget({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return _buildTree(node);
  }

  Widget _buildTree(AssetBase node, {int depth = 0}) {
    if (node.children.isEmpty) {
      return ListTile(
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        minTileHeight: 0,
        title: Row(
          children: _buildTitle(node),
        ),
        contentPadding: const EdgeInsets.all(0),
      );
    } else {
      return ExpansionTile(
        minTileHeight: 0,
        tilePadding: const EdgeInsets.all(0),
        childrenPadding: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          children: _buildTitle(node),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              padding: const EdgeInsets.only(left: 16.0),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppColors.materialGrey[100]!,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: node.children.map((childNode) {
                  return _buildTree(childNode, depth: depth + 1);
                }).toList(),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _getTileIcon(AssetBase node) {
    SvgPicture icon;
    switch (node.type) {
      case AssetType.asset:
        icon = SvgPicture.asset(AppImages.assetIcon);
        break;
      case AssetType.component:
        icon = SvgPicture.asset(AppImages.componentIcon);
        break;
      case AssetType.location:
        icon = SvgPicture.asset(AppImages.locationIcon);
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: icon,
    );
  }

  Widget _getExtraIcons(AssetBase node) {
    if (node is! CompanyAsset) return const SizedBox.shrink();
    return Row(
      children: [
        if (node.status == AssetStatus.alert)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SvgPicture.asset(AppImages.redDot),
          ),
        if (node.sensorType == SensorType.energy.name)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SvgPicture.asset(AppImages.greenBolt),
          ),
      ],
    );
  }

  List<Widget> _buildTitle(AssetBase node) {
    return [
      _getTileIcon(node),
      Flexible(
        fit: FlexFit.loose,
        child: Text(
          node.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      _getExtraIcons(node),
    ];
  }
}
