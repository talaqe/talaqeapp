import 'package:flutter/material.dart';

class FAQExpansionTile extends StatelessWidget {
  final String questionTitleText;
  final String answerContentText;
  const FAQExpansionTile({
    Key? key,
    required this.questionTitleText,
    required this.answerContentText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
          tilePadding: const EdgeInsets.only(top: 16, bottom: 5),
          childrenPadding: const EdgeInsets.only(bottom: 16),
          title: Text(
            questionTitleText,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          children: [Text(answerContentText)]),
    );
  }
}
