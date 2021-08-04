class AppUser {
  String fullName;
  int intake;
  String college;
  String cName;
  int cNumber;
  String email;
  bool pLocation;
  bool premium;
  bool pPhone;
  String? photoUrl;
  String? phone;
  double? lat;
  double? long;
  DateTime? timeStamp;
  bool? pAlways;
  bool? pMaps;

  AppUser({
    required this.cName,
    required this.cNumber,
    required this.fullName,
    required this.college,
    required this.email,
    required this.intake,
    required this.premium,
    required this.pLocation,
    required this.pPhone,
    this.photoUrl,
    this.lat,
    this.long,
    this.phone,
    this.pAlways,
    this.timeStamp,
    this.pMaps,
  });

  bool equals(AppUser user) {
    return ((user.college == this.college) && (user.cNumber == this.cNumber));
  }
}
