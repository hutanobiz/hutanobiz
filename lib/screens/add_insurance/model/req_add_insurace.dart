import 'dart:convert';

class ReqAddInsurance {
  String? insuranceCompany;
  String? insuranceMember;
  String? memberId;
  String? healthPlan;
  String? groupNumber;
  String? effectiveDate;
  bool? isPrimary;
  ReqAddInsurance({
    this.insuranceCompany,
    this.insuranceMember,
    this.memberId,
    this.healthPlan,
    this.isPrimary,
    this.groupNumber,
    this.effectiveDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'insuranceId': insuranceCompany,
      'insuredMemberName': insuranceMember,
      'memberId': memberId,
      'healthPlan': healthPlan,
      'groupNumber': groupNumber,
      'effectiveDate': effectiveDate,
      'isPrimary': isPrimary,
    };
  }

  factory ReqAddInsurance.fromMap(Map<String, dynamic> map) {
  

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
