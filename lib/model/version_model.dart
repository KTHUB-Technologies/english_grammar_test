class Version{
  num version;
  String data;

  Version.fromMap(Map<dynamic,dynamic>map):
      version=map['version'],
      data=map['data'];
}