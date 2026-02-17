import 'package:schooly/constant/export_utils.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatelessWidget {
  final int length;
  final TextEditingController controller;
  final Function(String)? onCompleted;
  final bool showCursor;
  final Color borderColor;
  final Color focusedBorderColor;
  final double fieldSize;
  final Color? cursorColor;

  const OtpInputField({
    super.key,
    this.length = 4,
    required this.controller,
    this.onCompleted,
    this.showCursor = true,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Colors.green,
    this.fieldSize = 60,
    this.cursorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => _buildOtpField(context, index),
      ),
    );
  }

  Widget _buildOtpField(BuildContext context, int index) {
    return Container(
      width: fieldSize,
      height: fieldSize,
      margin: EdgeInsets.symmetric(horizontal: index < length - 1 ? 8 : 0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: _getBorderColor(index),
          width: _getBorderWidth(index),
        ),
      ),
      child: Center(
        child: _buildFieldContent(index),
      ),
    );
  }

  Color _getBorderColor(int index) {
    final text = controller.text;
    if (text.length > index) {
      return focusedBorderColor;
    }
    if (text.length == index) {
      return focusedBorderColor;
    }
    return borderColor;
  }

  double _getBorderWidth(int index) {
    final text = controller.text;
    if (text.length > index || text.length == index) {
      return 2.0;
    }
    return 1.0;
  }

  Widget _buildFieldContent(int index) {
    final text = controller.text;
    
    if (text.length > index) {
      return Text(
        text[index],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );
    } else if (text.length == index && showCursor) {
      return Container(
        width: 2.5,
        height: 28,
        color: cursorColor ?? focusedBorderColor,
      );
    }
    
    return const SizedBox.shrink();
  }
}

class OtpInputWidget extends StatefulWidget {
  final int length;
  final Function(String)? onCompleted;
  final TextEditingController? controller;
  final bool showCursor;
  final Color borderColor;
  final Color focusedBorderColor;
  final double fieldSize;

  const OtpInputWidget({
    super.key,
    this.length = 4,
    this.onCompleted,
    this.controller,
    this.showCursor = true,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Colors.green,
    this.fieldSize = 60,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isCursorVisible = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
    _startCursorBlink();
  }

  void _startCursorBlink() {
    _cursorTimer?.cancel();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (timer) {
      if (!mounted) return;
      if (_focusNode.hasFocus && _controller.text.length < widget.length) {
        setState(() {
          _isCursorVisible = !_isCursorVisible;
        });
      } else if (!_focusNode.hasFocus) {
        _isCursorVisible = true;
      }
    });
  }

  void _onTextChanged() {
    setState(() {});
    if (_controller.text.length == widget.length) {
      widget.onCompleted?.call(_controller.text);
    }
  }

  void _onFocusChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: widget.length,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          // Visual OTP fields
          OtpInputField(
            length: widget.length,
            controller: _controller,
            showCursor: _isCursorVisible && _focusNode.hasFocus,
            borderColor: widget.borderColor,
            focusedBorderColor: widget.focusedBorderColor,
            fieldSize: widget.fieldSize,
            cursorColor: widget.focusedBorderColor,
          ),
        ],
      ),
    );
  }
}
