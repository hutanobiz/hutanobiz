import 'package:flutter/material.dart';


class ResCreateCardToken {

  String id;
  String object;
  Card card;
  String client_ip;
  int created;
  bool livemode;
  String type;
  bool used;

	ResCreateCardToken.fromJsonMap(Map<String, dynamic> map):
		id = map["id"],
		object = map["object"],
		client_ip = map["client_ip"],
		created = map["created"],
		livemode = map["livemode"],
		type = map["type"],
		used = map["used"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['object'] = object;
		data['client_ip'] = client_ip;
		data['created'] = created;
		data['livemode'] = livemode;
		data['type'] = type;
		data['used'] = used;
		return data;
	}
}
