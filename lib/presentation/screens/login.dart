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
    return authenticate.dummyValidation(userData);
    //return authenticate.validateUser(userData);
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

    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Changas Ya'),
        backgroundColor: Colors.blue,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
        
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              width: double.infinity,
              height: 200,
              child: Image.asset(
                'lib/images/login_banner.png',
                fit: BoxFit.cover),
            ),

            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
              child: Text('> Ingrese a la aplicación <', style: textStyle.titleLarge,)
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
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
                                            labelText: 'E-Mail'),
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (String? text) { return validateEmail(text); }
              ),
            ),
        
            SizedBox(height: 20,),
        
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
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
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (String? password) { return validatePassword(password); },
              ),
            ),
            
            SizedBox(height: 20.0,),
        
            Row(
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                FilledButton(onPressed: () {
                  User newUser = User(_inputName, _inputPassword);
                  if (validateData(newUser)){
                    
                    context.push('/jobs', extra: {newUser.name});
                  }     
                }, 
                child: Text('Iniciar sesión'),
              ),
                
                SizedBox(width: 10.0,),
                Text("ó"),
                SizedBox(width: 10.0,),
                
                FilledButton.tonal(onPressed: () {
                  context.push('/signup');
                }, child: Text('Registarse')),
              ],
            ),

            SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Instituto Tecnológico ORT  2025',
                  style: TextStyle(fontSize: 12.0,),          
                  ),
                  //TextButton(onPressed: () => { context.push(/nosotros)}, child: Text("Nosotros")),
                  TextButton(onPressed: (){}, child: Text("Nosotros", style: TextStyle(fontSize: 12.0),))
              ]
              
            )
          ],
        ),
      ),
    );
    
  }
}