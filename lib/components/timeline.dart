import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final Widget title;
  final Widget? subtitle;
  final Widget suffix;
  final Widget prefix;
  final VoidCallback? onPressed;

  const TimelineItem({
    required this.title,
    this.subtitle,
    this.prefix = const Icon(Icons.circle),
    this.suffix = const Icon(Icons.chevron_right, color: Colors.grey),
    this.onPressed,
    this.isFirst = false,
    this.isLast = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final contentList = [title];
    if (subtitle != null) {
      contentList.add(subtitle!);
    }

    return Stack(
      children: [
        Material(
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 40,
                      child: prefix,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: contentList,
                      ),
                    ),
                    const SizedBox(width: 10),
                    suffix,
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !isFirst,
          child: const Positioned(
            top: 0,
            left: 32,
            child: SizedBox(height: 8, child: VerticalDivider()),
          ),
        ),
        Visibility(
          visible: !isLast,
          child: const Positioned(
              top: 55, bottom: 0, left: 32, child: VerticalDivider()),
        )
      ],
    );
  }
}
