class UserApp{
  final num numberUser;
  final String email;
  final String displayName;
  final String phoneNumber;
  final num providerNumber;

  UserApp({this.numberUser, this.email, this.displayName, this.phoneNumber, this.providerNumber});

  UserApp.fromJson(Map<dynamic, dynamic>json):
        numberUser=json['numberUser']??null,
        email=json['email']??'',
        displayName=json['displayName']??'',
        phoneNumber=json['phoneNumber']??'',
        providerNumber=json['providerNumber']??null;

  Map<dynamic, dynamic> toJson ()=>{
    'numberUser':numberUser??null,
    'email':email??'',
    'displayName':displayName??'',
    'phoneNumber':phoneNumber??'',
    'providerNumber':providerNumber??null,
  };
}