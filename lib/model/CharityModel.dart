class CharityModel {
  const CharityModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.impact,
    required this.distance,
    required this.tags,
    required this.email,
    required this.number,
    required this.website,
  });

  final String id;
  final String name;
  final String location;
  final String description;
  final String impact;
  final String distance;
  final List<String> tags;
  final String email;
  final String number;
  final String website;
}


