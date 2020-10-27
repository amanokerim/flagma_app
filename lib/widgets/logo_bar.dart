import 'package:flagma_app/screens/image_carousel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../const.dart';

class LogoBar extends StatelessWidget {
  final String logo, image;
  final images;

  const LogoBar({
    Key key,
    this.logo = "",
    this.image = "-",
    this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: image != null && image.isNotEmpty && image != "undefined"
              ? () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) => ImageCarousel(images: images)));
                }
              : null,
          child: ClipPath(
            clipper: MyClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * .45,
              width: double.infinity,
              decoration: BoxDecoration(
                image: image == "undefined" || image.isEmpty
                    ? DecorationImage(
                        image: AssetImage("assets/images/1.jpg"),
                        fit: BoxFit.cover,
                      )
                    : image != "-"
                        ? DecorationImage(
                            image: NetworkImage("$image"),
                            fit: BoxFit.cover,
                          )
                        : null,
                gradient: image == "-"
                    ? LinearGradient(
                        colors: [
                          myPrimaryColor,
                          myPrimaryColor.withOpacity(.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0, bottom: 70),
                    child: Text(
                      logo,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * .45 - 40),
            ClipPath(
              clipper: MyClipper2(),
              child: Container(
                height: 40.0,
                width: double.infinity,
                color: Colors.white60,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 50);
    path.lineTo(100, size.height - 50);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MyClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 30);
    path.lineTo(60, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 30);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
