import 'dart:async';
import 'dart:convert';

import 'package:booknplay/Screens/TaskBoard/TaskBoardList.dart';
import 'package:booknplay/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../Local_Storage/shared_pre.dart';
import '../../Models/Getdatagame_model.dart';
import '../../Models/HomeModel/dashboard_model.dart';
import '../../Models/news_update_model.dart';
import '../../Models/setting_model.dart';
import '../../Services/api_services/apiConstants.dart';
import '../Auth_Views/Login/login_view.dart';
import '../Home/app_close_screen.dart';
import '../Timer/timer_controller.dart';
import '../Timer/timer_count.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DashboardModel dashboardModel = DashboardModel();
  NewsModel newsModel = NewsModel();
  GetgamedataModel getgamedataModel = GetgamedataModel();
  bool ischeck = false;

  SettingModel settingModel = SettingModel();
  getSetting() async {
    final response =
        await http.post(Uri.parse('${baseUrl}api_admin_valid_settings'));

    var data = jsonDecode(response.body);
    print(data.toString() + "________________");
    if (response.statusCode == 200) {
      settingModel = SettingModel.fromJson(data);
      if (settingModel.data?.loginType != "1") {
        await SharedPre.clear('userId');
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));

        Get.off(() => AppCloseScreen());
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  getGamedata() async {
    Map<String, String> body = {
      'user_id': await SharedPre.getStringValue('userId'),
    };
    print(body);
    final response = await http.post(
        Uri.parse('${baseUrl}api_game_old_game_data_get'),
        body: jsonEncode(body));

    var data = jsonDecode(response.body);
    print(data.toString() + "________________");
    if (response.statusCode == 200) {
      getgamedataModel = GetgamedataModel.fromJson(data);
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  getRols() async {
    // Map<String,String> body={
    //   'user_id':await SharedPre.getStringValue('userId'),
    //
    // };
    //  print(body);
    final response = await http.post(Uri.parse('${baseUrl}api_getAllNews'));

    var data = jsonDecode(response.body);
    print(data.toString() + "________________");
    if (response.statusCode == 200) {
      newsModel = NewsModel.fromJson(data);
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  checkgame() async {
    Map<String, String> body = {
      'user_id': await SharedPre.getStringValue('userId'),
    };
    print(body);
    final response = await http.post(Uri.parse('${baseUrl}api_gamerun_yesNo'),
        body: jsonEncode(body));

    var data = jsonDecode(response.body);
    print(data.toString() + "________________");
    if (response.statusCode == 200) {
      ischeck = data["status"];
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  var hours = "00";
  var minutes = "00";
  var seconds1 = "00";
  var totalAmount = 0.0;

  getDashboard() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=68b65db8a6659ad0354398bd4cd6449fc10b9b7f'
    };
    var request =
        http.Request('POST', Uri.parse('${baseUrl}apiGetDashboardData1'));
    request.body =
        json.encode({"user_id": "${await SharedPre.getStringValue('userId')}"});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print(result);
      var finalResult = DashboardModel.fromJson(json.decode(result));
      setState(() {
        dashboardModel = finalResult;
      });
      Fluttertoast.showToast(msg: "${finalResult.msg}");
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDashboard();
    getRols();
    controllettimer.getgamelist();

    //   getGamedata();
    checkgame();
    getSetting();
    print("++++++++++++++++++++++++++++++++++");
    //  isplay ? calculateTime(listtime) : null;
    // var timer1=timer;
    // print(timer1?.tick);
    //timer?.cancel();
    //timer=timer1;
    // setState(() {
    //
    // });
    // isplay ? startTimer1(currentindex??0) : null;
    //  if(isplay) {
    //
    //    for (int i = 0; i < planStartModel.data!.game!.length; i++) {
    //      isplay ? startTimer1(i) : null;
    //    }
    //  }
    // if(isplay) {
    //   print("${timer?.isActive.toString()}"+"PPPPPPPPPPPPPPPPPPPPP");
    //   for (int i = 0; i < planStartModel.data!.game!.length; i++) {
    //     isplay ? startTimer2(i) : null;
    //   }
    // }
  }

  // double calculateTime(List<dynamic> time) {
  //   double total = 0.0;
  //   for (Duration amount in time) {
  //     seconds1 += amount.inSeconds;
  //     hours += amount.inHours;
  //     minutes += amount.inMinutes;
  //   }
  //   setState(() {});
  //   return total;
  // }
  var controllettimer = Get.put(TimerController());

  @override
  void dispose() {
    // TODO: implement dispose
    //isplay? oldgameadddata():null;

    // isplay?startTimer(currentindex??0):null;
    //  for(int i=0;i<planStartModel.data!.game!.length;i++){
    //
    //
    //    isplay?startTimer2(i):null;
    //
    //  }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20),
          ),
        ),
        toolbarHeight: 60,
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: TextStyle(fontSize: 17),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
      ),
      body: GetBuilder(
          init: TimerController(),
          builder: (controller) {
            if (controllettimer.listduration.isNotEmpty ?? false) {
              String twoDigits(int n) => n.toString().padLeft(2, '0');
              hours = twoDigits(controller.listduration[0].inHours);
              minutes =
                  twoDigits(controller.listduration[0].inMinutes.remainder(60));
              seconds1 =
                  twoDigits(controller.listduration[0].inSeconds.remainder(60));
            } else {}
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildContainer("Recharge Balance",
                              "${dashboardModel.msg?.walletBalance ?? "0"}"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: buildContainer("Today Income ",
                              "${dashboardModel.msg?.todayAmount ?? "0"}"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildContainer("Total Recharge\nIncome",
                              "${dashboardModel.msg?.totalAmount ?? "0"}"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: buildContainer("Total Refferal",
                              "${dashboardModel.msg?.referredBy ?? "0"}"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildContainer("Active Refferal id",
                              "${dashboardModel.msg?.active ?? "0"}"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: buildContainer(" in Active Refferal id",
                              "${dashboardModel.msg?.inactive ?? "0"}"),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          elevation: 1,
                          color: AppColors.whit,
                          //border: Border.all(),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(0)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TimerScreen();
                              })).then((value) {
                                //calculateTime(listtime);
                                //startTimer();
                              });
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 1.0,
                              decoration: BoxDecoration(
                                  color: AppColors.whit,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(0),
                                      topLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(0))),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Text("Playner Active Timer",
                                          style: TextStyle(
                                              color: AppColors.fntClr,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildContainer(
                                  "Total Second's", "${seconds1 ?? "00"}"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: buildContainer(
                                  "Total Minute's", "${minutes ?? "00"}"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildContainer(
                                  "Total Hour's", "${hours ?? "00"}"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: buildContainer("Total Amount",
                                  "Rs.${controller.convermaptointger()}"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Material(
                          elevation: 1,
                          color: AppColors.whit,
                          //border: Border.all(),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(0)),
                          child: InkWell(
                            onTap: () {
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return TimerScreen();
                              // })).then((value) {
                              //   calculateTime(listtime);
                              //   //   startTimer();
                              // });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TaskBoardListScreen();
                              }));
                              //     .then((value) {
                              //   calculateTime(listtime);
                              //   //   startTimer();
                              // });
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 1.0,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(0)),
                                //border: Border.all(color: Colors.black),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Text("Task Board",
                                          style: TextStyle(
                                              color: AppColors.whit,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      elevation: 1,
                      color: AppColors.whit,
                      //border: Border.all(),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(0)),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.0,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(0))),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Text("News Update",
                                    style: TextStyle(
                                        color: AppColors.fntClr,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                        itemCount: newsModel.data?.length ?? 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Card(
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(0))),
                            color: AppColors.whit,
                            child: ListTile(
                              title: Text("${newsModel.data?[index].title}",
                                  style: const TextStyle(
                                      color: AppColors.fntClr,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  "${newsModel.data?[index].description}",
                                  style: const TextStyle(
                                      color: AppColors.fntClr,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                            ),
                          );
                        })
                  ],
                ),
              ),
            );
          }),
    );
  }

  Material buildContainer(String title, String amount) {
    return Material(
      color: AppColors.whit,
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topRight: Radius.circular(0)),
      elevation: 1,
      child: Container(
        height: 95,
        width: 150,
        decoration: BoxDecoration(
            color: AppColors.whit,
            border: Border.all(color: AppColors.fntClr),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${title}",
              style: const TextStyle(
                  color: AppColors.fntClr,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
              color: AppColors.fntClr,
            ),
            Text(
              "${amount}",
              style: const TextStyle(
                  color: AppColors.fntClr,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
