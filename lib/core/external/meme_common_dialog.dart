import 'package:flutter/material.dart';

import '../../resources/styles/text_styles.dart';

///Meme [common base dialog] classs to build different types of dilog with content
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
        child: Material(
          elevation: 24.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Title of the dialog
              if (widget.title != null && widget.title!.isNotEmpty)
                _buildTitle(),
              //widget draws as content of the dialog
              _buildContent(),

              //Bottom Buttons
              _buildBottomBar(context)
            ],
          ),
        ),
      ),
    );
  }

  Align _buildContent() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: widget.content,
      ),
    );
  }

  Align _buildTitle() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 8.0),
        child: Text(
          widget.title!,
          textAlign: TextAlign.left,
          style: TextStyles.memeDialogHeadline,
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

///class to handle different types of dialog inside the app
///Used as a [mixin class]
class MemeCommonDialog<T extends StatefulWidget> {
  ///show meme [confirmation] dialog
  showSuccessDialog({
    required String text,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return MemeDialog(
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: TextStyles.memeDialogText,
            ),
          ),
          negativeButtonContent: 'Ok',
        );
      },
    );
  }
}
