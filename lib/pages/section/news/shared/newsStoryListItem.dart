import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tv/controller/textScaleFactorController.dart';
import 'package:tv/helpers/analyticsHelper.dart';
import 'package:tv/models/storyListItem.dart';
import 'package:tv/pages/storyPage.dart';

class NewsStoryListItem extends StatelessWidget {
  final StoryListItem storyListItem;
  final String categorySlug;
  NewsStoryListItem({
    required this.storyListItem,
    this.categorySlug = 'latest',
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double imageSize = 33.3 * (width - 32) / 100;
    if (imageSize > 150) imageSize = 150;
    final TextScaleFactorController textScaleFactorController = Get.find();

    return InkWell(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                height: imageSize,
                width: imageSize,
                imageUrl: storyListItem.photoUrl,
                placeholder: (context, url) => Container(
                  height: imageSize,
                  width: imageSize,
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => Container(
                  height: imageSize,
                  width: imageSize,
                  color: Colors.grey,
                  child: Icon(Icons.error),
                ),
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Obx(
                  () => ExtendedText(
                    storyListItem.name,
                    joinZeroWidthSpace: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      height: 1.5,
                    ),
                    textScaleFactor:
                        textScaleFactorController.textScaleFactor.value,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          AnalyticsHelper.logClick(
            slug: storyListItem.slug,
            title: storyListItem.name,
            location:
                categorySlug == 'latest' ? 'HomePage_最新列表' : 'CategoryPage_列表',
          );
          Get.to(() => StoryPage(
                slug: storyListItem.slug,
              ));
        });
  }
}
