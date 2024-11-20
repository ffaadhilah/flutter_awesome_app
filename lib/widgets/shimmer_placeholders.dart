import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGridPlaceholder extends StatelessWidget {
  final int itemCount;

  const ShimmerGridPlaceholder({Key? key, this.itemCount = 6})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: EdgeInsets.all(8.0),
              color: Colors.grey[300],
            ),
          );
        },
        childCount: itemCount,
      ),
    );
  }
}

class ShimmerListPlaceholder extends StatelessWidget {
  final int itemCount;

  const ShimmerListPlaceholder({Key? key, this.itemCount = 6})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
              ),
              title: Container(
                width: double.infinity,
                height: 16.0,
                color: Colors.grey[300],
              ),
              subtitle: Container(
                width: double.infinity,
                height: 12.0,
                color: Colors.grey[300],
              ),
            ),
          );
        },
        childCount: itemCount,
      ),
    );
  }
}
