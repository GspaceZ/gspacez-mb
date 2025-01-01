import 'package:flutter/widgets.dart';
import 'package:untitled/model/post_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    fetchPost();
  }

  final List<PostModel> posts = [];

  Future<void> fetchPost() async {
    final List<PostModel> postsExample = [
      PostModel(
          author: "Mạc Bùi",
          urlAvatar:
              'https://res.cloudinary.com/dszkt92jr/image/upload/v1721463934/fgcnetakyb8nibeqr9do.png',
          content: 'Content 1'),
      PostModel(
        author: "Author 2",
        urlAvatar: 'https://picsum.photos/250?image=10',
        content: 'Content 2',
        urlImages: [
          'https://res.cloudinary.com/dszkt92jr/image/upload/v1721463934/fgcnetakyb8nibeqr9do.png',
          'https://res.cloudinary.com/dszkt92jr/image/upload/v1719943637/vcbhui3dxeusphkgvycg.png',
        ],
      ),
      PostModel(
          author: "Author 3",
          urlAvatar: 'https://picsum.photos/250?image=11',
          content: "Phân tích Code: Khi bạn chạy trình tạo code (auto_route),"
              " nó sẽ phân tích code của dự án, đặc biệt là tìm kiếm"
              " các widget được đánh dấu bằng @RoutePage"
              " Tạo Cấu hình: Dựa trên các widget này, auto_route s"
              "  ẽ tự động tạo ra code cấu hình cho lớp router của bạn (thườ"
              "  ng là AppRouter)."
              "  Lưu trữ Route: Code được tạo ra sẽ định nghĩa một danh sách cá"
              "  c đối tượng AutoRoute bên trong lớp AppRouter. Mỗ"
              " i đối tượng AutoRoute chứa thông tin về một route cụ thể, bao g"
              " ồm widget trang và các tham số tùy chọn."
              " Không Tự Động Tạo Lớp Route Riêng: auto_route không trực tiếp tạ"
              " o ra các lớp PageRouteInfo tùy chỉnh như BookListRoute trong v"
              " í dụ của bạn."),
      PostModel(
        author: "Author 4",
        urlAvatar: 'https://picsum.photos/250?image=11',
        content: 'Content 4',
        urlVideo:
            'https://res.cloudinary.com/dszkt92jr/video/upload/v1721473062/Screencast_from_18-07-2024_15_42_45_nxip2u.mp4',
      ),
    ];
    posts.addAll(postsExample);
    notifyListeners();
    // fetch post from api
  }

  Future<void> createPost(PostModel postModel) async {
    // create post from api
    await Future.delayed(const Duration(seconds: 1)); // delay 1s
    posts.insert(0, postModel);
    notifyListeners();
  }
}
