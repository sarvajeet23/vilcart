class ProductModel {
  bool? status;
  String? message;
  int? noOfPages;
  List<Product>? result;

  ProductModel({this.status, this.message, this.noOfPages, this.result});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    status: json["status"],
    message: json["message"],
    noOfPages: json["noOfPages"],
    result:
        json["result"] == null
            ? []
            : List<Product>.from(json["result"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "noOfPages": noOfPages,
    "result":
        result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Product {
  int? productId;
  String? productName;
  String? skuUpcEan;
  int? openingStock;
  int? goodOpeningStock;
  int? damagedOpeningStock;
  int? inward;
  int? goodInward;
  int? damagedInward;
  int? outward;
  int? goodOutward;
  int? damagedOutward;
  int? closing;
  int? goodClosing;
  int? damagedClosing;
  int? primaryClosing;
  int? totalQty;
  int? totalGoodQty;
  int? totalDamagedQty;
  int? actualQty;

  Product({
    this.productId,
    this.productName,
    this.skuUpcEan,
    this.openingStock,
    this.goodOpeningStock,
    this.damagedOpeningStock,
    this.inward,
    this.goodInward,
    this.damagedInward,
    this.outward,
    this.goodOutward,
    this.damagedOutward,
    this.closing,
    this.goodClosing,
    this.damagedClosing,
    this.primaryClosing,
    this.totalQty,
    this.totalGoodQty,
    this.totalDamagedQty,
    this.actualQty,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["productId"],
    productName: json["productName"],
    skuUpcEan: json["SkuUpcEan"],
    openingStock: json["openingStock"],
    goodOpeningStock: json["goodOpeningStock"],
    damagedOpeningStock: json["damagedOpeningStock"],
    inward: json["inward"],
    goodInward: json["goodInward"],
    damagedInward: json["damagedInward"],
    outward: json["outward"],
    goodOutward: json["goodOutward"],
    damagedOutward: json["damagedOutward"],
    closing: json["closing"],
    goodClosing: json["goodClosing"],
    damagedClosing: json["damagedClosing"],
    primaryClosing: json["primaryClosing"],
    totalQty: json["totalQty"],
    totalGoodQty: json["totalGoodQty"],
    totalDamagedQty: json["totalDamagedQty"],
    actualQty: json["actualQty"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "SkuUpcEan": skuUpcEan,
    "openingStock": openingStock,
    "goodOpeningStock": goodOpeningStock,
    "damagedOpeningStock": damagedOpeningStock,
    "inward": inward,
    "goodInward": goodInward,
    "damagedInward": damagedInward,
    "outward": outward,
    "goodOutward": goodOutward,
    "damagedOutward": damagedOutward,
    "closing": closing,
    "goodClosing": goodClosing,
    "damagedClosing": damagedClosing,
    "primaryClosing": primaryClosing,
    "totalQty": totalQty,
    "totalGoodQty": totalGoodQty,
    "totalDamagedQty": totalDamagedQty,
    "actualQty": actualQty,
  };
}
