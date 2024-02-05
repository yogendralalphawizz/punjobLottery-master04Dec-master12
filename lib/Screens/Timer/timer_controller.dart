import 'dart:async';
import 'dart:convert';
import 'package:booknplay/Screens/Timer/timer_count.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Local_Storage/shared_pre.dart';
import '../../Models/HomeModel/sucess_model.dart';
import '../../Models/cancel_model.dart';
import '../../Models/current_transfer_model.dart';
import '../../Models/gameplaylist_model.dart';
import '../../Models/get_collect_wallet.dart';
import '../../Models/list_rols.dart';
import '../../Models/plan_start_model.dart';
import '../../Models/sucess_list_model.dart';
import '../../Services/api_services/apiConstants.dart';

class TimerController extends GetxController {
  List<Timer?> timer = [];
  List listduration = [];
  String? activeandprogress;
  double cashcalculate = 0.0;
  var listmodel = [];
  var cashwallet = [];
  String? selectoption;
  var listsucess = [];
  var listTimercount = [];
  Map<String, dynamic> pricecollect = {};
  int sucess = 0;
  int count = 0;
  CancelModel cancelModel = CancelModel();
  bool isruning = false;
  bool isplay = false;
  int? currentindex;
  GameListModel gameListModel = GameListModel();
  PlanStartModel planStartModel = PlanStartModel();
  SucessModel sucessModel = SucessModel();

  BuyNowModel buyNowModel = BuyNowModel();

  TextEditingController enternoCon = TextEditingController();

  String? playerId;
  addListDuration(var value) {
    listduration.add(value);
    update();
  }

  addData() async {
    print("data edit ");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("duration", listduration.toString());
    await prefs.setString("savetime", DateTime.now().toString());
    await prefs.setBool("isPause", true);

    // print(DateTime.now().toIso8601String());
    // await prefs.setInt("numTimers", timer.length);

    // Store each timer's remaining duration and start time
    for (int i = 0; i < timer.length; i++) {
      print("hello");
      // Timer timer1 = timer[i]!;
      // await   prefs.setInt("timerDurationInSeconds_$i", timer1.tick);
      // await prefs.setString("timerStartTime_$i", DateTime.now().toString());
      timer[i]?.cancel();
    }

    await prefs.setString("model", jsonEncode(planStartModel.toJson()));
    print(prefs.getString("savetime"));
  }

  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? durationString = prefs.getString("duration");

