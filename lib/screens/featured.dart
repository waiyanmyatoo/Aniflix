import 'package:flutter/material.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';
import 'package:flutter_netflix_ui_redesign/screens/movie_screen.dart';
import 'package:flutter_netflix_ui_redesign/screens/verticalmovie.widget.dart';
import 'package:flutter_netflix_ui_redesign/services/database.dart';
import 'package:flutter_netflix_ui_redesign/widgets/content_scroll.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:frefresh/frefresh.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
    //db.UpdateAnime();
  }

  // _movieSelector(int index,BuildContext context) {
  //    final anime = Provider.of<List<Movie>>(context) ?? [];
  //   //db.UpdateAnime();

  // }

  @override
  Widget build(BuildContext context) {
    try {
      final anime = Provider.of<List<Movie>>(context) ?? [];
      final List<Movie> result =
          anime.where((element) => element.typeMovie == 'Featured').toList();

      if (anime.isNotEmpty) {
        return ListView(
          children: <Widget>[
            Container(
              //color: Colors.green,
              height: ((MediaQuery.of(context).size.height) / 2.8) - 20,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController,
                itemCount: result.length,
                itemBuilder: (context, int index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (BuildContext context, Widget widget) {
                      double value = 1;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page - index;
                        value =
                            (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
                      }
                      return Center(
                        child: SizedBox(
                          height: Curves.easeInOut.transform(value) *
                              (MediaQuery.of(context).size.width / 1.8),
                          width: Curves.easeInOut.transform(value) * 400.0,
                          child: widget,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieScreen(
                            movieid: result[index].id,
                            animeUri: result[index].uri,
                          ),
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 3.0, vertical: 14.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black45,
                                //     offset: Offset(0.0, 4.0),
                                //     blurRadius: 6.0,
                                //   ),
                                // ],
                              ),
                              child: Center(
                                child: Hero(
                                  tag: anime[index].id,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    // child: FadeInImage.assetNetwork(
                                    //   placeholder: 'assets/images/source.gif',
                                    //   image: result[index].imageUrl,
                                    //   height: 220.0,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    child: CachedNetworkImage(
                                      height: 220.0,
                                      fit: BoxFit.cover,
                                      imageUrl: result[index].imageUrl,
                                      placeholder: (context, url) => Center(
                                        child: Image.asset(
                                            'assets/images/source.gif'),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0.0,
                            right: 0.0,
                            bottom: 10.0,
                            child: Container(
                              color: Hexcolor('#18242b')
                                  .withBlue(60)
                                  .withOpacity(0.6),
                              width: 250.0,
                              height: 40,
                              child: Center(
                                child: Text(
                                  result[index].title.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 50.0,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: labels.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    width: 130.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Hexcolor('#84C9FB').withAlpha(40),
                      // gradient: LinearGradient(
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      //   colors: [
                      //     Colors.pink,
                      //     Colors.red,
                      //   ],
                      // ),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.red,
                      //     offset: Offset(0.0, 6.0),
                      //     blurRadius: 6.0,
                      //   ),
                      // ],
                    ),
                    child: Center(
                      child: Text(
                        labels[index].toUpperCase(),
                        style: TextStyle(
                          //color: Color(0xff001030),
                          color: Hexcolor('#84C9FB'),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15.0),
            VerticalMovieWidge(title: 'Popular', typeMovie: "Popular"),
            SizedBox(height: 15.0),
            VerticalMovieWidge(title: 'Trending', typeMovie: "Popular"),
            SizedBox(
              height: 20,
            ),
          ],
        );
      } else {
        return Container(
            // child: CircularProgressIndicator(
            //   backgroundColor: Colors.white38,
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            // ),
            //child: Image.asset('assets/images/source.gif')
            );
      }
    } catch (e) {
      return Center(
        child: Text(e),
      );
    }
  }
}
