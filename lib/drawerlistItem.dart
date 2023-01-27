import 'package:flutter/material.dart';

import '../constant.dart';

class DrawerListItem extends StatelessWidget {
  const DrawerListItem({
    this.onPress,
    this.icons,
    this.label,
    this.customWidget,
    Key? key,
    // @required this.context,
  }) : super(key: key);

  // final BuildContext context;
  final VoidCallback? onPress;
  final String? label;
  final IconData? icons;
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Icon(
        icons,
        color: kSubColor,
        size: 18,
      ),
      title: Text(
        label!,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Gilroy',
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      trailing: customWidget,
    );
  }
}
