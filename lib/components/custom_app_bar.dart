import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onBackTap;
  final bool showBackArrow;
  final List<Widget>? actionWidgets;
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.showBackArrow = true,
    this.actionWidgets,
    this.systemUiOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0,
      leading: showBackArrow
          ? IconButton(
        padding: EdgeInsetsGeometry.all(16.0),
              icon: SvgPicture.asset(
                'assets/svgs/back_arrow.svg',
                colorFilter: ColorFilter.mode(
                    isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),
              ),
              onPressed: () {
                if (onBackTap != null) {
                  onBackTap!();
                } else {
                  Navigator.of(context).pop();
                }
              },
            )
          : null,
      actions: actionWidgets,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
