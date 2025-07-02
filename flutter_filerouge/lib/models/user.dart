class User {
  final String id;
  final String userName;
  final String email;
  final String password;
  final int role;
  final String createdAt;
  final int score;
  final String lastActivity;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.score,
    required this.lastActivity,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      score: json['score'] ?? 0,
      lastActivity: json['lastActivity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
      'role': role,
      'createdAt': createdAt,
      'score': score,
      'lastActivity': lastActivity,
    };
  }
}
