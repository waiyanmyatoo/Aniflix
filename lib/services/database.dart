import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';

class DatabaseServices {
  static final String _baseUrl = 'anime';

  final CollectionReference _db;

  DatabaseServices() : _db = Firestore.instance.collection(_baseUrl);

  Future updateAnime(
    String id,
  ) async {
    String aid;
    if (aid == null) aid = _db.document().documentID;

    return await _db.document(id).setData({
      "Id": id,
      "ImageUrl": 'https://gogocdn.net/images/anime/One-piece.jpg',
      "Title": 'Naruto: Shippuuden',
      "TvShowPoster": 'https://gogocdn.net/images/anime/One-piece.jpg',
      "Type": 'TV',
      "TypeMovie": 'Popular',
      "Categories":
          'Action, Adventure, Comedy, Super Power, Martial Arts, Shounen',
      "Rating": 3,
      "Released": '2007',
      "Status": 'Complete',
      "Length": '23 min. per ep.',
      "Description":
          'It has been two and a half years since Naruto Uzumaki left Konohagakure, the Hidden Leaf Village, for intense training following events which fueled his desire to be stronger. Now Akatsuki, the mysterious organization of elite rogue ninja, is closing in on their grand plan which may threaten the safety of the entire shinobi world',
      "CreatedIn": DateTime.now(),
      "Episode": [
        '1',
        '2',
        '3',
      ]
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
        createdIn: doc.data['CreatedIn'].toDate(),
        episode: List.from(doc.data['Episode']),
        uri: doc.data['Uri'],
      );
    }).toList();
  }

  Stream<List<Movie>> get anime {
    return _db.snapshots().map(_animeListFromSnapshot);
  }
}
