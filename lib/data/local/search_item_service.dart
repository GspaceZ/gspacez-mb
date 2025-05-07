import 'package:hive/hive.dart';
import 'package:untitled/model/search_item.dart';

class SearchItemService {
  static const String _boxName = 'search_item_box';
  static bool _adapterRegistered = false;

  /// Đăng ký adapter
  static void registerAdapter() {
    if (!_adapterRegistered) {
      Hive.registerAdapter(SearchItemAdapter());
      Hive.registerAdapter(SearchTypeAdapter());
      _adapterRegistered = true;
    }
  }

  /// Mở box
  static Future<void> initBox() async {
    await Hive.openBox<SearchItem>(_boxName);
  }

  /// Thêm hoặc cập nhật SearchItem
  static Future<void> saveSearchItem(String key, SearchItem searchItem) async {
    final box = Hive.box<SearchItem>(_boxName);
    await box.put(key, searchItem);
  }

  /// Lấy SearchItem theo key
  static SearchItem? getSearchItem(String key) {
    final box = Hive.box<SearchItem>(_boxName);
    return box.get(key);
  }

  /// Lấy danh sách tất cả SearchItems
  static List<SearchItem> getAllSearchItems() {
    final box = Hive.box<SearchItem>(_boxName);
    return box.values.toList();
  }

  /// Xoá SearchItem theo key
  static Future<void> deleteSearchItem(String key) async {
    final box = Hive.box<SearchItem>(_boxName);
    await box.delete(key);
  }

  /// Đóng box khi không dùng nữa (tùy chọn)
  static Future<void> closeBox() async {
    final box = Hive.box<SearchItem>(_boxName);
    await box.close();
  }
}
