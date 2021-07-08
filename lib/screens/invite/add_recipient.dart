import 'package:flutter/cupertino.dart';

class AddRecipient
{
  String  nameOfRecipient ;
  String emailAddress ;
  FocusNode emailFocus;
  FocusNode nameFocus;

  AddRecipient({this.nameOfRecipient="",
    this.emailAddress="",this.emailFocus,this.nameFocus});
}
