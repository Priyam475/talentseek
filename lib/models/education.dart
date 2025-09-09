/// Represents a single educational entry in a user's portfolio.
class Education {
  final String institutionName;
  final String degree;
  final String fieldOfStudy;
  final String startDate;
  final String endDate;

  Education({
    required this.institutionName,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
  });

  /// [NEW] Creates an Education instance from a map (e.g., from Firestore).
  /// This allows you to easily convert a Firestore document back into an Education object.
  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institutionName: map['institutionName'] ?? '',
      degree: map['degree'] ?? '',
      fieldOfStudy: map['fieldOfStudy'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
    );
  }

  /// Converts this Education object into a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'institutionName': institutionName,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

