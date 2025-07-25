import 'package:flutter/material.dart';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Graphing Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Graphing Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _functionController = TextEditingController();
  String _functionString = 'sin(x)';
  List<Offset> _graphPoints = [];

  double _minX = -10.0;
  double _maxX = 10.0;
  double _minY = -5.0;
  double _maxY = 5.0;
  double _scaleX = 20.0;
  double _scaleY = 20.0;

  @override
  void initState() {
    super.initState();
    _functionController.text = _functionString;
    _computeGraphPoints();
    _functionController.addListener(() {
      setState(() {
        _functionString = _functionController.text;
        _computeGraphPoints();
      });
    });
  }

  @override
  void dispose() {
    _functionController.dispose();
    super.dispose();
  }

  void _computeGraphPoints() {
    _graphPoints.clear();
    try {
      // Use math_expressions to parse and evaluate
      final parser = Parser();
      final exp = parser.parse(_functionString);
      final context = ContextModel();
      for (double x = _minX; x <= _maxX; x += 0.05) {
        context.bindVariable(Variable('x'), Number(x));
        final double y = exp.evaluate(EvaluationType.REAL, context);
        if (y.isFinite) {
          _graphPoints.add(Offset(x, y));
        }
      }
    } catch (e) {
      _graphPoints.clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _functionController,
              decoration: const InputDecoration(
                labelText: 'Enter function (e.g., sin(x) + x)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              onSubmitted: (value) {
                _computeGraphPoints();
              },
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  // Remove onPanUpdate, handle pan inside onScaleUpdate
                  onScaleUpdate: (details) {
                    setState(() {
                      // Zoom
                      _scaleX *= details.scale;
                      _scaleY *= details.scale;
                      _scaleX = _scaleX.clamp(5.0, 100.0);
                      _scaleY = _scaleY.clamp(5.0, 100.0);

                      // Pan
                      if (details.scale == 1.0) {
                        final double dx = details.focalPointDelta.dx / _scaleX;
                        final double dy = details.focalPointDelta.dy / _scaleY;
                        _minX -= dx;
                        _maxX -= dx;
                        _minY += dy;
                        _maxY += dy;
                      }

                      _computeGraphPoints();
                    });
                  },
                  child: CustomPaint(
                    painter: GraphPainter(
                      graphPoints: _graphPoints,
                      minX: _minX,
                      maxX: _maxX,
                      minY: _minY,
                      maxY: _maxY,
                      scaleX: _scaleX,
                      scaleY: _scaleY,
                      canvasWidth: constraints.maxWidth,
                      canvasHeight: constraints.maxHeight,
                    ),
                    child: Container(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<Offset> graphPoints;
  final double minX, maxX, minY, maxY;
  final double scaleX, scaleY;
  final double canvasWidth, canvasHeight;

  GraphPainter({
    required this.graphPoints,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.scaleX,
    required this.scaleY,
    required this.canvasWidth,
    required this.canvasHeight,
  });

  Offset _toScreenCoordinates(Offset point) {
    final double originX = -minX * scaleX;
    final double originY = maxY * scaleY;
    final double screenX = originX + point.dx * scaleX;
    final double screenY = originY - point.dy * scaleY;
    return Offset(screenX, screenY);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint axisPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2.0;

    final Paint gridPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 0.5;

    final Paint graphPaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Offset origin = _toScreenCoordinates(Offset.zero);

    // Draw X-axis
    canvas.drawLine(
      Offset(0, origin.dy),
      Offset(size.width, origin.dy),
      axisPaint,
    );
    // Draw Y-axis
    canvas.drawLine(
      Offset(origin.dx, 0),
      Offset(origin.dx, size.height),
      axisPaint,
    );

    // Draw grid lines
    for (double x = 0; x <= maxX; x += 1.0) {
      if (x != 0) {
        canvas.drawLine(
          _toScreenCoordinates(Offset(x, minY)),
          _toScreenCoordinates(Offset(x, maxY)),
          gridPaint,
        );
        canvas.drawLine(
          _toScreenCoordinates(Offset(-x, minY)),
          _toScreenCoordinates(Offset(-x, maxY)),
          gridPaint,
        );
      }
    }
    for (double y = 0; y <= maxY; y += 1.0) {
      if (y != 0) {
        canvas.drawLine(
          _toScreenCoordinates(Offset(minX, y)),
          _toScreenCoordinates(Offset(maxX, y)),
          gridPaint,
        );
        canvas.drawLine(
          _toScreenCoordinates(Offset(minX, -y)),
          _toScreenCoordinates(Offset(maxX, -y)),
          gridPaint,
        );
      }
    }

    final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (double x = minX.roundToDouble(); x <= maxX.roundToDouble(); x += 1.0) {
      if (x != 0) {
        textPainter.text = TextSpan(
          text: x.toInt().toString(),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        );
        textPainter.layout();
        final Offset screenCoord = _toScreenCoordinates(Offset(x, 0));
        textPainter.paint(
          canvas,
          Offset(screenCoord.dx - textPainter.width / 2, origin.dy + 5),
        );
      }
    }
    for (double y = minY.roundToDouble(); y <= maxY.roundToDouble(); y += 1.0) {
      if (y != 0) {
        textPainter.text = TextSpan(
          text: y.toInt().toString(),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        );
        textPainter.layout();
        final Offset screenCoord = _toScreenCoordinates(Offset(0, y));
        textPainter.paint(
          canvas,
          Offset(origin.dx + 5, screenCoord.dy - textPainter.height / 2),
        );
      }
    }

    if (graphPoints.isNotEmpty) {
      final List<Offset> screenGraphPoints = graphPoints
          .map((point) => _toScreenCoordinates(point))
          .toList();

      final Path path = Path();
      if (screenGraphPoints.isNotEmpty) {
        path.moveTo(screenGraphPoints.first.dx, screenGraphPoints.first.dy);
        for (int i = 1; i < screenGraphPoints.length; i++) {
          path.lineTo(screenGraphPoints[i].dx, screenGraphPoints[i].dy);
        }
      }
      canvas.drawPath(path, graphPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is GraphPainter) {
      return oldDelegate.graphPoints != graphPoints ||
          oldDelegate.minX != minX ||
          oldDelegate.maxX != maxX ||
          oldDelegate.minY != minY ||
          oldDelegate.maxY != maxY ||
          oldDelegate.scaleX != scaleX ||
          oldDelegate.scaleY != scaleY;
    }
    return true;
  }
}
