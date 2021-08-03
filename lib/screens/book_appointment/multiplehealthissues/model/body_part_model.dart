class BodyPartModel {
  String bodyPart;
  bool hasInternalPart;
  bool isItClicked;
  List<int> sides;
  String selectedSide;
  BodyPartModel(this.bodyPart, this.hasInternalPart, this.sides,
      this.isItClicked, this.selectedSide);
}
