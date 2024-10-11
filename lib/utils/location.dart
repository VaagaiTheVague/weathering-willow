class Location {
  const Location({
    required this.id,
    required this.name,
    required this.country,
    required this.language,
    required this.long,
    required this.lat,
    required this.admin,
  });

  final int id;

  final String name;

  final String? country;

  final String language;

  final double long;

  final double lat;

  final List<String> admin;
}
