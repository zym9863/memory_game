import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/card_item.dart';

enum GameDifficulty {
  easy,
  medium,
  hard,
}

class GameProvider extends ChangeNotifier {
  List<CardItem> _cards = [];
  List<CardItem> get cards => _cards;

  CardItem? _firstCard;
  CardItem? _secondCard;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  int _score = 0;
  int get score => _score;

  int _moves = 0;
  int get moves => _moves;

  int _remainingPairs = 0;
  int get remainingPairs => _remainingPairs;

  bool _isGameOver = false;
  bool get isGameOver => _isGameOver;

  late Timer _timer;
  int _elapsedSeconds = 0;
  int get elapsedSeconds => _elapsedSeconds;
  bool _isTimerRunning = false;

  GameDifficulty _difficulty = GameDifficulty.easy;
  GameDifficulty get difficulty => _difficulty;

  // Initialize the game with the given difficulty
  void initGame(GameDifficulty difficulty) {
    _difficulty = difficulty;
    _isGameOver = false;
    _score = 0;
    _moves = 0;
    _elapsedSeconds = 0;
    _isTimerRunning = false;
    _firstCard = null;
    _secondCard = null;
    _isProcessing = false;

    // Create pairs of cards based on difficulty
    int pairsCount;
    switch (difficulty) {
      case GameDifficulty.easy:
        pairsCount = 6; // 12 cards
        break;
      case GameDifficulty.medium:
        pairsCount = 8; // 16 cards
        break;
      case GameDifficulty.hard:
        pairsCount = 12; // 24 cards
        break;
    }

    _remainingPairs = pairsCount;

    // Create card pairs
    List<CardItem> newCards = [];
    for (int i = 0; i < pairsCount; i++) {
      // Using emoji as card values for simplicity
      String value = _getCardValue(i);
      
      // Add two cards with the same value (a pair)
      newCards.add(CardItem(id: i * 2, value: value));
      newCards.add(CardItem(id: i * 2 + 1, value: value));
    }

    // Shuffle the cards
    newCards.shuffle(Random());
    _cards = newCards;
    notifyListeners();
  }

  // Get a card value (emoji) based on index
  String _getCardValue(int index) {
    // List of emojis to use as card values
    List<String> emojis = [
      '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', 
      '🐻', '🐼', '🐨', '🐯', '🦁', '🐮',
      '🐷', '🐸', '🐵', '🐔', '🐧', '🐦',
      '🦆', '🦅', '🦉', '🦇', '🐺', '🐗',
    ];
    
    return emojis[index % emojis.length];
  }

  // Start the game timer
  void startTimer() {
    if (!_isTimerRunning) {
      _isTimerRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedSeconds++;
        notifyListeners();
      });
    }
  }

  // Stop the game timer
  void stopTimer() {
    if (_isTimerRunning) {
      _timer.cancel();
      _isTimerRunning = false;
    }
  }

  // Handle card tap
  void flipCard(int cardId) {
    // Don't allow flipping if we're processing a pair or game is over
    if (_isProcessing || _isGameOver) {
      return;
    }

    // Find the tapped card
    final cardIndex = _cards.indexWhere((card) => card.id == cardId);
    if (cardIndex == -1) return;

    final tappedCard = _cards[cardIndex];

    // Don't allow flipping already matched or flipped cards
    if (tappedCard.isMatched || tappedCard.isFlipped) {
      return;
    }

    // Start the timer on first card flip
    if (!_isTimerRunning) {
      startTimer();
    }

    // Flip the card
    _cards[cardIndex] = tappedCard.copyWith(isFlipped: true);

    // Check if this is the first or second card flipped
    if (_firstCard == null) {
      _firstCard = _cards[cardIndex];
    } else if (_secondCard == null && _firstCard!.id != cardId) {
      _secondCard = _cards[cardIndex];
      _moves++;
      _checkForMatch();
    }

    notifyListeners();
  }

  // Check if the two flipped cards match
  void _checkForMatch() {
    _isProcessing = true;

    // Delay to allow player to see the second card
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_firstCard != null && _secondCard != null) {
        if (_firstCard!.value == _secondCard!.value) {
          // Cards match
          final firstIndex = _cards.indexWhere((card) => card.id == _firstCard!.id);
          final secondIndex = _cards.indexWhere((card) => card.id == _secondCard!.id);

          _cards[firstIndex] = _cards[firstIndex].copyWith(isMatched: true);
          _cards[secondIndex] = _cards[secondIndex].copyWith(isMatched: true);

          _score += 10;
          _remainingPairs--;

          // Check if game is over
          if (_remainingPairs == 0) {
            _isGameOver = true;
            stopTimer();
          }
        } else {
          // Cards don't match, flip them back
          final firstIndex = _cards.indexWhere((card) => card.id == _firstCard!.id);
          final secondIndex = _cards.indexWhere((card) => card.id == _secondCard!.id);

          _cards[firstIndex] = _cards[firstIndex].copyWith(isFlipped: false);
          _cards[secondIndex] = _cards[secondIndex].copyWith(isFlipped: false);
        }

        // Reset selected cards
        _firstCard = null;
        _secondCard = null;
        _isProcessing = false;
        notifyListeners();
      }
    });
  }

  // Reset the game with the same difficulty
  void resetGame() {
    stopTimer();
    initGame(_difficulty);
  }

  @override
  void dispose() {
    if (_isTimerRunning) {
      _timer.cancel();
    }
    super.dispose();
  }
}
