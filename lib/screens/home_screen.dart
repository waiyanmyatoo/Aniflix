import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';
import 'package:flutter_netflix_ui_redesign/screens/anime_series.dart';
import 'package:flutter_netflix_ui_redesign/screens/anime_movies.dart';
import 'package:flutter_netflix_ui_redesign/screens/favorite.dart';
import 'package:flutter_netflix_ui_redesign/screens/featured.dart';
import 'package:flutter_netflix_ui_redesign/screens/movie_screen.dart';
import 'package:flutter_netflix_ui_redesign/splashScreen.dart';
import 'package:flutter_netflix_ui_redesign/widgets/content_scroll.dart';
import 'package:flutter_netflix_ui_redesign/services/database.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Image(
  //   image: AssetImage('assets/images/netflix_logo.png'),
  //   height: 60.0,
  //   width: 150.0,
  // );

  PageController _pageController;
  Timer _timerLink;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
    //WidgetsBinding.instance.addObserver(this);
    this._retrieveDynamicLink();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _retrieveDynamicLink();
  //   }
  // }

  Future<void> _retrieveDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      var isAnime = deepLink.pathSegments.contains('anime');
      if (isAnime) {
        var id = deepLink.queryParameters['id'];

        if (id != null) {
          _timerLink = new Timer(const Duration(milliseconds: 850), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieScreen(movieid: id),
              ),
            );
          });
        }
      }
    } else {
      print("Deep link : " + deepLink.toString());
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        //Navigator.pushNamed(context, deepLink.path);
        print('_handleDeepLink | deeplink:1 $deepLink');
        var isAnime = deepLink.pathSegments.contains('anime');
        if (isAnime) {
          var id = deepLink.queryParameters['id'];

          if (id != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieScreen(movieid: id),
              ),
            );
          }
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  @override
  void dispose() {
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  DateTime currentBackPressTime;

  Icon menuBtn = new Icon(Icons.sort);
  Icon searchIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text(
    'ANIFLIX',
    style: TextStyle(
      fontFamily: 'Bebas Neue',
      fontSize: 23.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 2.0,
    ),
    textAlign: TextAlign.center,
  );

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to leave");
      return Future.value(false);
    }
    return Future.value(true);
  }

  int _currentIndex = 2;

  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return AnimeMovies(
          title: 'Movies',
          type: 'Movie',
        );
      case 1:
        return AnimeSeries(
          title: 'Series',
          type: 'TV',
        );
      case 2:
        return Featured();
      case 3:
        return Favorited(
          title: 'Favorited',
          type: 'TV',
        );
      case 4:
        return Container(
          child: Center(
            child: Text('Coming Soon', style: TextStyle(color: Colors.white)),
          ),
        );

        break;
      default:
        return Featured();
    }
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
    //final anime = Provider.of<List<Movie>>(context) ?? [];
    return StreamProvider<List<Movie>>.value(
      value: DatabaseServices().anime,
      child: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     Color(0xffED46D5),
          //     Color(0xffAA6AE0),
          //     Color(0xff7089EB),
          //     Color(0xff37A6F4),
          //     Color(0xff2DA9F0),
          //   ],
          // ),
          //color: Color(0xff171723),
          color: Color(0xff001030),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          //backgroundColor: Colors.deepPurple[700].withOpacity(0.9),
          //backgroundColor: Color(0xff001030),
          //backgroundColor: Color(0xFF2D2F41),
          //backgroundColor: Color(0xff171723),
          // backgroundColor: LinearGradient(
          //             begin: Alignment.topLeft,
          //             end: Alignment.bottomRight,
          //             colors: [
          //               Colors.pink,
          //               Colors.red,
          //             ],
          //           ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: appBarTitle,
            ),
            // leading: IconButton(
            //   padding: EdgeInsets.only(left: 30.0),
            //   onPressed: () {
            //     print('Menu');
            //   },
            //   icon: menuBtn,
            //   iconSize: 30.0,
            //   color: Colors.white,
            // ),
            actions: <Widget>[
              Builder(
                builder: (context) => IconButton(
                  padding: EdgeInsets.only(right: 8.0),
                  onPressed: () async {
                    final Movie result = await showSearch(
                        context: context, delegate: AnimeSearch());
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieScreen(movieid: result.id),
                        ),
                      );
                    }
                  },
                  icon: searchIcon,
                  iconSize: 30.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: WillPopScope(
              onWillPop: onWillPop,
              child: OfflineBuilder(
                connectivityBuilder: (BuildContext context,
                    ConnectivityResult connectivity, Widget child) {
                  final bool connected =
                      connectivity != ConnectivityResult.none;
                  if (connected == true) {
                    return finalConnection =
                        connectionState(callPage(_currentIndex));
                  }
                  return finalConnection = connectionState(connectionOffline());
                },
                child: Container(child: finalConnection),
              ),
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            color: Colors.white,
            animationDuration: Duration(
              milliseconds: 500,
            ),
            animationCurve: Curves.easeInOut,
            backgroundColor: Color(0xff001030),
            height: MediaQuery.of(context).padding.top * 2,
            index: 2,
            items: <Widget>[
              Icon(
                Icons.movie,
                size: 25.0,
                color: Color(0xff000f34),
              ),
              Icon(Icons.live_tv, size: 25.0, color: Color(0xff000f34)),
              Icon(Icons.home, size: 25.0, color: Color(0xff000f34)),
              Icon(Icons.favorite, size: 25.0, color: Color(0xff000f34)),
              Icon(Icons.settings, size: 25.0, color: Color(0xff000f34)),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

class AnimeSearch extends SearchDelegate<Movie> {
  // final Stream<List<Movie>> animes;

  // AnimeSearch({this.animes});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Movie>>(
      stream: DatabaseServices().anime,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('No data!'),
          );
        }

        final results = snapshot.data
            .where((a) => a.title.toLowerCase().contains(query.toLowerCase()));

        if (results.isNotEmpty) {
          if (query.isNotEmpty) {
            return Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.live_tv,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Results',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.black38,
                  ),
                  new Expanded(
                    child: gridView(results.toList(), context),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text("You didn't search anything."),
          );
        }
        return Center(
          child: Text('No result found'),
        );
      },
    );
  }

  gridView(List<Movie> movie, BuildContext context) => GridView.count(
        padding: EdgeInsets.all(5.0),
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: ((MediaQuery.of(context).size.width / 3) + 10) / 250,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: movie
            .map((a) => Container(
                  // width: 150,
                  // height: 270,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieScreen(movieid: a.id),
                      ),
                    ),
                    child: Container(
                      //color: Colors.red,

                      //padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                      // margin: EdgeInsets.symmetric(
                      //   horizontal: 5.0,
                      //   vertical: 15.0,
                      // ),
                      //width: 150,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10.0),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.black54,
                      //       offset: Offset(0.0, 4.0),
                      //       blurRadius: 6.0,
                      //     ),
                      //   ],
                      // ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13.0),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/source.gif',
                                height: 180.0,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                image: a.tvShowPoster,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            a.title,
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.0),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<Movie>>(
      stream: DatabaseServices().anime,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('No data!'),
          );
        }

        final results = snapshot.data
            .where((a) => a.title.toLowerCase().contains(query.toLowerCase()));

        if (results.isNotEmpty) {
          if (query.isNotEmpty) {
            return Container(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                new Expanded(
                  child: gridView(results.toList(), context),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ));
          }
          final bestAnime =
              snapshot.data.where((a) => a.typeMovie == "Featured");
          return Container(
            child: Column(children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.live_tv,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Best Anime Series of All Time',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                indent: 15,
                endIndent: 15,
                color: Colors.black38,
              ),
              new Expanded(
                child: gridView(bestAnime.toList(), context),
              ),
            ]),
          );
        }
        return Center(
          child: Text('No result found'),
        );
      },
    );
  }
}
