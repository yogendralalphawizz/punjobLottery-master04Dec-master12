class ListSucessModel {
  bool? status;
  String? msg;
  List<Data>? data;

  ListSucessModel({this.status, this.msg, this.data});

  ListSucessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sno;
  String? id;

  Data({this.sno, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['id'] = this.id;
    return data;
  }
}
