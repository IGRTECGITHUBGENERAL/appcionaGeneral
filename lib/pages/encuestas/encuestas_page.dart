import 'package:appciona/config/palette.dart';
import 'package:appciona/models/encuestas.dart';
import 'package:appciona/pages/encuestas/encuestas_controller.dart';
import 'package:appciona/pages/encuestas/encuestas_single_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EncuestasPage extends StatefulWidget {
  const EncuestasPage({Key? key}) : super(key: key);

  @override
  State<EncuestasPage> createState() => _EncuestasPageState();
}

class _EncuestasPageState extends State<EncuestasPage> {
  final EncuestasController _controller = EncuestasController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0XFFF3F4F6),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const Text(
          "Encuestas",
          style: TextStyle(
            color: Palette.appcionaPrimaryColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Palette.appcionaPrimaryColor,
          ),
        ),
        actions: [
          Image.asset(
            'assets/images/logo-green.png',
            fit: BoxFit.contain,
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _controller.getForms(),
          builder: (context, data) {
            if (data.hasData) {
              List<Encuestas> encuestas = data.data as List<Encuestas>;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: encuestas.isEmpty ? 0 : encuestas.length,
                      itemBuilder: (context, index) {
                        return _encuesta(
                          size,
                          '${encuestas[index].titulo}',
                          '${encuestas[index].imagen}',
                          '${encuestas[index].descripcion}',
                          '${encuestas[index].uid}',
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (data.hasError) {
              return Center(
                child: Text('Error al cargar las encuestas:\n${data.error}'),
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

  Widget _encuesta(
      Size size, String titulo, String urlImg, String resumen, String uid) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => EncuestasSingleTestPage(uidEncuesta: uid),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  width: size.width * 0.70,
                  imageUrl: urlImg,
                  placeholder: (context, url) =>
                      Image.asset('assets/images/logo-green.png'),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/logo-green.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(resumen),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
