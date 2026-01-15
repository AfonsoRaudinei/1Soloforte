import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

enum EventType {
  @JsonValue('technicalVisit')
  technicalVisit,
  @JsonValue('application')
  application,
  @JsonValue('consultancy')
  consultancy,
  @JsonValue('harvest')
  harvest,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('meeting')
  meeting,
  @JsonValue('reminder')
  reminder,
  @JsonValue('custom')
  custom,
}

enum EventStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('inProgress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('rescheduled')
  rescheduled,
}

@freezed
class EventRecurrence with _$EventRecurrence {
  const factory EventRecurrence({
    required String frequency, // 'daily', 'weekly', 'monthly'
    required int interval,
    DateTime? endDate,
    @Default([]) List<DateTime> exceptionDates,
  }) = _EventRecurrence;

  factory EventRecurrence.fromJson(Map<String, dynamic> json) =>
      _$EventRecurrenceFromJson(json);
}

@freezed
class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String id,
    required String label,
    @Default(false) bool isCompleted,
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);
}

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required EventType type,
    @Default(EventStatus.scheduled) EventStatus status,
    required String location,

    // Relations
    String? clientId,
    String? clientName,
    String? areaId,
    String? areaName,

    // Details
    @Default([]) List<String> participants,
    @Default([]) List<ChecklistItem> checklist,
    @Default([]) List<String> attachmentUrls,
    String? notes,

    // Recurrence
    EventRecurrence? recurrence,

    // Integrations & Metadata
    Map<String, dynamic>? weatherForecast,
    Map<String, double>? locationCoordinates, // Added for Map integration
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
