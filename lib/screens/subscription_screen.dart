import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutteryoutubeclone/constants/common_size.dart';
import 'package:flutteryoutubeclone/widgets/home_item_widget.dart';
import 'package:provider/provider.dart';


class SubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Divider(
          height: 1,
          color: Colors.white54,
        ),
        buildSubUsers(),
        Divider(
          height: 1,
          color: Colors.white54,
        ),
        buildTags()
      ]..addAll(List.generate(30, (index) => HomeItemWidget(index)))),
    );
  }

  SizedBox buildTags() {
    return SizedBox(
      height: 60,
      child: ChangeNotifierProvider<SelectedChip>(
        create: (_) => SelectedChip(),
        child: Consumer<SelectedChip>(
          builder: (BuildContext context, SelectedChip value, Widget child) {
            return ListView(
              padding: EdgeInsets.only(right: common_xs_gap),
              scrollDirection: Axis.horizontal,
              children: getTags(value.selectedLabel),
            );
          },
        ),
      ),
    );
  }

  SizedBox buildSubUsers() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: EdgeInsets.all(common_xs_gap),
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: common_s_gap,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                  'https://randomuser.me/api/portraits/women/$index.jpg',
                  width: 56,
                  height: 56,
                ),
              ),
              SizedBox(
                height: common_xxs_gap,
              ),
              SizedBox(
                height: 18,
                child: FittedBox(
                  child: Text(
                    'USERNAME',
                    style: TextStyle(
                        color: Colors.white60, fontWeight: FontWeight.w700),
                  ),
                  fit: BoxFit.fitHeight,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  List<SelectableChip> getTags(SelectedLabel selectedLabel) {
    return SelectedLabel.values
        .map((e) => SelectableChip(selectedLabel == e, e))
        .toList();
  }
}

class SelectableChip extends StatelessWidget {
  final bool selected;
  final SelectedLabel label;

  SelectableChip(
      this.selected,
      this.label, {
        Key key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected)
          Provider.of<SelectedChip>(context, listen: false).setSelected(label);
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: common_xs_gap,
          top: common_xxxs_gap,
          bottom: common_xxxs_gap,
        ),
        child: Chip(
          label: Text(
            label
                .toString()
                .replaceFirst("SelectedLabel.", "")
                .replaceFirst("_", " "),
            style: TextStyle(
                color: selected ? Colors.black54 : Colors.white,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: selected ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }
}

class SelectedChip extends ChangeNotifier {
  SelectedLabel _selectedLabel = SelectedLabel.All;

  void setSelected(SelectedLabel selectedLabel) {
    _selectedLabel = selectedLabel;
    notifyListeners();
  }

  SelectedLabel get selectedLabel => _selectedLabel;
}

enum SelectedLabel {
  All,
  Today,
  Continue_Watching,
  Unwatched,
  Live,
  Posts,
}