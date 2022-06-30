class ErrorModelStripe {
  Error? _error;

  ErrorModelStripe({Error? error}) {
    this._error = error;
  }

  Error? get error => _error;
  set error(Error? error) => _error = error;

  ErrorModelStripe.fromJson(Map<String, dynamic> json) {
    _error = json['error'] != null ? new Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._error != null) {
      data['error'] = this._error!.toJson();
    }
    return data;
  }
}

class Error {
  String? _code;
  String? _docUrl;
  String? _message;
  String? _param;
  String? _type;

  Error(
      {String? code, String? docUrl, String? message, String? param, String? type}) {
    this._code = code;
    this._docUrl = docUrl;
    this._message = message;
    this._param = param;
    this._type = type;
  }

  String? get code => _code;
  set code(String? code) => _code = code;
  String? get docUrl => _docUrl;
  set docUrl(String? docUrl) => _docUrl = docUrl;
  String? get message => _message;
  set message(String? message) => _message = message;
  String? get param => _param;
  set param(String? param) => _param = param;
  String? get type => _type;
  set type(String? type) => _type = type;

  Error.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _docUrl = json['doc_url'];
    _message = json['message'];
    _param = json['param'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['doc_url'] = this._docUrl;
    data['message'] = this._message;
    data['param'] = this._param;
    data['type'] = this._type;
    return data;
  }
}
