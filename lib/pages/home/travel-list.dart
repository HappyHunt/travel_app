import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../offers/offers_data.dart';

class TravelsListView extends StatelessWidget {
  final List<Offer> dataList;

  TravelsListView({required this.dataList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(dataList[index].title),
        );
      },
    );
  }
}
