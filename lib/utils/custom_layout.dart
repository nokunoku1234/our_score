import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class KeyBoard extends StatefulWidget {
  final TextEditingController textEditingController;
  final String type;
  final String whichKey;

  KeyBoard({this.textEditingController, this.type, this.whichKey});

  @override
  _KeyBoardState createState() => _KeyBoardState();
}

class _KeyBoardState extends State<KeyBoard> {
  // Holds the text that user typed.
  String text = '';
  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  List<VirtualKeyboardDefaultLayouts> keyBoardLayout;

  @override
  void initState() {
    super.initState();

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
        keyBoardLayout = [VirtualKeyboardDefaultLayouts.Chord];
        break;
      case 'degree':
        keyBoardLayout = [VirtualKeyboardDefaultLayouts.Degree];
        break;
      case 'diatonic':
        if(widget.whichKey == 'C' || widget.whichKey == 'Am') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.CDiatonic];
        } else if(widget.whichKey == 'G' || widget.whichKey == 'Em') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.GDiatonic];
        } else if(widget.whichKey == 'D' || widget.whichKey == 'Bm') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.DDiatonic];
        } else if(widget.whichKey == 'A' || widget.whichKey == 'F#m') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.ADiatonic];
        } else if(widget.whichKey == 'E' || widget.whichKey == 'C#m') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.EDiatonic];
        } else if(widget.whichKey == 'B' || widget.whichKey == 'G#m') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.BDiatonic];
        } else if(widget.whichKey == 'F#' || widget.whichKey == 'D#m') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.FsharpDiatonic];
        } else if(widget.whichKey == 'F' || widget.whichKey == 'Dm') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.FDiatonic];
        } else if(widget.whichKey == 'Bb' || widget.whichKey == 'Gm') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.BflatDiatonic];
        } else if(widget.whichKey == 'Eb' || widget.whichKey == 'Cm') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.EflatDiatonic];
        } else if(widget.whichKey == 'Ab' || widget.whichKey == 'Fm') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.AflatDiatonic];
        } else if(widget.whichKey == 'Db' || widget.whichKey == 'Bbm') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.DflatDiatonic];
        } else if(widget.whichKey == 'Gb' || widget.whichKey == 'Ebm') {
          keyBoardLayout = [VirtualKeyboardDefaultLayouts.GflatDiatonic];
        }
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

