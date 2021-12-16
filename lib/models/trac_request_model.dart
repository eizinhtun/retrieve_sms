class TracRequestModel {
  double transferAmount = 0.0;
  String transactionNumber = "";
  String paymentName = "";
  String signature = "";
  String secretKey = "";
  String transferAccount = "";

  TracRequestModel(
      {this.transferAmount = 0.0,
      this.transactionNumber = "",
      this.paymentName = "",
      this.signature = "",
      this.secretKey = "",
      this.transferAccount = ""});

  TracRequestModel.fromJson(Map<String, dynamic> json) {
    transferAmount = json['transferAmount'];
    transactionNumber = json['transactionNumber'];
    paymentName = json['paymentName'];
    signature = json['signature'];
    secretKey = json['secretKey'];
    transferAccount = json['transferAccount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transferAmount'] = this.transferAmount.toString();
    data['transactionNumber'] = this.transactionNumber;
    data['paymentName'] = this.paymentName;
    data['signature'] = this.signature;
    data['secretKey'] = this.secretKey;
    data['transferAccount'] = this.transferAccount;
    return data;
  }
}
