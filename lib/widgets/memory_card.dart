import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers
import '../constants/theme_constants.dart';
import '../models/card_item.dart';

class MemoryCard extends StatefulWidget {
  final CardItem card;
  final Function(int) onCardTap;
  final double size;

  const MemoryCard({
    super.key,
    required this.card,
    required this.onCardTap,
    this.size = 80.0,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFrontVisible = false;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Create AudioPlayer instance

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: pi / 2,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: pi / 2,
          end: pi,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  @override
  void didUpdateWidget(MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.isFlipped != oldWidget.card.isFlipped) {
      _isFrontVisible = widget.card.isFlipped;
      if (widget.card.isFlipped) {
        _controller.forward();
        _playFlipSound(); // Play sound when card is flipped
      } else {
        _controller.reverse();
      }
    }
  }

  void _playFlipSound() async {
    await _audioPlayer.play(
      AssetSource('card_flip.mp3'),
    ); // Play sound from assets
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose(); // Dispose AudioPlayer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onCardTap(widget.card.id);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final transform =
              Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(_animation.value);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child:
                _isFrontVisible && _animation.value >= pi / 2
                    ? _buildFrontCard()
                    : _buildBackCard(),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color:
            widget.card.isMatched
                ? ThemeConstants.cardMatchedColor.withAlpha(75)
                : ThemeConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color:
              widget.card.isMatched
                  ? ThemeConstants.cardMatchedColor
                  : Colors.grey.shade300,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.card.value,
          style: TextStyle(
            fontSize: widget.size * 0.5,
            color:
                widget.card.isMatched
                    ? ThemeConstants.cardMatchedColor
                    : ThemeConstants.textPrimaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.identity()..rotateY(pi),
      alignment: Alignment.center,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeConstants.primaryColor,
              ThemeConstants.primaryDarkColor,
            ],
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 6.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Card pattern
            Positioned.fill(child: CustomPaint(painter: CardPatternPainter())),
            // Question mark icon
            Center(
              child: Icon(
                Icons.question_mark_rounded,
                color: ThemeConstants.textOnPrimaryColor,
                size: widget.size * 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for card back pattern
class CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withAlpha(30)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    // Draw a grid pattern
    final spacing = size.width / 5;

    // Horizontal lines
    for (var i = 1; i < 5; i++) {
      canvas.drawLine(
        Offset(0, i * spacing),
        Offset(size.width, i * spacing),
        paint,
      );
    }

    // Vertical lines
    for (var i = 1; i < 5; i++) {
      canvas.drawLine(
        Offset(i * spacing, 0),
        Offset(i * spacing, size.height),
        paint,
      );
    }

    // Draw diagonal lines
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);

    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
