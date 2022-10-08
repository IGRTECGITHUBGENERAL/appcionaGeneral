import 'package:appciona/config/palette.dart';
import 'package:appciona/pages/audiovisual/imagenes/imagenes_page.dart';
import 'package:appciona/pages/audiovisual/media/media_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AudiovisualPage extends StatefulWidget {
  final Widget drawer;
  const AudiovisualPage({
    Key? key,
    required this.drawer,
  }) : super(key: key);

  @override
  State<AudiovisualPage> createState() => _AudiovisualPageState();
}

class _AudiovisualPageState extends State<AudiovisualPage> {
  String radioUrl = "";

  Future<void> getRadioUrl() async {
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("Radio").limit(1).get();
    radioUrl = qs.docs.first["Link"];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getRadioUrl();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const Text(
          'Audiovisual',
          style: TextStyle(
            color: Palette.appcionaPrimaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          Image.asset(
            'assets/images/logo-green.png',
            fit: BoxFit.contain,
          )
        ],
        iconTheme: const IconThemeData(
          color: Palette.appcionaPrimaryColor,
        ),
      ),
      drawer: Drawer(
        child: widget.drawer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            child: Center(
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      _turismoImageCard(
                        size,
                        'assets/icons/podcast_colors.png',
                        'Podcasts',
                        () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const MediaPage(
                              type: 'Podcast',
                              iconAssetPlaceholder:
                                  'assets/icons/podcast_colors.png',
                            ),
                          ),
                        ),
                      ),
                _turismoImageCard(
                  size,
                  'assets/icons/radio_directo_colors.png',
                  'Radio en vivo',
                      () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const MediaPage(
                        type: 'Radio en vivo',
                        iconAssetPlaceholder:
                        'assets/icons/directo_colors.png',
                      ),
                    ),
                  ),
                ),
                      _turismoImageCard(
                        size,
                        'assets/icons/directo_colors.png',
                        'En directo',
                        () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const MediaPage(
                              type: 'Streaming',
                              iconAssetPlaceholder:
                                  'assets/icons/directo_colors.png',
                            ),
                          ),
                        ),
                      ),
                      _turismoImageCard(
                        size,
                        'assets/icons/imagen_colors.png',
                        'Imágenes',
                        () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const ImagenesPage(
                              logo: 'assets/icons/imagen_colors.png',
                            ),
                          ),
                        ),
                      ),
                      _turismoImageCard(
                        size,
                        'assets/icons/videos_colors.png',
                        'Videos',
                            () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const MediaPage(
                              type: 'Videos',
                              iconAssetPlaceholder:
                              'assets/icons/videos_colors.png',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card _turismoImageCard(
      Size size, String image, String title, void Function()? onTap) {
    return Card(
      elevation: 7,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: size.width * 0.43,
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Image.asset(image),
              const Divider(),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
