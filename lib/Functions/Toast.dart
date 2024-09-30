import 'package:auto_size_text/auto_size_text.dart';
import 'package:sarenplaner/Functions/HexColor.dart';
import 'package:flutter/material.dart';

class CustomToast extends StatefulWidget {
  final String message;
  final IconData? icon;
  final OverlayEntry overlayEntry;

  CustomToast({required this.message, this.icon, required this.overlayEntry});

  @override
  _CustomToastState createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (1 - _animation.value)),
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: HexColor('#53b175'),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                ],
                Expanded(
                  child: AutoSizeText(
                    widget.message,
                    maxLines: 1,
                    minFontSize: 20,
                    maxFontSize: 26,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 1500),
              tween: Tween(begin: 1.0, end: 0.0),
              onEnd: () {
                widget.overlayEntry.remove();
              },
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  borderRadius: BorderRadius.circular(8.0),
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showToast(
  BuildContext context,
  String message, {
  IconData? icon,
  VoidCallback? onClose,
  Duration duration = const Duration(milliseconds: 1500),
}) {
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) {
    print('No Overlay widget found in the widget tree');
    return;
  }

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 75.0,
      left: 20.0,
      right: 20.0,
      child: Material(
        color: Colors.transparent,
        child: CustomToast(
          message: message,
          icon: icon,
          overlayEntry: overlayEntry,
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(duration, () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
      onClose?.call();
    }
  });
}
