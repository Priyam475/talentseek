class UserProfile {
  final String uid;
  final String fullName;
  final String email;
  final String headline;
  final String about;
  final String? profilePictureUrl; // Changed from profileImageUrl and made nullable for flexibility

  UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.headline,
    required this.about,
    this.profilePictureUrl, // Changed from profileImageUrl
  });

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      uid: uid,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      headline: map['headline'] ?? '',
      about: map['about'] ?? '',
      profilePictureUrl: map['profilePictureUrl'], // Changed from profileImageUrl
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'uid': uid, // UID is usually the document ID, not stored in the map itself
      'fullName': fullName,
      'email': email,
      'headline': headline,
      'about': about,
      'profilePictureUrl': profilePictureUrl, // Changed from profileImageUrl
    };
  }
}
