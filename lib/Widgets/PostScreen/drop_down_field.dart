import 'package:flutter/material.dart';

class NeuDropdownButton extends StatefulWidget {
  const NeuDropdownButton({
    super.key,
    required this.initialDropDownValue,
    required this.setDropDownValue,
    required this.darkModeEnabled,
  });
  final String initialDropDownValue;
  final dynamic setDropDownValue;
  final bool darkModeEnabled;

  @override
  State<NeuDropdownButton> createState() => _NeuDropdownButtonState();
}

class _NeuDropdownButtonState extends State<NeuDropdownButton> {
  List<String> list = <String>[
    'Vlog',
    'DIY',
    'Review',
    'Educational',
    'Challenge',
    'Unboxing',
    'Reaction'
  ];

  late String dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = widget.initialDropDownValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      icon: const Icon(
        Icons.arrow_downward,
        color: Colors.black,
      ),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        color: Colors.transparent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          widget.setDropDownValue(dropdownValue);
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: AnimatedDefaultTextStyle(
            style: widget.darkModeEnabled
                ? const TextStyle(color: Colors.white)
                : const TextStyle(color: Colors.black),
            duration: const Duration(milliseconds: 500),
            child: Text(
              value,
              style: TextStyle(
                  color: widget.darkModeEnabled ? Colors.white : Colors.black),
            ),
          ),
        );
      }).toList(),
    );
  }
}
