import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_netflix_ui_redesign/services/database.dart';
import 'package:flutter_netflix_ui_redesign/widgets/chewie.dart';
import 'package:html/parser.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:video_player/video_player.dart';
//import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';

class DbUpdate extends StatefulWidget {
  @override
  _DbUpdateState createState() => _DbUpdateState();
}

Future<Void> htmlget() async {
  DatabaseServices databaseServices = new DatabaseServices();
  final response = await http.get(Uri.parse(
      "https://gogoanime.pro/filter?type[]=movie&language[]=subbed&sort=views%3Adesc&keyword="));

  if (response.statusCode == 200) {
    var document = parse(response.body);

    var ul = document.body.getElementsByClassName('items');
    var div = ul[0].getElementsByClassName('img');
    Set item = Set();
    for (var i = 0; i < div.length; i++) {
      var str = "https://gogoanime.pro" +
          div[i].querySelector('a').attributes['href'].toString();
      //item.add(str);

      String str1 = div[i].querySelector('img').attributes['alt'];
      String rmspec = str1.replaceAll(' ', '-');
      String rmco = rmspec.replaceAll(':', '').replaceAll('.', '');
      String uri = 'https://www19.gogoanime.io/category/' + rmco.toLowerCase();

      String name;
      String img;
      String type;
      String aired;
      String status;
      String genre;
      double score;
      String length;
      String animeuri;
      String desc;

      final response2 = await http.get(Uri.parse(str));
      if (response2.statusCode == 200) {
        var document2 = parse(response2.body);

        if (div[i].querySelector('img').attributes['alt'] ==
            "Fate/stay night: Heaven's Feel - II. Lost Butterfly") {
          name = "Fate stay night: Heaven's Feel - II Lost Butterfly";
        } else {
          name = div[i].querySelector('img').attributes['alt'];
        }

        img = div[i].querySelector('img').attributes['src'];
        var animeinfo = document2.body.getElementsByClassName('anime_info');
        var infotag = animeinfo[0].getElementsByTagName('dd');
        type = infotag[0].text;
        if (div[i].querySelector('img').attributes['alt'] ==
            'Kimetsu no Yaiba Movie: Mugen Ressha-hen') {
          aired = '0';
        } else {
          aired = infotag[2].text.split(',').elementAt(1);
        }
        status = infotag[3].text;
        genre = infotag[4].text;
        if (div[i].querySelector('img').attributes['alt'] ==
            'Kimetsu no Yaiba Movie: Mugen Ressha-hen') {
          score = 0.0;
        } else {
          score = double.parse(infotag[5].text.split('/').elementAt(0));
        }

        length = infotag[6].text;
        desc = document2.body.getElementsByClassName('desc').elementAt(0).text;
      }

      final response1 = await http.get(Uri.parse(uri));
      if (response1.statusCode == 404) {
        final response2 = await http.get(Uri.parse(str));
        if (response2.statusCode == 200) {
          var document1 = parse(response2.body);

          var span = document1.body.getElementsByTagName('span');
          String spanName = span[0].text;
          var splitCo = spanName.split(";");
          String rmspec1 = splitCo[0].replaceAll(' ', '-');
          String rmco1 = rmspec1.replaceAll(':', '').replaceAll('.', '');
          String uri1 =
              'https://www19.gogoanime.io/category/' + rmco1.toLowerCase();
          item.add(uri1);
          animeuri = uri1;
          //print(uri1);
        }
      } else {
        item.add(uri);
        animeuri = uri;
        //print(uri);
      }
      print(name);
      print(img);
      print(type);
      print(aired);
      print(status);
      print(genre);
      print(score);
      print(length);
      print(animeuri);
      print(desc);

      final response3 = await http.get(Uri.parse(animeuri));

      if (response3.statusCode == 200) {
        var document3 = parse(response3.body);
        var ul1 = document3.body.querySelectorAll('ul[id="episode_page"]');
        var li = ul1[0].getElementsByTagName('li');
        print(li[li.length - 1].querySelector('a').attributes['ep_end']);
      } else {
        print(response3.statusCode);
      }

      // await databaseServices.updateAnime(
      //     name, img, type, aired, status, genre, score, length, animeuri, desc);
    }

    //print(div[0].querySelector('a').attributes['href']);
    // final response1 = await http
    //     .get(Uri.parse("https://www19.gogoanime.io/category/one-piece"));

    // if (response1.statusCode == 200) {
    //   var document1 = parse(response1.body);
    //   var ul1 = document1.body.querySelectorAll('ul[id="episode_page"]');
    //   var li = ul1[0].getElementsByTagName('li');
    //   print(li[li.length - 1].querySelector('a').attributes['ep_end']);
    // }
  }
}

class _DbUpdateState extends State<DbUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001030),
      body: Center(
        child: Container(
          color: Colors.white,
          child: FlatButton(
            child: Text('Press here'),
            onPressed: () {
              htmlget();
            },
          ),
        ),
      ),
    );
  }
}
