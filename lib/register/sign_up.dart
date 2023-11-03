import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/data_class/my_user.dart';
import 'package:todolist/dialogs.dart';
import 'package:todolist/firebase/firebase_utils.dart';
import 'package:todolist/home-screen.dart';
import 'package:todolist/Theming/my-theme.dart';
import 'package:todolist/provider/AuthProvider.dart';
import 'package:todolist/register/sign_in.dart';

class signUp extends StatefulWidget{
  static String routeName = "sign_up";
  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  String password = '';

  String conPassword = '';

  String email ='';
  String name= '';


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
                    Text("Create Account",style:Theme.of(context).textTheme.titleLarge?.copyWith(color: myTheme.whiteColor),textAlign: TextAlign.center,),
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
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Name',
                                labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                              ),
                              onChanged: (value){
                                name = value;
                              },
                              validator: (value){
                                if(value == null || value.trim().isEmpty)
                                  {
                                    return 'please enter name';
                                  }
                              },
                            ),
                            Spacer(flex: 1,),
                            TextFormField(
                              onChanged: (value){
                                email = value;
                              },
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
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
                                else if(password.length < 6)
                                  {
                                    return"password should be greater than 6 chars";
                                  }
                              },
                            ),
                            Spacer(flex: 1,),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Confirm password',
                                labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                              ),
                              onChanged: (value){
                                conPassword = value;
                              },
                              validator: (value){
                                if(value == null ||value.trim().isEmpty)
                                {
                                  return 'please enter confirm password';
                                }
                                else if(conPassword != password)
                                  {
                                    return 'password don\'t match';
                                  }
                              },
                            ),
                            Spacer(flex: 4,),

                            ElevatedButton(onPressed:(){
                              if(formKey.currentState!.validate())
                                {
                                  register();
                                }
                              },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(13),
                                  elevation: 0,
                                ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Create Account"),
                                Spacer(),
                                Icon(Icons.arrow_forward),
                              ]
                            ),),
                            Spacer(flex: 1,),
                            Row(
                              children: [
                                Text("Are you have an account ",style: Theme.of(context).textTheme.bodySmall,),
                                InkWell(
                                  child: Text("Login"),
                                  onTap: (){
                                    Navigator.of(context).pushReplacementNamed(signIn.routeName);
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

  void register ()async
  {

    dialog.showLoading(context, 'Loading...');
    if(formKey.currentState!.validate())
    {
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(credential.user?.uid);
        myUser MyUser = myUser(id: credential.user?.uid, name: name, email: credential.user?.email);
        await firebaseUtils.addUserToFirestore(MyUser);
        var authProvider = Provider.of<AuthProvider>(context,listen: false);
        authProvider.updateUser(MyUser);
        dialog.hideLoading(context);
        dialog.showMessage(context, "Resister Successfully",posActionName: "OK",title: "success",posAction:() =>  Navigator.of(context).pushReplacementNamed(homeScreen.routeName));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        }

        else if (e.code == 'email-already-in-use') {
          dialog.hideLoading(context);
          dialog.showMessage(context, "email already exist",posActionName: "OK",title: "Error");
          print('The account already exists for that email.');
        }
      } catch (e) {
        dialog.hideLoading(context);
        dialog.showMessage(context, e.toString(),posActionName: "OK",title: "Error");
        print(e);
      }
    }
  }
}