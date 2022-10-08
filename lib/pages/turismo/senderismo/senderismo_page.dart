import 'package:appciona/config/palette.dart';
import 'package:appciona/pages/turismo/senderismo/senderismo_controller.dart';
import 'package:appciona/pages/turismo/senderismo/senderismo_single/senderismo_single_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SenderismoPage extends StatefulWidget {
  final String assetImagePlaceholder;
  const SenderismoPage({
    Key? key,
    required this.assetImagePlaceholder,
  }) : super(key: key);

  @override
  State<SenderismoPage> createState() => _SenderismoPageState();
}

class _SenderismoPageState extends State<SenderismoPage> {
  final SenderismoController _controller = SenderismoController();
  final ScrollController _scCtrl = ScrollController();

  late int noItems = -1;

  Future<void> _getInitData() async {
    noItems = await _controller.getItemsSize();
    await _controller.getFirstItems();
    setState(() {});
  }

  Future<void> _getNextData() async {
    await _controller.getNextItems();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getInitData();
    _scCtrl.addListener(() {
      if (_scCtrl.position.atEdge) {
        if (_scCtrl.position.pixels != 0 &&
            _controller.itemSenderismo.length < noItems) {
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
        title: const Text(
          "Senderismo",
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
        child: noItems == 0
            ? const Center(
                child: Text('No hay información aún'),
              )
            : _controller.itemSenderismo.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: _getInitData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scCtrl,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: size.height - 90,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: size.width * 0.90,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: _controller.itemSenderismo.length,
                                  itemBuilder: (context, index) {
                                    return _cardInterest(size, index);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Card _cardInterest(Size size, int index) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SenderismoSinglePage(
              uid: '${_controller.itemSenderismo[index].uid}',
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: size.width * 0.25,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(right: 5),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                        '${_controller.itemSenderismo[index].imagenes!.first}',
                    placeholder: (context, url) =>
                        Image.asset(widget.assetImagePlaceholder),
                    errorWidget: (context, url, error) =>
                        Image.asset(widget.assetImagePlaceholder),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${_controller.itemSenderismo[index].titulo}',
                      style: TextStyle(
                        color: Palette.appcionaPrimaryColor.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      color: Palette.appcionaSecondaryColor,
                      thickness: 1,
                    ),
                    Text(
                      '${_controller.itemSenderismo[index].descripcion}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
