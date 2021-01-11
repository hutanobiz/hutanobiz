import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'localization_en.dart';

class MyLocalizationsDelegate extends LocalizationsDelegate<Localization> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        'en',
      ].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) => _load(locale);

  static Future<Localization> _load(Locale locale) async {
    final String name =
        (locale.countryCode == null || locale.countryCode.isEmpty)
            ? locale.languageCode
            : locale;

    final localeName = Intl.canonicalizedLocale(name);
    Intl.defaultLocale = localeName;
    return LocalizationEN();
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;
}

abstract class Localization {
  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  String get appName;
  String get internetNotConnected;
  String get email;
  String get name;
  String get mobile;
  String get forgotPassword;
  String get logIn;
  String get register;
  String get loginTitle;
  String get signInTitle;
  String get password;
  String get signIn;
  String get labelPhone;
  String get hintPhone;
  String get remembermeTitle;
  String get welcome;
  String get accNowActive;
  String get completeTask;
  String get activateEmail;
  String get activateEmailDesc;
  String get addPaymentOption;
  String get addPaymentDesc;
  String get addFamily;
  String get addFamilyDesc;
  String get addProvider;
  String get addProviderDesc;
  String get completeTaskNow;
  String get skipTasks;
  String get enterPin;
  String get forgotPin;
  String get resetPin;
  String get confirm;
  String get update;
  String get emailAddress;
  String get confirmPassword;
  String get newPin;
  String get confirmNewPin;
  String get verifyCode;
  String get resend;
  String get labelAuthWithFingerPrint;
  String get verify;
  String get creditCard;
  String get required;

  String get labelMyFamilyCircle;
  String get edit;
  String get ok;
  String get cancel;
  String get recover;
  String get goToSetting;
  String get firstName;
  String get lastName;
  String get dob;
  String get address;
  String get city;
  String get state;
  String get zipcode;
  String get phoneNo;
  String get primaryInsurance;
  String get uploadPhoto;
  String get male;
  String get female;
  String get next;
  String get done;
  String get newPassword;
  String get createNewPassowrd;

  String get msgEnterAddress;
  String get msgEnterValidAddress;
  String get msgEnterName;
  String get msgEnterMobile;
  String get msgEnterValidMobile;
  String get msgEnterPin;
  String get msgResetPassword;
  String get msgResetPin;
  String get msgForgotPin;
  String get msgReturnLogin;
  String get msgOtpReceived;
  String get msgCodeNotRecieved;
  String get msgGetCode;
  String get fullAccess;
  String get appointments;
  String get documents;
  String get notifications;
  String get permissions;
  String get yourPhone;
  String get msgVerification;
  String get privacyPolicy;
  String get termsAndCondition;
  String get privacyPolicyLabel;

  String get enablelPermission;
  String get createAccount;
  String get errorEnterFirstName;
  String get errorEnterLastName;
  String get errorEnterPassword;
  String get errorEnterCity;
  String get errorEnterAddress;
  String get errorShortPassword;
  String get errorZipCode;
  String get errorPassword;
  String get errorValidPassword;
  String get errorPasswordNotMatch;
  String get helpSigningIn;
  String get dataSecurityStatement;
  String get emailVerification;
  String get checkYourEmail;
  String get stepOneofFour;
  String get enterActivationCode;
  String get didReceiveTheCode;
  String get activateMail;
  String get complete;
  String get taskComplete;
  String get skip;
  String get paymentOptions;
  String get addCreditCardAndInsurance;

  String get myMedicalHistory;
  String get painSymptoms;
  String get generalizedSymptoms;
  String get back;
  String get front;
  String get side;
  String get allOver;

  String get nameOnCard;
  String get cardNumber;
  String get expiaryDate;
  String get additionalCreditCard;
  String get insurance;
  String get selectInsurance;
  String get addSecondaryInsurance;
  String get cvv;
  String get paymentTermsAndCondition;

  String get inviteFamily;
  String get inviteFamilyAndFriendsYour;
  String get inviteFamilyAndFriends;
  String get assignPermisstion;
  String get inviteByEmail;
  String get enterEmailAddress;
  String get inviteByPhoneNumber;
  String get inviteByText;
  String get enterPhoneNumber;
  String get step3of4;
  String get addRecipients;
  String get addMoreRecipients;
  String get send;
  String get nameOfRecipient;
  String get typeMessage;
  String get text;
  String get inviteSent;
  String get congratulations;
  String get moreInvite;
  String get redeemPoints;
  String get continueText;

  String get step4of4;
  String get consultationFee;
  String get yearsOfExpereince;
  String get addToNetwork;
  String get bookAppointment;
  String get miles;
  String get searchResults;
  String get typeHere;
  String get add;
  String get addCreateGroup;
  String get addDoctorNetwork;
  String get selectNetwork;
  String get office;
  String get videoChat;
  String get onSite;
  String get myAppointments;
  String get upComing;
  String get reviewChart;
  String get textPatient;
  String get callPatient;
  String get rescheduleAppointment;
  String get completed;
  String get past;
  String get addProviders;
  String get enterProviderName;
  String get enterProviderNumber;
  String get searchByName;
  String get searchByNumber;
  String get skipThisTask;
  String get or;
  String get search;
  String get inviteByNumber;
  String get msgEnterPhoneNumber;
  String get msgRelationToMember;
  String get myFamilyNetwork;
  String get continueLabel;
  String get relation;
  String get addMore;
  String get makeAppointment;
  String get share;
  String get remove;
  String get myProviderNetwork;
  String get saveCard;
  String get addCardErrorMsg;
  String get confirmPinMessage;
  String get searchByNetwork;
  String get inviteByPhone;
  String get passwordResetSuccess;
  String get refCode;
  String get errorEmailExists;
  String get errorDob;
  String get errorState;
  String get errorGender;
  String get camera;
  String get gallery;
  String get selectImageType;
  String get picker;
  String get errorSelectRelation;
  String get commonErrorMsg;
  String get addCardDetails;
  String get msgCVV;
  String get msgMonth;
  String get msgYear;
  String get cardExpired;
  String get invalidCard;
  String get addProviderToNetwork;
  String get setting;
  String get home;
  String get errorEnterGroup;
  String get searchAndInvite;
  String get groupName;
  String get errorMsgInviteEmail;
  String get noMemberFound;
  String get imagesUploaded;
  String get selecteOnImage;
  String get appointmentSuccess;
  String get selectCreditCard;
  String get oops;
  String get errorSelectOneOption;
  String get errorSelectProfile;
  String get logout;
  String get selectBodyPart;
  String get errorBodyPartSelect;
  String get healthInsurance;
  String get labelHealthInsurance;
}
