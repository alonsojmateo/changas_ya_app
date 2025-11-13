import 'package:flutter_riverpod/flutter_riverpod.dart';


final paymentMethodProvider = StateProvider.family<String, String>((ref, jobId) => '');