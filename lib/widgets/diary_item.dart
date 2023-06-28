// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipier/screens/recipe_details_screen.dart';

import '../providers/diary_provider.dart';
import '../providers/diary_item_model.dart';

class DiaryItem extends StatelessWidget {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final DiaryItemModel diaryItem;
  DiaryItem(this.diaryItem);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dismissible(
        direction: DismissDirection.startToEnd,
        background: Container(
          height: 65,
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.delete,
            color: Theme.of(context).errorColor,
            size: 30,
          ),
        ),
        key: UniqueKey(),
        onDismissed: (direction) {
          var diaryItems = Provider.of<DiaryProvider>(context, listen: false);
          diaryItems.removeFromDiary(diaryItem, userId);
        },
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              RecipeDetailScreen.routeName,
              arguments: diaryItem.recipeId,
            );
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            height: 65,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.98,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UpperRow(diaryItem.title),
                    UpperRow('${diaryItem.kcal} kcal'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Protein: ',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          '${diaryItem.p} g',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Carbohydrates: ',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          '${diaryItem.c} g',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Fat: ',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          '${diaryItem.f} g',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpperRow extends StatelessWidget {
  String value;
  UpperRow(this.value);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Text(
        value,
        style: Theme.of(context).textTheme.headline5!.copyWith(
            fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
      ),
    );
  }
}
