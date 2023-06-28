// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        semanticsLabel: 'Loading...',
      ),
    );
  }
}
