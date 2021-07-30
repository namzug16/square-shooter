import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:square_shooter/src/Player/PlayerControllerFSM.dart';

class KControls extends HookWidget {
  const KControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final node = useFocusNode();

    final playerController = useProvider(playerFSMProvider.notifier);

    return RawKeyboardListener(
      autofocus: true,
      focusNode: node,
      onKey: (RawKeyEvent data){
        playerController.kInput(data);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
