 class Item {
      final int id;
      final String description;
      final String location;

      Item({
        required this.id,
        required this.description,
        required this.location,
      });

      factory Item.fromJson(Map<String, dynamic> json) {
        return Item(
          id: json['id'],
          description: json['description'],
          location: json['location'],
        );
      }
    }