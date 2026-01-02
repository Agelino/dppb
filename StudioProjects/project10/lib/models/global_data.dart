class UserModel {
  int id;
  String username;
  String socialMedia;
  String fotoProfil;

  UserModel({
    required this.id,
    required this.username,
    required this.socialMedia,
    required this.fotoProfil,
  });
}

List<UserModel> dummyUsers = [
  UserModel(
    id: 1,
    username: "adzraaditama",
    socialMedia: "@adzraaditama",
    fotoProfil: "asset/adzra.jpeg",
  ),
  UserModel(
    id: 2,
    username: "sharonejp",
    socialMedia: "@sharonejes",
    fotoProfil: "asset/sharone.jpeg",
  ),
  UserModel(
    id: 3,
    username: "khansafeby",
    socialMedia: "@fbyysain",
    fotoProfil: "asset/feby.jpeg",
  ),
];
