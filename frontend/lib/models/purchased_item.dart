class PurchasedItem {
  const PurchasedItem({
    required this.id,
    required this.trip,
    required this.pantryItem,
    required this.purchasePrice,
    required this.quantityBought,
    this.createdBy,
    this.updatedBy,
  });

  final int id;
  final int trip;
  final int pantryItem;
  final double purchasePrice;
  final double quantityBought;
  final int? createdBy;
  final int? updatedBy;
}
