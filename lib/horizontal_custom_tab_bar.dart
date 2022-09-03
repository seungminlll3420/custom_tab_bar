library custom_tab_bar;

import 'package:flutter/material.dart';

class HorozontalAnimatedButtonBar extends StatefulWidget {
  final int initialIndex;
  final Duration animationDuration;
  final Color? unselectedBackgroundColor;
  final Color? selectedBackgroundColor;
  final double radius;

  final List<HorozontalButtonBarEntry> children;
  final double innerVerticalPadding;
  final double elevation;
  final Color? borderColor;
  final double? borderWidth;
  final Curve curve;
  final EdgeInsets padding;

  final bool invertedSelection;

  const HorozontalAnimatedButtonBar({
    Key? key,
    required this.initialIndex,
    required this.children,
    this.animationDuration = const Duration(milliseconds: 200),
    this.unselectedBackgroundColor,
    this.selectedBackgroundColor,
    this.radius = 0.0,
    this.innerVerticalPadding = 8.0,
    this.elevation = 0,
    this.borderColor,
    this.borderWidth,
    this.curve = Curves.fastOutSlowIn,
    this.padding = const EdgeInsets.all(0),
    this.invertedSelection = false,
  }) : super(key: key);

  @override
  _HorozontalAnimatedButtonBarState createState() =>
      _HorozontalAnimatedButtonBarState();
}

class _HorozontalAnimatedButtonBarState
    extends State<HorozontalAnimatedButtonBar> {
  int _index = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        widget.unselectedBackgroundColor ?? Theme.of(context).backgroundColor;
    return Padding(
      padding: widget.padding,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
              side: BorderSide(
                color: widget.borderColor ?? Colors.transparent,
                width: widget.borderWidth ??
                    (widget.borderColor != null ? 1.0 : 0.0),
              )),
          elevation: widget.elevation,
          child: Stack(
            fit: StackFit.loose,
            children: [
              AnimatedPositioned(
                top: 0,
                bottom: 0,
                left: constraints.maxWidth / widget.children.length * _index,
                right: (constraints.maxWidth / widget.children.length) *
                    (widget.children.length - _index - 1),
                duration: widget.animationDuration,
                curve: widget.curve,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.selectedBackgroundColor ??
                        Theme.of(context).colorScheme.secondary,
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.radius)),
                  ),
                ),
              ),
              Row(
                children: widget.children
                    .asMap()
                    .map((i, sideButton) => MapEntry(
                          i,
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                try {
                                  sideButton.onTap();
                                } catch (e) {}
                                setState(() {
                                  _index = i;
                                });
                              },
                              borderRadius: BorderRadius.all(
                                  Radius.circular(widget.radius)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: widget.innerVerticalPadding),
                                child: Center(
                                    child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            backgroundColor,
                                            widget.invertedSelection &&
                                                    _index == i
                                                ? BlendMode.srcIn
                                                : BlendMode.dstIn),
                                        child: sideButton.child)),
                              ),
                            ),
                          ),
                        ))
                    .values
                    .toList(),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class HorozontalButtonBarEntry {
  final Widget child;
  final VoidCallback onTap;
  HorozontalButtonBarEntry({required this.child, required this.onTap});
}
