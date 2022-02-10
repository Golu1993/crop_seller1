class DashboardModel {
  int? status;
  String? message;
  DashboardData? data;

  DashboardModel({this.status, this.message, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DashboardData.fromJson(json['data']) : null;
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

class DashboardData {
  Temperature? temperature;
  Temperature? weather;
  Temperature? humidity;
  Temperature? windspeed;
  Order? order;
  int? notification;

  DashboardData(
      {this.temperature,
        this.weather,
        this.humidity,
        this.windspeed,
        this.order,
        this.notification});

  DashboardData.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'] != null
        ? new Temperature.fromJson(json['temperature'])
        : null;
    weather = json['weather'] != null
        ? new Temperature.fromJson(json['weather'])
        : null;
    humidity = json['humidity'] != null
        ? new Temperature.fromJson(json['humidity'])
        : null;
    windspeed = json['windspeed'] != null
        ? new Temperature.fromJson(json['windspeed'])
        : null;
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    notification = json['notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.temperature != null) {
      data['temperature'] = this.temperature!.toJson();
    }
    if (this.weather != null) {
      data['weather'] = this.weather!.toJson();
    }
    if (this.humidity != null) {
      data['humidity'] = this.humidity!.toJson();
    }
    if (this.windspeed != null) {
      data['windspeed'] = this.windspeed!.toJson();
    }
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    data['notification'] = this.notification;
    return data;
  }
}

class Temperature {
  String? name;
  String? icon;

  Temperature({this.name, this.icon});

  Temperature.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}

class Order {
  String? newOrder;
  String? inProgress;

  Order({this.newOrder, this.inProgress});

  Order.fromJson(Map<String, dynamic> json) {
    newOrder = json['new_order'];
    inProgress = json['in_progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['new_order'] = this.newOrder;
    data['in_progress'] = this.inProgress;
    return data;
  }
}