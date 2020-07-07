import 'package:flutter/material.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';
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
                  onTap: () => print('View  '),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 250.0,
            child:
                listView(anime.where((e) => e.typeMovie == typeMovie).toList()),
          ),
        ],
      ),
    );
  }

  listView(List<Movie> movies) => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            //color: Colors.green,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieScreen(movieid: movies[index].id),
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
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/source.gif',
                          height: 190.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          image: movies[index].tvShowPoster,
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
