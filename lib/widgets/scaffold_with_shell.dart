// lib/widgets/scaffold_with_shell.dart
import 'package:flutter/material.dart';
import 'package:all_pnud/ui/shared/app_header.dart';

class ScaffoldWithShell extends StatelessWidget {
  final Widget body;
  final bool showAppBar;
  final PreferredSizeWidget? customAppBar;

  const ScaffoldWithShell({
    super.key,
    required this.body,
    this.showAppBar = true,
    this.customAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? (customAppBar ?? const AppHeader())
          : null,
      body: body,
    );
  }
}
