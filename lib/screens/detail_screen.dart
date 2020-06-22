import 'package:flutter/material.dart';
import 'package:flutteryoutubeclone/constants/common_size.dart';
import 'package:flutteryoutubeclone/constants/size.dart';
import 'package:flutteryoutubeclone/data/bool_change_notifier.dart';
import 'package:flutteryoutubeclone/widgets/my_video_player.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() {
    return _DetailScreenState();
  }
}

class _DetailScreenState extends State<DetailScreen> {
  double minDraggableSize;
  double videoScale = 1.0;
  double translateY = 0.0;

  @override
  Widget build(BuildContext context) {
    if (minDraggableSize == null) minDraggableSize = calculateMinDraggable();
    if (size == null) size = MediaQuery.of(context).size;
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        print("${notification.extent}");
        setState(() {
          videoScale = getVideoScale(notification.extent);
          translateY = getVideoYPosition(notification.extent);
        });
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: minDraggableSize,
        maxChildSize: 1,
        builder: (context, scrollController) {
          return Container(
            width: size.width,
            height: size.height,
            color: Theme.of(context).backgroundColor,
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        height: (size.width * 1080 / 1920) / 2,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: size.width / 2,
                            ),
                            Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: common_s_gap),
                                  child: Text(
                                    "Best cooking EVER!!!",
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Provider.of<BoolNotifier>(context,
                                    listen: false)
                                    .value = false;
                              },
                            )
                          ],
                        ),
                      ),
                      Transform(
                          transform: Matrix4(videoScale, 0, 0, 0, 0, videoScale,
                              0, 0, 0, 0, 1, 0, 0, 0, 0, 1),
                          child: MyVideoPlayer()),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: common_s_gap,
                              right: common_s_gap,
                              top: common_s_gap),
                          child: Text(
                            'Hainanese chicken rice • Tasty',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: common_s_gap,
                              right: common_s_gap,
                              top: common_xs_gap),
                          child: Text(
                            '1.8M views • 2 years ago',
                            style:
                            TextStyle(color: Colors.white30, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  double getVideoScale(double curExtend) {
    return 0.5 / (1 - minDraggableSize) * curExtend +
        (0.5 - (0.5 / (1 - minDraggableSize) * minDraggableSize));
  }

  double getVideoYPosition(double curExtend) {
    double h = (size.width * 1080 / 1920) / 2;
    return (-h / (1 - minDraggableSize) * curExtend) +
        ((h / (1 - minDraggableSize) * minDraggableSize) + h);
  }

  double getDragTransformEquationResult(double endValue, double curExtend) {
    return endValue / (1 - minDraggableSize) * curExtend +
        (endValue / (1 - minDraggableSize));
  }

  double calculateMinDraggable() {
    return (1080 /
        (1080 +
            (size.height - (1080 * size.width / 1920)) *
                1920 /
                size.width)) /
        2;
  }
}