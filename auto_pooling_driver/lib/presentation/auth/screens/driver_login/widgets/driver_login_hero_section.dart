import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class DriverLoginHeroSection extends StatelessWidget {
  const DriverLoginHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DriverLoginHeroBackdrop(),
          DriverLoginHeroOverlay(),
          DriverLoginBranding(),
        ],
      ),
    );
  }
}

class DriverLoginHeroBackdrop extends StatelessWidget {
  const DriverLoginHeroBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            context.currentTheme.accentPrimary.withValues(alpha: 0.88),
            context.currentTheme.accentPrimary.withValues(alpha: 0.56),
          ],
        ),
      ),
      child: const Stack(
        children: <Widget>[
          DriverLoginHeroCircle(alignment: Alignment.topRight, size: 180),
          DriverLoginHeroCircle(alignment: Alignment.centerLeft, size: 220),
          DriverLoginHeroRouteGlyph(),
        ],
      ),
    );
  }
}

class DriverLoginHeroCircle extends StatelessWidget {
  const DriverLoginHeroCircle({
    required this.alignment,
    required this.size,
    super.key,
  });

  final Alignment alignment;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class DriverLoginHeroRouteGlyph extends StatelessWidget {
  const DriverLoginHeroRouteGlyph({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.alt_route_rounded, size: 136, color: Color(0x33FFFFFF)),
    );
  }
}

class DriverLoginHeroOverlay extends StatelessWidget {
  const DriverLoginHeroOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            context.currentTheme.backgroundPrimary,
          ],
          stops: const <double>[0.45, 1],
        ),
      ),
    );
  }
}

class DriverLoginBranding extends StatelessWidget {
  const DriverLoginBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: <Widget>[
          const DriverLoginBrandMark(),
          const SizedBox(width: 12),
          Text(
            context.localization.appTitle,
            style: AppTextStyles.h2Bold.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class DriverLoginBrandMark extends StatelessWidget {
  const DriverLoginBrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: const Icon(Icons.local_taxi_rounded, color: Colors.white),
    );
  }
}
