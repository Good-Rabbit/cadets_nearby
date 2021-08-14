class AppUser {
  String id;
  String fullName;
  int intake;
  String college;
  String cName;
  int cNumber;
  String email;
  bool pLocation;
  bool premium;
  bool pPhone;
  bool verified;
  bool celeb;
  bool bountyHead;
  bool bountyHunter;
  String photoUrl;
  String phone;
  double lat;
  double long;
  DateTime timeStamp;
  bool pAlways;
  bool pMaps;

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
    required this.bountyHead,
    required this.bountyHunter,
    required this.id,
    required this.timeStamp,
    this.photoUrl:'',
    this.lat:0,
    this.long:0,
    this.phone:'',
    this.pAlways:false,
    this.pMaps:false,
  });

  bool equals(AppUser user) => (user.id == this.id);
  bool notEquals(AppUser user) => (user.id != this.id);
}
