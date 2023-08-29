import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('disposes error stream', (WidgetTester tester) async {
    final StreamController<ErrorAnimationType> controller =
        StreamController<ErrorAnimationType>();
    final gradient = RadialGradient(
      colors: [
        Colors.lightBlue,
        Colors.lightBlue.shade800,
      ],
      center: const Alignment(
        -0.9,
        -0.6,
      ),
      stops: const [
        0.0,
        1.0,
      ],
      radius: 2.4,
    );
    final Widget app = Builder(
      builder: (context) => MaterialApp(
        home: Scaffold(
          body: PinCodeTextField(
            bottomGradient: gradient,
            appContext: context,
            length: 6,
            errorAnimationController: controller,
          ),
        ),
      ),
    );

    await tester.pumpWidget(app);
    expect(controller.hasListener, isTrue);

    await tester.pumpWidget(SizedBox());
    expect(controller.hasListener, isFalse);
    controller.close();
  });

  /// This test demonstrates that a application can set a InputDecorationTheme
  /// which specifies a background color for input fields. When this happens,
  /// the PinCodeFields should override the theme setting with the users chosen
  /// background color.
  testWidgets('transparent background', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(800, 400));

    final Widget app = Builder(
      builder: (context) {
        final gradient = RadialGradient(
          colors: [
            Colors.lightBlue,
            Colors.lightBlue.shade800,
          ],
          center: const Alignment(
            -0.9,
            -0.6,
          ),
          stops: const [
            0.0,
            1.0,
          ],
          radius: 2.4,
        );
        return MaterialApp(
          theme: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.red,
            filled: true,
          )),
          home: Scaffold(
            backgroundColor: Colors.black,
            body: Builder(builder: (context) {
              return PinCodeTextField(
                bottomGradient: gradient,
                appContext: context,
                autoFocus: true,
                backgroundColor: Colors.transparent,
                length: 6,
                animationDuration: Duration.zero,
              );
            }),
          ),
        );
      },
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('golden_test_1.png'),
    );
  });
}
