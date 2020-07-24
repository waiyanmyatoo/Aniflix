import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';

class DatabaseServices {
  static final String _baseUrl = 'anime';

  final CollectionReference _db;

  DatabaseServices() : _db = Firestore.instance.collection(_baseUrl);

  Future updateAnime(
    String name,
    String img,
    String type,
    String aired,
    String status,
    String genre,
    double score,
    String length,
    String animeuri,
    String desc,
  ) async {
    String aid;
    if (aid == null) aid = _db.document().documentID;

    return await _db.document(name).setData({
      "Id": name,
      "ImageUrl": img,
      "Title": name,
      "TvShowPoster": img,
      "Type": type,
      "TypeMovie": 'Popular',
      "Categories": genre,
      "Rating": score,
      "Year": aired,
      "Status": status,
      "Length": length,
      "Description": desc,
      "Uri": animeuri,
    });
  }

  List<Movie> _animeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Movie(
        id: doc.data['Id'],
        imageUrl: doc.data['ImageUrl'],
        title: doc.data['Title'],
        tvShowPoster: doc.data['TvShowPoster'],
        rating: doc.data['Rating'],
        type: doc.data['Type'],
        typeMovie: doc.data['TypeMovie'],
        categories: doc.data['Categories'],
        year: doc.data['Year'],
        status: doc.data['Status'],
        length: doc.data['Length'],
        description: doc.data['Description'],
        //createdIn: doc.data['CreatedIn'].toDate(),
        //episode: List.from(doc.data['Episode']),
        uri: doc.data['Uri'],
      );
    }).toList();
  }

  Stream<List<Movie>> get anime {
    return _db.snapshots().map(_animeListFromSnapshot);
  }
}
