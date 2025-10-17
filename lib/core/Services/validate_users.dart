import 'package:changas_ya_app/Domain/User/user.dart';

class ValidateUsers {
  
 
  // ListOfusers userList = ListOfusers();
  List<User> listOfAuthUsers = List<User>.empty();
  

  ValidateUsers();

 //Obtengo la lista de la "base de datos".
  void getUsersList() {
    //listOfAuthUsers = userList.getAuthUsers();
  }

  bool validateUser(User userToValidate) {
    
    getUsersList();
    bool lista = listOfAuthUsers.any((user) => (
      user.name == userToValidate.name && 
      user.password == userToValidate.password));
    return lista;
  }


/*
 * Function used to test the app login.
 */
  bool dummyValidation(User testUser){
     return (testUser.name == 'user@test.com' && testUser.password == "Pass123#");
  }

}