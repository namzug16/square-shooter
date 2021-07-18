import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../Player/PlayerController.dart';

class KControls extends HookWidget {
  const KControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final node = useFocusNode();

    final playerController = useProvider(playerProvider.notifier);

    return RawKeyboardListener(
      autofocus: true,
      focusNode: node,
      onKey: (RawKeyEvent data){
        if(data.logicalKey.keyLabel == "k"){
          playerController.shoot(data);
        }else if(data.logicalKey.keyLabel == "l"){
          playerController.activateLaserBeam(data);
        }else{
          playerController.setDirection(data);

        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
