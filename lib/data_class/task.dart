class task{
  static const String collectionName = 'tasks';
  String? title;
  String? desc;
  DateTime? date;
  String? id;
  bool? isDone;

  task({this.id = '' , required this.title,required this.date ,required this.desc,this.isDone = false});

  task.fromFireStore(Map<String,dynamic>data):this(
    id:data['id'] ,
    title: data['title'] ,
    date: DateTime.fromMicrosecondsSinceEpoch(data['date']),
    desc:data['desc']  ,
    isDone: data['isDone']
  );
  Map<String,dynamic> toFireStore(){
    return{
      'id' : id,
      'desc' : desc,
      'date' : date?.microsecondsSinceEpoch,
      'title' : title,
      'isDone':isDone
    };
  }
}