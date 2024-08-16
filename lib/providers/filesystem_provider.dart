import 'dart:async';

import 'package:client/protos/filesystem.pb.dart';
import 'package:client/services/fs_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final queryProvider =
    StateProvider.autoDispose.family<String, int>((ref, int tabIndex) {
  return '';
});

final getFolderProvider =
    FutureProvider.family<Folder, String>((ref, String path) async {
  return FsService.i.client.listFiles(Path(path: path));
});

class FileFetcher extends AutoDisposeFamilyAsyncNotifier<Folder, int> {
  FileFetcher();

  @override
  FutureOr<Folder> build(int arg) {
    return ref.watch(getFolderProvider('.').future);
  }

  Future<void> changeDir(String path) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => ref.watch(getFolderProvider(path).future),
    );
  }
}

final folderProvider =
    AutoDisposeAsyncNotifierProviderFamily<FileFetcher, Folder, int>(
  () {
    final fife = FileFetcher();
    return fife;
  },
);
