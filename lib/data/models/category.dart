import 'package:uuid/uuid.dart';

class Category {
  late final String id;
  late final String name;
  final DateTime createdAt;

  Category({required this.name})
      : id = Uuid().v4(),
        createdAt = DateTime.now();
}
