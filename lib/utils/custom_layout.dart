import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class KeyBoard extends StatefulWidget {
  final TextEditingController textEditingController;
  String type;

  KeyBoard(this.textEditingController, this.type);

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

  List<VirtualKeyboardDefaultLayouts> keyBoardLayout;

  @override
  void initState() {
    super.initState();

    _customLayoutKeys = CustomLayoutKeys();
    selectKeyBoardType();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(220,220, 220, 1.0),
      child: VirtualKeyboard(
        height: 250,
        //width: 500,
        textColor: Colors.white,
        textController: widget.textEditingController,
        //customLayoutKeys: _customLayoutKeys,
        defaultLayouts: keyBoardLayout,
        //reverseLayout :true,
        type: VirtualKeyboardType.Alphanumeric,
        onKeyPress: _onKeyPress
      ),
    );
  }

  void selectKeyBoardType() {
    switch(widget.type) {
      case 'musicKey':
        keyBoardLayout = [VirtualKeyboardDefaultLayouts.Key];
        break;
      case 'chord':
        keyBoardLayout = [VirtualKeyboardDefaultLayouts.Chord, VirtualKeyboardDefaultLayouts.Degree];
        break;
      case 'label':
        keyBoardLayout = [VirtualKeyboardDefaultLayouts.Label];
        break;
      default:
    }
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
        return _chordLayout;
      default:
        return defaultEnglishLayout;
    }
  }

}


const List<List> _chordLayout = [
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
    'alt',
    'omit',
    'add',
    'sus',
    'φ',
    'dim',
    'aug',
    'm',
    'M',
    '/',
  ],
  // Row 3
  const [
    'C',
    'D',
    'E',
    'F',
    'G',
    'A',
    'B',
    '♭',
    '#',
    VirtualKeyboardKeyAction.Backspace,
  ],
  // Row 4
  const [
    VirtualKeyboardKeyAction.SwithLanguage,
    VirtualKeyboardKeyAction.Space,
    VirtualKeyboardKeyAction.Done,
//    VirtualKeyboardKeyAction.Shift
  ],

];