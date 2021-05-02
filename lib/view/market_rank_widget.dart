import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_book/log/event_log.dart';
import 'package:style_book/model/item_model.dart';
import 'package:style_book/provider/item_provider.dart';

class MarketRankStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MarketRankGridWidget(),
    );
  }
}

class MarketRankGridWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MarketRankState();
}

class MarketRankState extends State<MarketRankGridWidget> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ItemProvider>(context, listen: false);
    provider.getItemList("");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12),
        itemCount: provider.items.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
        controller: _controller,
        itemBuilder: (context, index) {
          final item = provider.items[index];
          return InkWell(
            onTap: () {
              EventLog.sendEventLog("click_market_rank",
                  eventProperties: {'item': item.toJson(item)});
              // _launchUrl(url: item.postUrl ?? "", title: _shop.name);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AnimatedSwitcher(
                child: _getImage(item),
                duration: Duration(seconds: 1),
              ),
            ),
          );
        });
  }

  Widget? _getImage(Item item) {
    final list = item.imageList();
    print("market image list $list");
    if (list.isEmpty) {
      return null;
    }

    return Image.network(list[0], fit: BoxFit.fitHeight);
  }
}
