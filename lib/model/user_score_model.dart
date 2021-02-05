class UserScore{
  final Map scores;

  UserScore({this.scores});

  UserScore.fromJson(Map<dynamic, dynamic> json)
      :scores = json['scores']??{};

  Map<dynamic, dynamic> toJson() => {
    "scores": scores?? {},
  };
}