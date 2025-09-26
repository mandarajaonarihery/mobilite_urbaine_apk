import 'package:flutter/material.dart';

/// Un widget de carte réutilisable et personnalisable.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    this.title,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.elevation = 1,
    this.borderRadius = 16,
    this.color,
    this.isLoading = false,
    this.centerTitle = true,
  });

  /// Titre principal (style TitleMedium par défaut)
  final String? title;

  /// Espacement interne
  final EdgeInsetsGeometry padding;

  /// Callback au tap
  final VoidCallback? onTap;

  /// Ombre de la carte
  final double elevation;

  /// Rayon d'arrondi des coins
  final double borderRadius;

  /// Couleur de fond de la carte
  final Color? color;

  /// Affiche des placeholders si true
  final bool isLoading;

  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: color,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Column(
             mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: centerTitle 
                ? CrossAxisAlignment.center   // Centre le texte horizontalement
                : CrossAxisAlignment.start,   // Aligne à gauche
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null) ...[
                          isLoading
                              ? _ShimmerBox(height: 16, width: 160)
                              : Text(
                                  title!,
                                  textAlign: centerTitle ? TextAlign.center : TextAlign.start, // Centrage du texte
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                          const SizedBox(height: 6),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Petit placeholder rectangulaire pour le mode chargement
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.height, required this.width});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
      ),
    );
  }
}