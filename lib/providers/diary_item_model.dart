import 'package:flutter/material.dart';

class DiaryItemModel with ChangeNotifier {
  String title;
  String id;
  int kcal;
  int p;
  int c;
  int f;
  int date;
  int servings;
  String recipeId;
  

  DiaryItemModel({
    required this.id,
    required this.title,
    required this.c,
    required this.kcal,
    required this.f,
    required this.p,
    required this.servings,
    required this.recipeId,
    required this.date,
    
  });
}
