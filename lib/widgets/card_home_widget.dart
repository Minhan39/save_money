import 'package:flutter/material.dart';
import 'package:save_money/widgets/content_widget.dart';
import 'package:save_money/widgets/heading_widget.dart';

class CardHomeWidget extends StatefulWidget {
  const CardHomeWidget(
      {super.key,
      required this.picture,
      required this.heading,
      required this.content,
      required this.onTap,
      this.trailing});
  final Widget picture;
  final String heading;
  final String content;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  State<CardHomeWidget> createState() => _CardHomeWidgetState();
}

class _CardHomeWidgetState extends State<CardHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: widget.picture,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingWidget(text: widget.heading),
                    ContentWidget(text: widget.content),
                  ],
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 16),
                widget.trailing!
              ],
            ],
          ),
        ),
      ),
    );
  }
}
