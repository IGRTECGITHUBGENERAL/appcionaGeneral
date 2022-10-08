import 'package:appciona/config/palette.dart';
import 'package:appciona/pages/audiovisual/imagenes/galeria/photo_viewer_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GaleriaPage extends StatefulWidget {
  final List<dynamic> imagenes;
  final String logo;
  final String nombreAlbum;
  const GaleriaPage({
    Key? key,
    required this.imagenes,
    required this.logo,
    required this.nombreAlbum,
  }) : super(key: key);

  @override
  State<GaleriaPage> createState() => _GaleriaPageState();
}

class _GaleriaPageState extends State<GaleriaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Palette.appcionaPrimaryColor,
          ),
        ),
        title: Text(
          widget.nombreAlbum,
          style: const TextStyle(
            color: Palette.appcionaPrimaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          Image.asset(
            widget.logo,
            fit: BoxFit.contain,
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        padding: const EdgeInsets.all(10),
        children: List.generate(
          widget.imagenes.length,
          (index) => _cardImage(index),
        ),
      ),
    );
  }

  Widget _cardImage(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PhotoViewerPage(
              images: widget.imagenes,
              initialIndex: index,
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl: widget.imagenes[index],
          placeholder: (context, url) =>
              Image.asset('assets/images/logo-green.png'),
          errorWidget: (context, url, error) =>
              Image.asset('assets/images/logo-green.png'),
        ),
      ),
    );
  }
}
