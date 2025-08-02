import 'package:flutter/material.dart';
import 'package:save_money/assets/file_manager.dart';
import 'package:save_money/widgets/content_widget.dart';
import 'package:save_money/widgets/heading_widget.dart';

class CardSmartSavingWidget extends StatelessWidget {
  const CardSmartSavingWidget(
      {super.key,
      required this.label,
      required this.value,
      required this.picture,
      required this.backgroundColor,
      required this.textColor});
  final String label;
  final String value;
  final String picture;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor,
      ),
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: imagePicture(picture),
                ),
              ),
              const SizedBox(height: 16),
              ContentWidget(text: label, textColor: textColor),
              HeadingWidget(text: value, textColor: textColor),
            ],
          ),
        ),
      ),
    );
  }
}