    List<String>? durationInSecondsList = durationString
        ?.toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split(',');
    print(durationInSecondsList);
    String? currentTime11 = prefs.getString("savetime");
    bool? isCheck = await prefs.getBool("isPause");
    if (isCheck ?? false) {
      listduration = durationInSecondsList?.map((durationString) {
            // Split the duration string into its components
            List<String> components = durationString.split(':');

            // Parse hours, minutes, and seconds
            int hours = int.parse(components[0]);
            int minutes = int.parse(components[1]);
            double seconds = double.parse(components[2]);

            print(currentTime11.toString() + "save time");
            print(DateTime.now().toString() + "current Time");
            Duration elapsedTime =
                DateTime.now().difference(DateTime.parse(currentTime11 ?? ""));
            print(elapsedTime);
            // Create a Duration object
            return Duration(
                  hours: hours,
                  minutes: minutes,
                  seconds: seconds
                      .toInt(), // Truncate the fractional part of seconds
                ) +
                elapsedTime;
          }).toList() ??
          [];

      update();

      // int? numTimers = prefs.getInt("numTimers");

      // if (numTimers != null) {
      //   List<Timer> retrievedTimers = [];
      //
      //   // Retrieve and recreate each timer
      //   for (int i = 0; i < numTimers; i++) {
      //     // Retrieve the remaining duration of the timer (in seconds)
      //     int? timerDurationInSeconds = prefs.getInt("timerDurationInSeconds_$i");
      //
      //     // Retrieve the time when the timer value was stored
      //     String? storedTime = prefs.getString("timerStartTime_$i");
      //
      //     if (timerDurationInSeconds != null && storedTime != null) {
      //       // Calculate the elapsed time since the timer value was stored
      //       Duration elapsedTime = DateTime.now().difference(
      //           DateTime.parse(storedTime));
      //
      //       // Calculate the remaining time
      //       int remainingTimeInSeconds = timerDurationInSeconds -
      //           elapsedTime.inSeconds;
      //
      //
      //       // Check if the timer has not expired
      //       if (remainingTimeInSeconds > 0) {
      //         // Start a new timer with the remaining time
      //         Timer newTimer = Timer(
      //             Duration(seconds: remainingTimeInSeconds), () {
      //           // Timer completion logic
      //         });
      //
      //         // Store the new timer
      //         retrievedTimers.add(newTimer);
      //       } else {
      //         // The timer has expired, handle accordingly
      //       }
      //     }
      //   }
      //   timer=retrievedTimers;
      //
      //
      //   update();
      //
      // }
      // for (int i = 0; i < timer.length; i++) {
      //   timer[i]?.cancel();
      // }

      // Clear the existing timer list
      timer.clear();
      update();

      // Introduce a slight delay before starting new timers
      await Future.delayed(Duration(milliseconds: 10));
      planStartModel =
          PlanStartModel.fromJson(jsonDecode("${prefs.getString("model")}"));

      update();

      if (planStartModel.data?.game?.isNotEmpty ?? false) {
        for (int i = 0; i < planStartModel.data!.game!.length; i++) {
          timer.add(Timer.periodic(Duration(seconds: 1), (_) {
            addTime(i);
          }));

          update();
        }
      }
      await prefs.setBool("isPause", false);
      print(timer.length);
    } else {}
  }

  addTimer(var value) {
    timer.add(value);
    update();
  }

  addTimercount(var value) {
    listTimercount.add(value);
    update();
  }

  clearAlldata() {
    timer = [];
    count = 0;

    isplay = false;
    currentindex = null;
    listduration = [];
    cashwallet = [];
    enternoCon.text = "";
    gameListModel = GameListModel();
    planStartModel = PlanStartModel();
    activeandprogress = null;
    cashcalculate = 0.0;
    listmodel = [];
    selectoption = null;
    listsucess = [];
    sucess = 0;
    cancelModel = CancelModel();
    update();
  }

  void startTimer(int index) {
    // if (timer[index] != null) {
    //   // Cancel the previous timer
    //   timer[index]?.cancel();
    // }
    timer[index];
    //= Timer.periodic(Duration(seconds: 1), (_) => addTime(index));
  }

  convermaptointger() {
    var data = 0.0;

    for (int i = 0; i < pricecollect.length; i++) {
      data += double.parse(pricecollect["${i}"].toString());
      print(data);
    }
    return data.toStringAsFixed(2);
  }

  Future<void> addTime(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const addSeconds = 1;

    final seconds = listduration[index].inSeconds + addSeconds;
    print(seconds);
    if (seconds <= 3600 * int.parse("${gameListModel.data?.golTimeHoure}")) {
      listduration[index] = Duration(seconds: seconds);

      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final hours = twoDigits(listduration[index].inHours);
      final minutes = twoDigits(listduration[index].inMinutes.remainder(60));
      final seconds1 = twoDigits(listduration[index].inSeconds.remainder(60));

      // double hourprice = double.parse(hours) *
      //     double.parse("${planStartModel.data?.game?[index].tHourePrice}");
      // double minutesprice = double.parse(minutes) *
      //     double.parse("${planStartModel.data?.game?[index].tHourePrice}");

      var minutesdi = int.parse("${prefs.get("${index}") ?? "0"}") -
          int.parse("${minutes}");
      print("${prefs.get("${index}") ?? "0"}" + "${index}");

      if (prefs.get("${index}") == null && minutes == "${twoDigits(2)}") {
        prefs.setString("${index}", "${minutes}");
        print('_________this${minutes == "${twoDigits(30)}"}____${minutes}___');
        print(hours.toString());

        pricecollect.addEntries({
          "${index}": double.parse(minutes) *
              double.parse("${planStartModel.data?.game?[index].tMinutePrice}")
        }.entries);

        update();
      } else if (minutesdi >= 2 || minutes == "${twoDigits(2)}") {
        print('_________this${minutes}____${seconds}___');
        pricecollect.addEntries({
          "${index}": double.parse("${seconds / 60}") *
              double.parse("${planStartModel.data?.game?[index].tMinutePrice}")
        }.entries);
        prefs.setString("${index}", "${minutes}");
      }
      if (seconds > 3600 * int.parse("${gameListModel.data?.golTimeHoure}")) {
        timer[index]?.cancel();
      } else {
        if (seconds ==
            3600 * int.parse("${gameListModel.data?.golTimeHoure}")) {
          winingaler(index);

          update();
        } else {
          update();
        }

        update();
      }
    } else {
      timer[index]?.cancel();
    }
  }

  winingaler(int index) {
    print("open dilogs");
    Get.dialog(
      barrierDismissible: false,
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Center(
                child: Text("Congratulations",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Image.asset("assets/images/thumb.png",
                      width: 100, height: 100, fit: BoxFit.contain),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text("You Are Winner",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              InkWell(
                onTap: () async {
                  await transfordata(index);
                  planStartModel.data!.game!.removeAt(index);
                  listduration.removeAt(index);
                  timer[index]?.cancel();
                  cashwallet.removeAt(index);
                  timer.removeAt(index);
                  update();
                  addCashWallet("${convermaptointger()}");

                  if (planStartModel.data!.game!.isEmpty ?? false) {
                    currentindex = null;
                    update();
                  } else {}
                  Get.back(); // Close the dialog
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text("Ok",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  getgamelist() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=68b65db8a6659ad0354398bd4cd6449fc10b9b7f'
    };

    var request =
        http.Request('POST', Uri.parse('${baseUrl}api_game_Package_list'));
    request.body =
        json.encode({"user_id": "${await SharedPre.getStringValue('userId')}"});
    print(request.body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print(result);
      var finalResult = GameListModel.fromJson(json.decode(result));

      gameListModel = finalResult;
      var gameId = gameListModel.data?.packageId ?? "0";
      SharedPre.setValue("GameId", gameId);

      Fluttertoast.showToast(msg: "${finalResult.msg}");
    } else {
      print(response.reasonPhrase);
    }
  }

  getSucesslist() async {
    Map<String, String> body = {
      'user_id': await SharedPre.getStringValue('userId'),
    };
    //  print(body);
    final response =
        await http.post(Uri.parse('${baseUrl}list_of_activegame'), body: body);

    var data = jsonDecode(response.body);
    print(data.toString() + "________________");
    if (response.statusCode == 200) {
      sucessModel = SucessModel.fromJson(data);
      update();
    } else {
      print(response.reasonPhrase);
    }
  }

  CurrentTransferDataModel currentTransferDataModel =
      CurrentTransferDataModel();
  getCurrentTransferData() async {
    Map<String, String> body = {
      'user_id': await SharedPre.getStringValue('userId'),
    };
    //  print(body);
    final response =
        await http.post(Uri.parse('${baseUrl}last_transfor_data'), body: body);

    var data = jsonDecode(response.body);
    print(data.toString() + "________________");
    if (response.statusCode == 200) {
      currentTransferDataModel = CurrentTransferDataModel.fromJson(data);
      update();
    } else {
      print(response.reasonPhrase);
    }
  }

  addCashWallet(String amount) async {
    Map<String, String> body = {
      'user_id': await SharedPre.getStringValue('userId'),
      "amount": "${amount}"
    };
    print(body);
    final response =
        await http.post(Uri.parse('${baseUrl}add_game_collection'), body: body);

    var data = jsonDecode(response.body);
    print(data.toString() + "________________");
    if (response.statusCode == 200) {
      sucessModel = SucessModel.fromJson(data);
      update();
    } else {
      print(response.reasonPhrase);
    }
  }

  GetcollectWalletModel getcollectWalletModel = GetcollectWalletModel();
  getCashWallet() async {
    Map<String, String> body = {
      'user_id': await SharedPre.getStringValue('userId'),
    };
    print(body);
    final response =
        await http.post(Uri.parse('${baseUrl}get_game_collection'), body: body);

    var data = jsonDecode(response.body);
    print(data.toString() + "________________");
    if (response.statusCode == 200) {
      getcollectWalletModel = GetcollectWalletModel.fromJson(data);
      update();
    } else {
      print(response.reasonPhrase);
    }
  }

  oldgameadddata(int i) async {
    print("++++++++++++++++++++++");
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // final hours = twoDigits(duration.inHours);
    // final minutes = twoDigits(duration.inMinutes.remainder(60));
    // final seconds = twoDigits(duration.inSeconds.remainder(60));
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=68b65db8a6659ad0354398bd4cd6449fc10b9b7f'
    };

    var request =
        http.Request('POST', Uri.parse('${baseUrl}api_transfor_Data'));
    request.body = json.encode({
      "user_id": "${await SharedPre.getStringValue('userId')}",
      "amount": "${convermaptointger()}",
      //"${calculateTotal(cashwallet)}",

      "array": [
        //  for (int i = 0; i < planStartModel.data!.game!.length; i++)
        {
          "play_id": "${planStartModel.data!.game?[i].id}",
          "user_id": "${await SharedPre.getStringValue('userId')}",
          "second": "${twoDigits(listduration[i].inSeconds.remainder(60))}",
          "secode_price": "${planStartModel.data!.second}",
          "houre_price": "${planStartModel.data!.houre}",
          "houre": "${twoDigits(listduration[i].inHours)}",
          "minute_price": "${planStartModel.data!.minute}",
          "minute": "${twoDigits(listduration[i].inMinutes.remainder(60))}",
          "amount": "${pricecollect[i].toString()}",
        }
      ].toList(),
    });
    print(request.body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var result = await response.stream.bytesToString();
    var data = jsonDecode(result);
    print(result);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "${data["msg"]}");
      if (data["status"] == false) {
        // planStartModel=PlanStartModel();
        // listduration=[];
        //
        //
        // cashwallet=[];
        // pricecollect.clear();
        // update();
        //
        // if (planStartModel.data!.game!.isEmpty ?? false) {
        //   currentindex = null;
        //   update();
        // } else {
        //
        // }
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  transfordata(int i) async {
    print("++++++++++++++++++++++");
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // final hours = twoDigits(duration.inHours);
    // final minutes = twoDigits(duration.inMinutes.remainder(60));
    // final seconds = twoDigits(duration.inSeconds.remainder(60));
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=68b65db8a6659ad0354398bd4cd6449fc10b9b7f'
    };

    var request =
        http.Request('POST', Uri.parse('${baseUrl}api_transfor_single_row'));
    request.body = json.encode({
      "user_id": "${await SharedPre.getStringValue('userId')}",
      //"amount":"${convermaptointger()}",
      //"${calculateTotal(cashwallet)}",

      "array": [
        //  for (int i = 0; i < planStartModel.data!.game!.length; i++)
        {
          "play_id": "${planStartModel.data!.game?[i].id}",
          "user_id": "${await SharedPre.getStringValue('userId')}",
          "second": "${twoDigits(listduration[i].inSeconds.remainder(60))}",
          "secode_price": "0",
          "houre_price":
              "${double.parse("${planStartModel.data?.game?[i].tHourePrice}") * int.parse("${twoDigits(listduration[i].inHours)}")}",
          "houre": "${twoDigits(listduration[i].inHours)}",
          "minute_price":
              "${double.parse("${planStartModel.data?.game?[i].tMinutePrice}") * int.parse("${twoDigits(listduration[i].inMinutes.remainder(60))}")}",
          "minute": "${twoDigits(listduration[i].inMinutes.remainder(60))}",
          "amount": "${pricecollect[i].toString()}",
        }
      ].toList(),
    });
    print(request.body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var result = await response.stream.bytesToString();
    var data = jsonDecode(result);
    print(result);
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: "${data["msg"]}");
      if (data["status"] == false) {
        // planStartModel=PlanStartModel();
        // listduration=[];
        //
        //
        // cashwallet=[];
        // pricecollect.clear();
        // update();
        //
        // if (planStartModel.data!.game!.isEmpty ?? false) {
        //   currentindex = null;
        //   update();
        // } else {
        //
        // }
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  transfordatamony(int i) async {
    print("++++++++++++++++++++++");
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // final hours = twoDigits(duration.inHours);
    // final minutes = twoDigits(duration.inMinutes.remainder(60));
    // final seconds = twoDigits(duration.inSeconds.remainder(60));
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=68b65db8a6659ad0354398bd4cd6449fc10b9b7f'
    };

    var request = http.Request(
        'POST', Uri.parse('${baseUrl}collect_wallet_amount_tranfor'));
    request.body = json.encode({
      "user_id": "${await SharedPre.getStringValue('userId')}",
      "amount": "${convermaptointger()}",
      //"${calculateTotal(cashwallet)}",
    });
    print(request.body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var result = await response.stream.bytesToString();
    var data = jsonDecode(result);
    print(result);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "${data["msg"]}");
      if (data["status"] == false) {
        pricecollect.clear();
        // planStartModel=PlanStartModel();
        // listduration=[];
        //
        //
        // cashwallet=[];
        // pricecollect.clear();
        // update();
        //
        // if (planStartModel.data!.game!.isEmpty ?? false) {
        //   currentindex = null;
        //   update();
        // } else {
        //
        // }
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  var minutes;
  var hourly;
  buynowgame() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=68b65db8a6659ad0354398bd4cd6449fc10b9b7f'
    };

    var request = http.Request('POST', Uri.parse('${baseUrl}api_game_buy_now'));
    request.body = json.encode({
      "user_id": "${await SharedPre.getStringValue('userId')}",
      "packeage_id": "${gameListModel.data?.packageId}",
      "count": "${count}",
    });
    print(request.body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var data = json.decode(result);
      print(result);
      Fluttertoast.showToast(msg: "${data["msg"]}");
      // var finalResult = BuyNowModel.fromJson(json.decode(result));

      if (data["status"] == true) {
        var finalResult = BuyNowModel.fromJson(json.decode(result));

        buyNowModel = finalResult;
        print(data["data"]["player_id"]);
        playerId = "${data["data"]["player_id"]}";

        count++;
        getactivegamelist();
        // activeandprogress=null;

        activeandprogress = int.parse("${buyNowModel.data?.currentStatus}") == 0
            ? "Failed"
            : "Sucess";
        minutes = "${buyNowModel.data?.minute}";
        hourly = "${buyNowModel.data?.houre}";
        update();
        // Here you can write your code for open new view

        if (activeandprogress == "Failed") {
          Future.delayed(const Duration(seconds: 1), () {
            // activeandprogress = "Active";
//
            minutes = "0";
            hourly = "0";
            update();
            // Here you can write your code for open new view
          });
        } else {
          Future.delayed(const Duration(seconds: 25), () {
            minutes = "0";
            hourly = "0";
            activeandprogress = "Active";
//

            // Here you can write your code for open new view
          });
        }
        getSucesslist();
      } else {
        Fluttertoast.showToast(msg: "${data["msg"]}");
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  transfermoney() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=68b65db8a6659ad0354398bd4cd6449fc10b9b7f'
    };

    var request = http.Request(
        'POST', Uri.parse('${baseUrl}collect_wallet_amount_tranfor'));
    request.body = json.encode({
      "user_id": "${await SharedPre.getStringValue('userId')}",
      "amount": "${convermaptointger()}",
    });
    print(request.body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print(result);

      var data = jsonDecode(result);
      Fluttertoast.showToast(msg: "${data["msg"]}");
    } else {
      print(response.reasonPhrase);
    }
  }

  cancegame(String id, int index) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=68b65db8a6659ad0354398bd4cd6449fc10b9b7f'
    };

    var request =
        http.Request('POST', Uri.parse('${baseUrl}apicancelGameCount'));
    request.body = json.encode({
      "user_id": "${await SharedPre.getStringValue('userId')}",
      "play_id": "${id}",
    });
    print(request.body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print(result);
      var finalResult = CancelModel.fromJson(json.decode(result));

      cancelModel = finalResult;
      planStartModel.data?.game?.removeAt(index);
      listduration.removeAt(index);
      cashwallet.removeAt(index);
      timer.removeAt(index);
      if (listduration.length == 0 || listduration.isEmpty) {
        timer[index]?.cancel();

        activeandprogress = "failed";

        currentindex = null;
      }
      // if(currentindex!=null) {
      //   if (planStartModel.data!.game!.length > 0 &&
      //       currentindex! < planStartModel.data!.game!.length) {
      //     currentindex = currentindex! +1;
      //   }
      //
      //   else {
      //     currentindex = null;
      //   }
      // }

      update();
      Fluttertoast.showToast(msg: "${finalResult.message}");
    } else {
      print(response.reasonPhrase);
    }
  }

  playStartgame() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=68b65db8a6659ad0354398bd4cd6449fc10b9b7f'
    };

    var request = http.Request('POST', Uri.parse('${baseUrl}api_game_plays'));
    request.body = json.encode({
      "user_id": "${await SharedPre.getStringValue('userId')}",
      "player_id": "${playerId}",
      "success_count": "${enternoCon.text}"
    });
    print(request.body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print('______result___this${result}_______');
      var data = json.decode(result);
      Fluttertoast.showToast(msg: "${data['message']}");
      var finalResult = PlanStartModel.fromJson(data);

      planStartModel = finalResult;
      update();
      // Fluttertoast.showToast(msg: "${finalResult.message}");
    } else {
      print(response.reasonPhrase);
    }
  }

  RolesListModel rolesListModel = RolesListModel();
  dynamic? localmodel;
  bool istimestatus = false;
  getRols() async {
    final response = await http.post(Uri.parse('${baseUrl}api_ListofRoles'));

    var data = jsonDecode(response.body);
    print(data.toString() + "________________");
    if (response.statusCode == 200) {
      rolesListModel = RolesListModel.fromJson(data);
      update();
    } else {
      print(response.reasonPhrase);
    }
  }

  getimecheck() async {
    Map<String, String> body = {
      'user_id': await SharedPre.getStringValue('userId'),
    };
    //  print(body);
    final response =
        await http.post(Uri.parse('${baseUrl}api_time_management'), body: body);

    var data = jsonDecode(response.body);
    print(data.toString() + "jksdfjkjkdsjkdfsjkdssdjk");
    if (response.statusCode == 200) {
      istimestatus = data['status'];
      if (istimestatus == true) {
        count = 0;
      }
      update();
    } else {
      print(response.reasonPhrase);
    }
  }

  ListSucessModel listSucessModel = ListSucessModel();
  getactivegamelist() async {
    Map<String, String> body = {
      'user_id': await SharedPre.getStringValue('userId'),
    };
    print(body);
    final response = await http.post(Uri.parse('${baseUrl}active_game_list'),
        body: jsonEncode(body));

    var data = jsonDecode(response.body);
    print(data.toString() + "________________");
    if (response.statusCode == 200) {
      listSucessModel = ListSucessModel.fromJson(data);
      listsucess.clear();
      if (listSucessModel.data?.isNotEmpty ?? false) {
        for (int i = 0; i < listSucessModel.data!.length; i++) {
          listsucess.add(int.parse("${listSucessModel.data?[i].sno}"));
        }
      }
      update();
    } else {
      print(response.reasonPhrase);
    }
  }
}
