class Profile {

  final String id;
  final String name;
  final String photoUrl;
  final String type;

  final double? rating;
  final int? jobsCompleted;
  final List<String>? trades;

  final double? totalBudget;

  Profile({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.type,
    this.rating,
    this.jobsCompleted,
    this.trades,
    this.totalBudget,
  });

  bool get isProfessional => type == 'professional';
  bool get isClient => type == 'client';

  Profile copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? type,
    double? rating,
    int? jobsCompleted,
    List<String>? trades,
    double? totalBudget,
  }) =>
      Profile(
        id: id ?? this.id,
        name: name ?? this.name,
        photoUrl: photoUrl ?? this.photoUrl,
        type: type ?? this.type,
        rating: rating ?? this.rating,
        jobsCompleted: jobsCompleted ?? this.jobsCompleted,
        trades: trades ?? this.trades,
        totalBudget: totalBudget ?? this.totalBudget,
      );

}