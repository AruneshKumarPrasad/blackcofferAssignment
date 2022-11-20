import 'package:flutter/material.dart';

import '../../Global/global.dart';

class NeuTextField extends StatelessWidget {
  const NeuTextField({
    Key? key,
    required bool darkModeEnabled,
    required String textLabel,
    required TextEditingController textController,
    required Function textValidator,
    required TextInputType keyboardType,
    required TextCapitalization capitalization,
    required FocusNode focusNode,
    required this.changeFocus,
  })  : _darkModeEnabled = darkModeEnabled,
        _textLabel = textLabel,
        _textController = textController,
        _textValidator = textValidator,
        _keyboardType = keyboardType,
        _capitalization = capitalization,
        _focusNode = focusNode,
        super(key: key);

  final bool _darkModeEnabled;
  final String _textLabel;
  final dynamic _textValidator;
  final TextEditingController _textController;
  final TextInputType _keyboardType;
  final TextCapitalization _capitalization;
  final FocusNode _focusNode;
  final dynamic changeFocus;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        boxShadow: _darkModeEnabled
            ? GlobalTraits.neuShadowsDark
            : GlobalTraits.neuShadows,
        color: _darkModeEnabled
            ? GlobalTraits.bgGlobalColorDark
            : GlobalTraits.bgGlobalColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _textLabel,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              textInputAction: _textLabel == "Description: "
                  ? TextInputAction.done
                  : TextInputAction.next,
              onFieldSubmitted: (_) {
                changeFocus(_textLabel);
              },
              controller: _textController,
              validator: _textValidator,
              keyboardType: _keyboardType,
              enableSuggestions: true,
              textCapitalization: _capitalization,
              decoration: GlobalTraits.textFieldDecoration,
              focusNode: _focusNode,
            ),
          ),
        ],
      ),
    );
  }
}
