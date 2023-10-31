import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

import 'image_text.dart';

class CommentField extends StatefulWidget {
  const CommentField({super.key});

  @override
  CommentFieldState createState() => CommentFieldState();
}

class CommentFieldState extends State<CommentField> {
  bool _showStampList = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ExtendedTextField(
              specialTextSpanBuilder: ImageSpanBuilder(
                showAtBackground: true,
              ),
              maxLines: 4,
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'input comment',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Color(0xff9299A3),
                ),
                // TODO: 以降二つがなぜ必要なのか見極める
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff9299A3),
                  )
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff9299A3),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showStampList = !_showStampList;
                  });
                },
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset('assets/images/add_reaction.png'),
                ),
              ),
            ),
          ],
        ),
        if (_showStampList) ...[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            height: 68,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      final stamp = '<img src=\'${stampPaths[index]}\' width=\'24\' height=\'24\'/>';
                      final text = _controller.text;
                      final selection = _controller.selection;

                      final before = selection.start == -1
                        ? '' : text.substring(0, selection.start);

                      final after = selection.start == -1
                        ? '' : text.substring(selection.end);

                      _controller..text = selection.start == -1 
                      ? stamp : '$before$stamp$after'
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: before.length + stamp.length),
                        );

                      _showStampList = false;
                    });
                  },
                  child: Container(
                    margin: index == 0 ? const EdgeInsets.only(left: 19.5) 
                        : const EdgeInsets.only(left: 32),
                    alignment: Alignment.center,
                    child: Image.asset(stampPaths[index]),
                  ),
                );
              },
            ),
          )
        ],
      ],
    );
  }

  List<String> stampPaths = const [
    'assets/images/bad.png',
    'assets/images/cool.png',
    'assets/images/cry.png',
    'assets/images/laughter.png',
    'assets/images/love.png',
    'assets/images/smile.png',
  ];
}

class ImageSpanBuilder extends SpecialTextSpanBuilder {
  ImageSpanBuilder({this.showAtBackground = false});

  final bool showAtBackground;
  @override
  TextSpan build(String data,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    final textSpan =
        super.build(data, textStyle: textStyle, onTap: onTap);
    return textSpan;
  }

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, int? index}) {
    if (flag == '') {
      return null;
    }

    if (isStart(flag, ImageText.flag)) {
      return ImageText(textStyle,
          start: index! - (ImageText.flag.length - 1), onTap: onTap,);
    }

    return null;
  }
}
