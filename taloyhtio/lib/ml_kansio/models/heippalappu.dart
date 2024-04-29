class Heippalappu {
  Heippalappu(
      {required this.title,
      required this.message,
      required this.id,
      required this.timeStamp,
      required this.likes,
      required this.dislikes,
      required this.reporters});
  final String title;
  final String message;
  //lisäys, jotta voi poistaa vain itse tallentamansa heippalapun
  final String id;
  final String timeStamp;
  final List likes;
  final List dislikes;
  final List reporters;

  factory Heippalappu.fromJson(Map<Object?, Object?> json) {
    return Heippalappu(
      title: json['title'].toString(),
      message: json['message'].toString(),
      id: json['id'].toString(),
      timeStamp: json['time'].toString(),
      likes: json['likes'] == null ? [] : List.from(json['likes'] as List),
      dislikes:
          json['dislikes'] == null ? [] : List.from(json['dislikes'] as List),
      reporters:
          json['reporters'] == null ? [] : List.from(json['reporters'] as List),
      //reporters: json['reporters'] == null ? [] :Report.toReportList(json['reporters']),
    );
  }
}
