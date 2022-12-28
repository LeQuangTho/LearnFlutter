import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket_booking/widgets/map_select_seats.dart';
import 'package:sizer/sizer.dart';
import 'package:vector_math/vector_math_64.dart' as v;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TransformationController controller = TransformationController();
  Matrix4 matrix4 = Matrix4.identity();
  Animation<Matrix4>? _animationReset;
  late final AnimationController _controllerReset;
  bool ignore = false;

  void _onAnimateReset() {
    controller.value = _animationReset!.value;
    if (!_controllerReset.isAnimating) {
      _animationReset!.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize(DragDownDetails details) {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
            begin: controller.value,
            end: Matrix4.identity()
              ..setRow(
                  0,
                  v.Vector4(controller.value.getMaxScaleOnAxis(), 0, 0,
                      -details.localPosition.dx))
              ..setRow(
                  1,
                  v.Vector4(0, controller.value.getMaxScaleOnAxis(), 0,
                      -details.localPosition.dy)))
        .animate(_controllerReset);
    _animationReset!.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

// Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      matrix4 = controller.value.clone();
      setState(() {});
    });

    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar();
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              constrained: false,
              maxScale: 4,
              transformationController: controller,
              child: SizedBox(
                width: 100.w,
                height: 100.h - appBar.preferredSize.height,
                child: Column(
                  children: [
                    const Spacer(),
                    Image.asset(
                      'assets/images/screen.png',
                      width: 80.w,
                    ),
                    const MapSelectSeats(),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Transform.scale(
              scale: 0.2,
              alignment: Alignment.topLeft,
              child: AbsorbPointer(
                absorbing: ignore,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (details) {
                    _animateResetInitialize(details);
                  },
                  onPanUpdate: (details) {
                    controller.value = controller.value.clone()
                      ..translate(
                        -details.delta.dx,
                        -details.delta.dy,
                      );
                  },
                  onPanEnd: (details) {},
                  child: Stack(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.h - appBar.preferredSize.height,
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                        ),
                        child: Column(
                          children: [
                            const Spacer(),
                            Image.asset(
                              'assets/images/screen.png',
                              width: 80.w,
                            ),
                            const MapSelectSeats(),
                            const Spacer(flex: 2),
                          ],
                        ),
                      ),
                      Transform(
                        transform: matrix4..invert(),
                        child: Container(
                          width: 100.w,
                          height: 100.h - appBar.preferredSize.height,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.yellow,
                              width: 10 * controller.value.getMaxScaleOnAxis(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
