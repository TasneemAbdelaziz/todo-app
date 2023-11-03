import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist/data_class/my_user.dart';
import 'package:todolist/data_class/task.dart';
class firebaseUtils{

  static CollectionReference<task> getTasksCollections(String uId){
    return
      getUsersCollections().doc(uId).
      collection(task.collectionName)
        .
    withConverter(
        fromFirestore: (snapshot,options)=>task.fromFireStore(snapshot.data()!),
        toFirestore: (tasks,options)=>tasks.toFireStore()
    );
  }

  static Future<void> addTaskToFirebase(task tasks,String uId) {
    var taskCollection = getTasksCollections(uId);
    var doc = taskCollection.doc();
    tasks.id = doc.id;
    return doc.set(tasks);
  }

  static Future<void> editTaskToFirebase(task tasks,String uId) {
    return getTasksCollections(uId)
        .doc(tasks.id)
        .update(tasks.toFireStore());
  }

  static Future<void> deleteTask(task tasks,String uId) {
    return getTasksCollections(uId).doc(tasks.id).delete();
  }


  static CollectionReference<myUser> getUsersCollections() {
    return
      FirebaseFirestore.instance.collection(myUser.collectionName).
    withConverter(
          fromFirestore: (snapshot, options) => myUser.fromFireStore(snapshot.data()),
          toFirestore: (user,options)=> user.toFireStore());
  }

  static Future<void> addUserToFirestore(myUser MyUser){
   return getUsersCollections().doc(MyUser.id).set(MyUser);
  }

  static Future<myUser?> readUserFromFirestore(String id)async{
    var query= await getUsersCollections().doc(id).get();
    return query.data();
  }

  static Future<void> updateTask(task tasks,String uId) {

    return  getTasksCollections(uId)
        .doc(tasks.id)
        .update({'isDone':tasks.isDone});
  }



}