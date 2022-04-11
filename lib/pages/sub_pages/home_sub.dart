import 'package:cadets_nearby/data/menu_item.dart';
import 'package:cadets_nearby/pages/ui_elements/nearby_list_holder.dart';
import 'package:cadets_nearby/services/data_provider.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/services/notification_provider.dart';
import 'package:cadets_nearby/services/sign_out.dart';
import 'package:cadets_nearby/services/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeSubPage extends StatefulWidget {
  const HomeSubPage({
    Key? key,
  }) : super(key: key);

  @override
  _HomeSubPageState createState() => _HomeSubPageState();
}

class _HomeSubPageState extends State<HomeSubPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    context.read<GlobalNotifications>().initialize();

    return SafeArea(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/account');
            },
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ProfilePicture(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        UserNameRow(),
                        Quote(),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/notifications');
                      },
                      icon: const NotificationIndicator(),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child: PopupMenuButton<MenuItem>(
                      onSelected: (e) {
                        switch (e) {
                          case MenuItems.itemAccount:
                            Navigator.of(context).pushNamed('/account');
                            break;
                          case MenuItems.itemAbout:
                            Navigator.of(context).pushNamed('/about');
                            break;
                          case MenuItems.itemSignOut:
                            signOut();
                            break;
                          case MenuItems.itemRateUs:
                            launchURL(context.read<Data>().rateLink);
                            break;
                          default:
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        ...MenuItems.first.map(buildItem),
                        const PopupMenuDivider(height: 10),
                        ...MenuItems.second.map(buildItem),
                      ],
                      color: Theme.of(context).chipTheme.backgroundColor,
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // FutureBuilder(
          //     future: FirebaseFirestore.instance.collection('users').get(),
          //     builder: (context,
          //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          //       if (snapshot.hasData) {
          //         for (var doc in snapshot.data!.docs) {
          //           int sector =
          //               (doc.data()['lat'] / (0.0181)).ceil();
          //           doc.reference.update({'latsector': sector});
          //         }
          //         return const Text('Done');
          //       } else {
          //         return Container();
          //       }
          //     }),
          const Expanded(child: NearbyListHolder()),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  PopupMenuEntry<MenuItem> buildItem(MenuItem e) {
    return PopupMenuItem<MenuItem>(
        value: e,
        child: Row(
          children: [
            e.icon,
            const SizedBox(width: 12),
            Text(e.name),
          ],
        ));
  }
}

class Quote extends StatelessWidget {
  const Quote({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.watch<Data>().quote ?? '',
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: context.watch<MainUser>().user!.photoUrl == ''
            ? Image.asset(
                'assets/images/user.png',
                fit: BoxFit.cover,
              )
            : Image.network(
                context.watch<MainUser>().user!.photoUrl,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
      ),
    );
  }
}

class UserNameRow extends StatelessWidget {
  const UserNameRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.watch<MainUser>().user!.cName,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
        if (context.watch<MainUser>().user!.verified != 'yes')
          const Icon(
            Icons.info_rounded,
            size: 15,
            color: Colors.redAccent,
          ),
        if (context.watch<MainUser>().user!.celeb)
          const Icon(
            Icons.verified,
            size: 15,
            color: Colors.green,
          ),
      ],
    );
  }
}

class NotificationIndicator extends StatelessWidget {
  const NotificationIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(context.watch<GlobalNotifications>().hasUnread
        ? Icons.notifications_active
        : Icons.notifications_rounded);
  }
}
