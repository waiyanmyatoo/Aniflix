import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_netflix_ui_redesign/widgets/chewie.dart';
import 'package:html/parser.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:video_player/video_player.dart';
//import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';

class WebViewTut extends StatefulWidget {
  final String url;
  final String ep;
  WebViewTut({this.url, this.ep});
  @override
  _WebViewTutState createState() => _WebViewTutState();
}

class _WebViewTutState extends State<WebViewTut> {
  String url =
      'https://file.gogocdn.net/prime-keel-282905/AHC9DJQL8ZZR/23a_1595009756142421.mp4';

  //final Completer<WebViewController> _controller = Completer<WebViewController>();
  //VideoPlayerController _controller;
  //WebViewController _controller;
  String launchurl;

  @override
  void initState() {
    super.initState();
    htmlget();
    // _controller = VideoPlayerController.network(
    //     'https://storage.googleapis.com/linear-theater-254209.appspot.com/v3.4animu.me/One-Piece/One-Piece-01-1080p.mp4')
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }

  String finalLink;
  Future<String> htmlget() async {
    final String _baseUrl =
        "https://floating-thicket-76387.herokuapp.com/api/info?url=";
    String urlLink =
        widget.url.replaceAll('category/', '') + "-episode-" + widget.ep;
    print(urlLink);
    final response = await http.get(Uri.parse(urlLink));

    if (response.statusCode == 200) {
      print(response.statusCode);
      RegExp regExp = new RegExp(
        r'hd_src:"(.+?)"',
        caseSensitive: true,
        multiLine: true,
      );

      var document = parse(response.body);

      var stage = document.body
          .getElementsByClassName('anime_video_body_watch_items load');
      var stage2 = stage[0].querySelector('iframe').attributes['src'];
      final response1 = await http.get(Uri.parse("https:" + stage2));

      var document1 = parse(response1.body);

      var stage3 = document1.body.querySelector('div[id="list-server-more"]');
      var links = stage3.querySelectorAll('li[class="linkserver"]');
      String streamLink = '';

      for (var i = 0; i < links.length; i++) {
        if (links[i]
            .attributes['data-video']
            .toString()
            .contains('loadserver.php')) {
          streamLink = links[i].attributes['data-video'];
          print(streamLink);
          // download = await http.get(Uri.parse(downLink));
          // if (download.statusCode==200) {
          //   var document1 = parse(download.body);

          // }
          break;
        }
        print(streamLink);
      }
      final response2 = await http.get(Uri.parse(_baseUrl + streamLink));
      if (response2.statusCode == 200) {
        Map decoder = jsonDecode(response2.body);
        final response3 =
            await http.get(Uri.parse(_baseUrl + decoder['info']['url']));
        if (response3.statusCode == 200) {
          Map decoder1 = jsonDecode(response3.body);
          setState(() {
            finalLink = decoder1['info']['url'];
          });

          print(decoder['info']['url']);
          // final pattern =
          //     new RegExp('.{1,800}'); // 800 is the size of each chunk
          // pattern
          //     .allMatches(finalLink)
          //     .forEach((match) => print(match.group(0)));

        } else
          print("response code is 404");
      }
    }
    return finalLink;
    //4Anime
    // var stage = document.body.getElementsByClassName(
    //     'landingHero-1OHkS9 grid-1P-ohk themeDark-w1n_8h');
    // var stage1 = stage[0].getElementsByClassName('container');
    // var stage2 = stage1[0].getElementsByClassName('firstDiv');
    // var stage3 = stage2[0].getElementsByClassName('videojs-desktop');

    //Gogoanime.pro
    //var stage4 = stage3[0].getElementsByClassName('vmn-ct');
    // var stage5 = stage4[0].getElementsByClassName('vmn-player');
    // var stage6 = stage5[0].getElementsByClassName('vmn-video');
    // var stage7 = stage6[0].querySelector('div');
    //print(stage4);
    //print(stage.getElementsByClassName('cvideo').length);
    // var links = document.querySelectorAll('video');
    // for (var i = 0; i < links.length; i++) {
    //   String downLink = links[i].attributes['src'].toString();
    //   // if (downLink.contains('https://vidstreaming.io/download?')) {
    //   //   //print(downLink);
    //   //   download = await http.get(Uri.parse(downLink));
    //   //   if (download.statusCode==200) {
    //   //     var document1 = parse(download.body);

    //   //   }
    //   //   break;
    //   // }
    //   print(downLink);
    // }
    //print(document.outerHtml);
    //print('String match: ${regExp.stringMatch(document.body.text)}');
    // else {
    //   throw Exception();
    // }
  }

