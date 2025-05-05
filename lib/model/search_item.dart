import 'package:hive/hive.dart';

part 'search_item.g.dart';

@HiveType(typeId: 0)
class SearchItem extends HiveObject {
  @HiveField(0)
  String id; // profile id or squad tag

  @HiveField(1)
  String name;

  @HiveField(2)
  String? imageUrl;

  @HiveField(3)
  SearchType type;

  @HiveField(4)
  String? title;

  SearchItem({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.type,
    this.title,
  });
}

enum SearchType {
  profile,
  squad,
  post,
}
