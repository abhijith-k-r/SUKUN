// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/news/model/news_model.dart' hide Image;

// ! Custom News Card
Widget buidNewsCard(Responsive r, TextTheme textThem, Datum newsItem) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: r.w * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                newsItem.image.url,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stk) => Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported, size: 50),
                ),
                loadingBuilder: (ctx, child, loading) => loading == null
                    ? child
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ),

          SizedBox(height: r.hLarge),

          // ! Title
          Text(
            newsItem.title,
            style: textThem.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),

          SizedBox(height: r.hMedium),
          Text(
            newsItem.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),

          SizedBox(height: r.hMedium),
          Text(
            "${newsItem.source.name} | ${newsItem.updatedAt.toString().split(' ')[0]}",
          ),
          SizedBox(height: r.hSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => print('Share ${newsItem.title}'),
                label: Text('Share', style: TextStyle(color: AppColors.error)),
                icon: Transform.flip(
                  flipX: true,
                  child: Icon(CupertinoIcons.reply, color: AppColors.error),
                ),
              ),

              TextButton.icon(
                onPressed: () => print('Bookmark ${newsItem.id}'),
                label: Text(
                  'Bookmark',
                  style: TextStyle(color: AppColors.accentYellow),
                ),

                icon: Icon(
                  CupertinoIcons.bookmark_fill,
                  color: AppColors.accentYellow,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
