import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calculator_provider.dart';
import '../../providers/theme_provider.dart';
import '../widgets/display_area.dart';
import '../widgets/history_drawer.dart';
import '../widgets/keypad_advanced.dart';
import '../widgets/keypad_simple.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calcProvider = Provider.of<CalculatorProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      drawer: const HistoryDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          calcProvider.isAdvancedMode ? 'Rathi Scientific' : 'Rathi Calculator',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          // Mode Toggle Button (Simple <-> Advanced)
          IconButton(
            icon: Icon(
              calcProvider.isAdvancedMode
                  ? Icons.calculate_outlined
                  : Icons.functions_outlined,
            ),
            tooltip: calcProvider.isAdvancedMode
                ? 'Switch to Simple Mode'
                : 'Switch to Advanced Mode',
            onPressed: calcProvider.toggleMode,
          ),

          // Theme Selector (System Default, Light, Dark)
          PopupMenuButton<ThemeMode>(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.system
                  ? Icons.brightness_auto_outlined
                  : (themeProvider.themeMode == ThemeMode.dark
                      ? Icons.dark_mode_outlined
                      : Icons.wb_sunny_outlined),
            ),
            tooltip: 'Theme Mode',
            onSelected: (mode) => themeProvider.setThemeMode(mode),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ThemeMode.system,
                child: Row(
                  children: [
                    Icon(Icons.brightness_auto_outlined),
                    SizedBox(width: 12),
                    Text('System Default'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ThemeMode.light,
                child: Row(
                  children: [
                    Icon(Icons.wb_sunny_outlined),
                    SizedBox(width: 12),
                    Text('Light Theme'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ThemeMode.dark,
                child: Row(
                  children: [
                    Icon(Icons.dark_mode_outlined),
                    SizedBox(width: 12),
                    Text('Dark Theme'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: isLandscape
            ? Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: DisplayArea(),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: SizedBox(
                        height: calcProvider.isAdvancedMode ? 400 : 300,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: calcProvider.isAdvancedMode
                              ? const KeypadAdvanced(key: ValueKey('advanced_landscape'))
                              : const KeypadSimple(key: ValueKey('simple_landscape')),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  // Upper Area: Calculator Display
                  const Expanded(
                    flex: 2,
                    child: DisplayArea(),
                  ),

                  const Divider(height: 1, indent: 16, endIndent: 16),
                  const SizedBox(height: 8),

                  // Lower Area: Keypad (Simple or Advanced with smooth transition)
                  Expanded(
                    flex: calcProvider.isAdvancedMode ? 5 : 4,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, child: child),
                        );
                      },
                      child: calcProvider.isAdvancedMode
                          ? const KeypadAdvanced(key: ValueKey('advanced'))
                          : const KeypadSimple(key: ValueKey('simple')),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
