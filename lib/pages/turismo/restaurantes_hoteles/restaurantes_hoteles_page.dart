import 'package:appciona/config/palette.dart';
import 'package:appciona/models/turismo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'restaurantes_hoteles_controller.dart';

class RestaurantesHotelesPage extends StatefulWidget {
  final String tipo;
  const RestaurantesHotelesPage({
    Key? key,
    required this.tipo,
  }) : super(key: key);

  @override
  State<RestaurantesHotelesPage> createState() =>
      _RestaurantesHotelesPageState();
}

class _RestaurantesHotelesPageState extends State<RestaurantesHotelesPage> {
  final RestaurantesHotelesController _controller =
      RestaurantesHotelesController();

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
            Icons.arrow_back_ios,
            color: Palette.appcionaPrimaryColor,
          ),
        ),
        title: widget.tipo == "Hotel"
            ? Text(
                "${widget.tipo}es",
                style: const TextStyle(
                  color: Palette.appcionaPrimaryColor,
                ),
              )
            : Text(
                "${widget.tipo}s",
                style: const TextStyle(
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _controller.getServices(widget.tipo),
            builder: (context, data) {
              if (data.hasData) {
                List<Turismo> items = data.data as List<Turismo>;
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: items.isEmpty ? 0 : items.length,
                      itemBuilder: (context, index) => _cardServices(
                        size,
                        '${items[index].imagen}',
                        '${items[index].titulo}',
                        '${items[index].telefono}',
                        '${items[index].direccion}',
                        '${items[index].correo}',
                      ),
                    ),
                  ],
                );
              } else if (data.hasError) {
                return Center(
                  child: Text(
                      'Ocurrió un error al cargar la información: ${data.error}'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  FlipCard _cardServices(Size size, String img, String titulo, String telefono,
      String direccion, String correo) {
    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL,
      front: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 5,
          ),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: img,
                      placeholder: (context, url) =>
                          Image.asset('assets/images/logo-green.png'),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/logo-green.png'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: '$titulo\n',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(Icons.location_on_rounded),
                        ),
                        const TextSpan(
                          text: ' Dirección\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '$direccion\n'),
                        const WidgetSpan(
                          child: Icon(Icons.rotate_90_degrees_ccw_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      back: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              width: size.width,
              decoration: const BoxDecoration(
                color: Color(0XFF007474),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.phone,
                            color: Color(0XFF005059),
                          ),
                          Text(telefono),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.email_rounded,
                            color: Color(0XFF005059),
                          ),
                          Text(correo.isEmpty ? 'Sin correo' : correo),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
