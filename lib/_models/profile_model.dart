class ProfileModel {
  int? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  SellerObj? sellerObj;
  CompanyObj? companyObj;
  List<BankObj>? bankObj;
  List<AddressObj>? addressObj;

  Data({this.sellerObj, this.companyObj, this.bankObj, this.addressObj});

  Data.fromJson(Map<String, dynamic> json) {
    sellerObj = json['seller_obj'] != null
        ? new SellerObj.fromJson(json['seller_obj'])
        : null;
    companyObj = json['company_obj'] != null
        ? new CompanyObj.fromJson(json['company_obj'])
        : null;
    if (json['bank_obj'] != null) {
      bankObj = <BankObj>[];
      json['bank_obj'].forEach((v) {
        bankObj!.add(new BankObj.fromJson(v));
      });
    }
    if (json['address_obj'] != null) {
      addressObj = <AddressObj>[];
      json['address_obj'].forEach((v) {
        addressObj!.add(new AddressObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sellerObj != null) {
      data['seller_obj'] = this.sellerObj!.toJson();
    }
    if (this.companyObj != null) {
      data['company_obj'] = this.companyObj!.toJson();
    }
    if (this.bankObj != null) {
      data['bank_obj'] = this.bankObj!.map((v) => v.toJson()).toList();
    }
    if (this.addressObj != null) {
      data['address_obj'] = this.addressObj!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SellerObj {
  String? sellerId;
  String? sellerUid;
  String? parent;
  String? fname;
  String? mname;
  String? lname;
  String? email;
  String? mobile;
  String? password;
  String? gender;
  String? dob;
  String? image;
  String? status;
  String? created;
  String? modified;

  SellerObj(
      {this.sellerId,
        this.sellerUid,
        this.parent,
        this.fname,
        this.mname,
        this.lname,
        this.email,
        this.mobile,
        this.password,
        this.gender,
        this.dob,
        this.image,
        this.status,
        this.created,
        this.modified});

  SellerObj.fromJson(Map<String, dynamic> json) {
    sellerId = json['seller_id'];
    sellerUid = json['seller_uid'];
    parent = json['parent'];
    fname = json['fname'];
    mname = json['mname'];
    lname = json['lname'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    gender = json['gender'];
    dob = json['dob'];
    image = json['image'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seller_id'] = this.sellerId;
    data['seller_uid'] = this.sellerUid;
    data['parent'] = this.parent;
    data['fname'] = this.fname;
    data['mname'] = this.mname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}

class CompanyObj {
  String? companyId;
  String? sellerId;
  String? companyName;
  String? companyEmail;
  String? companyMobile;
  String? logo;
  String? ein;
  String? driverLicence;
  String? taxExemption;
  String? noOfYearInBusiness;
  String? status;
  String? created;
  String? modified;

  CompanyObj(
      {this.companyId,
        this.sellerId,
        this.companyName,
        this.companyEmail,
        this.companyMobile,
        this.logo,
        this.ein,
        this.driverLicence,
        this.taxExemption,
        this.noOfYearInBusiness,
        this.status,
        this.created,
        this.modified});

  CompanyObj.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    sellerId = json['seller_id'];
    companyName = json['company_name'];
    companyEmail = json['company_email'];
    companyMobile = json['company_mobile'];
    logo = json['logo'];
    ein = json['ein'];
    driverLicence = json['driver_licence'];
    taxExemption = json['tax_exemption'];
    noOfYearInBusiness = json['no_of_year_in_business'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['seller_id'] = this.sellerId;
    data['company_name'] = this.companyName;
    data['company_email'] = this.companyEmail;
    data['company_mobile'] = this.companyMobile;
    data['logo'] = this.logo;
    data['ein'] = this.ein;
    data['driver_licence'] = this.driverLicence;
    data['tax_exemption'] = this.taxExemption;
    data['no_of_year_in_business'] = this.noOfYearInBusiness;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}

class BankObj {
  String? bankId;
  String? sellerId;
  String? bankName;
  String? accountNumber;
  String? receiptNumber;
  String? status;
  String? created;
  String? modified;

  BankObj(
      {this.bankId,
        this.sellerId,
        this.bankName,
        this.accountNumber,
        this.receiptNumber,
        this.status,
        this.created,
        this.modified});

  BankObj.fromJson(Map<String, dynamic> json) {
    bankId = json['bank_id'];
    sellerId = json['seller_id'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    receiptNumber = json['receipt_number'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_id'] = this.bankId;
    data['seller_id'] = this.sellerId;
    data['bank_name'] = this.bankName;
    data['account_number'] = this.accountNumber;
    data['receipt_number'] = this.receiptNumber;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}

class AddressObj {
  String? addressId;
  String? sellerId;
  String? street;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? address;
  String? type;
  String? status;
  String? created;
  String? modified;
  String? addressType;
  String? countryName;
  String? fullAddress;

  AddressObj(
      {this.addressId,
        this.sellerId,
        this.street,
        this.city,
        this.state,
        this.zip,
        this.country,
        this.address,
        this.type,
        this.status,
        this.created,
        this.modified,
        this.addressType,
        this.countryName,
        this.fullAddress});

  AddressObj.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    sellerId = json['seller_id'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    address = json['address'];
    type = json['type'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
    addressType = json['address_type'];
    countryName = json['country_name'];
    fullAddress = json['full_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    data['seller_id'] = this.sellerId;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['country'] = this.country;
    data['address'] = this.address;
    data['type'] = this.type;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['address_type'] = this.addressType;
    data['country_name'] = this.countryName;
    data['full_address'] = this.fullAddress;
    return data;
  }
}