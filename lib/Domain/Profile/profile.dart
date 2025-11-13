class Opinion {
  final String comment;
  final int rating;

  const Opinion({
    required this.comment,
    required this.rating,
  });

  factory Opinion.fromFirestore(Map<String, dynamic> map) {
    return Opinion(
      comment: map['comment'] as String,
      rating: (map['rating'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'comment': comment,
      'rating': rating,
    };
  }
}

class Profile {
  final String uid;
  final String name;
  final String email;
  final bool isWorker;

  final String? phone;
  final String? address;
  final String? photoUrl;

  final double rating = 4.5;

  final List<Opinion> opinions;
  final List<String> trades;

  const Profile({
    required this.uid,
    required this.name,
    required this.email,
    required this.isWorker,
    this.phone,
    this.address,
    this.photoUrl,
    this.opinions = const [],
    this.trades = const [],
  });

  factory Profile.fromFirestore(Map<String, dynamic> data, String id) {
    final List<dynamic> opinionsList = data['opinions'] ?? [];
    final List<Opinion> convertedOpinions = opinionsList.map((opinionMap) {
      return Opinion.fromFirestore(opinionMap as Map<String, dynamic>);
    }).toList();

    return Profile(
      uid: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      isWorker: data['isWorker'] ?? false,
      phone: data['phone'],
      address: data['address'],
      photoUrl: data['photoUrl'],
      opinions: convertedOpinions,
      trades: List<String>.from(data['trades'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    final List<Map<String, dynamic>> opinionsAsMap =
        opinions.map((opinion) => opinion.toFirestore()).toList();

    return {
      'name': name,
      'email': email,
      'isWorker': isWorker,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'opinions': opinionsAsMap,
      'trades': trades,
    };
  }

  /// 🔁 Permite crear una copia modificando solo algunos campos
  Profile copyWith({
    String? uid,
    String? name,
    String? email,
    bool? isWorker,
    String? phone,
    String? address,
    String? photoUrl,
    List<Opinion>? opinions,
    List<String>? trades,
  }) {
    return Profile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      isWorker: isWorker ?? this.isWorker,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      opinions: opinions ?? this.opinions,
      trades: trades ?? this.trades,
    );
  }

  bool get isProfessional => isWorker;
  bool get isClient => !isWorker;
}
