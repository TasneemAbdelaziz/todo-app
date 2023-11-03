import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/dialogs.dart';
import 'package:todolist/firebase/firebase_utils.dart';
import 'package:todolist/home-screen.dart';
import 'package:todolist/Theming/my-theme.dart';
import 'package:todolist/provider/AuthProvider.dart';
import 'package:todolist/register/sign_up.dart';

class signIn extends StatefulWidget{
  static String routeName = "sign_in";

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  String password = '';

  String email ='';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: myTheme.greenColor,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Image.asset("assets/images/background.png",width: double.infinity
                  ,height: double.infinity,
                  fit: BoxFit.fill,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                    Text("Login",style:Theme.of(context).textTheme.titleLarge?.copyWith(color: myTheme.whiteColor),textAlign: TextAlign.center,),
                    // Spacer(flex: 4,),
                    Form(
                      key: formKey,
                      child:
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [

                              Spacer(flex: 10,),
                              TextFormField(

                                onChanged:(value){
                                  email = value;
                                },
                                keyboardType: TextInputType.emailAddress,

                                decoration: InputDecoration(
                                  // focusedBorder:OutlineInputBorder(
                                  //   borderSide:  BorderSide(color: myTheme.primaryLight , width: 2.0),
                                  //   borderRadius: BorderRadius.circular(10.0),
                                  // ),
                                  //   enabledBorder: OutlineInputBorder(
                                  //     borderSide: BorderSide(
                                  //         width: 3,
                                  //         color: myTheme.primaryLight
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(20.0),
                                  //   ),
                                  labelText: 'Email',
                                  labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                ),
                                validator: (value){
                                  if(value == null || value.trim().isEmpty)
                                  {
                                    return 'please enter email';
                                  }
                                  else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value))
                                  {
                                    return'enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              Spacer(flex: 1,),
                              TextFormField(
                                obscureText: true,
                                onChanged: (value){
                                  password = value;
                                },
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Password',
                                  labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                ),
                                validator: (value){
                                  if(value == null || value.trim().isEmpty)
                                  {
                                    return 'please enter password';
                                  }
                                },
                              ),

                              Spacer(flex: 4,),

                              ElevatedButton(onPressed:(){
                                if(formKey.currentState!.validate()){
                                  login();
                                }
                              },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(13),
                                  elevation: 0,
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Login"),
                                      Spacer(),
                                      Icon(Icons.arrow_forward),
                                    ]
                                ),),
                              Spacer(flex: 1,),
                              Row(
                                children: [
                                  Text("Create a new ",style: Theme.of(context).textTheme.bodySmall,),
                                  InkWell(
                                      child: Text("Account"),
                                    onTap: (){
                                        Navigator.of(context).pushNamed(signUp.routeName);
                                    },
                                  ),
                                ],
                              ),
                              Spacer(flex: 1,),
                            ],
                          ),

                        ),

                      ),
                    ),


                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }

  void login ()async
  {

    if(formKey.currentState?.validate() == true)
    dialog.showLoading(context,"Loading..");
    // await Future.delayed(Duration(seconds: 2));
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      var user = await firebaseUtils.readUserFromFirestore(credential.user?.uid ??'');
      if(user == null){
        return;
      }
      var authProvider = Provider.of<AuthProvider>(context,listen: false);
      authProvider.updateUser(user);
      dialog.hideLoading(context);
      dialog.showMessage(context, "login Succuesfully",title: "sucess",posActionName: "OK",posAction:() =>  Navigator.of(context).pushReplacementNamed(homeScreen.routeName));
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        dialog.hideLoading(context);
        dialog.showMessage(context, "user not found",title: "Error",posActionName: "OK");
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        dialog.hideLoading(context);
        dialog.showMessage(context, "wrong password",title: "Error",posActionName: "OK");
        print('Wrong password provided for that user.');
      }
    }catch(e){
      dialog.hideLoading(context);
      dialog.showMessage(context, e.toString(),title: "Error",posActionName: "OK");
      print(e.toString());

    }

  }
}

