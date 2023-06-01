import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';

class GridImageItem extends StatefulWidget {
  final String image;
  final bool? selected;
  final String tooltip;
  final ValueChanged<bool> onSelected;

  const GridImageItem({
    required this.image,
    required this.onSelected,
    required this.tooltip,
    this.selected,
    super.key,
  });

  @override
  State<GridImageItem> createState() => _GridImageItemState();
}

class _GridImageItemState extends State<GridImageItem> {
  bool _selected = false;

  @override
  void initState() {
    _selected = widget.selected ?? false;
    super.initState();
  }

  void _onSelected() {
    setState(() {
      _selected = !_selected;
      widget.onSelected(_selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: Material(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 3,
            color: _selected ? primaryColor : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.hardEdge,
        child: Ink.image(
          fit: BoxFit.cover,
          image: AssetImage(widget.image),
          child: Container(
            color: _selected ? primaryColor.withOpacity(.4) : null,
            child: InkWell(onTap: _onSelected),
          ),
        ),
      ),
    );
  }
}
