import 'dart:math';
import 'package:flutter/material.dart';

class CellBackground extends StatefulWidget {
  const CellBackground({super.key});

  @override
  State<CellBackground> createState() => _CellBackgroundState();
}

class _CellBackgroundState extends State<CellBackground>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  final List<_Cell> _cells = [];
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 18; i++) {
      _cells.add(
        _Cell(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: 35 + _random.nextDouble() * 55,
          speed: 0.00015 + _random.nextDouble() * 0.00025,
          direction: _random.nextDouble() * pi * 2,
          opacity: 0.12 + _random.nextDouble() * 0.18,
        ),
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAway(_Cell cell) {
    final angle = _random.nextDouble() * pi * 2;

    cell.targetX = (cell.x + cos(angle) * 0.18).clamp(0.02, 0.98);
    cell.targetY = (cell.y + sin(angle) * 0.18).clamp(0.02, 0.98);
    cell.isRunning = true;

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        cell.isRunning = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Container(
      color: const Color(0xFF052E16),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          for (final cell in _cells) {
            if (cell.isRunning) {
              cell.x += (cell.targetX - cell.x) * 0.08;
              cell.y += (cell.targetY - cell.y) * 0.08;
            } else {
              cell.x += cos(cell.direction) * cell.speed;
              cell.y += sin(cell.direction) * cell.speed;

              if (cell.x < -0.1) {
                cell.x = 1.1;
              } else if (cell.x > 1.1) {
                cell.x = -0.1;
              }

              if (cell.y < -0.1) {
                cell.y = 1.1;
              } else if (cell.y > 1.1) {
                cell.y = -0.1;
              }
            }
          }

          return Stack(
            children: [
              for (final cell in _cells)
                Positioned(
                  left: screenSize.width * cell.x,
                  top: screenSize.height * cell.y,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.basic,
                    onEnter: (_) => _runAway(cell),
                    child: _buildCell(cell),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildCell(_Cell cell) {
  return Container(
    width: cell.size,
    height: cell.size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: const Color(0xFF86EFAC).withValues(
        alpha: cell.opacity,
      ),
      border: Border.all(
        color: const Color(0xFFBBF7D0).withValues(
          alpha: cell.opacity + 0.1,
        ),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF22C55E).withValues(
            alpha: cell.opacity * 0.5,
          ),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Center(
      child: Container(
        width: cell.size * 0.35,
        height: cell.size * 0.35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF15803D).withValues(
            alpha: cell.opacity + 0.1,
          ),
        ),
      ),
    ),
  );
}

class _Cell {
  double x;
  double y;
  final double size;
  final double speed;
  final double direction;
  final double opacity;

  double targetX;
  double targetY;
  bool isRunning = false;

  _Cell({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.direction,
    required this.opacity,
  })  : targetX = x,
        targetY = y;
}
