import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:changas_ya_app/Domain/User/user.dart';
import 'package:changas_ya_app/core/Services/validate_users.dart';

class AppLogin extends StatefulWidget {
  static const String name = 'login';
  const AppLogin({super.key});

  @override
  State<AppLogin> createState() => _AppLoginState();
}

class _AppLoginState extends State<AppLogin> {

  // Agregar instancia de objeto usuario.
  
  late TextEditingController nameController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  String _inputName = '';
  String _inputPassword = '';
  
  bool validateData (User userData) {
    ValidateUsers authenticate = ValidateUsers();
    return authenticate.validateUser(userData);
  }

  String? validateEmail(String? text){
    if (text == null || !text.contains('@') || !text.contains('.com')) {
      return 'Debe contener "@" y ".com"';
    }
    return null;
  }

  String? validatePassword(String? password){
    if (password == null ||  password.length < 8){
      return '';
    }
    return null;
  }
  // void showSnackBar(String messageValue){
  //   final showMessage = SnackbarStateless(message: messageValue,).build(context);
  //   ScaffoldMessenger.of(context).showSnackBar(showMessage);
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changas Ya')
      ),
      body: Center( child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextFormField(
              controller: nameController,
              onChanged: (String nameValue) {
                if (nameController.text.isNotEmpty){
                  setState(() {
                    _inputName = nameController.text;
                  });
                }                
              },
              obscureText: false,
              decoration: InputDecoration(border: OutlineInputBorder(), 
                                          labelText: 'Usuario'),
              autovalidateMode: AutovalidateMode.always,
              validator: (String? text) { return validateEmail(text); }
            ),
            SizedBox(height: 20,),

            TextFormField(
              controller: passwordController,
              onChanged: (String passwordValue) {
                if (passwordController.text.isNotEmpty){
                  setState(() {
                    _inputPassword = passwordController.text;
                  });
                }                
              },
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(), 
                labelText: 'Contraseña',
                ),
              autovalidateMode: AutovalidateMode.always,
              validator: (String? password) { return validatePassword(password); },
            ),
            

            ElevatedButton(onPressed: () {
              User newUser = User(_inputName, _inputPassword);
              if (validateData(newUser)){
                final snackBar = SnackBar(content: Text('LogIn Exitoso!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                context.push('/jobs', extra: {newUser.name});
              } 
              
            }, child: Text('Iniciar sesión')),
            
            SizedBox(height: 10,),
            Text("ó"),
            SizedBox(height: 10,),

            ElevatedButton(onPressed: () {
              User newUser = User(_inputName, _inputPassword);
              if (validateData(newUser)){
                context.push('/jobs', extra: {newUser.name});
              } 
              
            }, child: Text('Registarse')),
          ],
        ),
    ),
    );
    
  }
}