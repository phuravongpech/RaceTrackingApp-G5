import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:race_tracking_app_g5/models/participant.dart';
import 'package:race_tracking_app_g5/repository/participant_repository.dart';
import 'package:race_tracking_app_g5/utils/async_value.dart';

class ParticipantProvider extends ChangeNotifier {
  final ParticipantRepository _repository;
  AsyncValue<List<Participant>>? participantState;

  bool get isLoading => participantState?.state == AsyncValueState.loading;
  bool get hasData =>
      participantState?.state == AsyncValueState.success &&
      participantState?.data != null;

  bool isDuplicate(int bibNumber) {
    final list = participantState?.data ?? [];
    return list.any((p) => p.bibNumber == bibNumber);
  }

  bool isDuplicateOnEdit(String name, int bibNumber, String id) {
    final list = participantState?.data ?? [];

    return list.any(
      (p) => p.id != id && (p.name == name || p.bibNumber == bibNumber),
    );
  }

  ParticipantProvider(this._repository) {
    fetchParticipants();
  }

  void fetchParticipants() async {
    try {
      participantState = AsyncValue.loading();
      notifyListeners();

      participantState = AsyncValue.success(
        await _repository.getAllParticipants(),
      );

      Logger().d(
        "SUCCESS: list size ${participantState?.data?.length.toString()}",
      );
    } catch (e) {
      participantState = AsyncValue.error(e);
      Logger().e("ERROR: $e");
    }

    notifyListeners();
  }

  void addParticipant(String name, int bibNumber) async {
    if (isDuplicate(bibNumber)) {
      Logger().w('Duplicate BIB number');
      return;
    }
    try {
      final newParticipant = await _repository.addParticipant(name, bibNumber);

      if (hasData) {
        participantState!.data!.add(newParticipant);
        notifyListeners();
      } else {
        fetchParticipants();
      }
    } catch (e) {
      Logger().e("ERROR: $e");
    }
  }

  void editParticipant(String name, int bibNumber, String id) async {
    try {
      await _repository.updateParticipant(name, bibNumber, id);
      //refresh after update
      fetchParticipants();
    } catch (e) {
      Logger().e("ERROR: $e");
    }
  }

  void deleteParticipant(String id) async {
    try {
      await _repository.deleteParticipant(id);
      //refresh after update
      fetchParticipants();
    } catch (e) {
      Logger().e("ERROR: $e");
    }
  }
}
