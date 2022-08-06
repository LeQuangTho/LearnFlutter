import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:test_deep_link/dynamic_link_service.dart';
import 'package:test_deep_link/locator.dart';
import 'package:test_deep_link/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SlopeDAppView extends StatefulWidget {
  const SlopeDAppView({Key? key}) : super(key: key);

  @override
  State<SlopeDAppView> createState() => _SlopeDAppViewState();
}

class _SlopeDAppViewState extends State<SlopeDAppView> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final param = await locator<DynamicLinkService>().handleDynamicLink();

      if (param != null) {
        logger.w("${param['public-key'] ?? 0}");
      }
    });
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final dynamicLinkParams = DynamicLinkParameters(
            link: Uri.parse(
                "https://toilathor.page.link/on-connect?public-key"),
            uriPrefix: "https://toilathor.page.link",
            androidParameters: const AndroidParameters(
                packageName: "com.example.test_deep_link"),
          );
          final dynamicLink =
              await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

          // logger.w(dynamicLink);

          final slopePayParams = {
            // "type": "connect",
            "type": "pay",
            "address": "Amz5fuuKUX1jUYL11FsjsdgHLN425PU3upmvxk5j3Srp",
            "memo": "000001",
            "amount": "0.001",
            "symbol": "SOL",
            "label": "testing notes",
            "message": "testing mark"
          };

          await launchUrl(
            Uri(
                scheme: "slopewallet",
                host: "wallet.slope",
                path: "pay",
                queryParameters: {
                  "returnSchemes": const HexEncoder().convert(
                      const Utf8Encoder()
                          .convert(dynamicLink.toString())),
                  "slopePayParams": const HexEncoder()
                      .convert(const Utf8Encoder().convert(jsonEncode(slopePayParams))),
                }),
            mode: LaunchMode.externalNonBrowserApplication,
          );

          // launchUrl(
          //   dynamicLink,
          //   mode: LaunchMode.externalNonBrowserApplication,
          // );
          // print(Uri(
          //     scheme: "slopewallet",
          //     host: "wallet.slope",
          //     path: "pay",
          //     queryParameters: {
          //       "returnSchemes": const HexEncoder().convert(
          //           const Utf8Encoder().convert(
          //               "https://toilathor.page.link/onConnect?publicKey")),
          //       "slopePayParams": const HexEncoder().convert(
          //           const Utf8Encoder().convert('''{"type": "connect"}''')),
          //     }));
        },
      ),
    );
  }
}

Future<void> launchUniversalLinkIos(Uri url,
    [LaunchMode mode = LaunchMode.externalNonBrowserApplication]) async {
  // var decrypted = Encryptor.decrypt(key, encrypted);

  final bool nativeAppLaunchSucceeded = await launchUrl(
    url,
    mode: mode,
  );

  if (!nativeAppLaunchSucceeded) {
    await launchUrl(
      url,
      mode: mode,
    );
  }
}
