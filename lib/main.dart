// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'dart:developer';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_picker/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FFmpegKitConfig.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  // late VideoPlayerController _controller;
  late String _filePath2;

  Future<void> _pickVideo() async {
    Directory? outputFile = await getExternalStorageDirectory();
    // String? path = await FilePicker.platform.getDirectoryPath();
    // final outputFile = await FilePicker.platform.getDirectoryPath();

    print('=================================================================');
    print('Video Picker Opened');
    print(outputFile);

    print('=================================================================');

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && outputFile != null) {
      print(
          '=================================================================');
      print('Video Picked');
      print(
          '=================================================================');
      setState(() {
        _filePath2 = result.files.single.path!;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayervideo(
                filePath: _filePath2,
                outPath: outputFile.path,
              ),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenPixelWidth =
        screenSize.width * MediaQuery.of(context).devicePixelRatio;
    final double screenPixelHeight =
        screenSize.height * MediaQuery.of(context).devicePixelRatio;

    print('================================================================');
    print('Back To Main Screen');
    print('================================================================');
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick Video'),
            ),
            Text(
              'Width: ${screenPixelWidth.toStringAsFixed(0)} pixels',
              style: TextStyle(color: Colors.white),
            ),
            Text('Height: ${screenPixelHeight.toStringAsFixed(0)} pixels',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
