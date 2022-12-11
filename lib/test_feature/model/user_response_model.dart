class UserResponseModel {
  int? id;
  String? email;
  String? firstname;
  String? lastname;
  String? avatar;

  UserResponseModel(
      {this.id, this.email, this.firstname, this.lastname, this.avatar});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstname = json['first_name'];
    lastname = json['last_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstname;
    data['last_name'] = lastname;
    data['avatar'] = avatar;
    return data;
  }
}

class UserResponseResultList {
  int? page;
  int? perpage;
  int? total;
  int? totalpages;
  List<UserResponseModel?>? data;
  Support? support;

  UserResponseResultList(
      {this.page, this.perpage, this.total, this.totalpages, this.data, this.support});

  UserResponseResultList.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perpage = json['per_page'];
    total = json['total'];
    totalpages = json['total_pages'];
    if (json['data'] != null) {
      data = <UserResponseModel>[];
      json['data'].forEach((v) {
        data!.add(UserResponseModel.fromJson(v));
      });
    }
    support =
    json['support'] != null ? Support?.fromJson(json['support']) : null;
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = Map<String, dynamic>();
//   data['page'] = page;
//   data['per_page'] = perpage;
//   data['total'] = total;
//   data['total_pages'] = totalpages;
//   data['data'] =data != null ? data.map((key, value) => UserResponseModel(value)) : null;
//   data['support'] = support!.toJson();
//   return data;
// }
}

class Support {
  String? url;
  String? text;

  Support({this.url, this.text});

  Support.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = url;
    data['text'] = text;
    return data;
  }
}

