class PG {
  final String id;
  final String name;
  final String location;
  final int priceWithFoodAC;
  final int priceWithoutFood;
  final int priceWithoutAC;
  final double foodRating;
  final String foodReview;
  final String contactNumber;
  final String contactPerson;
  final String houseSize;
  final List<String> houseFeatures;
  final String description;
  final String? mainImage;

  PG({
    required this.id,
    required this.name,
    required this.location,
    required this.priceWithFoodAC,
    required this.priceWithoutFood,
    required this.priceWithoutAC,
    required this.foodRating,
    required this.foodReview,
    required this.contactNumber,
    required this.contactPerson,
    required this.houseSize,
    required this.houseFeatures,
    required this.description,
    this.mainImage,
  });

  factory PG.fromMap(Map<String, dynamic> data, String documentId) {
    return PG(
      id: documentId,
      name: data['name'],
      location: data['location'],
      priceWithFoodAC: data['priceWithFoodAC'],
      priceWithoutFood: data['priceWithoutFood'],
      priceWithoutAC: data['priceWithoutAC'],
      foodRating: (data['foodRating'] as num).toDouble(),
      foodReview: data['foodReview'],
      contactNumber: data['contactNumber'],
      contactPerson: data['contactPerson'],
      houseSize: data['houseSize'],
      houseFeatures: List<String>.from(data['houseFeatures']),
      description: data['description'],
      mainImage: data['mainImage'],
    );
  }
}
