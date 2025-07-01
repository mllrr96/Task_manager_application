import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'routes/pages.dart';
import 'utils/color_palette.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  Future<void> startTimer() async {
    await Future.delayed(
      const Duration(milliseconds: 3000),
      () {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          Pages.home,
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 100,
            ),
            Gap(20),
            Text(
              'Everything Tasks',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Gap(10),
            Text(
              'Schedule your week with ease',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
