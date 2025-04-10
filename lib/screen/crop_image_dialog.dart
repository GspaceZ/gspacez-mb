import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:untitled/service/cloudinary_service.dart';
import 'package:untitled/utils/style.dart';

class CropImageDialog extends StatefulWidget {
  final Function(String) voidCallback;
  const CropImageDialog({super.key, required this.voidCallback});

  @override
  State<CropImageDialog> createState() => _CropSimplePageState();
}

class _CropSimplePageState extends State<CropImageDialog> {
  final _cropController = CropController();
  Uint8List? _imageData;
  Uint8List? _croppedData;
  bool _isCropping = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = imageBytes;
        _croppedData = null;
      });
    }
  }

  Future<String> _saveCroppedImage(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'cropped_image_${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = path.join(directory.path, fileName);

    final file = File(filePath);
    await file.writeAsBytes(bytes);
    final res = await CloudinaryService.instance.uploadImage(filePath);

    return res;
  }

  Future<void> _onCrop(CropResult result) async {
    switch (result) {
      case CropSuccess(:final croppedImage):
        _croppedData = croppedImage;
        final filePath = await _saveCroppedImage(croppedImage);
        widget.voidCallback(filePath);
        if (mounted) {
          Navigator.of(context).pop();
        }
      case CropFailure(:final cause):
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to crop image: $cause'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
    }
    setState(() => _isCropping = false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      title: const Text('Upload Avatar',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        child: _imageData == null
            ? Center(
                child: TextButton(
                  onPressed: _pickImage,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: Colors.blue,
                        size: 30,
                      ),
                      Text(
                        'Pick an image',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              )
            : _isCropping
                ? const Center(child: CircularProgressIndicator())
                : _croppedData != null
                    ? Center(child: Image.memory(_croppedData!))
                    : Column(
                        children: [
                          Expanded(
                            child: Crop(
                              controller: _cropController,
                              image: _imageData!,
                              onCropped: _onCrop,
                              fixCropRect: true,
                              interactive: true,
                              willUpdateScale: (scale) => scale < 5,
                              initialRectBuilder:
                                  InitialRectBuilder.withBuilder(
                                (viewport, imageRect) {
                                  return Rect.fromLTRB(
                                    viewport.left + 24,
                                    viewport.top + 24,
                                    viewport.right - 24,
                                    viewport.bottom - 24,
                                  );
                                },
                              ),
                              overlayBuilder: (overlayRect, imageRect) {
                                return CustomPaint(
                                  painter: GridPainter(),
                                  child: Container(
                                    color: withOpacityCompat(Colors.black, 0.0),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: _pickImage,
                                  child: const Text('Choose Another Image'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.blue),
                                    foregroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isCropping = true;
                                    });
                                    _cropController.crop();
                                  },
                                  child: const Text('Save Image'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final divisions = 2;
  final strokeWidth = 1.0;
  final Color color = Colors.black54;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = color;

    final spacing = size / (divisions + 1);
    for (var i = 1; i < divisions + 1; i++) {
      // draw vertical line
      canvas.drawLine(
        Offset(spacing.width * i, 0),
        Offset(spacing.width * i, size.height),
        paint,
      );

      // draw horizontal line
      canvas.drawLine(
        Offset(0, spacing.height * i),
        Offset(size.width, spacing.height * i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}
