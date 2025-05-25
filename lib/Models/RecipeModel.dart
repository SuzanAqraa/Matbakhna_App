
import 'package:matbakhna_mobile/Models/CommentModel.dart';
import 'package:matbakhna_mobile/Models/StepModel.dart';

class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String duration;
  final String videoUrl;
  final String serving;
  final String difficulty;
  final String mealType;
  final String nationality;
  final int numLikes;
  final int numComments;
  final List<CommentModel> comments;
  final List<StepModel> steps;
  final List<String> ingredients;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.videoUrl,
    required this.serving,
    required this.difficulty,
    required this.mealType,
    required this.nationality,
    required this.numLikes,
    required this.numComments,
    required this.comments,
    required this.steps,
    required this.ingredients,
  });

  factory RecipeModel.fromJson(String id, Map<String, dynamic> json) {
    return RecipeModel(
      id: id,
      title: json['Title'] ?? '',
      description: json['Description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      duration: json['duration'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      serving: json['serving'] ?? '',
      difficulty: json['difficulty'] ?? '',
      mealType: json['mealType'] ?? '',
      nationality: json['nationality'] ?? '',
      numLikes: json['Num_Likes'] is int ? json['Num_Likes'] : 0,
      numComments: json['Num_Comments'] is int ? json['Num_Comments'] : 0,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e))
          .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => StepModel.fromJson(e))
          .toList() ??
          [],
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Description': description,
      'imageUrl': imageUrl,
      'duration': duration,
      'videoUrl': videoUrl,
      'serving': serving,
      'difficulty': difficulty,
      'mealType': mealType,
      'nationality': nationality,
      'Num_Likes': numLikes,
      'Num_Comments': numComments,
      'comments': comments.map((e) => e.toJson()).toList(),
      'steps': steps.map((e) => e.toJson()).toList(),
      'ingredients': ingredients,
    };
  }
}
