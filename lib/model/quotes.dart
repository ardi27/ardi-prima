class Quotes {
  String sId;
  String sr;
  String en;
  String author;
  String rating;
  String id;

  Quotes({this.sId, this.sr, this.en, this.author, this.rating, this.id});

  Quotes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sr = json['sr'];
    en = json['en'];
    author = json['author'];
    rating = json['rating'].toString();
    id = json['id'];
  }
}
