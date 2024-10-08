import 'dart:async';

import 'package:alt/grpc/grpc_client.dart';
import 'package:alt/protos/filesystem.pb.dart';
import 'package:alt/services/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final fetchFolderProvider =
    FutureProvider.autoDispose.family<Folder, String>((ref, String path) async {
  // remove cached folders after 5 min
  ref.cacheFor(const Duration(minutes: 5));
  return fs.listFiles(Path(path: path));
});

class FileFetcher extends AutoDisposeFamilyAsyncNotifier<Folder, FolderInput> {
  FileFetcher();

  @override
  FutureOr<Folder> build(FolderInput arg) {
    return ref.read(fetchFolderProvider(arg.initialDir).future);
  }

  Future<void> changeDir(String path) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => ref.watch(fetchFolderProvider(path).future),
    );
  }

  Future<void> refreshDir(String path) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        return ref.refresh(fetchFolderProvider(path).future);
      },
    );
  }
}

@immutable
class FolderInput {
  const FolderInput({required this.initialDir, required this.tab});

  final String initialDir;
  final int tab;

  @override
  bool operator ==(Object other) {
    return other is FolderInput &&
        runtimeType == other.runtimeType &&
        tab == other.tab &&
        initialDir == other.initialDir;
  }
}

final folderProvider =
    AutoDisposeAsyncNotifierProviderFamily<FileFetcher, Folder, FolderInput>(
  () {
    final fife = FileFetcher();
    return fife;
  },
);
