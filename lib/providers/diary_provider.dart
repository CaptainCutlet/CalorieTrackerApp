// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'diary_item_model.dart';

class DiaryProvider with ChangeNotifier {
  List<DiaryItemModel> _diaryList = [];
  int sum = 0;
  int proteinSum = 0;
  int carbsSum = 0;
  int fatsSum = 0;
  int kcalGoal = 0;
  int pGoal = 0;
  int cGoal = 0;
  int fGoal = 0;

  List<DiaryItemModel> get diaryList {
    return [..._diaryList];
  }

  Future<void> AddUserGoals(String userId, String kcal, String p, String c,
      String f, BuildContext context) async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/userGoals.json');
    try {
      print(kcal);
      final response = await http.put(
        url,
        body: json.encode(
          {
            'currentBalance': kcal,
            'protein': p,
            'carbs': c,
            'fats': f,
          },
        ),
      );
      var decodedData = json.decode(response.body) as Map<String, dynamic>;
      if (decodedData['error'] == null) {
        kcalGoal = int.parse(decodedData['currentBalance']);
        pGoal = int.parse(decodedData['protein']);
        cGoal = int.parse(decodedData['carbs']);
        fGoal = int.parse(decodedData['fats']);
      } else {
        showDialog(
          context: context,
          builder: (ctx) => const AlertDialog(
            title: Text('An error accured'),
            content: Text('Please try again later.'),
          ),
        );
      }
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> fetchUserGoals(String userId, BuildContext context) async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/userGoals.json');
    try {
      final response = await http.get(url);
      var decodedData = json.decode(response.body) as Map<String, dynamic>;

      if (decodedData['error'] == null) {
        kcalGoal = int.parse(decodedData['currentBalance']);
        pGoal = int.parse(decodedData['protein']);
        cGoal = int.parse(decodedData['carbs']);
        fGoal = int.parse(decodedData['fats']);
      } else {
        showDialog(
          context: context,
          builder: (ctx) => const AlertDialog(
            title: Text('An error accured'),
            content: Text('Please try again later.'),
          ),
        );
      }
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> addToDiary(DiaryItemModel diaryRecipe, String userId,
      String recipeId, int date) async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/usersDiary.json');
    final kcalUrl = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/usersDiaryKcalInfo.json');
    try {
      var response = await http.post(
        url,
        body: json.encode(
          {
            'title': diaryRecipe.title,
            'kcal': diaryRecipe.kcal,
            'p': diaryRecipe.p,
            'c': diaryRecipe.c,
            'f': diaryRecipe.f,
            'servings': diaryRecipe.servings,
            'recipeId': recipeId,
            'dayAdded': date,
          },
        ),
      );
      _diaryList.add(
        DiaryItemModel(
          id: json.decode(response.body)['name'],
          title: diaryRecipe.title,
          c: diaryRecipe.c,
          kcal: diaryRecipe.kcal,
          f: diaryRecipe.f,
          p: diaryRecipe.p,
          servings: diaryRecipe.servings,
          recipeId: recipeId,
          date: date,
        ),
      );
      sum += diaryRecipe.kcal;
      proteinSum += diaryRecipe.p;
      carbsSum += diaryRecipe.c;
      fatsSum += diaryRecipe.f;
      if (_diaryList.isEmpty) {
        await http.post(
          kcalUrl,
          body: json.encode(
            {
              'currentSum': sum.toString(),
            },
          ),
        );
      } else if (_diaryList.isNotEmpty) {
        await http.patch(
          kcalUrl,
          body: json.encode(
            {
              'currentSum': sum.toString(),
              'currentProteinSum': proteinSum.toString(),
              'currentCarbsSum': carbsSum.toString(),
              'currentFatsSum': fatsSum.toString(),
            },
          ),
        );
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> fetchUserDiary(String userId) async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/usersDiary.json');
    try {
      var response = await http.get(url);
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null || extractedData['error'] != null) {
        return;
      }
      List<DiaryItemModel> diaryList2 = [];
      extractedData.forEach((id, value) {
        diaryList2.add(
          DiaryItemModel(
            id: id,
            title: value['title'],
            c: value['c'],
            kcal: value['kcal'],
            f: value['f'],
            p: value['p'],
            servings: value['servings'],
            recipeId: value['recipeId'],
            date: value['dayAdded'],
          ),
        );
      });
      _diaryList = diaryList2;
      final kcalUrl = Uri.parse(
          'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/usersDiaryKcalInfo.json');
      var kcalResponse = await http.get(kcalUrl);
      var calorieData = json.decode(kcalResponse.body) as Map<String, dynamic>;
      sum = calorieData == null ? sum : int.parse(calorieData['currentSum']);
      proteinSum = int.parse(calorieData['currentProteinSum']);
      carbsSum = int.parse(calorieData['currentCarbsSum']);
      fatsSum = int.parse(calorieData['currentFatsSum']);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeFromDiary(DiaryItemModel diaryItem, String userId) async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/usersDiary/${diaryItem.id}.json');
    final kcalUrl = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/usersDiaryKcalInfo.json');
    http.delete(url);
    _diaryList.remove(diaryItem);
    sum -= diaryItem.kcal;
    proteinSum -= diaryItem.p;
    carbsSum -= diaryItem.c;
    fatsSum -= diaryItem.f;
    await http.patch(
      kcalUrl,
      body: json.encode(
        {
          'currentSum': sum.toString(),
          'currentProteinSum': proteinSum.toString(),
          'currentCarbsSum': carbsSum.toString(),
          'currentFatsSum': fatsSum.toString(),
        },
      ),
    );
    notifyListeners();
  }

  Future<void> autoRemove(DiaryItemModel diaryItem, String userId) async {
    final url = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/usersDiary/${diaryItem.id}.json');
    final kcalUrl = Uri.parse(
        'https://recipier-e1139-default-rtdb.europe-west1.firebasedatabase.app/usersData/$userId/usersDiaryKcalInfo.json');
    http.delete(url);
    _diaryList.remove(diaryItem);
    sum -= diaryItem.kcal;
    proteinSum -= diaryItem.p;
    carbsSum -= diaryItem.c;
    fatsSum -= diaryItem.f;
    await http.patch(
      kcalUrl,
      body: json.encode(
        {
          'currentSum': sum.toString(),
          'currentProteinSum': proteinSum.toString(),
          'currentCarbsSum': carbsSum.toString(),
          'currentFatsSum': fatsSum.toString(),
        },
      ),
    );
    notifyListeners();
  }
}
