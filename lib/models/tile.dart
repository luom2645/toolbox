/// 游戏方块模型
class Tile {
  final int id;
  int value;
  int x;
  int y;
  bool isNew;
  bool isMerged;

  Tile({
    required this.id,
    required this.value,
    required this.x,
    required this.y,
    this.isNew = false,
    this.isMerged = false,
  });

  /// 获取方块对应的英雄等级
  int get heroLevel {
    if (value <= 2) return 1;
    return (value.log(2) - 1).floor();
  }

  /// 获取英雄名称
  String get heroName {
    const names = [
      '新手剑士',    // 2
      '见习骑士',    // 4
      '精英战士',    // 8
      '荣耀骑士',    // 16
      '钢铁领主',    // 32
      '传奇英雄',    // 64
      '史诗王者',    // 128
      '神话战神',    // 256
      '不朽天神',    // 512
      '创世神祇',    // 1024
      '数字之主',    // 2048
    ];
    final index = heroLevel - 1;
    if (index < 0 || index >= names.length) return '未知英雄';
    return names[index];
  }

  /// 获取方块颜色
  int get colorValue {
    if (value <= 4) return 0xFF4285F4;      // 蓝色
    if (value <= 16) return 0xFF34A853;     // 绿色
    if (value <= 64) return 0xFFEA4335;     // 红色
    if (value <= 256) return 0xFFFBBC05;    // 黄色
    if (value <= 1024) return 0xFF9C27B0;   // 紫色
    return 0xFFFF5722;                       // 橙色 (终极)
  }

  @override
  String toString() => 'Tile($value at [$x,$y])';
}