  Future<void> _videoLaunch(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }

  returnWg(BuildContext context, String url) {
    Navigator.pop(context);
    _videoLaunch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001030),
//         body: WebView(
//           javascriptMode: JavascriptMode.unrestricted,
//           //debuggingEnabled: true,

//           // initialUrl: ,
//           onWebViewCreated: (WebViewController webViewController) {
//             _controller = webViewController;
//             _controller.loadUrl(
//                 "data:text/html;charset=utf-8," + Uri.encodeComponent('''

//  <video id='video-player' autoplay preload='metadata' controls width=100% height=100%>
//   <source src="https://00e9e64bac813ce46243b164b66a1403de0c41f599a3882a9a-apidata.googleusercontent.com/download/storage/v1/b/superb-cycle-282901/o/7LYN3YC5TXPN%2F23a_1595125655142481.mp4?qk=AD5uMEs108_eFWpqW25MLPz0_7cDtgFBacl9vvYpTcAm5ggaif9oKYLRHvUhMNwHPpguoexrHhHlN-hF27CFXaIlQXx81BfplXSVipO0oOLNDEepEQxbnTizWmjQcP1BhkjLG_FM1RzPAztLzzlLELOosy95zYoBtuULBeaflsmzHE8mTcc6DioCowFXzBQoswO24jA_2fzCw633hWtojck2V7tlZwCU6h478jxL9UL1C8fFfRp4ZxPNcbCYmZiJGB6oXrXXh51Y5D44F-ngeKEcIa9J9rQkixuvCkvsvGHhXx78MscJzZVru81scYXWkPjib4BTNC7x7Z9r-4FoSNUTkjoPvPIy5iE7pALYdULScf8TVqNpscoZvh8Vr_MQKG7PUoXG8uX7197Bc-Cwpm_Lqosnd3n4V0CdpTYgAflnIe6JI29pZu71gwwQeZKru7_HtcxEqcswsSOkZEwiXH0WnvYiE8VaPpxic0k7SLGh5kOaxTiR0IA6tLzA2wbrE7JTnUfm1Qk5Kebk5A05nwn2iu8dKD8NkJ5UsL_B_rcu101ZtalaLgQ8mzegPRzJ6_UgI21BK91YnTCzEEUwRrPeg5wMrxCTC1y7nf2s7gJGw995djWb6bws9NZ3O8e4mG_JfcgR6KCVy8VC_EAyjvDZLM_IJo7dT08VOvoyHwTkr1DMmJI-BmkZ0wA16w-EwRdYDE75t4H-wHtM6zz2EfUDEjtrwM898_uzbnNMAbbmdLNjOlotV4v2kyuoCRY4j4FeR3Ej_ebKJeDAJ41joOVsNsVEAdzrA67hQ1LLgGuJykVrwBf5JJaEcpXRbNoL8vO0a5TqC5E4p3O_vRKXdJEIF10Ty3-jBg&isca=1" type="video/mp4">
// </video>

//               '''));
//           },
//         ));
      // body: WebviewScaffold(
      //   url: ,
      //   hidden: true,
      //   ignoreSSLErrors: true,
      //   // clearCache: true,
      //   // clearCookies: true,
      //   mediaPlaybackRequiresUserGesture: false,
      // );
      body: Center(
        child: finalLink != null
            ? returnWg(context, finalLink)
            : CircularProgressIndicator(),
      ),

