import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dio_client.dart';

// 1. Create a Provider for the phone's secure vault.
// We use 'const' here because we only ever need one instance of this.
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// 2. Create a Provider for our custom Dio Client.
// Notice how we use 'ref.watch' to grab the secure storage and inject it into Dio!
final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return DioClient(secureStorage);
});