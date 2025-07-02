class LeaderboardUser {
  final String id;
  final String userName;
  final int score;

  LeaderboardUser({
    required this.id,
    required this.userName,
    required this.score,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      score: json['score'] ?? 0,
    );
  }
}
