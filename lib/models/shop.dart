/// 商店系统
/// 英雄购买：价格 = 50 × 2^(星级 -1)

/// 商店物品类型
enum ShopItemType {
  hero,      // 英雄
  refresh,   // 刷新
  expand,    // 扩展场地
}

/// 商店物品
class ShopItem {
  final String id;
  final ShopItemType type;
  final String? heroId; // 英雄 ID (如果是英雄)
  final int star; // 星级
  final int price; // 金币价格
  final String? description;

  ShopItem({
    required this.id,
    required this.type,
    this.heroId,
    this.star = 1,
    required this.price,
    this.description,
  });

  /// 计算英雄价格
  static int calculateHeroPrice(int star) {
    // 价格公式：50 × 2^(星级 -1)
    return 50 * (1 << (star - 1));
    // 1 星=50, 2 星=100, 3 星=200, 4 星=400...
  }

  /// 创建英雄物品
  factory ShopItem.hero(String heroId, int star) {
    return ShopItem(
      id: 'hero_${heroId}_$star',
      type: ShopItemType.hero,
      heroId: heroId,
      star: star,
      price: calculateHeroPrice(star),
      description: '$star 星英雄',
    );
  }

  /// 创建刷新物品
  factory ShopItem.refresh(int price) {
    return ShopItem(
      id: 'refresh',
      type: ShopItemType.refresh,
      star: 1,
      price: price,
      description: '刷新商店',
    );
  }

  /// 从 JSON 创建
  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'] as String,
      type: ShopItemType.values[json['type'] as int],
      heroId: json['heroId'] as String?,
      star: json['star'] as int? ?? 1,
      price: json['price'] as int,
      description: json['description'] as String?,
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'heroId': heroId,
      'star': star,
      'price': price,
      'description': description,
    };
  }
}

/// 商店管理
class Shop {
  List<ShopItem> items = []; // 当前商品
  int refreshCount = 0; // 刷新次数
  int freeRefreshes = 3; // 每波免费刷新次数
  int refreshCost = 20; // 刷新价格

  /// 刷新商店
  void refresh(List<String> availableHeroes, {int maxStar = 3}) {
    items.clear();
    refreshCount++;

    // 生成随机英雄
    for (int i = 0; i < 3; i++) {
      if (availableHeroes.isEmpty) break;
      final heroId = availableHeroes[i % availableHeroes.length];
      final star = (i % maxStar) + 1;
      items.add(ShopItem.hero(heroId, star));
    }
  }

  /// 免费刷新
  bool canFreeRefresh() => freeRefreshes > 0;

  /// 执行免费刷新
  void useFreeRefresh() {
    if (freeRefreshes > 0) freeRefreshes--;
  }

  /// 付费刷新成本
  int get refreshPrice => refreshCost;

  /// 重置每波免费次数
  void resetPerWave() {
    freeRefreshes = 3;
    refreshCount = 0;
  }

  /// 购买物品
  ShopItem? purchase(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      return items.removeAt(index);
    }
    return null;
  }

  /// 重置商店
  void reset() {
    items.clear();
    refreshCount = 0;
    freeRefreshes = 3;
  }
}
