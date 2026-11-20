import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/calculator_provider.dart';
import '../theme/app_theme.dart';

class DisplayArea extends StatelessWidget {
  const DisplayArea({super.key});

  void _copyToClipboard(BuildContext context, String text, String label) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$label copied to clipboard',
          style: const TextStyle(
            color: AppTheme.brightGold,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.darkSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppTheme.primaryGold.withValues(alpha: 0.5), width: 1),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    // Responsive font size calculation
    double getAdaptiveFontSize(String text) {
      if (text.length > 36) return 22.0;
      if (text.length > 22) return 28.0;
      if (text.length > 12) return 34.0;
      return 42.0;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Top Row: Angle Badge (DEG / RAD) & Memory Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (provider.isAdvancedMode)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurface : AppTheme.lightOperatorBtn,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    provider.isDegreeMode ? 'DEG' : 'RAD',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.brightGold : const Color(0xFFB5891C),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),

              if (provider.memoryValue != 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'M',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                ),
            ],
          ),

          // Main Expression Display Area - Editable TextField supporting cursor tap-to-edit
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                reverse: true,
                physics: const BouncingScrollPhysics(),
                child: TextField(
                  controller: provider.textController,
                  textAlign: TextAlign.right,
                  readOnly: false,
                  showCursor: true,
                  enableInteractiveSelection: true,
                  keyboardType: TextInputType.none,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: getAdaptiveFontSize(provider.expression),
                    fontWeight: FontWeight.w400,
                    color: provider.expression.isEmpty ? secondaryTextColor : primaryTextColor,
                    letterSpacing: 1.1,
                    height: 1.25,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: '0',
                    hintStyle: TextStyle(
                      fontSize: 42.0,
                      color: secondaryTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Bottom Result / Live Preview Display Area - Long press to copy
          GestureDetector(
            onLongPress: () => _copyToClipboard(
              context,
              provider.result.isNotEmpty ? provider.result : (provider.preview ?? ''),
              'Result',
            ),
            child: Container(
              width: double.infinity,
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Builder(
                  builder: (context) {
                    if (provider.isError) {
                      return Text(
                        provider.result,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      );
                    } else if (provider.result.isNotEmpty && provider.expression.isEmpty) {
                      // Final Result after clicking equal: Right-aligned
                      return Text(
                        provider.result,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: getAdaptiveFontSize(provider.result),
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.brightGold : const Color(0xFFB5891C),
                        ),
                      );
                    } else if (provider.preview != null) {
                      // Live Preview: Right-aligned, without = sign
                      return Text(
                        provider.preview!,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: getAdaptiveFontSize(provider.preview!) * 0.85,
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor.withValues(alpha: 0.75),
                        ),
                      );
                    }
                    return const SizedBox(height: 36.0);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
