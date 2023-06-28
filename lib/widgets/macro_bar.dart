// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';

class MacroBar extends StatelessWidget {
  double partOfTheBar;
  MacroBar(this.partOfTheBar);

  @override
  Widget build(BuildContext context) {
    double width = 350 * partOfTheBar;
    return Container(
      width: 350,
      height: 4,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.75),
        color: Theme.of(context).accentColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: width,
          color: Theme.of(context).primaryColorDark,
          height: 4,
        ),
      ),
    );
  }
}
