library custom_tab_bar;

import 'package:flutter/material.dart';

///A row of buttons with animated selection
class VerticalAnimatedButtonBar extends StatefulWidget {
  ///Duration for the selection animation
  final int initialIndex;
  final Duration animationDuration;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double radius;

  ///A list of [VerticalButtonBarEntry] to display
  final List<VerticalButtonBarEntry> children;
  final double innerHorizontalPadding;
  final double elevation;
  final Color? borderColor;
  final double? borderWidth;
  final Curve curve;
  final EdgeInsets padding;
  final double height;

  ///Invert color of the child when true
  final bool invertedSelection;

  const VerticalAnimatedButtonBar({
    Key? key,
    required this.initialIndex,
    required this.children,
    required this.height,
    this.animationDuration = const Duration(milliseconds: 200),
    this.backgroundColor,
    this.foregroundColor,
    this.radius = 0.0,
    this.innerHorizontalPadding = 8.0,
    this.elevation = 0,
    this.borderColor,
    this.borderWidth,
    this.curve = Curves.fastOutSlowIn,
    this.padding = const EdgeInsets.all(0),
    this.invertedSelection = false,
  }) : super(key: key);

  @override
  _VerticalAnimatedButtonBarState createState() =>
      _VerticalAnimatedButtonBarState();
}

class _VerticalAnimatedButtonBarState extends State<VerticalAnimatedButtonBar> {
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        widget.backgroundColor ?? Theme.of(context).backgroundColor;
    return SizedBox(
      height: widget.height,
      child: Padding(
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
                  top: constraints.minHeight / widget.children.length * _index,
                  bottom: (constraints.minHeight / widget.children.length) *
                      (widget.children.length - _index - 1),
                  left: 0,
                  right: 0,
                  duration: widget.animationDuration,
                  curve: widget.curve,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.foregroundColor ??
                          Theme.of(context).accentColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(widget.radius)),
                    ),
                  ),
                ),
                Column(
                  children: widget.children
                      .asMap()
                      .map((i, sideButton) => MapEntry(
                            i,
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  try {
                                    sideButton.onTap();
                                  } catch (e) {
                                    print('onTap implementation is missing');
                                  }
                                  setState(() {
                                    _index = i;
                                  });
                                },
                                borderRadius: BorderRadius.all(
                                    Radius.circular(widget.radius)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          widget.innerHorizontalPadding),
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
      ),
    );
  }
}

class VerticalButtonBarEntry {
  final Widget child;
  final VoidCallback onTap;
  VerticalButtonBarEntry({required this.child, required this.onTap});
}
