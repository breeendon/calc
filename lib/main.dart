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
      title: 'Graphing Calculator',
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
  String _functionString = 'sin(x)'; // Default function
  List<Offset> _graphPoints = [];

  // Initial viewable range for the graph
  double _minX = -10.0;
  double _maxX = 10.0;
  double _minY = -10.0;
  double _maxY = 10.0;

  // Variables to store the start point of a pan gesture
  double _panStartX = 0.0;
  double _panStartY = 0.0;

  @override
  void initState() {
    super.initState();
    _functionController.text =
        _functionString; // Set initial text in the input field
    _computeGraphPoints(); // Compute initial graph points
    // Listen for changes in the text field to update the graph dynamically
    _functionController.addListener(() {
      setState(() {
        _functionString = _functionController.text;
        _computeGraphPoints();
      });
    });
  }

  @override
  void dispose() {
    _functionController
        .dispose(); // Clean up the controller when the widget is removed
    super.dispose();
  }

  // Function to compute the points for the graph based on the current function string
  void _computeGraphPoints() {
    _graphPoints.clear(); // Clear existing points
    try {
      final parser = Parser();
      final exp = parser.parse(
        _functionString,
      ); // Parse the mathematical expression
      final context = ContextModel();

      // Determine a reasonable step size for plotting based on the current X-range
      // This ensures a good density of points regardless of zoom level
      final double step =
          (_maxX - _minX) /
          500.0; // Aim for approximately 500 points across the visible X range

      // Iterate through the X-range and evaluate the function for Y values
      for (double x = _minX; x <= _maxX; x += step) {
        context.bindVariable(Variable('x'), Number(x)); // Bind 'x' variable
        final double y = exp.evaluate(
          EvaluationType.REAL,
          context,
        ); // Evaluate the expression

        // Add the point only if Y is a finite number (prevents issues with division by zero, log of negatives, etc.)
        if (y.isFinite) {
          _graphPoints.add(Offset(x, y));
        }
      }
    } catch (e) {
      _graphPoints
          .clear(); // Clear points if there's an error in parsing or evaluating
      // In a production app, you might want to display an error message to the user
      print("Error parsing function: $e"); // Log the error for debugging
    }
    setState(() {}); // Trigger a rebuild to draw the updated graph
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
            padding: const EdgeInsets.all(
              16.0,
            ), // Padding around the text field
            child: TextField(
              controller: _functionController,
              decoration: const InputDecoration(
                labelText: 'Enter function (e.g., sin(x) + x, x^2, 1/x)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text, // Keyboard type for text input
              onSubmitted: (value) {
                // Recompute points when the user submits (e.g., presses enter)
                _computeGraphPoints();
              },
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // GestureDetector for handling pan and zoom gestures on the graph area
                return GestureDetector(
                  onScaleStart: (details) {
                    // Record the starting point of the pan gesture
                    _panStartX = details.focalPoint.dx;
                    _panStartY = details.focalPoint.dy;
                  },
                  onScaleUpdate: (details) {
                    setState(() {
                      // Calculate the current "units per pixel" for both axes
                      final double unitsPerPixelX =
                          (_maxX - _minX) / constraints.maxWidth;
                      final double unitsPerPixelY =
                          (_maxY - _minY) / constraints.maxHeight;

                      // Pan: If no zoom is applied (scale is approximately 1.0)
                      if (details.scale == 1.0) {
                        // Calculate the change in graph coordinates based on pixel movement
                        final double dx =
                            (details.focalPoint.dx - _panStartX) *
                            unitsPerPixelX;
                        final double dy =
                            (details.focalPoint.dy - _panStartY) *
                            unitsPerPixelY;

                        // Update min/max bounds for panning
                        _minX -= dx;
                        _maxX -= dx;
                        _minY +=
                            dy; // Invert dy because screen Y increases downwards, but graph Y increases upwards
                        _maxY += dy;

                        // Update pan start points for the next update event
                        _panStartX = details.focalPoint.dx;
                        _panStartY = details.focalPoint.dy;
                      } else {
                        // Zoom: Adjust the visible range based on the scale factor
                        // This logic attempts to center the zoom around the user's focal point.

                        // Get the point in graph coordinates where the user is pinching
                        final double focalPointGraphX =
                            _minX + details.localFocalPoint.dx * unitsPerPixelX;
                        final double focalPointGraphY =
                            _maxY -
                            details.localFocalPoint.dy *
                                unitsPerPixelY; // Screen Y is inverted

                        // Calculate new range based on zoom
                        final double newRangeX =
                            (_maxX - _minX) / details.scale;
                        final double newRangeY =
                            (_maxY - _minY) / details.scale;

                        // Calculate new min/max values to achieve zoom centered at focal point
                        _minX =
                            focalPointGraphX -
                            (details.localFocalPoint.dx /
                                    constraints.maxWidth) *
                                newRangeX;
                        _maxX = _minX + newRangeX;
                        _maxY =
                            focalPointGraphY +
                            (details.localFocalPoint.dy /
                                    constraints.maxHeight) *
                                newRangeY;
                        _minY = _maxY - newRangeY;
                      }

                      _computeGraphPoints(); // Recompute graph points after pan/zoom
                    });
                  },
                  child: CustomPaint(
                    painter: GraphPainter(
                      graphPoints: _graphPoints,
                      minX: _minX,
                      maxX: _maxX,
                      minY: _minY,
                      maxY: _maxY,
                      canvasWidth: constraints.maxWidth,
                      canvasHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      // Background color for the graph area
                    ),
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
  final double canvasWidth, canvasHeight;

  GraphPainter({
    required this.graphPoints,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.canvasWidth,
    required this.canvasHeight,
  });

  // Helper function to convert mathematical graph coordinates to screen (pixel) coordinates
  Offset _toScreenCoordinates(Offset point) {
    final double rangeX = maxX - minX;
    final double rangeY = maxY - minY;

    // Calculate screen X: (point.dx - minX) gives position relative to minX, then scale to canvas width
    final double screenX = (point.dx - minX) / rangeX * canvasWidth;
    // Calculate screen Y: (point.dy - minY) gives position relative to minY.
    // We subtract from canvasHeight because screen Y increases downwards, while graph Y increases upwards.
    final double screenY =
        canvasHeight - ((point.dy - minY) / rangeY * canvasHeight);

    return Offset(screenX, screenY);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for drawing axes
    final Paint axisPaint = Paint()
      ..color = Colors
          .white // White color for axes
      ..strokeWidth = 2.0; // Thicker axes

    // Paint for drawing grid lines
    final Paint gridPaint = Paint()
      ..color = Colors.grey
          .withOpacity(0.3) // Slightly visible grey grid lines
      ..strokeWidth = 0.5; // Thin grid lines

    // Paint for drawing the function graph
    final Paint graphPaint = Paint()
      ..color = Colors
          .blueAccent // Bright blue for the graph line
      ..strokeWidth =
          2.5 // Slightly thicker graph line
      ..style = PaintingStyle
          .stroke // Draw only the outline
      ..isAntiAlias = true; // Smooth the graph line

    // TextPainter for rendering axis labels
    final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Calculate the screen coordinates of the origin (0,0)
    final Offset originScreen = _toScreenCoordinates(Offset.zero);

    // Function to determine an appropriate step size for grid lines and labels
    // This makes the grid dynamic, showing fewer lines when zoomed out and more when zoomed in.
    double _getGridStep(double range, double canvasDimension) {
      double idealNumSteps = 10.0; // Target around 10 major grid lines/labels
      double step = range / idealNumSteps;

      // Choose a "nice" rounded number for the step
      // This ensures grid lines fall on intuitive values (e.g., 1, 2, 5, 10, 0.5, 0.1)
      final List<double> niceSteps = [
        0.001,
        0.002,
        0.005,
        0.01,
        0.02,
        0.05,
        0.1,
        0.2,
        0.5,
        1.0,
        2.0,
        5.0,
        10.0,
        20.0,
        50.0,
        100.0,
        200.0,
        500.0,
        1000.0,
      ];
      for (double ns in niceSteps) {
        if (step <= ns) {
          return ns;
        }
      }
      return step; // Fallback if no nice step is found
    }

    final double gridStepX = _getGridStep(maxX - minX, canvasWidth);
    final double gridStepY = _getGridStep(maxY - minY, canvasHeight);

    // --- Draw Grid Lines ---

    // Vertical grid lines
    // Start from the first multiple of gridStepX that is greater than or equal to minX
    for (
      double x = (minX / gridStepX).ceil() * gridStepX;
      x <= maxX;
      x += gridStepX
    ) {
      if (x.abs() < gridStepX / 2)
        continue; // Skip if too close to the main Y-axis (effectively x=0)
      final Offset screenCoord1 = _toScreenCoordinates(Offset(x, minY));
      final Offset screenCoord2 = _toScreenCoordinates(Offset(x, maxY));
      canvas.drawLine(screenCoord1, screenCoord2, gridPaint);
    }

    // Horizontal grid lines
    // Start from the first multiple of gridStepY that is greater than or equal to minY
    for (
      double y = (minY / gridStepY).ceil() * gridStepY;
      y <= maxY;
      y += gridStepY
    ) {
      if (y.abs() < gridStepY / 2)
        continue; // Skip if too close to the main X-axis (effectively y=0)
      final Offset screenCoord1 = _toScreenCoordinates(Offset(minX, y));
      final Offset screenCoord2 = _toScreenCoordinates(Offset(maxX, y));
      canvas.drawLine(screenCoord1, screenCoord2, gridPaint);
    }

    // --- Draw Axes ---

    // Draw X-axis
    canvas.drawLine(
      Offset(0, originScreen.dy),
      Offset(size.width, originScreen.dy),
      axisPaint,
    );
    // Draw Y-axis
    canvas.drawLine(
      Offset(originScreen.dx, 0),
      Offset(originScreen.dx, size.height),
      axisPaint,
    );

    // --- Draw Axis Labels ---

    final TextStyle labelStyle = const TextStyle(
      color: Colors.white70,
      fontSize: 12,
    );
    final Paint labelBgPaint = Paint()
      ..color = Colors.black.withOpacity(
        0.5,
      ); // Semi-transparent background for labels

    // X-axis labels
    for (
      double x = (minX / gridStepX).ceil() * gridStepX;
      x <= maxX;
      x += gridStepX
    ) {
      // Only draw labels if they are not too close to zero to avoid overlap with Y-axis label
      if (x.abs() < gridStepX / 2 &&
          (originScreen.dx >= 0 && originScreen.dx <= size.width))
        continue;

      String labelText = x.toStringAsFixed(
        x.abs() < 1 && x != 0
            ? _getDecimalPlaces(gridStepX)
            : (gridStepX >= 1 ? 0 : _getDecimalPlaces(gridStepX)),
      );
      if (x == 0 &&
          (originScreen.dx >= 0 && originScreen.dx <= size.width) &&
          (originScreen.dy >= 0 && originScreen.dy <= size.height)) {
        labelText = '0'; // Special label for the origin
      }

      textPainter.text = TextSpan(text: labelText, style: labelStyle);
      textPainter.layout();
      final Offset screenCoord = _toScreenCoordinates(Offset(x, 0));

      // Adjust label Y position to be slightly below X-axis, or above if X-axis is near bottom
      double labelY = originScreen.dy + 5;
      if (originScreen.dy > size.height - 20)
        labelY =
            originScreen.dy - textPainter.height - 5; // If axis is at bottom
      else if (originScreen.dy < 20)
        labelY = originScreen.dy + 5; // If axis is at top

      // Draw background rectangle for label
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            screenCoord.dx - textPainter.width / 2 - 2,
            labelY - 2,
            textPainter.width + 4,
            textPainter.height + 4,
          ),
          const Radius.circular(
            3,
          ), // Slightly rounded corners for label background
        ),
        labelBgPaint,
      );
      // Draw the text label
      textPainter.paint(
        canvas,
        Offset(screenCoord.dx - textPainter.width / 2, labelY),
      );
    }

    // Y-axis labels
    for (
      double y = (minY / gridStepY).ceil() * gridStepY;
      y <= maxY;
      y += gridStepY
    ) {
      // Only draw labels if they are not too close to zero to avoid overlap with X-axis label
      if (y.abs() < gridStepY / 2 &&
          (originScreen.dx >= 0 && originScreen.dx <= size.width))
        continue;

      String labelText = y.toStringAsFixed(
        y.abs() < 1 && y != 0
            ? _getDecimalPlaces(gridStepY)
            : (gridStepY >= 1 ? 0 : _getDecimalPlaces(gridStepY)),
      );
      if (y == 0 &&
          (originScreen.dx >= 0 && originScreen.dx <= size.width) &&
          (originScreen.dy >= 0 && originScreen.dy <= size.height)) {
        continue; // '0' is handled by X-axis label
      }

      textPainter.text = TextSpan(text: labelText, style: labelStyle);
      textPainter.layout();
      final Offset screenCoord = _toScreenCoordinates(Offset(0, y));

      // Adjust label X position to be slightly right of Y-axis, or left if Y-axis is near right edge
      double labelX = originScreen.dx + 5;
      if (originScreen.dx > size.width - 20)
        labelX = originScreen.dx - textPainter.width - 5; // If axis is at right
      else if (originScreen.dx < 20)
        labelX = originScreen.dx + 5; // If axis is at left

      // Draw background rectangle for label
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            labelX - 2,
            screenCoord.dy - textPainter.height / 2 - 2,
            textPainter.width + 4,
            textPainter.height + 4,
          ),
          const Radius.circular(3),
        ),
        labelBgPaint,
      );
      // Draw the text label
      textPainter.paint(
        canvas,
        Offset(labelX, screenCoord.dy - textPainter.height / 2),
      );
    }

    // --- Draw the Graph Function ---
    if (graphPoints.isNotEmpty) {
      final Path path = Path();
      // Move to the first point of the graph
      path.moveTo(
        _toScreenCoordinates(graphPoints.first).dx,
        _toScreenCoordinates(graphPoints.first).dy,
      );

      // Iterate through the rest of the points, drawing lines
      for (int i = 1; i < graphPoints.length; i++) {
        final Offset p1Screen = _toScreenCoordinates(graphPoints[i - 1]);
        final Offset p2Screen = _toScreenCoordinates(graphPoints[i]);

        // Check for large jumps (potential discontinuities like asymptotes)
        // If the jump is too large, lift the pen and start a new segment
        // This prevents drawing a vertical line across an asymptote.
        if ((p2Screen.dy - p1Screen.dy).abs() >
                size.height * 0.8 || // Large vertical jump
            (p2Screen.dx - p1Screen.dx).abs() > size.width * 0.8) {
          // Large horizontal jump (e.g., due to extreme value)
          path.moveTo(p2Screen.dx, p2Screen.dy);
        } else {
          path.lineTo(p2Screen.dx, p2Screen.dy);
        }
      }
      canvas.drawPath(path, graphPaint); // Draw the entire path
    }
  }

  // Helper function to determine the number of decimal places for labels
  int _getDecimalPlaces(double step) {
    if (step >= 1) return 0; // No decimal places for steps 1 or greater
    if (step >= 0.1) return 1;
    if (step >= 0.01) return 2;
    if (step >= 0.001) return 3;
    return 4; // Default for very small steps
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Repaint only if the graph points or view parameters have changed
    if (oldDelegate is GraphPainter) {
      return oldDelegate.graphPoints != graphPoints ||
          oldDelegate.minX != minX ||
          oldDelegate.maxX != maxX ||
          oldDelegate.minY != minY ||
          oldDelegate.maxY != maxY ||
          oldDelegate.canvasWidth != canvasWidth ||
          oldDelegate.canvasHeight != canvasHeight;
    }
    return true; // Repaint if the delegate type changes
  }
}
