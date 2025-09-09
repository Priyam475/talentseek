/// Represents a single certification or license in a user's portfolio.
class Certificate {
  final String name;
  final String issuingOrganization;
  final String date;
  final String credentialUrl;
  final String? documentPath; // New field for the document path

  Certificate({
    required this.name,
    required this.issuingOrganization,
    required this.date,
    required this.credentialUrl,
    this.documentPath, // Added to constructor
  });

  /// Creates a Certificate instance from a map (e.g., from Firestore).
  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      name: map['name'] ?? '',
      issuingOrganization: map['issuingOrganization'] ?? '',
      date: map['date'] ?? '',
      credentialUrl: map['credentialUrl'] ?? '',
      documentPath: map['documentPath'], // Added here
    );
  }

  /// Converts this Certificate object into a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'issuingOrganization': issuingOrganization,
      'date': date,
      'credentialUrl': credentialUrl,
      'documentPath': documentPath, // Added here
    };
  }
}
