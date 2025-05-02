import 'package:flutter/material.dart';

enum Segment { swimming, cycling, running }

extension SegmentExtension on Segment {
  String get label {
    switch (this) {
      case Segment.swimming:
        return 'Swimming';
      case Segment.cycling:
        return 'Cycling';
      case Segment.running:
        return 'Running';
    }
  }

  IconData get icon{
    switch (this) {
      case Segment.swimming:
        return Icons.pool_rounded;
      case Segment.cycling:
        return Icons.pedal_bike_rounded;
      case Segment.running:
        return Icons.directions_run_rounded;
    }
  }
}

class SegmentTime {
  final Segment segment;
  final String participantId;
  final int elapsedTimeInSeconds;
  // example: 753sec  = 12 mins 33 secs

  SegmentTime({
    required this.segment,
    required this.participantId,
    required this.elapsedTimeInSeconds,
  });

  factory SegmentTime.fromMap(Map<String, dynamic> map) {
    return SegmentTime(
      segment: _statusFromString(map['segment']),
      participantId: map['participantId'],
      elapsedTimeInSeconds: map['elapsedTimeInSeconds'] ?? 'N/A',
    );
  }

  static Segment _statusFromString(String segment) {
    switch (segment) {
      case 'Swimming':
        return Segment.swimming;
      case 'Cycling':
        return Segment.cycling;
      case 'Running':
        return Segment.running;
      default:
        throw ArgumentError('Invalid segment: $segment');
    }
  }
}
