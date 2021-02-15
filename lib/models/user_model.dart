class UserModel {
  UserModel({this.userId});
  int userId;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(userId: json["id"]);

  Map<String, dynamic> toJson() => {
        "id": userId,
      };
}
