import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';
import 'package:flutter_netflix_ui_redesign/screens/movie_screen.dart';
import 'package:flutter_netflix_ui_redesign/screens/prefsClass.dart';
import 'package:flutter_netflix_ui_redesign/services/database.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class Favorited extends StatefulWidget {
  final String title;
  final String type;

  Favorited({this.title, this.type});

  @override
  _FavoritedState createState() => _FavoritedState();
}

class _FavoritedState extends State<Favorited> {
  String _selectedGenre;
  List _genres = [
    "All",
    "Action",
    "Adventure",
    "Cars",
    "Comedy",
    "Dementia",
    "Demons",
    "Drama",
    "Ecchi",
    "Fantasy",
    "Game",
    "Harem",
    "Historical",
    "Horror",
    "Josei",
    "Kids",
    "Magic",
    "Martial Arts",
    "Mecha",
    "Military",
    "Music",
    "Mystery",
    "Parody",
    "Police",
    "Psychological",
    "Romance",
    "Samurai",
    "School",
    "Sci-Fi",
    "Seinen",
    "Shoujo",
    "Shoujo Ai",
    "Shounen",
    "Shounen Ai",
    "Slice of Life",
    "Space",
    "Sports",
    "Super Power",
    "Supernatural",
    "Thriller",
    "Vampire",
    "Yaoi",
    "Yuri"
  ];
  List<Movie> result;
  static Set _saved;

  @override
  void initState() {
    SharedPreferencesHelper.getSavedId().then(getId);

    super.initState();
  }

  void getId(List id) async {
    setState(() {
      print("Id length is ${id.length}");
      if (id.length == 0) {
        _saved = null;
      } else
        _saved = id.toSet();
    });
  }

  Widget noAnime() {
    return Container(
      child: Column(
        children: <Widget>[
          initStateAnime(),
          Expanded(
            child: Center(
              child: Text(
                'No favorite found!',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget initStateAnime() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
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
        ],
      ),
    );
  }

  Widget finalResult;

  @override
  Widget build(BuildContext context) {
    //finalResult = initStateAnime(_saved.toList());
    final anime = Provider.of<List<Movie>>(context) ?? [];
    result = anime.toList();
    //print("Saved length is ${_saved.length}");
    if (_saved == null) {
      return noAnime();
    } else {
      List<Movie> fav = List<Movie>(_saved?.length ?? 0);
      for (var i = 0; i < _saved.length; i++) {
        for (var j = 0; j < result.length; j++) {
          if (_saved.elementAt(i) == result[j].id) {
            //fav.add(result[j]);
            fav[i] = result[j];
            print("Added");
          } else {
            //print(result[i].id.toString());
            print("Not contain");
          }
        }
      }
      if (fav.isNotEmpty) {
        return Container(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            initStateAnime(),
            SizedBox(
              height: 10,
            ),
            new Expanded(child: gridView(fav, context)),
            SizedBox(
              height: 20,
            ),
          ],
        ));
      } else {
        return noAnime();
      }
    }
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
                        builder: (_) =>
                            MovieScreen(movieid: a.id, animeUri: a.uri),
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
