class Project {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String? projectUrl;


  Project({
    this.projectUrl,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      technologies: List<String>.from(map['technologies'] ?? []),
      projectUrl: map['projectUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'technologies': technologies,
      'projectUrl': projectUrl,
    };
  }
}
