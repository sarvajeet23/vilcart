
class BusinessModel {
    bool? status;
    String? message;
    List<Business>? result;

    BusinessModel({
        this.status,
        this.message,
        this.result,
    });

    factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null ? [] : List<Business>.from(json["result"]!.map((x) => Business.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    };
}

class Business {
    int? id;
    String? businessName;
    IndustrySubcategory? industrySubcategory;
    int? userId;
    String? fullname;
    String? mobileNo;
    String? email;
    bool? ecommCustomer;

    Business({
        this.id,
        this.businessName,
        this.industrySubcategory,
        this.userId,
        this.fullname,
        this.mobileNo,
        this.email,
        this.ecommCustomer,
    });

    factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json["id"],
        businessName: json["businessName"],
        industrySubcategory: json["industrySubcategory"] == null ? null : IndustrySubcategory.fromJson(json["industrySubcategory"]),
        userId: json["userId"],
        fullname: json["fullname"],
        mobileNo: json["mobileNo"],
        email: json["email"],
        ecommCustomer: json["ecommCustomer"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "businessName": businessName,
        "industrySubcategory": industrySubcategory?.toJson(),
        "userId": userId,
        "fullname": fullname,
        "mobileNo": mobileNo,
        "email": email,
        "ecommCustomer": ecommCustomer,
    };
}

class IndustrySubcategory {
    int? id;
    String? name;
    String? description;
    bool? status;
    int? industryCategoryId;
    IndustryCategory? industryCategory;

    IndustrySubcategory({
        this.id,
        this.name,
        this.description,
        this.status,
        this.industryCategoryId,
        this.industryCategory,
    });

    factory IndustrySubcategory.fromJson(Map<String, dynamic> json) => IndustrySubcategory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        status: json["status"],
        industryCategoryId: json["industryCategoryId"],
        industryCategory: json["industryCategory"] == null ? null : IndustryCategory.fromJson(json["industryCategory"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "status": status,
        "industryCategoryId": industryCategoryId,
        "industryCategory": industryCategory?.toJson(),
    };
}

class IndustryCategory {
    int? id;
    String? name;
    String? description;
    bool? status;

    IndustryCategory({
        this.id,
        this.name,
        this.description,
        this.status,
    });

    factory IndustryCategory.fromJson(Map<String, dynamic> json) => IndustryCategory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "status": status,
    };
}
