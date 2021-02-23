class UserApp{
  final String email;
  final String displayName;
  final String phoneNumber;
  final num providerNumber;

  UserApp({this.email, this.displayName, this.phoneNumber, this.providerNumber});

  UserApp.fromJson(Map<dynamic, dynamic>json):
        email=json['email']??'',
        displayName=json['displayName']??'',
        phoneNumber=json['phoneNumber']??'',
        providerNumber=json['providerNumber']??null;

  Map<dynamic, dynamic> toJson ()=>{
    'email':email??'',
    'displayName':displayName??'',
    'phoneNumber':phoneNumber??'',
    'providerNumber':providerNumber??null,
  };
}