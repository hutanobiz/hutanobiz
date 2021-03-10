import 'dart:convert';

class ReqAddInsurance {
  String insuranceCompany;
  String insuranceMember;
  String memberId;
  String healthPlan;
  String groupNumber;
  String effectiveDate;
  ReqAddInsurance({
    this.insuranceCompany,
    this.insuranceMember,
    this.memberId,
    this.healthPlan,
    this.groupNumber,
    this.effectiveDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'insuranceCompany': insuranceCompany,
      'insuranceMember': insuranceMember,
      'memberId': memberId,
      'healthPlan': healthPlan,
      'groupNumber': groupNumber,
      'effectiveDate': effectiveDate,
    };
  }

  factory ReqAddInsurance.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReqAddInsurance(
      insuranceCompany: map['insuranceCompany'],
      insuranceMember: map['insuranceMember'],
      memberId: map['memberId'],
      healthPlan: map['healthPlan'],
      groupNumber: map['groupNumber'],
      effectiveDate: map['effectiveDate'],
    );
  }

  String toJson() => json.encode(toMap());
}
