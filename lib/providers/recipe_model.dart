import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Recipe with ChangeNotifier {
  String title;
  String id;
  String description;
  String? imageUrl;
  bool favorite;
  List<String> ingredients;
  List<String> steps;
  String creatorId;
  int servings;
  int kcal;
  int p;
  int c;
  int f;
  bool isKeto;
  bool isVegan;
  bool isVegetarian;
  bool isLowFat;
  bool isLowCarbs;
  bool isLowCalories;

  Recipe({
    // required this.categories,
    required this.title,
    required this.description,
    this.favorite = false,
    required this.id,
    this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.c,
    required this.kcal,
    required this.f,
    required this.p,
    required this.servings,
    required this.creatorId,
    this.isKeto = false,
    this.isLowCalories = false,
    this.isVegan = false,
    this.isLowCarbs = false,
    this.isLowFat = false,
    this.isVegetarian = false,
  });

  void restoreFavStatus(newValue) {
    favorite = newValue;
  }

  Future<void> selectFavorite(String userId) async {
    final bool oldStatus = favorite;
    favorite = !favorite;
    notifyListeners();
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/usersFavorites/$id.json');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          {
            'favoriteStatus': favorite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        restoreFavStatus(oldStatus);
      }
    } catch (error) {
      restoreFavStatus(oldStatus);
      rethrow;
    }
  }
}
