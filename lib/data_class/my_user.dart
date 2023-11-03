class myUser{
  String? id;
  String? name;
  String? email;

  static String collectionName = 'users';
  myUser({required this.id,required this.name,required this.email});

  Map<String,dynamic> toFireStore(){
    return{
      'id':id,
      'name':name,
      'email':email,
    };
  }

  myUser.fromFireStore(Map<String,dynamic>?data):this(
    id: data?['id'],
    name: data?['name'],
    email: data?['email']
  );
}