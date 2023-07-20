import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/message/message.dart';
import '../../core/models/person/person.dart';
import '../../static/hero_dialog_route.dart';
import 'show_profile_pic_widget.dart';

class SpeechBubble extends StatelessWidget {
  const SpeechBubble(this._message, this._person, {Key? key}) : super(key: key);

  final Message _message;
  final Person _person;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: _person.uid == _message.from
              ? WrapAlignment.end
              : WrapAlignment.start,
          children: [
            _person.uid == _message.from
                ? _message.contentTime == null
                    ? _showCurrentTimeText()
                    : _showContentTime(_message.contentTime!)
                : const SizedBox(),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _person.uid == _message.from
                    ? Colors.green.shade100
                    : Colors.blue.shade100,
              ),
              child: _message.type == "text"
                  ? Text(
                      _message.content!,
                      softWrap: true,
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.push(context, HeroDialogRoute(
                          builder: (context) {
                            return ShowProfilePicWid(_message.content!,
                                isDownloadable: true);
                          },
                        ));
                      },
                      child: Hero(
                        tag: _message.content!,
                        child: Image.network(
                          _message.content!,
                          scale: 4,
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              width: 5,
            ),
            _person.uid != _message.from
                ? _message.contentTime == null
                    ? _showCurrentTimeText()
                    : _showContentTime(_message.contentTime!)
                : const SizedBox()
          ]),
    );
  }

  Text _showContentTime(Timestamp contentTime) {
    String format = DateFormat.Hm().format(contentTime.toDate());
    return Text(format);
  }

  Text _showCurrentTimeText() {
    String format = DateFormat.Hm().format(DateTime.now());
    return Text(format);
  }
}
