import 'package:chat_app/presentation/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final socketServiceProvider = Provider((ref) => SocketService());
