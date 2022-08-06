import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:line_icons/line_icons.dart';

class Developers extends StatelessWidget {
  const Developers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: SvgPicture.asset(
              'lib/assets/companylogo.svg',
              width: 200,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 40, left: 30, right: 30,bottom: 50),
            child: Text(
              'This app is developed and maintained by strolltec company',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Contact Us',
              style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(
                Uri.parse('tel:+265885354868'),
                mode: LaunchMode.externalApplication,
              );
            },
            leading: const Icon(LineIcons.phone),
            title: const Text('+265 (0) 885 354 868'),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(
                Uri.parse('https://wa.me/+265885354868'),
                mode: LaunchMode.externalApplication,
              );
            },
            leading: const Icon(LineIcons.whatSApp),
            title: const Text('+265 (0) 885 354 868'),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(
                Uri.parse('https://www.facebook.com/Strolltec-100137352638947'),
                mode: LaunchMode.externalApplication,
              );
            },
            leading: const Icon(LineIcons.facebookF),
            title: const Text('strolltec'),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(
                Uri.parse('mailto:info@strolltec.com'),
                mode: LaunchMode.externalApplication,
              );
            },
            leading: const Icon(LineIcons.envelope),
            title: const Text('info@strolltec.com'),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(
                Uri.parse('https://strolltec.com'),
                mode: LaunchMode.externalApplication,
              );
            },
            leading: const Icon(LineIcons.globeWithAfricaShown),
            title: const Text('strolltec.com'),
          ),
          Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text('developed by:'),
              const SizedBox(
                height: 14,
              ),
              SvgPicture.asset(
                'lib/assets/companylogo.svg',
                width: 50,
              )
            ],
          )
        ],
      ),
    );
  }
}
