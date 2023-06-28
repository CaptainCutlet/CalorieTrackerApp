// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, deprecated_member_use

import 'package:flutter/material.dart';

class FrontCard extends StatelessWidget {
  final List<String> data;
  final String title;
  FrontCard(this.data, this.title);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(fontSize: 22, letterSpacing: 1.5),
          ),
          Divider(
            indent: 2,
            endIndent: 2,
            thickness: 2,
            color: Theme.of(context).accentColor,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              padding: const EdgeInsets.all(1),
              itemCount: data.length,
              itemBuilder: (context, i) => Text(
                data[i] + '\t',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
