import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';
import 'package:flutter_netflix_ui_redesign/screens/movie_screen.dart';
import 'package:flutter_netflix_ui_redesign/services/database.dart';
import 'package:provider/provider.dart';

class dynamicPage extends StatefulWidget {
  final String title;
  final String type;

  dynamicPage({this.title, this.type});

  @override
  _dynamicPageState createState() => _dynamicPageState();
}

class _dynamicPageState extends State<dynamicPage> {
  String _selectedGenre;
  // List _genres = [
  //   "All",
  //   "Action",
  //   "Adventure",
  //   "Cars",
  //   "Comedy",
  //   "Dementia",
  //   "Demons",
  //   "Drama",
  //   "Ecchi",
  //   "Fantasy",
  //   "Game",
  //   "Harem",
  //   "Historical",
  //   "Horror",
  //   "Josei",
  //   "Kids",
  //   "Magic",
  //   "Martial Arts",
  //   "Mecha",
  //   "Military",
  //   "Music",
  //   "Mystery",
  //   "Parody",
  //   "Police",
  //   "Psychological",
  //   "Romance",
  //   "Samurai",
  //   "School",
  //   "Sci-Fi",
  //   "Seinen",
  //   "Shoujo",
  //   "Shoujo Ai",
  //   "Shounen",
  //   "Shounen Ai",
  //   "Slice of Life",
  //   "Space",
  //   "Sports",
  //   "Super Power",
  //   "Supernatural",
  //   "Thriller",
  //   "Vampire",
  //   "Yaoi",
  //   "Yuri"
  // ];
  List<Movie> result;

  Widget noAnime() {
    return Container(
      child: Center(
        child: Text('No result found!', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget initStateAnime() {
    return StreamBuilder<List<Movie>>(
      stream: DatabaseServices().anime,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white38,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }
        result =
            snapshot.data.where((a) => a.typeMovie == widget.type).toList();

        if (result.isNotEmpty) {
          return gridView(result.toList(), context);
        } else
          return noAnime();
      },
    );
  }

  Widget finalResult;

  @override
  void initState() {
    //initStateAnime();
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    // final anime = Provider.of<List<Movie>>(context) ?? [];
    // result = anime.where((e) => e.typeMovie == widget.type).toList();

    return StreamProvider<List<Movie>>.value(
      value: DatabaseServices().anime,
      child: Scaffold(
        backgroundColor: Color(0xff001030),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: appBarTitle,
          ),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.filter_list),
                  //   color: Colors.white,
                  //   iconSize: 30.0,
                  //   onPressed: () {
                  //     _showSettingsPanel(context);
                  //   },
                  // )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            new Expanded(
              child: initStateAnime(),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        )),
      ),
    );

    // void _showSettingsPanel(context) {
    //   showModalBottomSheet(
    //       backgroundColor: Colors.transparent,
    //       context: context,
    //       builder: (BuildContext bc) {
    //         return Container(
    //           height: MediaQuery.of(context).size.height / 2.5,
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.only(
    //                 topRight: Radius.circular(30),
    //                 topLeft: Radius.circular(30)),
    //           ),
    //           child: Padding(
    //             padding: EdgeInsets.all(8.0),
    //             child: Center(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: <Widget>[
    //                   Text(
    //                     'Filter by Genres',
    //                     style: TextStyle(
    //                       fontSize: 20.0,
    //                       fontWeight: FontWeight.w600,
    //                       color: Colors.black87,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Flexible(
    //                     child: ListView(shrinkWrap: true, children: <Widget>[
    //                       Wrap(
    //                           direction: Axis.horizontal,
    //                           spacing: 3.0,
    //                           runSpacing: 3.0,
    //                           children: _genres
    //                               .map<Column>((a) => Column(
    //                                     children: <Widget>[
    //                                       Padding(
    //                                         padding: const EdgeInsets.all(2.0),
    //                                         child: RaisedButton(
    //                                             color: new Color(0xffeadffd),
    //                                             child: Text(
    //                                               a.toString(),
    //                                               style: TextStyle(
    //                                                 color:
    //                                                     new Color(0xff6200ee),
    //                                               ),
    //                                             ),
    //                                             onPressed: () {
    //                                               setState(() {
    //                                                 _selectedGenre =
    //                                                     a.toString();
    //                                                 print(_selectedGenre);
    //                                                 result = anime
    //                                                     .where((e) =>
    //                                                         e.categories
    //                                                             .toLowerCase()
    //                                                             .contains(a
    //                                                                 .toString()
    //                                                                 .toLowerCase()) &&
    //                                                         e.type ==
    //                                                             widget.type)
    //                                                     .toList();
    //                                                 if (a == 'All') {
    //                                                   finalResult =
    //                                                       initStateAnime();
    //                                                 } else if (result.isEmpty) {
    //                                                   finalResult = noAnime();
    //                                                 } else
    //                                                   finalResult = gridView(
    //                                                       result, context);
    //                                               });
    //                                             },
    //                                             shape: RoundedRectangleBorder(
    //                                               borderRadius:
    //                                                   BorderRadius.circular(
    //                                                       30.0),
    //                                             )),
    //                                       ),
    //                                     ],
    //                                   ))
    //                               .toList()),
    //                     ]),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       });
    // }
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
                              // child: FadeInImage.assetNetwork(
                              //   placeholder: 'assets/images/source.gif',
                              //   height: 180.0,
                              //   width: double.infinity,
                              //   fit: BoxFit.cover,
                              //   image: a.tvShowPoster,
                              // ),
                              child: CachedNetworkImage(
                                height: 180.0,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                imageUrl: a.tvShowPoster,
                                placeholder: (context, url) => Image.asset(
                                  'assets/images/source.gif',
                                  height: 180,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            a.title,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
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
}
