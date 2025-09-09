class Skill {
  final String name;
  final String iconUrl;

  Skill({
    required this.name,
    required this.iconUrl,
  });

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      name: map['name'] ?? '',
      iconUrl: map['iconUrl'] ?? '',
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconUrl': iconUrl,
    };
  }
}
