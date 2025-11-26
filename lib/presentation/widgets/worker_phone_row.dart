import 'package:changas_ya_app/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class WorkerPhoneRow extends ConsumerWidget {
  final String profileId;

  const WorkerPhoneRow({
    super.key,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(professionalFutureProvider(profileId));

    return profileAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (profile) {
        // 👇 Ajustá el nombre del campo según tu modelo:
        // puede ser profile.phone, profile.phoneNumber, profile.telefono, etc.
        final String? phone = profile?.phone;

        if (phone == null || phone.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              const Icon(Icons.phone, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                phone,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
