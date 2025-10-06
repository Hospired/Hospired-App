import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../text_styles.dart';
import '../providers/auth_user.dart';

class StartPage extends HookConsumerWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*
    final checkSession = useCallback(() {
      final authUserRes = ref.read(authUserProvider.notifier).checkSession();
      if (authUserRes != null) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }, []);
    */

    useEffect(() {
      Future.microtask(() {
        final authUserRes = ref.read(authUserProvider.notifier).checkSession();
        if (authUserRes != null) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        }
      });
      return;
    }, []);

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              "Verificando sesión ...",
              style: HospiredTextStyle.title3,
            ),
          ),
        ],
      ),
    );
  }
}
