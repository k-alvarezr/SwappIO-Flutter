class DropOffPoint {
  const DropOffPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.opensAt,
    required this.closesAt,
  });

  final String id;
  final String name;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String opensAt;
  final String closesAt;
}
