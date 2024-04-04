import 'package:app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class StepperTouch extends StatefulWidget {
  final Axis direction;
  final int initialValue;
  final ValueChanged<int> onChanged;
  final bool withSpring;

  const StepperTouch({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    this.direction = Axis.horizontal,
    this.withSpring = true,
  }) : super(key: key);

  @override
  _StepperTouchState createState() => _StepperTouchState();
}

class _StepperTouchState extends State<StepperTouch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);
    _controller.value = 0.0; // Reset the controller value each time it's being initialized.

    _setupAnimation();
  }

  void _setupAnimation() {
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.direction == Axis.horizontal ? Offset(1.5, 0.0) : Offset(0.0, 1.5),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StepperTouch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setupAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: widget.direction == Axis.horizontal ? 280.0 : 130.0,
        height: widget.direction == Axis.horizontal ? 130.0 : 280.0,
        child: Material(
          type: MaterialType.canvas,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(60.0),
          color: AppColors.blue.withOpacity(0.2),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (widget.direction == Axis.horizontal)
                Positioned(
                  left: 10.0,
                  child: Icon(Icons.remove, size: 40.0, color: AppColors.black),
                )
              else
                Positioned(
                  bottom: 10.0,
                  child: Icon(Icons.remove, size: 40.0, color: AppColors.black),
                ),
              if (widget.direction == Axis.horizontal)
                Positioned(
                  right: 10.0,
                  child: Icon(Icons.add, size: 40.0, color: AppColors.black),
                )
              else
                Positioned(
                  top: 10.0,
                  child: Icon(Icons.add, size: 40.0, color: AppColors.black),
                ),
              GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: SlideTransition(
                  position: _animation,
                  child: Material(
                    color: AppColors.blue,
                    shape: CircleBorder(),
                    elevation: 5.0,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          '$_value',
                          key: ValueKey<int>(_value),
                          style: TextStyle(color: AppColors.white, fontSize: 56.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _updateControllerValue(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updateControllerValue(details.globalPosition);
  }

  void _updateControllerValue(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);

    double pos = widget.direction == Axis.horizontal
        ? (local.dx / box.size.width) - 0.5
        : (local.dy / box.size.height) - 0.5;

    _controller.value = pos * 2; // Adjusting to the controller's bound
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();
    bool isHor = widget.direction == Axis.horizontal;
    bool changed = false;

    if (_controller.value <= -0.20) {
      // Prevent _value from going below 0
      if (_value > 0) { // Check if _value is greater than 0 before decrementing
        setState(() => isHor ? _value-- : _value++);
        changed = true;
      }
    } else if (_controller.value >= 0.20) {
      setState(() => isHor ? _value++ : _value--);
      changed = true;
    }

    if (widget.withSpring) {
      final SpringDescription _kDefaultSpring = SpringDescription.withDampingRatio(
        mass: 0.9,
        stiffness: 250.0,
        ratio: 0.6,
      );
      _controller.animateWith(SpringSimulation(_kDefaultSpring, _controller.value, 0.0, 0.0));
    } else {
      _controller.animateTo(0.0, curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
    }

    if (changed) widget.onChanged(_value);
  }
}
