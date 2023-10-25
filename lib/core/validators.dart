
String emailValidator(String input){
  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);
  if(!emailValid){
    return "Email inválido";
  }
  return "";
}
String passwordValidator(String input){
  if(input.isEmpty){
    return "Contraseña inválida";
  }
  return "";
}