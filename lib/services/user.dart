class AppUser {
  String fullName;
  int intake;
  String college;
  String cName;
  int cNumber;
  String email;
  String? photoUrl;
  String? phone;
  double? lat;
  double? long;
  DateTime? timeStamp;
  bool? pPhone;
  bool? pLocation;
  bool? pAlways;
  bool? pMaps;
  bool premium;

  AppUser({
    required this.cName,
    required this.cNumber,
    required this.fullName,
    required this.college,
    required this.email,
    required this.intake,
    required this.premium,
    this.photoUrl,
    this.lat,
    this.long,
    this.phone,
    this.pAlways,
    this.pLocation,
    this.timeStamp,
    this.pMaps,
    this.pPhone,
  });

  bool equals(AppUser user) {
    return ((user.college == this.college) && (user.cNumber == this.cNumber));
  }
}
