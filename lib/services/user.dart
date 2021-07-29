class AppUser {
  String fullName;
  int intake;
  String college;
  String cName;
  int cNumber;
  String email;
  String? phone;
  double? lat;
  double? long;
  bool? pPhone;
  bool? pLocation;
  bool? pAlways;
  bool? pMaps;

  AppUser({
    required this.cName,
    required this.cNumber,
    required this.fullName,
    required this.college,
    required this.email,
    required this.intake,
    this.lat,
    this.long,
    this.phone,
    this.pAlways,
    this.pLocation,
    this.pMaps,
    this.pPhone,
  });
}
