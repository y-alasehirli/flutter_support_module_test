import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';

class ShowProfilePicWid extends StatelessWidget {
  const ShowProfilePicWid(this._photoURL,
      {required this.isDownloadable, Key? key})
      : super(key: key);
  final String _photoURL;
  final bool isDownloadable;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: _photoURL,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Card(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Image.network(
                  _photoURL,
                ),
                isDownloadable
                    ? IconButton(
                        color: Colors.amberAccent.shade100,
                        onPressed: () async {
                          String? downloadImage =
                              await ImageDownloader.downloadImage(_photoURL,
                                  destination: AndroidDestinationType
                                      .directoryDownloads);
                          if (downloadImage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("İndirme başarılı"),
                              backgroundColor: Colors.green.shade700,
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("İndirme başarısız"),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                        icon: const Icon(Icons.download_for_offline_outlined))
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
