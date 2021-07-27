class ResDocumentList {
  List<Document> documents = [];
  int count;
  ResDocumentList.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      count = json['count'];
      json['data'][0]['medicalDocuments'].forEach((element) {
        documents.add(Document.fromJson(element));
      });
    }
  }
}

class Document {
  String id;
  String medicalDocuments;
  String type;
  String name;
  String date;
  Document.fromJson(Map<String, dynamic> json) {
    if (json != null){
      medicalDocuments = json['medicalDocuments'];
      id = json['_id'];
      type = json['type'];
      name = json['name'];
      date = json['date'];
    }
  }
}
