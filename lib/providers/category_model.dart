import 'recipe_model.dart';

class Category {
  String id;
  String title;
  List<Recipe> recipes;

  Category({
    required this.id,
    required this.title,
    required this.recipes,
  });
}
