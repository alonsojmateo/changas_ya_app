class User {
  String name;
  String password;

  User(this.name, this.password);

  void setName(String newName){
    name = newName;
  }
  void setPassword(String newPassword){
    password = newPassword;
  }
}