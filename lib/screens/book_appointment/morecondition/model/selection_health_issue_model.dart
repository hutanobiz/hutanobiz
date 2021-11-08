class SelectionHealthIssueModel {
  int index;
  String sId;
  String name;
  String image;
  bool isSelected;
  Map<String, dynamic> problem;
  SelectionHealthIssueModel(
      {this.index, this.sId, this.name, this.image, this.isSelected,this.problem});
}
