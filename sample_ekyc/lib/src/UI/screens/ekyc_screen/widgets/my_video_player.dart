import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

import '../../../../BLOC/app_blocs.dart';
import '../../../../BLOC/ekyc/ekyc_bloc.dart';
import '../../../designs/app_themes/app_assets_links.dart';
import '../../../designs/sizer_custom/sizer.dart';

class MyVideoPlayer extends StatelessWidget {
  const MyVideoPlayer({Key? key, required this.state}) : super(key: key);

  final EkycCameraReadyState state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        VideoPlayer(state.videoPlayerController!),
        state.isPlaying
            ? SizedBox.shrink()
            : Positioned(
                top: 180.px,
                child: InkWell(
                  onTap: () {
                    AppBlocs.ekycBloc.add(EkycPlayingVideoEvent());
                  },
                  child: SvgPicture.asset(AppAssetsLinks.play_circle),
                ),
              )
      ],
    );
  }
}
