import 'package:flutter/material.dart';

//added for purposes of navigation func
class ExampleSwitch extends StatefulWidget {
  const ExampleSwitch({
    super.key,
    required this.title,
    this.onChanged,
    required this.initialValue,
  });

  final String title;

  final ValueChanged<bool>? onChanged;

  // initial value of the switch.
  final bool initialValue;

  @override
  State<ExampleSwitch> createState() => _ExampleSwitchState();
}

class _ExampleSwitchState extends State<ExampleSwitch> {
  late bool _flag;

  @override
  void initState() {
    super.initState();
    _flag = widget.initialValue;
  }

  void _toggleFlag(bool value) {
    setState(() {
      _flag = value;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.title),
      value: _flag,
      onChanged: widget.onChanged != null ? _toggleFlag : null,
    );
  }
}
