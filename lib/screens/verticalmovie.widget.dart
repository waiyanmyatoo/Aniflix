import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';
import 'package:flutter_netflix_ui_redesign/screens/dynamicScreen.dart';
import 'package:flutter_netflix_ui_redesign/screens/movie_screen.dart';
import 'package:flutter_netflix_ui_redesign/services/database.dart';
import 'package:provider/provider.dart';

class VerticalMovieWidge extends StatelessWidget {
  final String typeMovie;
  final String title;

  const VerticalMovieWidge({Key key, this.typeMovie, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final anime = Provider.of<List<Movie>>(context) ?? [];

    if (anime.isNotEmpty) {
      return Container(
        //margin: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => dynamicPage(
                          title: title,
                          type: typeMovie,
                        ),
                      ),
                    ),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 250.0,
              child: listView(
                  anime.where((e) => e.typeMovie == typeMovie).toList()),
            ),
          ],
        ),
      );
    } else {
      // return Center(
      //   child: CircularProgressIndicator(
      //     backgroundColor: Colors.white38,
      //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      //   ),
      // );
      return Container();
    }
  }

  listView(List<Movie> movies) => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            //color: Colors.green,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieScreen(
                    movieid: movies[index].id,
                    animeUri: movies[index].uri,
                  ),
                ),
              ),
              child: Container(
                //color: Colors.green,
                width: MediaQuery.of(context).size.width / 3,
                height: 270,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 7.0,
                        vertical: 15.0,
                      ),
                      //width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black54,
                        //     offset: Offset(0.0, 4.0),
                        //     blurRadius: 6.0,
                        //   ),
                        // ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        //   child: FadeInImage.assetNetwork(
                        //     placeholder: 'assets/images/source.gif',
                        //     height: 190.0,
                        //     width: double.infinity,
                        //     fit: BoxFit.cover,
                        //     image: movies[index].tvShowPoster,
                        //   ),
                        child: CachedNetworkImage(
                          height: 190.0,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          imageUrl: movies[index].tvShowPoster,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/source.gif',
                            height: 190,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Text(
                      movies[index].title,
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
