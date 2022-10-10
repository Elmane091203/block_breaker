import 'dart:async';

import 'package:block_breaker/game/component/my_text_button.dart';
import 'package:block_breaker/game/component/paddle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

import '../constants/constants.dart';
import 'component/ball.dart';
import 'component/block.dart';
import 'component/countdown_text.dart';

class BlockBreaker extends FlameGame
    with HasCollisionDetection, HasDraggableComponents, HasTappableComponents {
  @override
  Future<void> onLoad() async {
    await addAll(
      [
        ScreenHitbox(),
        Paddle(),
        MyTextButton('Start'),
      ],
    );
    await resetBlocks();
  }

  Future<void> resetBall() async {
    for (var i = kCountdownDuration; i > 0; i--) {
      await add(
        CountdownText(
          count: i,
        ),
      );
      await Future<void>.delayed(const Duration(seconds: 1));
    }

    await add(Ball());
  }

  Future<void> resetBlocks() async {
    remainingBlocks = kBlocksColumnCount * kBlocksRowCount;
    final blocks = List<Block>.generate(remainingBlocks, (int index) {
      final indexX = index % kBlocksRowCount;
      final indexY = index ~/ kBlocksRowCount;

      final blockPosition = {
        kBlockPositionX: indexX,
        kBlockPositionY: indexY,
      };
      return Block(blockPosition: blockPosition);
    });

    await addAll(blocks);
  }

  int failedCount = kGameTryCount;

  int remainingBlocks = kBlocksColumnCount * kBlocksRowCount;

  Future<void> failed() async {
    failedCount--;
    if (failedCount == 0) {
      failedCount = kGameTryCount;
      await add(MyTextButton('Game Over', isGameOver: true));
    } else {
      await add(MyTextButton('Retry'));
    }
  }

  Future<void> hit() async {
    remainingBlocks--;
    if (remainingBlocks == 0) {
      await add(MyTextButton('Clear!', isCleared: true));
    }
  }
}
