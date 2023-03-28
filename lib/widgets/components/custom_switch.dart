import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const CustomSwitch({
    Key? key,
    this.initialValue = false,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        width: 60.0,
        height: 30.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: _value ? Colors.green : Colors.grey,
        ),
        child: Row(
          mainAxisAlignment:
              _value ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              margin: EdgeInsets.all(3.0),
              child: _value
                  ? Icon(Icons.check, size: 16.0, color: Colors.green)
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _value = !_value;
      if (widget.onChanged != null) {
        widget.onChanged!(_value);
      }
    });
  }
}
