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

    return GestureDetector(
      onTapDown: (_){
        playerController.shoot();

      },
      child: MouseRegion(
        onHover: (PointerHoverEvent details){
          playerController.setAim(details.position);
        },
        child: RawKeyboardListener(
          autofocus: true,
          focusNode: node,
          onKey: (RawKeyEvent data){
            playerController.setDirection(data);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}
