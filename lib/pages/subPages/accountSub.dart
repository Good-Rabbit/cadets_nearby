import 'package:flutter/material.dart';
import 'package:readiew/pages/homeSetter.dart';

class AccountSubPage extends StatefulWidget {
  AccountSubPage({Key? key}) : super(key: key);

  @override
  _AccountSubPageState createState() => _AccountSubPageState();
}

class _AccountSubPageState extends State<AccountSubPage>
    with AutomaticKeepAliveClientMixin {
  bool locationAccess = HomeSetterPage.mainUser!.pLocation;
  bool phoneAccess = HomeSetterPage.mainUser!.pPhone;

  bool editingEnabled = false;
  bool hasChanged = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 40.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: HomeSetterPage.mainUser!.photoUrl! == ''
                        ? Image.asset('assets/images/user.png')
                        : Image.network(
                            HomeSetterPage.mainUser!.photoUrl!,
                            width: 80,
                            height: 80,
                          ),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20.0),
                onTap: () {
                  //Enable Account Editing
                  setState(() {
                    editingEnabled = !editingEnabled;
                    if (editingEnabled == false) {
                      resetEdits();
                    }
                  });
                },
                child: CircleAvatar(
                  radius: 20.0,
                  child: Icon(editingEnabled ? Icons.cancel : Icons.edit),
                ),
              ),
            ],
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  HomeSetterPage.mainUser!.fullName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                if (!HomeSetterPage.auth.currentUser!.emailVerified)
                  Text(
                    ' - Verify e-mail',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  HomeSetterPage.mainUser!.cName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  HomeSetterPage.mainUser!.cNumber.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: CheckboxListTile(
                value: phoneAccess,
                title: Text('Make phone number public'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                activeColor: Colors.black,
                onChanged:
                    (HomeSetterPage.mainUser!.phone == '' || !editingEnabled)
                        ? null
                        : (value) {
                            setState(() {
                              phoneAccess = value!;
                              checkChanged();
                            });
                          }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: CheckboxListTile(
                value: !locationAccess,
                title: Text(
                  'Hide my exact location (Still show me in nearby result)',
                  maxLines: 2,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                activeColor: Colors.black,
                onChanged: !editingEnabled
                    ? null
                    : (value) {
                        setState(() {
                          locationAccess = !value!;
                          checkChanged();
                        });
                      }),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(100, 20, 100, 0),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                textStyle: MaterialStateProperty.all(
                  TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: !(editingEnabled && hasChanged)
                  ? null
                  : () async {
                      HomeSetterPage.mainUser!.pLocation = locationAccess;
                      HomeSetterPage.mainUser!.pPhone = phoneAccess;
                      await HomeSetterPage.store
                          .collection('users')
                          .doc(HomeSetterPage.auth.currentUser!.uid)
                          .update({
                        'pphone': phoneAccess,
                        'plocation': locationAccess
                      }).then((value) {
                        setState(() {
                          hasChanged = false;
                          editingEnabled = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Account settings updated',
                            ),
                          ),
                        );
                      });
                    },
              icon: Icon(Icons.save),
              label: Text('Save Changes'),
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
        ],
      ),
    );
  }

  checkChanged() {
    if (locationAccess != HomeSetterPage.mainUser!.pLocation) {
      hasChanged = true;
    } else if (phoneAccess != HomeSetterPage.mainUser!.pPhone) {
      hasChanged = true;
    } else {
      hasChanged = false;
    }
  }

  void resetEdits() {
    locationAccess = HomeSetterPage.mainUser!.pLocation;
    phoneAccess = HomeSetterPage.mainUser!.pPhone;
  }

  @override
  bool get wantKeepAlive => true;
}
