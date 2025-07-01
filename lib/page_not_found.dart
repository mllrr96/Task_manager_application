import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'utils/color_palette.dart';

class PageNotFound extends StatefulWidget {
  const PageNotFound({super.key});

  @override
  State<PageNotFound> createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFound> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Page not found',
              style: theme.textTheme.headlineLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Gap(10),
            Text(
              'Something went wrong',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
