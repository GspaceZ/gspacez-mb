import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/extensions/log.dart';
import 'package:untitled/provider/user_info_provider.dart';
import 'package:untitled/data/local/token_data_source.dart';
import 'package:untitled/service/user_service.dart';
import '../../components/dialog_loading.dart';
import '../../service/cloudinary_config.dart';

class UpdateAvatar extends StatefulWidget {
  const UpdateAvatar({super.key});

  @override
  State<UpdateAvatar> createState() => _UpdateAvatarState();
}

class _UpdateAvatarState extends State<UpdateAvatar> {
  String _uploadedImageUrl = '';
  final TokenDataSource _tokenDataSource = TokenDataSource.instance;
  late final UserInfoProvider _userInfoProvider;
  final _userService = UserService.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userInfoProvider = context.read<UserInfoProvider>();
  }

  Future<String> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      throw Exception('No image selected');
    }
    if (mounted) {
      LoadingDialog.showLoadingDialog(context);
    }

    try {
      final cloudinary = CloudinaryPublic(
        CloudinaryConfig.cloudName,
        CloudinaryConfig.uploadPreset,
        cache: false,
      );

      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(pickedFile.path,
            resourceType: CloudinaryResourceType.Image),
      );

      LoadingDialog.hideLoadingDialog();
      return response.secureUrl;
    } catch (e) {
      LoadingDialog.hideLoadingDialog();
      throw Exception('Failed to upload image: $e');
    }
  }

  void _chooseAvatar() async {
    try {
      final imageUrl = await pickAndUploadImage();
      setState(() {
        _uploadedImageUrl = imageUrl;
      });
    } catch (e) {
      // Handle error or show message to user
      Log.debug('Image upload failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFAAAAAA),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(140),
                ),
                child: CircleAvatar(
                  radius: 140,
                  backgroundColor: Colors.white54,
                  backgroundImage: _uploadedImageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(_uploadedImageUrl)
                      : null,
                  child: _uploadedImageUrl.isEmpty
                      ? TextButton(
                          onPressed: _chooseAvatar,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                const Color(0xFFE6F1FE)),
                          ),
                          child: Text(
                            FlutterI18n.translate(
                                context, "profile.avatar.choose_avatar"),
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                FlutterI18n.translate(context, "profile.avatar.content"),
                style: const TextStyle(color: Color(0xFF666666)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _submit,
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          FlutterI18n.translate(context, "profile.avatar.save"),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(width: 1.5, color: Colors.blue.shade400),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          FlutterI18n.translate(
                              context, "profile.avatar.cancel"),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final String? token = await _tokenDataSource.getToken();
    if (mounted) {
      LoadingDialog.showLoadingDialog(context);
    }

    try {
      final response =
          await _userService.updateAvatar(_uploadedImageUrl, token!);
      _userInfoProvider.setUrlAvatar(_uploadedImageUrl);
      if (response['code'] == 1000) {
        LoadingDialog.hideLoadingDialog();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(FlutterI18n.translate(
                  context, "profile.avatar.toast.success")),
            ),
          );
        }
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        LoadingDialog.hideLoadingDialog();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(FlutterI18n.translate(
                  context, "profile.avatar.toast.unknown")),
            ),
          );
        }
      }
    } catch (e) {
      LoadingDialog.hideLoadingDialog();
      Log.debug(e.toString());
    }
  }
}
