import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class FirebaseDynamicLinksService {
  //firebase
  void initDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    FirebaseDynamicLinks.instance.onLink.listen((link) {
      if (initialLink != null) {
        final Uri deepLink = link.link;

        handleDynamicLink(context, deepLink);
      }
    }).onError((error) {
      // Handle errors
    });
  }

  void handleDynamicLink(BuildContext context, Uri url) {
    print("DYNAMIC LINK");
    print(url);
  }
}
