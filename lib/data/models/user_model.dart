class UserModel {
  final String uid;
  final String? name;
  final bool isSubscribed;

  UserModel({
    required this.uid,
    this.name,
    required this.isSubscribed,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'],
      isSubscribed: json['isSubscribed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'isSubscribed': isSubscribed,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    bool? isSubscribed,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }
}