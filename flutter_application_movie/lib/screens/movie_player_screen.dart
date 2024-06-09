import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MoviePlayerScreen extends StatefulWidget {
  final String videoUrl;

  MoviePlayerScreen({required this.videoUrl});

  @override
  _MoviePlayerScreenState createState() => _MoviePlayerScreenState();
}

class _MoviePlayerScreenState extends State<MoviePlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9, // Tỷ lệ khung hình
      autoPlay: true, // Tự động phát video khi sẵn sàng
      looping: true, // Lặp video
      // Nếu bạn muốn tùy chỉnh giao diện của thanh điều khiển, bạn có thể thêm các thuộc tính khác ở đây
    );
    _videoPlayerController.addListener(() {
      if (!_videoPlayerController.value.isPlaying &&
          _videoPlayerController.value.isInitialized) {
        setState(() {
          // Trạng thái video đã dừng, hiển thị nút play
        });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
