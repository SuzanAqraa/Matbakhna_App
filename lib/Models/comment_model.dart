class CommentModel {
  final String username;
  final String comment;
  final String? profilePic;

  CommentModel({
    required this.username,
    required this.comment,
    this.profilePic,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      username: map['username'] ?? '',
      comment: map['comment'] ?? '',
      profilePic: map['profilepic'],
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      username: json['username'] ?? '',
      comment: json['comment'] ?? '',
      profilePic: json['profilepic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'comment': comment,
      'profilepic': profilePic,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'comment': comment,
      'profilepic': profilePic,
    };
  }
}
