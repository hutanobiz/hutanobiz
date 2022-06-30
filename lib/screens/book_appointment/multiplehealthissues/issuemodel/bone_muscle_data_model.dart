class BoneMuscleDateModel {
  List<BodyPartWithSide>? listOfBodyParts;
  String? selectedSymptom;
  String? rating;
  String? timeEffect;
  LongTimeWithProblem? longTimeWithProblem;
  String? problemTime;
}

class BodyPartWithSide {
  String bodyPart;
  String side;
  BodyPartWithSide(this.bodyPart,this.side);
}

class LongTimeWithProblem {
  String time;
  String problem;
  LongTimeWithProblem(this.time,this.problem);
}