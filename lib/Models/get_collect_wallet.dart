class GetcollectWalletModel {
  String? msg;
  bool? status;
  Data? data;

  GetcollectWalletModel({this.msg, this.status, this.data});

  GetcollectWalletModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? gameCollection;

  Data({this.gameCollection});

  Data.fromJson(Map<String, dynamic> json) {
    gameCollection = json['game_collection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['game_collection'] = this.gameCollection;
    return data;
  }
}
