class OrderProduct {
  String? id;
  String? orderId;
  String? sellerId;
  String? buyerId;
  String? buyerType;
  String? productId;
  String? listingType;
  String? productType;
  String? productTitle;
  String? productSlug;
  dynamic productUnitPrice;
  int? productQuantity;
  String? productCurrency;
  String? productVatRate;
  dynamic productVat;
  dynamic productTotalPrice;
  String? variationOptionIds;
  dynamic commissionRate;
  String? orderStatus;
  int? isApproved;
  String? shippingTrackingNumber;
  String? shippingTrackingUrl;
  String? shippingMethod;
  dynamic sellerShippingCost;
  String? updatedAt;
  String? createdAt;
  String? branchId;
  List<String>? imageList;
  String? unitPrice;
  String? totalPrice;
  String? shippingCost;
  String? product;
  String? updatedAgo;
  String? shoppingCartId;
  String? _image;
  String? productVariations;
  List<String>? skuIds;

  OrderProduct(
      {this.id,
        this.orderId,
        this.shoppingCartId,
        this.sellerId,
        this.buyerId,
        this.buyerType,
        this.productId,
        this.listingType,
        this.productType,
        this.productTitle,
        this.productSlug,
        this.productUnitPrice,
        this.productQuantity,
        this.productCurrency,
        this.productVatRate,
        this.productVat,
        this.productTotalPrice,
        this.variationOptionIds,
        this.commissionRate,
        this.orderStatus,
        this.isApproved,
        this.shippingTrackingNumber,
        this.shippingTrackingUrl,
        this.shippingMethod,
        this.sellerShippingCost,
        this.updatedAt,
        this.createdAt,
        this.branchId,
        this.imageList,
        this.unitPrice,
        this.totalPrice,
        this.shippingCost,
        this.product,
        this.updatedAgo,
        this.skuIds
      });

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    orderId = json['OrderId'];
    sellerId = json['SellerId'];
    buyerId = json['BuyerId'];
    buyerType = json['BuyerType'];
    productId = json['ProductId'];
    listingType = json['ListingType'];
    productType = json['ProductType'];
    productTitle = json['ProductTitle'];
    productSlug = json['ProductSlug'];
    productUnitPrice = json['ProductUnitPrice'];
    productQuantity = json['ProductQuantity'];
    productCurrency = json['ProductCurrency'];
    productVatRate = json['ProductVatRate'];
    productVat = json['ProductVat'];
    productTotalPrice = json['ProductTotalPrice'];
    variationOptionIds = json['VariationOptionIds'];
    commissionRate = json['CommissionRate'];
    orderStatus = json['OrderStatus'];
    isApproved = json['IsApproved'];
    shippingTrackingNumber = json['ShippingTrackingNumber'];
    shippingTrackingUrl = json['ShippingTrackingUrl'];
    shippingMethod = json['ShippingMethod'];
    sellerShippingCost = json['SellerShippingCost'];
    updatedAt = json['UpdatedAt'];
    createdAt = json['CreatedAt'];
    branchId = json['BranchId'];
    if(json['ImageList'] != null) {
      imageList = json['ImageList'].cast<String>();
    }
    unitPrice = json['UnitPrice'];
    totalPrice = json['TotalPrice'];
    shippingCost = json['ShippingCost'];
    product = json['Product'];
    updatedAgo = json['UpdatedAgo'];
    _image = json['Image'];
    productVariations = json['ProductVariations'];
    if(json['SkuIds'] != null) {
      skuIds = json['SkuIds'].cast<String>();
    }
  }

  String? get image {
    if(_image?.isNotEmpty == true) {
      return _image!;
    }
    if(imageList?.isNotEmpty == true) {
      return imageList?[0];
    } else {
      return "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['OrderId'] = this.orderId;
    data['SellerId'] = this.sellerId;
    data['BuyerId'] = this.buyerId;
    data['BuyerType'] = this.buyerType;
    data['ProductId'] = this.productId;
    data['ListingType'] = this.listingType;
    data['ProductType'] = this.productType;
    data['ProductTitle'] = this.productTitle;
    data['ProductSlug'] = this.productSlug;
    data['ProductUnitPrice'] = this.productUnitPrice;
    data['ProductQuantity'] = this.productQuantity;
    data['ProductCurrency'] = this.productCurrency;
    data['ProductVatRate'] = this.productVatRate;
    data['ProductVat'] = this.productVat;
    data['ProductTotalPrice'] = this.productTotalPrice;
    data['VariationOptionIds'] = this.variationOptionIds;
    data['CommissionRate'] = this.commissionRate;
    data['OrderStatus'] = this.orderStatus;
    data['IsApproved'] = this.isApproved;
    data['ShippingTrackingNumber'] = this.shippingTrackingNumber;
    data['ShippingTrackingUrl'] = this.shippingTrackingUrl;
    data['ShippingMethod'] = this.shippingMethod;
    data['SellerShippingCost'] = this.sellerShippingCost;
    data['UpdatedAt'] = this.updatedAt;
    data['CreatedAt'] = this.createdAt;
    data['BranchId'] = this.branchId;
    data['ImageList'] = this.imageList;
    data['UnitPrice'] = this.unitPrice;
    data['TotalPrice'] = this.totalPrice;
    data['ShippingCost'] = this.shippingCost;
    data['Product'] = this.product;
    data['UpdatedAgo'] = this.updatedAgo;
    data['ShoppingCartId'] = this.shoppingCartId;
    data['SkuIds'] = this.skuIds;
    return data;
  }
}
