class AppUser {
  int cNumber;
  int intake;
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
  DateTime timeStamp;
  bool pLocation;
  bool premium;
  bool pPhone;
  bool verified;
  bool celeb;
  bool bountyHead;
  bool bountyHunter;
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
    required this.fbUrl,
    required this.instaUrl,
    required this.workplace,
    required this.profession,
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
