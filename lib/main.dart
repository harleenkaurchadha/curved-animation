import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

//Size pathSize ;
var screenSize;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SampleAnimation(),
    );
  }
}
class SampleAnimation extends StatefulWidget{

  SampleAnimation();

  @override
  State<StatefulWidget> createState() {
    return SampleAnimationState();
  }
}

class SampleAnimationState extends State<SampleAnimation> with SingleTickerProviderStateMixin {
  var _loadedInitData = false;
  AnimationController _controller;
  Animation _animation;
  Path _path;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 2000));
    super.initState();
    _animation = Tween(begin: 0.32,end: 0.44).animate(_controller)
      ..addListener((){
        setState(() {
        });
      });
    _controller.forward();
    _path  = drawPath();

  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(!_loadedInitData) {
       screenSize = MediaQuery.of(context).size;
       _loadedInitData = true;
    }
    }



  @override
  Widget build(BuildContext context) {
    var h = screenSize.height * 0.4;
    var w = screenSize.width;
    return Scaffold(
      body: Column(
        children: [
          Stack(
          children: <Widget>[

            Container(
           height: h + 40,
           width: w,
        ),
          ClipPath(
                  clipper: CurveClipper(),
            child: Stack(
              children : [
            Container(
            decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.bottomCenter,
              image: AssetImage('assets/images/like_img.png'),
              fit: BoxFit.cover,
            ),
          ),
        height: h,
    ),
            Positioned(
              top: calculate(_animation.value).dy,
              left: calculate(_animation.value).dx,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed('/');
                    },
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    elevation: 8,
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(Icons.clear,
                        color: Color(0xff808080),
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),

            ),
          ],
        ),
          ),
        ],
        ),
    ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path drawPath(){
    CurveClipper clipper = CurveClipper();
    Size size = Size(350, 200);
    Path path = clipper.getClip(size);
 //   Path path = Path();
    path.moveTo(size.width / 2 , size.height);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height / 2);
    return path;
  }


  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }

}

class CurveClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);
 //   pathSize = Size.copy(size);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  // Offset calculate(value) {
  //   PathMetrics pathMetrics = _path.computeMetrics();
  //   PathMetric pathMetric = pathMetrics.elementAt(0);
  //   value = pathMetric.length * value;
  //   Tangent pos = pathMetric.getTangentForOffset(value);
  //   return pos.position;
  // }


  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


// class PathPainter extends CustomPainter {
//
//   Path path;
//
//   PathPainter(this.path);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.redAccent.withOpacity(0.3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.0;
//
//     canvas.drawPath(this.path, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }
