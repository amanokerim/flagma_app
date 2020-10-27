import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageCarousel extends StatefulWidget {
  final images;

  ImageCarousel({this.images});
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  PageController _pageController;
  bool isZoomed = false;

  @override
  void initState() {
    _pageController = new PageController(initialPage: 0, viewportFraction: 1);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.images.length,
      itemBuilder: (context, index) => PhotoView(
        imageProvider: NetworkImage(
          widget.images[index]["img_url_large"],
        ),
      ),
    );
  }
}
