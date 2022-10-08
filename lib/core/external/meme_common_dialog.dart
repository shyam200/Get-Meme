import 'package:flutter/material.dart';

import '../../resources/styles/text_styles.dart';

///Meme [common dialog] classs to build different types of dilog with content
class MemeDialog extends StatefulWidget {
  final String? title;
  final Widget content;
  final String? negativeButtonContent;
  final String? positiveButtonContent;
  final Function? negativeFunction;
  final Function? positiveFuntion;

  const MemeDialog({
    Key? key,
    this.title,
    required this.content,
    this.negativeButtonContent,
    this.positiveButtonContent,
    this.positiveFuntion,
    this.negativeFunction,
  }) : super(key: key);

  @override
  State<MemeDialog> createState() => _MemeDialogState();
}

class _MemeDialogState extends State<MemeDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280),
          child: Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //Title of the dialog
                if (widget.title != null && widget.title!.isNotEmpty)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 8.0),
                      child: Text(
                        widget.title!,
                        textAlign: TextAlign.left,
                        style: TextStyles.memeDialogHeadline,
                      ),
                    ),
                  ),
                //widget draws as content of the dialog
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                  child: widget.content,
                ),

                //Bottom Buttons
                _buildBottomBar(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBottomBar(BuildContext context) {
    return Row(
      children: [
        //negative button always shows
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: widget.positiveButtonContent != null
                  ? const Border(
                      top: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      right: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ))
                  : const Border(
                      top: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
            ),
            child: TextButton(
                onPressed: () {
                  if (widget.negativeFunction != null) {
                    widget.negativeFunction!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.negativeButtonContent ?? 'Cancel')),
          ),
        ),

        //positive button only shows when its content is passed
        if (widget.positiveButtonContent != null)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              )),
              child: TextButton(
                  onPressed: () {
                    if (widget.positiveFuntion != null) {
                      widget.positiveFuntion!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(widget.positiveButtonContent!)),
            ),
          ),
      ],
    );
  }
}
