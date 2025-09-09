/// Represents a single professional experience entry in a user's portfolio.
///
/// This class captures the details of a user's work history, including their role,
/// the company they worked for, the duration, and a description of their work.
class Experience {
  final String companyName;
  final String jobTitle;
  final String startDate;
  final String endDate; // Can be "Present" for the current job
  final String description;

  Experience({
    required this.companyName,
    required this.jobTitle,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  /// [NEW] Creates an Experience instance from a map (e.g., from Firestore).
  /// This allows you to easily convert a Firestore document back into an Experience object.
  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      companyName: map['companyName'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      description: map['description'] ?? '',
    );
  }

  /// Converts this Experience object into a Map for Firestore storage.
  ///
  /// This serialization is necessary to save the structured data of a user's
  /// work experience into a Firestore document.
  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'jobTitle': jobTitle,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }
}

