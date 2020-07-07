import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';
import 'package:flutter_netflix_ui_redesign/screens/prefsClass.dart';
import 'package:flutter_netflix_ui_redesign/services/database.dart';
import 'package:flutter_netflix_ui_redesign/widgets/circular_clipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';

class MovieScreen extends StatefulWidget {
  final String movieid;

  MovieScreen({this.movieid});

  bool isExpanded = false;
  bool isWatched = false;
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  static Set _saved;
  @override
  void initState() {
    //_saved = SharedPreferencesHelper.getSavedId() as Set;
    SharedPreferencesHelper.getSavedId().then(getId);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    AutoOrientation.portraitAutoMode();
    super.initState();
  }

  void getId(List id) {
    setState(() {
      _saved = id.toSet();
      print(_saved);
    });
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    AutoOrientation.portraitAutoMode();
    super.dispose();
  }

  Widget connectionState(Widget page) {
    return page;
  }

  Widget connectionOffline() {
    return Container(
      child: Center(
        child: Text('No Internet Connection',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget finalConnection;

  @override
  Widget build(BuildContext context) {
    String _url = '';

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

    String _dynamicUrl;

    Future<void> createAnimeLink(
        String title, String id, String imageurl) async {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://aniflix.page.link',
        link: Uri.parse('https://aniflix.com/anime?id=$id'),
        androidParameters: AndroidParameters(
          packageName: 'com.anime.aniflix',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: title,
          description: 'Watch free on AniFlix',
          imageUrl: Uri.parse(imageurl),
        ),
      );

      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      Uri uri = shortLink.shortUrl;

      setState(() {
        _dynamicUrl = uri.toString();
      });
    }

    return StreamBuilder(
        stream: DatabaseServices().anime,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final result =
              snapshot.data.where((e) => e.id == widget.movieid).toList();

          if (result.isNotEmpty) {
            return Scaffold(
              //backgroundColor: Color(0xff1c1742),
              backgroundColor: Color(0xff001030),
              body: SafeArea(
                child: OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult connectivity, Widget child) {
                    final bool connected =
                        connectivity != ConnectivityResult.none;
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        child,
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          height: 15.0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            color: connected
                                ? Colors.transparent
                                : Color(0xFFEE4400),
                            child: connected
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "OFFLINE",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                        height: 12.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        centerTitle: true,
                        title: Text(
                          'ANIFLIX',
                          style: TextStyle(
                            fontFamily: 'Bebas Neue',
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // leading: IconButton(
                        //   padding: EdgeInsets.only(left: 30.0),
                        //   onPressed: () => Navigator.pop(context),
                        //   icon: Icon(Icons.arrow_back),
                        //   iconSize: 25.0,
                        //   color: Colors.white,
                        // ),
                        // actions: <Widget>[
                        //   IconButton(
                        //     padding: EdgeInsets.only(right: 30.0),
                        //     onPressed: () => print('Add to Favorites'),
                        //     icon: Icon(Icons.favorite_border),
                        //     iconSize: 25.0,
                        //     color: Colors.white,
                        //   ),
                        // ],
                        //backgroundColor: Color(0xff1c1742),
                        backgroundColor: Color(0xff001030),
                        elevation: 0.0,
                        pinned: true,
                        expandedHeight:
                            MediaQuery.of(context).size.height / 2.2,
                        flexibleSpace: FlexibleSpaceBar(
                          background: ListView(children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 10.0),
                                  transform: Matrix4.translationValues(
                                      0.0, -50.0, 0.0),
                                  child: Hero(
                                    tag: result[0].title,
                                    child: ClipShadowPath(
                                      clipper: CircularClipper(),
                                      shadow: Shadow(blurRadius: 20.0),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/source.gif',
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.2,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.fitHeight,
                                        image: result[0].imageUrl,
                                      ),
                                    ),
                                  ),
                                ),
                                // Positioned.fill(
                                //   bottom: 10.0,
                                //   child: Align(
                                //     alignment: Alignment.bottomCenter,
                                //     child: RawMaterialButton(
                                //       padding: EdgeInsets.all(10.0),
                                //       elevation: 12.0,
                                //       onPressed: () => print('Play Video'),
                                //       shape: CircleBorder(),
                                //       fillColor: Colors.white,
                                //       child: Icon(
                                //         Icons.play_arrow,
                                //         size: 60.0,
                                //         color: Colors.red,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Positioned(
                                  bottom: 5.0,
                                  left: 25.0,
                                  // child: IconButton(
                                  //   //padding: EdgeInsets.only(right: 30.0),
                                  //   onPressed: () => print('Add to Favorites'),
                                  //   icon: Icon(Icons.favorite_border),
                                  //   iconSize: 25.0,
                                  //   color: Colors.white,
                                  // ),
                                  child: _buildRow(result[0].id.toString()),
                                ),
                                Positioned(
                                  bottom: 5.0,
                                  right: 25.0,
                                  child: IconButton(
                                    icon: Icon(Icons.share),
                                    iconSize: 25.0,
                                    color: Colors.white,
                                    onPressed: () async {
                                      setState(() {
                                        _dynamicUrl = result[0].uri.toString();
                                      });
                                      // await createAnimeLink(
                                      //     result[0].title,
                                      //     result[0].id.toString(),
                                      //     result[0].imageUrl.toString());
                                      if (_dynamicUrl != null) {
                                        await Share.share(_dynamicUrl);
                                        //await launch(_dynamicUrl);
                                        print(_dynamicUrl);
                                      } else
                                        print("Dynamic link is null");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    result[0].title.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    result[0].categories,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 12.0),
                                  // Text(
                                  //   '⭐ ⭐ ⭐ ⭐',
                                  //   style: TextStyle(fontSize: 25.0),
                                  // ),
                                  RatingBarIndicator(
                                    rating: result[0].rating / 2,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 25.0,
                                    direction: Axis.horizontal,
                                  ),
                                  SizedBox(height: 15.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            'Type',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(height: 2.0),
                                          Text(
                                            result[0].type.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            'Released',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(height: 2.0),
                                          Text(
                                            result[0].year.toString(),
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            'Status',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(height: 2.0),
                                          Text(
                                            result[0].status.toString(),
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            'Length',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(height: 2.0),
                                          Text(
                                            '${result[0].length}',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 25.0),
                                  // Container(
                                  //   width: MediaQuery.of(context).size.width,
                                  //   height: 150.0,
                                  //   child: SingleChildScrollView(
                                  //     child: Text(
                                  //       widget.movie.description,
                                  //       style: TextStyle(
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Column(children: <Widget>[
                                    new ConstrainedBox(
                                        constraints: widget.isExpanded
                                            ? new BoxConstraints()
                                            : new BoxConstraints(
                                                maxHeight: 65.0),
                                        child: new Text(
                                          result[0].description,
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    widget.isExpanded
                                        ? new IconButton(
                                            icon: Icon(
                                              Icons.keyboard_arrow_up,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => setState(() =>
                                                widget.isExpanded = false))
                                        : new IconButton(
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => setState(
                                                () => widget.isExpanded = true))
                                  ]),
                                  SizedBox(
                                    height: 7.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Episodes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '1-${result[0].episode.length}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              scrollDirection: Axis.vertical,
                              itemCount: result[0].episode.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: 3.0, bottom: 5.0),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 14.0,
                                    //margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                                    borderRadius: BorderRadius.circular(24.0),
                                    shadowColor: Colors.black,

                                    child: ListTile(
                                      //leading: uncheck,
                                      title: Text(
                                        'Episode ' + (index + 1).toString(),
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black38,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),

                                      onTap: () {
                                        setState(() {
                                          _url = result[0].episode[index];
                                          _videoLaunch(_url);
                                        });
                                      },
                                    ),

                                    // child: _buildRow(
                                    //     index, result[0].episode[index]),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else
            return Container(
              child: Center(
                child: Text('No Data', style: TextStyle(color: Colors.white)),
              ),
            );
        });
  }

  Widget _buildRow(String id) {
    final bool alreadySaved = _saved.contains(id);
    return IconButton(
      icon: new Icon(
        // Add the lines from here...
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : Colors.white,
      ),
      onPressed: () async {
        setState(() {
          if (alreadySaved) {
            _saved.remove(id);
            SharedPreferencesHelper.setSavedId(_saved);
            print(_saved);
          } else {
            _saved.add(id);
            SharedPreferencesHelper.setSavedId(_saved);
            print(_saved);
          }
        });
      },
    );
    // ... to here.
  }
}