      //   body: Center(
      //     child: _controller.value.initialized
      //         ? AspectRatio(
      //             aspectRatio: _controller.value.aspectRatio,
      //             child: VideoPlayer(_controller),
      //           )
      //         : Container(),
      //   ),
      //   floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       setState(() {
      //         _controller.value.isPlaying
      //             ? _controller.pause()
      //             : _controller.play();
      //       });
      //     },
      //     child: Icon(
      //       _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //     ),
      //   ),
      // );
    );
    // Uint8List image;

    // VlcPlayerController _videoViewController;
    // VlcPlayerController _videoViewController2;
    // bool isPlaying = true;
    // double sliderValue = 0.0;
    // double currentPlayerTime = 0;

    // @override
    // void initState() {
    //   _videoViewController = new VlcPlayerController(onInit: () {
    //     _videoViewController.play();
    //   });
    //   _videoViewController.addListener(() {
    //     setState(() {});
    //   });

    //   _videoViewController2 = new VlcPlayerController(onInit: () {
    //     _videoViewController2.play();
    //   });
    //   _videoViewController2.addListener(() {
    //     setState(() {});
    //   });

    //   Timer.periodic(Duration(seconds: 1), (Timer timer) {
    //     String state = _videoViewController2.playingState.toString();
    //     if (this.mounted) {
    //       setState(() {
    //         if (state == "PlayingState.PLAYING" &&
    //             sliderValue < _videoViewController2.duration.inSeconds) {
    //           sliderValue = _videoViewController2.position.inSeconds.toDouble();
    //         }
    //       });
    //     }
    //   });

    //   super.initState();
    // }

    // @override
    // Widget build(BuildContext context) {
    //   return new Scaffold(
    //     appBar: new AppBar(
    //       title: const Text('Plugin example app'),
    //     ),
    //     floatingActionButton: FloatingActionButton(
    //       child: Icon(Icons.camera),
    //       onPressed: _createCameraImage,
    //     ),
    //     body: Center(
    //       child: ListView(
    //         shrinkWrap: true,
    //         children: <Widget>[
    //           SizedBox(
    //             height: 360,
    //             child: new VlcPlayer(
    //               aspectRatio: 16 / 9,
    //               url:
    //                   "https://animevibe.tv/players/iframe.php?vid=https://vidstreaming.io/streaming.php?id=MzUxOA==&title=One+Piece+Episode+1",
    //               controller: _videoViewController,
    //               placeholder: Container(
    //                 height: 250.0,
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[CircularProgressIndicator()],
    //                 ),
    //               ),
    //             ),
    //           ),
    //           SizedBox(
    //             height: 360,
    //             child: new VlcPlayer(
    //               aspectRatio: 16 / 9,
    //               url: "https://www.novelplanet.me/v/qy8qqce42j84lnm",
    //               controller: _videoViewController2,
    //               placeholder: Container(
    //                 height: 250.0,
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[CircularProgressIndicator()],
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Slider(
    //             activeColor: Colors.white,
    //             value: sliderValue,
    //             min: 0.0,
    //             max: _videoViewController2.duration == null
    //                 ? 1.0
    //                 : _videoViewController2.duration.inSeconds.toDouble(),
    //             onChanged: (progress) {
    //               setState(() {
    //                 sliderValue = progress.floor().toDouble();
    //               });
    //               //convert to Milliseconds since VLC requires MS to set time
    //               _videoViewController2.setTime(sliderValue.toInt() * 1000);
    //             },
    //           ),
    //           FlatButton(
    //               child: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
    //               onPressed: () => {playOrPauseVideo()}),
    //           FlatButton(
    //             child: Text("Change URL"),
    //             onPressed: () => _videoViewController.setStreamUrl(
    //                 "https://animevibe.tv/players/iframe.php?vid=https://vidstreaming.io/streaming.php?id=MzUxOA==&title=One+Piece+Episode+1"),
    //           ),
    //           FlatButton(
    //               child: Text("+speed"),
    //               onPressed: () => _videoViewController.setPlaybackSpeed(2.0)),
    //           FlatButton(
    //               child: Text("Normal"),
    //               onPressed: () => _videoViewController.setPlaybackSpeed(1)),
    //           FlatButton(
    //               child: Text("-speed"),
    //               onPressed: () => _videoViewController.setPlaybackSpeed(0.5)),
    //           Text("position=" +
    //               _videoViewController.position.inSeconds.toString() +
    //               ", duration=" +
    //               _videoViewController.duration.inSeconds.toString() +
    //               ", speed=" +
    //               _videoViewController.playbackSpeed.toString()),
    //           Text("ratio=" + _videoViewController.aspectRatio.toString()),
    //           Text("size=" +
    //               _videoViewController.size.width.toString() +
    //               "x" +
    //               _videoViewController.size.height.toString()),
    //           Text("state=" + _videoViewController.playingState.toString()),
    //           image == null ? Container() : Container(child: Image.memory(image)),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    // void playOrPauseVideo() {
    //   String state = _videoViewController2.playingState.toString();

    //   if (state == "PlayingState.PLAYING") {
    //     _videoViewController2.pause();
    //     setState(() {
    //       isPlaying = false;
    //     });
    //   } else {
    //     _videoViewController2.play();
    //     setState(() {
    //       isPlaying = true;
    //     });
    //   }
    // }

    // void _createCameraImage() async {
    //   Uint8List file = await _videoViewController.takeSnapshot();
    //   setState(() {
    //     image = file;
    //   });
    // }
  }
}
