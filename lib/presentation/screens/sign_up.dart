import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  static const String  name = 'signup';
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _AppSignUp();
}


class _AppSignUp extends State<SignUp> {

  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController confirmedPassController = TextEditingController();
  String _inputName = '';
  String _inputEmail = '';
  String _inputPassword = '';
  String _inputConfirmedPassword = '';


  String? validateEmail(String? text){
    if (text == null || !text.contains('@') || !text.contains('.com')) {
      return 'Debe contener "@" y ".com"';
    }
    return null;
  }

  String? validatePassword(String? password){
    if (password == null ||  password.length < 8){
      return 'Reingrese la contraseña';
    }
    return null;
  }


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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              margin: EdgeInsets.all(20.0),
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 43, 171, 245),
                borderRadius: BorderRadius.all(Radius.circular(15.0))
              ),
              child: Column(
                children: [
                  Column(

                    children: [
                    Image.asset('lib/images/signup_banner.png',fit: BoxFit.contain, scale: 5.0,),
                  ]),

                  Column(
                    children: [
                      Center(child: Text('Registro de usuario', style: textStyle.titleLarge)),
                    ],
                  )
                ],
              ),
            ),


            // User name
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                                            labelText: 'Nombre de usuario'), 
              ),
            ),

            //Email
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: TextFormField(
                controller: emailController,
                onChanged: (String mailValue) {
                  if (emailController.text.isNotEmpty){
                    setState(() {
                      _inputEmail = emailController.text;
                    });
                  }                
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(), 
                  labelText: 'E-Mail',
                  ),
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (String? email) { return validateEmail(email); },
              ),
            ),

            //Password
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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

            //Confirm password
            //TODO: Change the validation process. It should use '_inputPassword' and check
            //if both passwords are equal. Or we can search for a automated function to 
            //solve the problem.
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: TextFormField(
                controller: confirmedPassController,
                onChanged: (String confirmedPasswordValue) {
                  if (confirmedPassController.text.isNotEmpty){
                    setState(() {
                      _inputConfirmedPassword = confirmedPassController.text;
                    });
                  }                
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(), 
                  labelText: 'Confirmar contraseña',
                  ),
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (String? confirmedPassword) { return validatePassword(confirmedPassword); },
              ),
            ),

            SizedBox(height: 20.0),
            //TODO: This button should trigger the database resgistration.
            FilledButton(onPressed: (){}, child: Text('Registrarse')),
          ]
        ),
      )
    );
  }
}
