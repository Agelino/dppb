class UserModel {
  final int id;
  final String username;
  final String socialMedia;
  final String fotoProfil;

  UserModel({
    required this.id,
    required this.username,
    required this.socialMedia,
    required this.fotoProfil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'] ?? '',
      socialMedia: json['social_media'] ?? '',
      fotoProfil: json['foto_profil'] ?? '',
    );
  }
}

String authToken = '';
String userRole = '';

UserModel? currentUser; 