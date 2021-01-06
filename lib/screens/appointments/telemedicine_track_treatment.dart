import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/fancy_button.dart';
class TelemedicineTrackTreatmentScreen extends StatefulWidget {
  @override
  _TelemedicineTrackTreatmentScreenState createState() => _TelemedicineTrackTreatmentScreenState();
}
class _TelemedicineTrackTreatmentScreenState extends State<TelemedicineTrackTreatmentScreen> {
  bool doctorBusy=false;
  @override
  Widget build(BuildContext context) {
   if(doctorBusy==true){
     return Scaffold(
       body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.containerBorderColor,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width * .95,
          height: MediaQuery.of(context).size.height * .6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Virtual Waiting Room',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  border: Border.all(
                    color: AppColors.containerBorderColor,
                    width: .5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: MediaQuery.of(context).size.width * .85,
                height: MediaQuery.of(context).size.height * .06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.info,color: Color(0xFFA1A1A1),),
                    Text('Your Appointment Starts In 14 Mins.',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
              Icon(Icons.error,color: AppColors.goldenTainoi,size: 80,),
              Padding(
                  padding: EdgeInsets.only(left: 30,right: 30),
                  child: Text('Dr. Joseph is busy helping another patient.',style: TextStyle(fontSize: 20),)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.containerBorderColor,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: MediaQuery.of(context).size.width * .30,
                height: MediaQuery.of(context).size.height * .09,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.exit_to_app_rounded),
                    Text(' Exit',style: TextStyle(fontSize: 20,color: Color(0xFF202020)),)
                  ],
                ),
              )
            ],
          ),
        ),
       ),
     );
   }
   else{
     return Scaffold(
       body: Center(
         child: Container(
           decoration: BoxDecoration(
             border: Border.all(
               color: AppColors.containerBorderColor,
               width: .5,
             ),
             borderRadius: BorderRadius.circular(15),
           ),
           width: MediaQuery.of(context).size.width * .95,
           height: MediaQuery.of(context).size.height * .6,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Text('Virtual Waiting Room',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
               Icon(Icons.check_circle,color: AppColors.emerald,size: 80,),
               Padding(
                   padding: EdgeInsets.only(left: 50,right: 50),
                   child: Text('Dr. Joseph Is ready for your appointment.',style: TextStyle(fontSize: 20),)),
               Container(
                 height: MediaQuery.of(context).size.height * .05,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Image.asset('images/uncheckedCheck.png',height: 20,),
                     Text('  Record meeting',style: TextStyle(fontSize: 20),),
                   ],
                 ),
               ),
               Container(
                   width: MediaQuery.of(context).size.width * .6,
                 height: MediaQuery.of(context).size.height * .1,
                 child: FancyButton(
                   onPressed: (){
                   },
                   title: 'Start meeting now',
                   buttonColor: AppColors.goldenTainoi,

                 )
               ),
               Divider(
                 thickness: .5,
                   color: AppColors.containerBorderColor,
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                Row(
                children: [
                  Icon(Icons.radio_button_checked,color: Color(0xFF1E36BA),),
                  Text('  Video & Audio',style: TextStyle(fontSize: 16),),
                ],
                ),
                   Row(
                     children: [
                       Icon(Icons.radio_button_unchecked,color: Colors.grey[300]),
                       Text('  Audio Only',style: TextStyle(fontSize: 16),),
                     ],
                   ),
              ],
               )
             ],
           ),
         ),
       ),
     );
   }
   }
  }

