import 'package:cadets_nearby/pages/ui_elements/bottom_sheet.dart';
import 'package:cadets_nearby/pages/ui_elements/intake_chip.dart';
import 'package:cadets_nearby/pages/ui_elements/user_profile.dart';
import 'package:cadets_nearby/services/mainuser_provider.dart';
import 'package:cadets_nearby/data/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        if (context.read<MainUser>().user!.verified == 'yes') {
          showBottomSheetWith([UserProfile(e: e)], context);
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Get verified first'),
                  content: const Text(
                      'You have to get verified first to be able to use this'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok.')),
                  ],
                );
              });
        }
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
                        const SizedBox(
                          width: 3,
                        ),
                        if (e.celeb)
                          const Icon(
                            Icons.verified,
                            size: 15,
                            color: Colors.green,
                          ),
                        if (e.celeb)
                          const SizedBox(
                            width: 3,
                          ),
                        if (e.verified != 'yes')
                          const Icon(
                            Icons.info_rounded,
                            size: 15,
                            color: Colors.redAccent,
                          ),
                        if (e.verified != 'yes')
                          const SizedBox(
                            width: 3,
                          ),
                        if (e.cName == 'Saim' &&
                            e.cNumber == 2129 &&
                            e.college == 'SCC')
                          const Icon(
                            Icons.code,
                            size: 20,
                            color: Colors.blue,
                          ),
                        if (e.cName == 'Muaz' &&
                            e.cNumber == 1999 &&
                            e.college == 'SCC')
                          const Icon(
                            Icons.support,
                            size: 15,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                    Text('Profession: ${e.profession}'),
                    Text(
                        'Designation: ${e.designation == '' ? '-' : e.designation}'),
                  ],
                ),
              ),
              IntakeChip(year: e.intake.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
