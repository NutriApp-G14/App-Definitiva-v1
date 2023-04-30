import 'package:flutter/material.dart';
import 'dart:math';

import 'package:my_app/model/NavBar.dart';

List<double> data = List.generate(10, (_) => Random().nextDouble() * 100);

class StatisticsPage extends StatefulWidget {
  final nombreUsuario;

  const StatisticsPage({required this.nombreUsuario});
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(52),
          child: NutriAppBar(nombreUsuario: widget.nombreUsuario),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: BarChart(
                data: data,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  final List<double> data;
  final Color color;

  BarChart({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BarChartPainter(data: data, color: color),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  BarChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / data.length;
    final maxValue = data.reduce(max);

    Paint paint = Paint()..color = color;

    for (var i = 0; i < data.length; i++) {
      final barHeight = data[i] / maxValue * size.height;
      final x = i * barWidth;
      final y = size.height - barHeight;
      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
