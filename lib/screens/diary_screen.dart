// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipier/widgets/loading_spinner.dart';
import 'package:recipier/widgets/macro_bar.dart';

import '../providers/diary_item_model.dart';
import '../widgets/diary_item.dart';
import '../providers/diary_provider.dart';

class DiaryScreen extends StatefulWidget {
  static const routeName = '/diary-screen';

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<DiaryItemModel> recipes = [];
  bool _isLoading = false;
  bool _runsForFirstTime = true;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isExtended = false;

  @override
  void didChangeDependencies() {
    if (_runsForFirstTime == true) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<DiaryProvider>(context).fetchUserDiary(userId);
      Provider.of<DiaryProvider>(context)
          .fetchUserGoals(userId, context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    final diaryList = Provider.of<DiaryProvider>(context).diaryList;
    for (var item in diaryList) {
      if (DateTime.now().day != item.date) {
        Provider.of<DiaryProvider>(context).removeFromDiary(item, userId);
      }
    }
    _runsForFirstTime = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final diary = Provider.of<DiaryProvider>(context);
    recipes = diary.diaryList;
    return _isLoading == true
        ? LoadingSpinner()
        : Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 1),
                padding:
                    const EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 1),
                height: _isExtended == false ? 70 : 180,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CalorieText('${diary.kcalGoal} kcal'),
                          CalorieText('-'),
                          CalorieText(
                              '${diary.sum < 0 ? '0  kcal' : diary.sum}  kcal'),
                          CalorieText('='),
                          CalorieText(diary.diaryList.isNotEmpty
                              ? '${diary.kcalGoal - diary.sum}  kcal'
                              : '${diary.kcalGoal} kcal'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 60,
                      child: IconButton(
                        key: const ValueKey('ArrowIcon'),
                        iconSize: 25,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        onPressed: () {
                          setState(() {
                            _isExtended = !_isExtended;
                          });
                        },
                        icon: Icon(
                          _isExtended == false
                              ? Icons.keyboard_arrow_down_outlined
                              : Icons.keyboard_arrow_up_outlined,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (_isExtended == true)
                      CalorieTextRow(
                          'Protein : ',
                          '${diary.pGoal}',
                          '${diary.proteinSum}',
                          '${diary.pGoal - diary.proteinSum} g',
                          (diary.proteinSum / diary.pGoal)),
                    if (_isExtended == true)
                      CalorieTextRow(
                          'Carbohydrates : ',
                          '${diary.cGoal}',
                          '${diary.carbsSum}',
                          '${diary.cGoal - diary.carbsSum} g',
                          (diary.carbsSum / diary.cGoal)),
                    if (_isExtended == true)
                      CalorieTextRow(
                          'Fats : ',
                          '${diary.fGoal}',
                          '${diary.fatsSum}',
                          '${diary.fGoal - diary.fatsSum} g',
                          (diary.fatsSum / diary.fGoal)),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: recipes[index],
                    child: DiaryItem(recipes[index]),
                  );
                },
              ),
            ],
          );
  }
}

class CalorieText extends StatelessWidget {
  String value;
  CalorieText(this.value);
  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }
}

class CalorieTextRow extends StatelessWidget {
  String name;
  String value1;
  String value2;
  String value3;
  double partOfTheBar;
  CalorieTextRow(
      this.name, this.value1, this.value2, this.value3, this.partOfTheBar);
  @override
  Widget build(BuildContext context) {
    Widget text0 = Text(
      name,
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
    );
    Widget text1 = Text(
      value1,
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
    );
    Widget text2 = Text(
      value2,
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
    );
    Widget text3 = Text(
      value3,
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
    );
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: text0),
            text1,
            Text(
              '  -  ',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            text2,
            Text(
              '  =  ',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            text3,
          ],
        ),
        const SizedBox(
          height: 1,
        ),
        MacroBar(partOfTheBar),
        const SizedBox(
          height: 1,
        ),
      ],
    );
  }
}
