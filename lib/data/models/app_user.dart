class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.location,
    required this.balance,
    required this.memberSince,
    this.profilePictureUrl,
    this.number = '',
    this.rating = 4.8,
    this.ratingCount = 0,
    this.soldCount = 0,
    this.purchases = const [],
    this.listings = const [],
    this.favorites = const [],
    this.followers = const [],
    this.following = const [],
  });

  final String id;
  final String name;
  final String lastname;
  final String email;
  final String location;
  final double balance;
  final DateTime memberSince;
  final String? profilePictureUrl;
  final String number;
  final double rating;
  final int ratingCount;
  final int soldCount;
  final List<String> purchases;
  final List<String> listings;
  final List<String> favorites;
  final List<String> followers;
  final List<String> following;

  String get fullName => '$name $lastname';

  AppUser copyWith({
    String? id,
    String? name,
    String? lastname,
    String? email,
    String? location,
    double? balance,
    DateTime? memberSince,
    String? profilePictureUrl,
    String? number,
    double? rating,
    int? ratingCount,
    int? soldCount,
    List<String>? purchases,
    List<String>? listings,
    List<String>? favorites,
    List<String>? followers,
    List<String>? following,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      location: location ?? this.location,
      balance: balance ?? this.balance,
      memberSince: memberSince ?? this.memberSince,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      number: number ?? this.number,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      soldCount: soldCount ?? this.soldCount,
      purchases: purchases ?? this.purchases,
      listings: listings ?? this.listings,
      favorites: favorites ?? this.favorites,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}
