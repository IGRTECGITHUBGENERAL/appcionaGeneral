import 'package:appciona/config/palette.dart';
import 'package:appciona/pages/audiovisual/imagenes/galeria/galeria_page.dart';
import 'package:appciona/pages/audiovisual/imagenes/imagenes_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagenesPage extends StatefulWidget {
  final String logo;
  const ImagenesPage({
    Key? key,
    required this.logo,
  }) : super(key: key);

  @override
  State<ImagenesPage> createState() => _ImagenesPageState();
}

class _ImagenesPageState extends State<ImagenesPage> {
  final ImagenesController _controller = ImagenesController();
  final ScrollController _scCtrl = ScrollController();

  late int noNoticias = -1;

  Future<void> _getInitData() async {
    noNoticias = await _controller.getAlbumsSize();
    await _controller.getFirstAlbums();
    setState(() {});
  }

  Future<void> _getNextData() async {
    await _controller.getNextAlbums();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getInitData();
    _scCtrl.addListener(() {
      if (_scCtrl.position.atEdge) {
        if (_scCtrl.position.pixels != 0 &&
            _controller.albums.length < noNoticias) {
          _getNextData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        title: const Text(
          'Imágenes',
          style: TextStyle(
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
      body: SafeArea(
        child: noNoticias == 0
            ? const Center(
                child: Text('Por el momento, no hay imágenes para mostrar'),
              )
            : _controller.albums.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: _getInitData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scCtrl,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: size.height - 110,
                        ),
                        child: Column(
                          children: [
                            Wrap(
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: const EdgeInsets.all(10),
                                  itemCount: _controller.albums.length,
                                  itemBuilder: (context, index) {
                                    return _album(size, index);
                                  },
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
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

  Widget _album(Size size, int index) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => GaleriaPage(
            imagenes: _controller.albums[index].imagenes,
            nombreAlbum: _controller.albums[index].titulo,
            logo: widget.logo,
          ),
        ),
      ),
      child: Container(
        width: size.width * 0.50,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Palette.appcionaPrimaryColor.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: _controller.albums[index].portada,
                placeholder: (context, url) => Image.asset(widget.logo),
                errorWidget: (context, url, error) => Image.asset(widget.logo),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Palette.appcionaPrimaryColor.withOpacity(0.8),
                ),
                width: size.width * 0.50,
                child: Text(
                  _controller.albums[index].titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
