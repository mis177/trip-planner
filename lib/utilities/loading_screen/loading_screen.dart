import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tripplanner/utilities/loading_screen/loading_screen_controller.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(context: context, loadingText: text);
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String loadingText,
  }) {
    final text = StreamController<String>();
    text.add(loadingText);

    final state = Overlay.of(context);
    final size = MediaQuery.of(context).size;
    final overlay = OverlayEntry(
      opaque: false,
      builder: (context) {
        return Material(
          color: Colors.grey.withOpacity(0.6),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.7,
                maxHeight: size.height * 0.5,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 24),
                    StreamBuilder(
                      stream: text.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        text.close();
        overlay.remove();
        return true;
      },
      update: (newText) {
        text.add(newText);
        return true;
      },
    );
  }
}
