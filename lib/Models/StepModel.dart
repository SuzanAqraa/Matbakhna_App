class StepModel {
  final String description;
  final List<String> ingredients;
  final List<String> tools;
  final String stepNumber;

  StepModel({
    required this.description,
    required this.ingredients,
    required this.tools,
    required this.stepNumber,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      description: json['description'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      tools: List<String>.from(json['tools'] ?? []),
      stepNumber: json['stepNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'ingredients': ingredients,
      'tools': tools,
      'stepNumber': stepNumber,
    };
  }
}