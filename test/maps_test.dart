import 'dart:convert';
import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  // mark exit handler test
  // loadJson

  final file = new File('test/logbook_data.json');
  final json = jsonDecode(await file.readAsString());
  final logbook = LogbookResponseModel.fromJson(json).data!;
  // print(logbook);

  final logbookStorage = [...logbook];

  group('markExit Handler', () {
    test('Remove an element from list', () async {
      // logbook.removeAt(0);
      logbook.removeAt(3);
      logbook.removeAt(10);
      // logbook.removeAt(19);
    });

    test('Find difference in list', () async {
      final itemsToRemove = [];
      final first20Items = logbook.getRange(0, 19).toList();

      for (var item in logbookStorage) {
        // if (first20Items.first.id! < item.id!) {
        //   itemsToRemove.add(item.id);
        //   return;
        // }

        if (first20Items.first.id! <= item.id!) {
          itemsToRemove.add(item.id);
        }

        final startEntry = item.id! <= first20Items.first.id!;
        final endEntry = item.id! >= first20Items.last.id!;

        if (startEntry && endEntry) {
          // print(item.id);
          print('logbook contains logrecord with id ${item.id} ${logbookStorage.contains(item)}');
          // itemsToRemove.add(item.id);
        }

        print(itemsToRemove.length);

        // if (first20Items.last.id! > item.id!) {
        //   print(item.id);
        //   return;
        // }
      }
    });

    // expect(logbook.length != logbookStorage.length, true);
    // final difference1 = logbookStorage.toSet().difference(logbook.toSet());
    // print(difference1.length);

    // difference1.forEach((element) {
    //   logbookStorage.remove(element);
    // });

    // expect(logbookStorage.length, logbook.length);

    // print(difference2.length);
  });

  LogbookEntry? getElementById(int? id) {
    final result = logbookStorage.indexWhere((element) => element.id == id);
    if (result != -1) {
      return logbookStorage[result];
    }
    return null;
  }
  // });
}
