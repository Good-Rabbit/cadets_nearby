class AppUser {
  int cNumber;
  int intake;
  int treatCount;
  double lat;
  double long;
  String id;
  String fullName;
  String college;
  String cName;
  String email;
  String photoUrl;
  String phone;
  String fbUrl;
  String instaUrl;
  String workplace;
  String profession;
  String verified;
  DateTime timeStamp;
  bool pLocation;
  bool premium;
  bool pPhone;
  bool celeb;
  bool treatHead;
  bool treatHunter;
  bool pAlways;
  bool pMaps;
  bool manualDp;

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
    required this.verified,
    required this.celeb,
    required this.treatHead,
    required this.treatHunter,
    required this.id,
    required this.timeStamp,
    required this.fbUrl,
    required this.instaUrl,
    required this.workplace,
    required this.profession,
    required this.manualDp,
    required this.treatCount,
    this.photoUrl: '',
    this.lat: 0,
    this.long: 0,
    this.phone: '',
    this.pAlways: false,
    this.pMaps: false,
  });

  bool equals(AppUser user) => (user.id == this.id);
  bool notEquals(AppUser user) => (user.id != this.id);
}
