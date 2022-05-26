import 'package:flutter/material.dart';
import 'dart:io';

class ImageDisplay extends StatelessWidget {
  final double _width;
  final double _height;
  final File? _imageFile;
  final VoidCallback _onClose;
  final bool _enableCloseButton;

  const ImageDisplay({
    double? width,
    double? height,
    File? imageFile,
    required VoidCallback onClose,
    enableCloseButton = true,
    Key? key,
  })  : _width = width ?? 0,
        _height = height ?? 0,
        _imageFile = imageFile,
        _enableCloseButton = enableCloseButton,
        _onClose = onClose,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double multiplier = 1;
    if (_imageFile == null) {
      multiplier = 0.8;
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: _width * multiplier,
            height: _height * multiplier,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            alignment: AlignmentDirectional.center,
            child: _imageFile != null
                ? Image.file(_imageFile!)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.grey.shade600,
                        size: 36,
                      ),
                      Text(
                        'Take photo',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        (_imageFile != null && _enableCloseButton)
            ? Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _onClose,
                    padding: EdgeInsets.zero,
                    splashRadius: 13,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
