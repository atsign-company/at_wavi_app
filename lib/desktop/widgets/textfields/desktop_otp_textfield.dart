import 'package:flutter/material.dart';

class DesktopOTPTextField extends StatefulWidget {
  /// Number of the OTP Fields
  final int length;

  /// Manage the type of keyboard that shows up
  final TextInputType keyboardType;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// Text Field Alignment
  /// default: MainAxisAlignment.spaceBetween [MainAxisAlignment]
  final MainAxisAlignment textFieldAlignment;

  /// Obscure Text if data is sensitive
  final bool obscureText;

  /// The border color text field.
  final Color borderColor;

  /// The background color text field.
  final Color backgroundColor;

  /// The border color of text field when in focus.
  final Color focusBorderColor;

  /// Callback function, called when a change is detected to the pin.
  final ValueChanged<String>? onChanged;

  /// Callback function, called when pin is completed.
  final ValueChanged<String>? onCompleted;

  const DesktopOTPTextField({Key? key, 
    this.length = 4,
    required this.backgroundColor,
    required this.borderColor,
    required this.focusBorderColor,
    this.keyboardType = TextInputType.number,
    this.style = const TextStyle(),
    this.textFieldAlignment = MainAxisAlignment.spaceBetween,
    this.obscureText = false,
    this.onChanged,
    this.onCompleted,
  }) : assert(length > 1), super(key: key);

  @override
  _DesktopOTPTextFieldState createState() => _DesktopOTPTextFieldState();
}

class _DesktopOTPTextFieldState extends State<DesktopOTPTextField> {
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  late List<Widget> _textFields;
  late List<String> _pin;

  @override
  void initState() {
    super.initState();
    _focusNodes = List<FocusNode?>.filled(widget.length, null, growable: false);
    _textControllers = List<TextEditingController?>.filled(widget.length, null,
        growable: false);

    _pin = List.generate(widget.length, (int i) {
      return '';
    });
    _textFields = List.generate(widget.length, (int i) {
      return buildTextField(i);
    });
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: widget.textFieldAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _textFields,
      ),
    );
  }

  /// This function Build and returns individual TextField item.
  ///
  /// * Requires a build context
  /// * Requires Int position of the field
  Widget buildTextField(int i) {
    if (_focusNodes[i] == null) {
      _focusNodes[i] = FocusNode();
      if (i == 0) {
        _focusNodes[i]?.requestFocus();
      }
    }

    if (_textControllers[i] == null) {
      _textControllers[i] = TextEditingController();
    }

    return Container(
      width: 68,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextFormField(
        controller: _textControllers[i],
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.center,
        style: widget.style,
        focusNode: _focusNodes[i],
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.symmetric(vertical: 24),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.focusBorderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onChanged: (String str) {
          if (str.length > 1) {
            _handlePaste(str);
            return;
          }

          // Check if the current value at this position is empty
          // If it is move focus to previous text field.
          if (str.isEmpty) {
            if (i == 0) return;
            _focusNodes[i]?.unfocus();
            _focusNodes[i - 1]?.requestFocus();
          }

          // Update the current pin
          setState(() {
            _pin[i] = str;
          });

          // Remove focus
          if (str.isNotEmpty) _focusNodes[i]?.unfocus();
          // Set focus to the next field if available
          if (i + 1 != widget.length && str.isNotEmpty) {
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
          }

          String currentPin = _getCurrentPin();

          // if there are no null values that means otp is completed
          // Call the `onCompleted` callback function provided
          if (!_pin.contains(null) &&
              !_pin.contains('') &&
              currentPin.length == widget.length) {
            widget.onCompleted?.call(currentPin);
          }

          // Call the `onChanged` callback function
          widget.onChanged?.call(currentPin);
        },
        onSaved: (text){
          if (i == _focusNodes.length - 1) {
            String currentPin = _getCurrentPin();
            // if there are no null values that means otp is completed
            // Call the `onCompleted` callback function provided
            if (!_pin.contains(null) &&
                !_pin.contains('') &&
                currentPin.length == widget.length) {
              widget.onCompleted?.call(currentPin);
            }
            widget.onChanged?.call(currentPin);
          }
        },
      ),
    );
  }

  String _getCurrentPin() {
    String currentPin = "";
    for (var value in _pin) {
      currentPin += value;
    }
    return currentPin;
  }

  void _handlePaste(String str) {
    if (str.length > widget.length) {
      str = str.substring(0, widget.length);
    }

    for (int i = 0; i < str.length; i++) {
      String digit = str.substring(i, i + 1);
      _textControllers[i]!.text = digit;
      _pin[i] = digit;
    }

    FocusScope.of(context).requestFocus(_focusNodes[widget.length - 1]);

    String currentPin = _getCurrentPin();

    // if there are no null values that means otp is completed
    // Call the `onCompleted` callback function provided
    if (!_pin.contains(null) &&
        !_pin.contains('') &&
        currentPin.length == widget.length) {
      widget.onCompleted?.call(currentPin);
    }

    // Call the `onChanged` callback function
    widget.onChanged?.call(currentPin);
  }
}
