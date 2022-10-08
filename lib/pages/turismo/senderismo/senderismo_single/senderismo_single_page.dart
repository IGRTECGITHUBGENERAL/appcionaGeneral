import 'package:appciona/config/palette.dart';
import 'package:appciona/models/senderismo.dart';
import 'package:appciona/pages/turismo/senderismo/senderismo_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SenderismoSinglePage extends StatefulWidget {
  final String uid;
  const SenderismoSinglePage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<SenderismoSinglePage> createState() => _SenderismoSinglePageState();
}

class _SenderismoSinglePageState extends State<SenderismoSinglePage> {
  final SenderismoController _controller = SenderismoController();

  void _launchContent(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      debugPrint('No se pudo acceder al sitio.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Palette.appcionaPrimaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _controller.getSingleItem(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Senderismo item = snapshot.data as Senderismo;
              List<String> imagenes = [];
              for (String? element in item.imagenes!) {
                imagenes.add(element.toString());
              }
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _carouselImgs(size, imagenes),
                      _titulo(size, item),
                      _descripcionTecnica(size, item),
                      _map(item, size),
                      _descripcion(size, item),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  SizedBox _titulo(Size size, Senderismo item) {
    return SizedBox(
      width: size.width * 0.90,
      child: Text(
        '${item.titulo}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Palette.appcionaPrimaryColor,
          fontSize: 22,
        ),
      ),
    );
  }

  Container _descripcion(Size size, Senderismo item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.90,
      child: Column(
        children: [
          Text(
            'Descripción',
            style: TextStyle(
              color: Palette.appcionaSecondaryColor.shade800,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const Divider(
            color: Palette.appcionaSecondaryColor,
            thickness: 1,
          ),
          Text('${item.descripcion}'),
        ],
      ),
    );
  }

  Container _carouselImgs(Size size, List<String> imagenes) {
    return Container(
      width: size.width * 0.90,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: imagenes.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Swiper(
                    itemCount: imagenes.length,
                    autoplay: imagenes.length == 1 ? false : true,
                    indicatorLayout: imagenes.isEmpty
                        ? PageIndicatorLayout.NONE
                        : PageIndicatorLayout.COLOR,
                    pagination:
                        imagenes.length == 1 ? null : const SwiperPagination(),
                    control:
                        imagenes.length == 1 ? null : const SwiperControl(),
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: imagenes[index],
                        placeholder: (context, url) =>
                            Image.asset('assets/icons/senderismo_mono.png'),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/icons/senderismo_mono.png'),
                      );
                    },
                  )),
            )
          : const SizedBox.shrink(),
    );
  }

  Card _map(Senderismo item, Size size) {
    return Card(
      elevation: 5,
      color: Palette.appcionaPrimaryColor.shade100,
      child: InkWell(
        onTap: () => _launchContent('${item.mapa}'),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: size.width * 0.90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ir al mapa del sendero  ',
                style: TextStyle(color: Palette.appcionaPrimaryColor.shade700),
              ),
              Icon(
                Icons.map,
                color: Palette.appcionaPrimaryColor.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _descripcionTecnica(Size size, Senderismo item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Palette.appcionaSecondaryColor.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      width: size.width * 0.90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text.rich(
            TextSpan(
              style: TextStyle(
                color: Palette.appcionaSecondaryColor.shade600,
              ),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.directions_walk_rounded,
                    color: Palette.appcionaSecondaryColor.shade600,
                  ),
                ),
                const TextSpan(
                  text: 'Distancia: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: '${item.desnivel}'),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              style: TextStyle(
                color: Palette.appcionaSecondaryColor.shade600,
              ),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.height,
                    color: Palette.appcionaSecondaryColor.shade600,
                  ),
                ),
                const TextSpan(
                  text: 'Desnivel: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: '${item.desnivel}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
