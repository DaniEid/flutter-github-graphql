import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UIComponents {
  static Widget buildImage(String imageUrl) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 24,
        ),
      ),
    );
  }
}
