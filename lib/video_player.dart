// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

// ! normail basic video player
class VideoPlayervideo extends StatefulWidget {
  final String filePath;
  final String outPath;

  VideoPlayervideo({
    Key? key,
    required this.filePath,
    required this.outPath,
  }) : super(key: key);

  @override
  _VideoPlayervideoState createState() => _VideoPlayervideoState();
}

class _VideoPlayervideoState extends State<VideoPlayervideo> {
  // late VideoPlayerController _controller;

  @override
  initState() {
    super.initState();
    log('````````````````````````````````````');
    log('Video Init');
    log(widget.filePath);
    log('````````````````````````````````````');

    //!
    log('************************************************************************');
    log('Convert Video');
    log('************************************************************************');

    //!   convert 4k video to 720
    // final String videoPath = widget.filePath;
    // final String outputPath = '/storage/emulated/0/Download/testvideo4k.mp4';
    final String outputPath = '${widget.outPath}/test27.mp4';
    // final String resolution = '1520x720';966666666+

    convertVideoToSupportedResolution(widget.filePath, outputPath);

    //! video player init
    // _controller = VideoPlayerController.file(File(widget.filePath))
    //   ..initialize().then((e) {
    //     log("Initialized");
    //     setState(() {});
    //     _controller.play();
    //   });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      //! video player
      // body: _controller.value.isInitialized
      //     ? AspectRatio(
      //         aspectRatio: _controller.value.aspectRatio,
      //         child: VideoPlayer(_controller),
      //       )
      //     : Container(),
      body: Center(
        child: Text('Video Screen'),
      ),
    );
  }
}

//

//!  compress video function
// Future<void> compressVideo(file) async {
//   log('comppression started');
//   await VideoCompress.setLogLevel(0);
//   final info = await VideoCompress.compressVideo(
//     file,
//     quality: VideoQuality.MediumQuality,
//     deleteOrigin: false,
//     includeAudio: true,
//   );
//   // setState(() {
// //       _counter = info.path!;
// //     });
//   log(info!.path.toString());
//   log('compression end');
// }

//! get info of any video
// FFprobeKit.getMediaInformation(widget.filePath).then((session) async {
//   final information = await session.getMediaInformation();
//   print('````````````````````````````````````');
//   log(information.toString());
//   print('````````````````````````````````````');
//   if (information == null) {
//     log('Info is null');
//     // CHECK THE FOLLOWING ATTRIBUTES ON ERROR
//     final state =
//         FFmpegKitConfig.sessionStateToString(await session.getState());
//     final returnCode = await session.getReturnCode();
//     final failStackTrace = await session.getFailStackTrace();
//     final duration = await session.getDuration();
//     final output = await session.getOutput();
//   } else {
//     // Access video information
//     final sessionId = session.getSessionId();
//     final duration = information.getDuration();
//     final output = await session.getOutput();
//     // Parse the JSON output -- to get height and width
//     final jsonOutput = json.decode(output.toString());
//     final size = information.getSize();
//     final stream = jsonOutput['streams'][0];
//     final height = stream['height'];
//     final width = stream['width'];
//     log('<><><><><<><><><><<>><><<><><><><>');
//     print('session ID: $sessionId');
//     print('Duration: $duration');
//     print('Size: $size');
//     print('output: $output ');
//     print('Video Resolution: $width x $height');
//     log('<><><><><<><><><><<>><><<><><><><>');
//   }
// });

// ! ===============TEST== CONVERT==========
//1

//    //! path directory for output
// Future<Directory?> pathloc = localPath;
// log('Compress Video');
// final String ffmpegCommand =
//     '-i ${widget.filePath} -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k ${pathloc}.compressed_video.mp4';
// FFmpegKit.execute('ffmpeg -y -i video.mp4 -vcodec h264 -crf 10 output.mp4')
//     .then((rc) {
//   if (rc == 0) {
//     log('Video compression completed successfully.');
//   } else {
//     log('Video compression failed with code: ${rc}');
//   }
// });
// print(info!.path);
// setState(() {
//   _counter = info.path!;
// });

//! 2
Future<void> convertVideoToSupportedResolution(
    String inputPath, String outputPath) async {
  String formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  // Set the FFmpeg command

  final ffmpegCommand =
      '-i $inputPath -vf "scale=2048:1080" -c:a copy $outputPath';
  // final ffmpegCommand3 =
  //     '-i $inputPath -vf "scale=1520x720" -c:a copy $outputPath';

  FFmpegKit.executeAsync(ffmpegCommand, (Session session) async {
    // CALLED WHEN SESSION IS EXECUTED
    log('==================================================');
    log('SESSION EXECUTED');
    log('==================================================');
  }, (Log log) {
    // CALLED WHEN SESSION PRINTS LOGS
    final message = log.getMessage();
    final level = log.getLevel();
    final sessionId = log.getSessionId();

    print('message from LOG :  $message');
    print('level from LOG :  $level');
    print('sessionId from LOG :  $sessionId');
  }, (Statistics statistics) {
    // CALLED WHEN SESSION GENERATES STATISTICS
    final int progress = statistics.getTime();
    final double duration = statistics.getSpeed();
    final videoquality = statistics.getVideoQuality();
    final bitrate = statistics.getBitrate();
    final size = statistics.getSize();

    final String progressTime = formatTime(progress);

    final progressPercentage = (progress / 1000).toStringAsFixed(2);

    // log('Conversion progress: $progress%');
    log('Conversion progress Time: $progressTime ');
    log('Conversion progressPercentage: $progressPercentage%');
    log('Conversion duration: $duration %');
    log('Conversion videoquality: $videoquality');
    log('Conversion bitrate: $bitrate');
    log('Conversion size: $size');
  }).then((session) async {
    // after convertion
    final returnCode = await session.getReturnCode();
    final startTime = session.getStartTime();
    final duration = await session.getDuration();
    final endTime = await session.getEndTime();
    final output = await session.getOutput();

    if (ReturnCode.isSuccess(returnCode)) {
      log('Video conversion succeeded');
      log('startTime: ${startTime.toString()}');
      log('endTime: ${endTime.toString()}');
      log('duration: ${duration.toString()}');
      log('returnCode: ${returnCode.toString()}');
      log('output: ${output.toString()}');
    } else if (ReturnCode.isCancel(returnCode)) {
      log('Video conversion is cancelled : $returnCode');
    } else {
      log('Video conversion failed: $returnCode');
    }
  });
}

///  3840x2160  =4k
///  2048:1080  =2k
///  1520:720 = 720p
