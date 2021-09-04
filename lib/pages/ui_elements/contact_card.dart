import 'package:cadets_nearby/pages/ui_elements/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:cadets_nearby/services/user.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.e,
  }) : super(key: key);

  final AppUser e;


  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: GestureDetector(
                  onTap: () {},
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.7,
                    maxChildSize: 0.9,
                    minChildSize: 0.5,
                    builder: (_, controller) => Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15.0),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                      child: ListView(
                        controller: controller,
                        children: [UserProfile(e: e)],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 25.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: e.photoUrl == ''
                        ? Image.asset('assets/images/user.png')
                        : Image.network(
                            e.photoUrl,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          e.cName,
                        ),
                        if (e.celeb)
                          const Icon(
                            Icons.verified,
                            size: 15,
                            color: Colors.green,
                          ),
                        if (e.verified != 'yes')
                          const Icon(
                            Icons.info_rounded,
                            size: 15,
                            color: Colors.redAccent,
                          ),
                      ],
                    ),
                    if (e.premium)
                      const Text(
                        'Premium User',
                        style: TextStyle(
                          color: Colors.deepOrange,
                        ),
                      ),
                    Text('Profession: ${e.profession}'),
                    Text('Designation: ${e.designation}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
