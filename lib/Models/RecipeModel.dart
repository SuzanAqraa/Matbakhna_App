import 'package:matbakhna_mobile/Models/CommentModel.dart';
import 'package:matbakhna_mobile/Models/StepModel.dart';
class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int numLikes;
  final int numComments;
  final List<CommentModel> comments;
  final List<StepModel> steps;
  final String duration;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.numLikes,
    required this.numComments,
    required this.comments,
    required this.steps,
    required this.duration,
  });

  factory RecipeModel.fromJson(String id, Map<String, dynamic> json) {
    final commentsJson = json['comments'];
    final stepsJson = json['steps'];

    return RecipeModel(
      id: id,
      title: json['Title'] ?? '',
      description: json['Description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      duration: json['duration'] ?? '',
      numLikes: json['Num_Likes'] ?? 0,
      numComments: json['Num_Coments'] ?? 0,
      comments: commentsJson is List
          ? commentsJson.map((e) => CommentModel.fromJson(e)).toList()
          : [],
      steps: stepsJson is List
          ? stepsJson.map((e) => StepModel.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Description': description,
      'imageUrl': imageUrl,
      'Num_Likes': numLikes,
      'Num_Comments': numComments,
      'comments': comments.map((e) => e.toJson()).toList(),
      'steps': steps.map((e) => e.toJson()).toList(),
      'Duration': duration,
    };
  }
}
