class Item {
  final String id;
  final String name;
  final String? description;
  final String? image;

  const Item({
    required this.id,
    required this.name,
    this.description,
    this.image,
  });
}
