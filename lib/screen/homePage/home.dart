import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/common_post.dart';
import 'package:untitled/model/post_model.dart';
import 'package:untitled/provider/user_info_provider.dart';
import 'package:untitled/screen/homePage/widgets/create_post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserInfoProvider>();
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSearchBar(user.urlAvatar),
          CommonPost(
            post: PostModel(
                author: "Mạc Bùi",
                urlAvatar:
                    'https://res.cloudinary.com/dszkt92jr/image/upload/v1721463934/fgcnetakyb8nibeqr9do.png',
                content: 'Content 1'),
          ),
          CommonPost(
            post: PostModel(
              author: "Author 2",
              urlAvatar: 'https://picsum.photos/250?image=10',
              content: 'Content 2',
              urlImages: [
                'https://res.cloudinary.com/dszkt92jr/image/upload/v1721463934/fgcnetakyb8nibeqr9do.png',
                'https://res.cloudinary.com/dszkt92jr/image/upload/v1719943637/vcbhui3dxeusphkgvycg.png',
              ],
            ),
          ),
          CommonPost(
            post: PostModel(
                author: "Author 3",
                urlAvatar: 'https://picsum.photos/250?image=11',
                content:
                    "Phân tích Code: Khi bạn chạy trình tạo code (auto_route),"
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
          ),
          CommonPost(
            post: PostModel(
              author: "Author 4",
              urlAvatar: 'https://picsum.photos/250?image=11',
              content: 'Content 4',
              urlVideo:
                  'https://res.cloudinary.com/dszkt92jr/video/upload/v1721473062/Screencast_from_18-07-2024_15_42_45_nxip2u.mp4',
            ),
          ),
        ],
      ),
    );
  }

  _buildSearchBar(String urlAvatar) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(urlAvatar),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                _showCreatePostDialog();
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                          FlutterI18n.translate(
                              context, "home.title_create_post"),
                          style: const TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          widthFactor: 1.1,
          child: CreatePostDialog(),
        );
      },
    );
  }
}
