import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class KeyBoard extends StatefulWidget {
  final TextEditingController textEditingController;

  KeyBoard(this.textEditingController);

  @override
  _KeyBoardState createState() => _KeyBoardState();
}

class _KeyBoardState extends State<KeyBoard> {
  // Holds the text that user typed.
  String text = '';
  CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  @override
  void initState() {
    _customLayoutKeys = CustomLayoutKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: VirtualKeyboard(
        height: 300,
        //width: 500,
        textColor: Colors.white,
        textController: widget.textEditingController,
        //customLayoutKeys: _customLayoutKeys,
        defaultLayouts: [VirtualKeyboardDefaultLayouts.Arabic,VirtualKeyboardDefaultLayouts.English],
        //reverseLayout :true,
        type: VirtualKeyboardType.Alphanumeric,
        onKeyPress: _onKeyPress
      ),
    );
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + (shiftEnabled ? key.capsText : key.text);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + key.text;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Update the screen
    setState(() {});
  }
}

class CustomLayoutKeys extends VirtualKeyboardLayoutKeys{

  @override
  int getLanguagesCount() => 2;

  List<List> getLanguage(int index){
    switch(index){
      case 1:
        return _arabicLayout;
      default:
        return defaultEnglishLayout;
    }
  }

}


const List<List> _arabicLayout = [
  // Row 1
  const [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
  ],
  // Row 2
  const [
    'ض',
    'ص',
    'ث',
    'ق',
    'ف',
    'غ',
    'ع',
    'ه',
    'خ',
    'ح',
    'د',
    VirtualKeyboardKeyAction.Backspace
  ],
  // Row 3
  const [
    'ش',
    'س',
    'ي',
    'ب',
    'ل',
    'ا',
    'ت',
    'ن',
    'م',
    'ك',
    'ط',
    VirtualKeyboardKeyAction.Return
  ],
  // Row 4
  const [
    'ذ',
    'ئ',
    'ء',
    'ؤ',
    'ر',
    'لا',
    'ى',
    'ة',
    'و',
    '.',
    'ظ',
    VirtualKeyboardKeyAction.Shift
  ],
  // Row 5
  const [
    VirtualKeyboardKeyAction.SwithLanguage,
    '@',
    VirtualKeyboardKeyAction.Space,
    '-',
    '_',
  ]
];