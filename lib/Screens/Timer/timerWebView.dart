
import 'package:booknplay/Local_Storage/shared_pre.dart';
import 'package:booknplay/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

String currentPageUrl = "";

class TimerWebView extends StatefulWidget  {
  const TimerWebView({Key? key}) : super(key: key);

  @override
  State<TimerWebView> createState() => _TimerWebViewState();
}

class _TimerWebViewState extends State<TimerWebView> with WidgetsBindingObserver{
  late final WebViewController _controller;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {

    switch (state) {
      case AppLifecycleState.resumed:
        _controller.reload();
        print("app in resumed"+"state**************");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive"+" state**************");
        break;
      case AppLifecycleState.paused:
        print("app in paused "+"state**************");
        break;
      case AppLifecycleState.detached:
        print("app in detached"+"**************");
        break;
      case AppLifecycleState.hidden:
    }
  }

  setUrl() async {
    var gameId = await SharedPre.getStringValue('GameId');
    var userId = await SharedPre.getStringValue('userId');
    String url = "https://cleverpager.in/playner-dashboard/$gameId/$userId";
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setBackgroundColor(const Color(0x00000000));
    _controller.enableZoom(false);
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {
          isLoading = true;
          setState(() {});
        },
        onPageFinished: (String url) {
          isLoading = false;
          setState(() {});
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) async {
          // if (request.url.contains('thankyou')) {
          //   await paymentCheck();
          //   if (paymentStatusModel.data?.orderPaymentStatusText == "Paid") {
          //     await sucessPayment1();
          //   } else {
          //     Fluttertoast.showToast(msg: "Payment Failed ");
          //   }
          //   print("+++++++++++++++++++++=");
          //   Get.off(() => AddMoney());

          //   /// Navigator.pop(context);
          //   return NavigationDecision.prevent;
          // }
          return NavigationDecision.navigate;
        },
      ),
    );
    _controller.loadRequest(Uri.parse(url));
  }
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
    WidgetsBinding.instance.removeObserver(this);
    SystemChannels.lifecycle.setMessageHandler(null);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = WebViewController();
    WidgetsBinding.instance.addObserver(this);

    setUrl();

    super.initState();
  }

  bool isLoading = true;
  late final WebViewController webwController;

  String getCroppedString(String start, String end, String urlForCrop) {
    String str = urlForCrop;

    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);

    return str.substring(
        startIndex + start.length, endIndex); // brown fox jumps
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: WebViewWidget(controller: _controller),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : Container(),
          ],
        ));
  }
}
