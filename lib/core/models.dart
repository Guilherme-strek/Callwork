class ProfessionalSummary {
  final int id;
  final String name, role, category, city;
  final bool meiVerified;
  final double rating;
  final int reviewsCount;
  final String? startingPrice;

  ProfessionalSummary({
    required this.id, required this.name, required this.role,
    required this.category, required this.city, required this.meiVerified,
    required this.rating, required this.reviewsCount, this.startingPrice,
  });

  factory ProfessionalSummary.fromJson(Map<String, dynamic> j) => ProfessionalSummary(
    id: j['id'], name: j['name'], role: j['role'],
    category: j['category'], city: j['city'],
    meiVerified: j['meiVerified'] ?? false,
    rating: (j['rating'] as num).toDouble(),
    reviewsCount: j['reviewsCount'] ?? 0,
    startingPrice: j['startingPrice'],
  );

  String get initials => name.split(' ').take(2).map((e) => e[0]).join().toUpperCase();
}

class ServiceItem {
  final int id;
  final String title, price;
  final bool active;

  ServiceItem({required this.id, required this.title, required this.price, required this.active});

  factory ServiceItem.fromJson(Map<String, dynamic> j) =>
      ServiceItem(id: j['id'], title: j['title'], price: j['price'], active: j['active'] ?? true);
}

class Review {
  final int id;
  final String author, comment;
  final int rating;
  final String createdAt;

  Review({required this.id, required this.author, required this.comment, required this.rating, required this.createdAt});

  factory Review.fromJson(Map<String, dynamic> j) =>
      Review(id: j['id'], author: j['author'], comment: j['comment'], rating: j['rating'], createdAt: j['createdAt'] ?? '');
}

class ProfessionalDetail {
  final int id;
  final String name, role, category, city, about;
  final bool meiVerified;
  final double rating;
  final int reviewsCount;
  final List<ServiceItem> services;
  final List<Review> reviews;

  ProfessionalDetail({
    required this.id, required this.name, required this.role, required this.category,
    required this.city, required this.about, required this.meiVerified,
    required this.rating, required this.reviewsCount,
    required this.services, required this.reviews,
  });

  factory ProfessionalDetail.fromJson(Map<String, dynamic> j) => ProfessionalDetail(
    id: j['id'], name: j['name'], role: j['role'], category: j['category'],
    city: j['city'], about: j['about'] ?? '',
    meiVerified: j['meiVerified'] ?? false,
    rating: (j['rating'] as num).toDouble(),
    reviewsCount: j['reviewsCount'] ?? 0,
    services: (j['services'] as List? ?? []).map((e) => ServiceItem.fromJson(e)).toList(),
    reviews: (j['reviews'] as List? ?? []).map((e) => Review.fromJson(e)).toList(),
  );

  String get initials => name.split(' ').take(2).map((e) => e[0]).join().toUpperCase();
}

class ServiceRequest {
  final int id, professionalId;
  final String requesterName, serviceTitle, message;
  String status;
  final String createdAt;

  ServiceRequest({
    required this.id, required this.professionalId, required this.requesterName,
    required this.serviceTitle, required this.message, required this.status, required this.createdAt,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> j) => ServiceRequest(
    id: j['id'], professionalId: j['professionalId'],
    requesterName: j['requesterName'], serviceTitle: j['serviceTitle'],
    message: j['message'], status: j['status'], createdAt: j['createdAt'] ?? '',
  );
}
