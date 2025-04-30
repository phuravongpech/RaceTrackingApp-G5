import 'package:flutter/material.dart';
import 'package:race_tracking_app_g5/models/segment_time.dart';
import 'package:race_tracking_app_g5/theme/theme.dart';

class SegmentTabbar extends StatelessWidget {
  const SegmentTabbar({
    super.key,
    required this.segments,
    required this.tabController,
  });

  final List<Segment> segments;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      unselectedLabelColor: RTColors.primary,
      labelColor: RTColors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: RTColors.primary,
      ),
      dividerColor: Colors.transparent,
      isScrollable: true,
      tabs:
          segments
              .map(
                (segments) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Tab(
                    child: Text(segments.label, style: TextStyle(fontSize: 25)),
                  ),
                ),
              )
              .toList(),
    );
  }
}

class SegmentTabView extends StatelessWidget {
  const SegmentTabView({
    super.key,
    required this.segments,
    required this.tabController,
  });

  final List<Segment> segments;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children:
          segments.map((segment) {
            return Center(
              child: Text(
                'Current Segment: ${segment.label}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: RTColors.textPrimary),
              ),
            );
          }).toList(),
    );
  }
}
