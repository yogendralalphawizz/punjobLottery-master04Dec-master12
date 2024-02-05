class PaymentStatusModel {
  String? code;
  String? status;
  String? mess;
  Data? data;

  PaymentStatusModel({this.code, this.status, this.mess, this.data});

  PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    mess = json['mess'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['mess'] = this.mess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? orderKeyId;
  String? orderAmount;
  String? orderId;
  String? orderStatus;
  String? orderPaymentStatus;
  String? orderPaymentStatusText;
  String? paymentStatus;
  String? paymentTransactionId;
  String? paymentResponseCode;
  String? paymentTransactionRefNo;
  String? paymentResponseText;
  String? paymentMethod;
  String? paymentAccount;
  String? paymentDateTime;
  String? updatedDateTime;
  String? orderPaymentTransactionDetail;
  String? paymentProcessUrl;

  Data(
      {this.orderKeyId,
        this.orderAmount,
        this.orderId,
        this.orderStatus,
        this.orderPaymentStatus,
        this.orderPaymentStatusText,
        this.paymentStatus,
        this.paymentTransactionId,
        this.paymentResponseCode,
        this.paymentTransactionRefNo,
        this.paymentResponseText,
        this.paymentMethod,
        this.paymentAccount,
        this.paymentDateTime,
        this.updatedDateTime,
        this.orderPaymentTransactionDetail,
        this.paymentProcessUrl});

  Data.fromJson(Map<String, dynamic> json) {
    orderKeyId = json['OrderKeyId'];
    orderAmount = json['OrderAmount'];
    orderId = json['OrderId'];
    orderStatus = json['OrderStatus'];
    orderPaymentStatus = json['OrderPaymentStatus'];
    orderPaymentStatusText = json['OrderPaymentStatusText'];
    paymentStatus = json['PaymentStatus'];
    paymentTransactionId = json['PaymentTransactionId'];
    paymentResponseCode = json['PaymentResponseCode'];
    paymentTransactionRefNo = json['PaymentTransactionRefNo'];
    paymentResponseText = json['PaymentResponseText'];
    paymentMethod = json['PaymentMethod'];
    paymentAccount = json['PaymentAccount'];
    paymentDateTime = json['PaymentDateTime'];
    updatedDateTime = json['UpdatedDateTime'];
    orderPaymentTransactionDetail = json['OrderPaymentTransactionDetail'];
    paymentProcessUrl = json['PaymentProcessUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderKeyId'] = this.orderKeyId;
    data['OrderAmount'] = this.orderAmount;
    data['OrderId'] = this.orderId;
    data['OrderStatus'] = this.orderStatus;
    data['OrderPaymentStatus'] = this.orderPaymentStatus;
    data['OrderPaymentStatusText'] = this.orderPaymentStatusText;
    data['PaymentStatus'] = this.paymentStatus;
    data['PaymentTransactionId'] = this.paymentTransactionId;
    data['PaymentResponseCode'] = this.paymentResponseCode;
    data['PaymentTransactionRefNo'] = this.paymentTransactionRefNo;
    data['PaymentResponseText'] = this.paymentResponseText;
    data['PaymentMethod'] = this.paymentMethod;
    data['PaymentAccount'] = this.paymentAccount;
    data['PaymentDateTime'] = this.paymentDateTime;
    data['UpdatedDateTime'] = this.updatedDateTime;
    data['OrderPaymentTransactionDetail'] = this.orderPaymentTransactionDetail;
    data['PaymentProcessUrl'] = this.paymentProcessUrl;
    return data;
  }
}
