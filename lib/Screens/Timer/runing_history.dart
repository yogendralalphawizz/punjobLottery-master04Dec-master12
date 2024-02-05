

import 'dart:async';
import 'dart:convert';

import 'package:booknplay/Screens/Timer/timer_controller.dart';
import 'package:booknplay/Screens/Timer/timer_count.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart'as http;

import '../../Local_Storage/shared_pre.dart';
import '../../Models/cancel_model.dart';
import '../../Services/api_services/apiConstants.dart';
import '../../Utils/Colors.dart';

class RuningHistory extends StatefulWidget {
  const RuningHistory({super.key});

  @override
  State<RuningHistory> createState() => _RuningHistoryState();
}

class _RuningHistoryState extends State<RuningHistory> {

  var controllettimer=Get.put(TimerController());



  Widget buildTime(String id,int index) {

    return GetBuilder(
      init: TimerController(),
      builder: (controller) {
        String twoDigits(int n) => n.toString().padLeft(2, '0');
        final hours = twoDigits(controller.listduration[index].inHours);
        final minutes = twoDigits(controller.listduration[index].inMinutes.remainder(60));
        final seconds = twoDigits(controller.listduration[index].inSeconds.remainder(60));

        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          SizedBox(height: 10,),

          buildTimeCard(time: seconds, header: 'SECONDS',price: "${double.parse(controller.planStartModel.data?.game?[index].tMinutePrice??"0.0")}"
            //"${planStartModel.data?.second??"0"}"
          ),

          SizedBox(
            height: 8,
          ),
          buildTimeCard(time: minutes, header: 'MINUTES',price: double.parse("${int.parse(minutes)*double.parse(controller.planStartModel.data?.game?[index].tMinutePrice??"0.0")}").toStringAsFixed(2)),
          SizedBox(
            height: 8,
          ),

          buildTimeCard(time: hours, header: 'HOURS',price:double.parse("${int.parse(hours)*double.parse(controller.planStartModel.data?.game?[index].tHourePrice??"0.0")}").toStringAsFixed(2)),
          SizedBox(
            height: 8,
          ),

          buildTimeCard(time: 'Hour Use', header: 'Availabale Hours',price: "${int.parse("${controller.planStartModel.data?.golTimeHoure??"0"}")-int.parse("${hours??"0"}")}"),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title:Center(child: Text("Are You Sure",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),

                      // content:  Container(
                      //   height: 100,
                      //   child: Column(
                      //     children: [
                      //     ],
                      //   ),
                      // ),
                      actions: <Widget>[
                        InkWell(
                          onTap:(){
                            Navigator.pop(context);
                            // Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5)
                            ),

                            child: const Text("Cancel",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                          ),
                        ),

                        InkWell(
                          onTap:() async {
                            // buynowgame();
                            // if (enternoCon
                            //     .text != "") {
                            //   await playStartgame();
                            //   if (planStartModel
                            //       .status ==
                            //       true) {
                            //     Future.delayed(
                            //         const Duration(
                            //             seconds: 5), () {
                            //       activeandprogress =
                            //       "Progress";
                            //       // Here you can write your code
                            //
                            //       setState(() {
                            //         // Here you can write your code for open new view
                            //       });
                            //     });
                            //     // listtime.clear();
                            //     for (int i = 0; i <
                            //         planStartModel
                            //             .data!
                            //             .game!
                            //             .length; i++) {
                            //       if (!listmodel
                            //           .contains(
                            //           planStartModel
                            //               .data!
                            //               .game?[i]
                            //               .id)) {
                            //         duration =
                            //             Duration();
                            //         listmodel
                            //             .add(
                            //             planStartModel
                            //                 .data!
                            //                 .game?[i]
                            //                 .id);
                            //         listtime.add(
                            //             duration);
                            //         cashwallet
                            //             .add(
                            //             0.0);
                            //         int a = listtime
                            //             .length;
                            //         startTimer1(
                            //             a - 1);
                            //       }
                            //     }
                            //
                            //
                            //     if (currentindex ==
                            //         null) {
                            //       // startTimer1(currentindex??0);
                            //     }
                            //     currentindex = 0;
                            //     activeandprogress =
                            //     "Progress";
                            //     setState(() {
                            //
                            //     });
                            //     //  startTimer();
                            //     isplay = true;
                            //   } else {
                            //     isplay = false;
                            //   }
                            // }
                            // else {
                            //   Fluttertoast
                            //       .showToast(
                            //       msg: "Enter No. Required");
                            // }
                            // Navigator.pop(context);
                            controller.cancegame(id,index);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5)
                            ),

                            child: const Text("Ok",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
                  );
                //  cancegame(id,index);
                },
                child: Container(

                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.fntClr),
                        color: AppColors.whit, borderRadius: BorderRadius.circular(50)),
                    child: Center(child: Text("Reset-My Table-Round",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),))),
              ),
            ],
          ),
        ]);
      }
    );
  }



  Widget buildTimeCard({required String time, required String header,required String price}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(

            child: Container(

                decoration: BoxDecoration(
                  // border: Border.all(color: AppColors.secondary),
                    color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
                child: Center(child: Text(header, style: TextStyle(color: AppColors.whit,fontSize: 13.5),textAlign:TextAlign.center ,))),
          ),
          SizedBox(width: 5,),
          Expanded(

            child: Container
              (

              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondary),
                  color: AppColors.whit, borderRadius: BorderRadius.circular(2)),
              child: Center(
                child: Text(
                  time,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.fntClr,
                      fontSize: 14),
                ),
              ),
            ),
          ),
          SizedBox(width: 5,),
          Expanded(

            child: Container
              (

              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondary),
                  color: AppColors.whit, borderRadius: BorderRadius.circular(2)),
              child: Center(
                child: Text(
                  price,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.fntClr,
                      fontSize: 14),
                ),
              ),
            ),
          ),


        ],
      );
   @override
  void initState() {
    // TODO: implement initState
    //  var timer1=timer;
    //  timer?.cancel();
    //  timer=timer1;
    //  setState(() {
    //
    //  });

     // for(int i=0;i<planStartModel.data!.game!.length;i++){
     //
     //   isplay?controllettimer.startTimer(i):null;
     //
     // }
    // isplay?startTimer1(currentindex??0):null;
   //  isplay?startTimer1(0):null;
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    //isplay? oldgameadddata():null;
   //isplay?startTimer(currentindex??0):null;
   // isplay?startTimer(0):null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        // automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(
            bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20),
          ),),
        toolbarHeight: 60,
        centerTitle: true,
        title: Text("Running",style: TextStyle(fontSize: 17),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius:   BorderRadius.only(
              bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10),),

          ),
        ),
      ),
      body: GetBuilder(
        init: TimerController(),
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                   // physics: NeverScrollableScrollPhysics(),
                    itemCount:controller.listduration.length ,
                    //   itemCount:listtime.length??0 ,
                    itemBuilder: (context,index){

                      return
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child:
                          buildTime("${controller.planStartModel.data?.game?[index].id}",index),
                          //buildTime("",index),
                        );
                    }),
              ),
            ],
          );
        }
      ),
    );
  }
}
