import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Interactive mobile device simulator wrapper for Web previewing in Brave Browser.
/// Lets you switch between iPhone (iOS) and Pixel (Android) viewports and test
/// WCAG 200% font scaling directly in the browser without an emulator.
class WebMobileFrame extends StatefulWidget {
  const WebMobileFrame({super.key, required this.child});

  final Widget child;

  @override
  State<WebMobileFrame> createState() => _WebMobileFrameState();
}

class _WebMobileFrameState extends State<WebMobileFrame> {
  bool _isIos = false; // Default to Android (Pixel 8: 412x915)
  double _textScale = 1.0;
  bool _showSemantics = false;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return widget.child;

    final Size screenSize =
        _isIos ? const Size(393, 852) : const Size(412, 915);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => Material(
              color: const Color(0xFF0F172A),
              child: Column(
          children: [
            // Top Simulator Control Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF1E293B),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    '📱 Web Phone Mirror',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(
                        value: false,
                        label: Text('Android (412×915)'),
                      ),
                      ButtonSegment<bool>(
                        value: true,
                        label: Text('iOS (393×852)'),
                      ),
                    ],
                    selected: {_isIos},
                    onSelectionChanged: (val) {
                      setState(() => _isIos = val.first);
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'WCAG Text Scale: ${(_textScale * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        child: Slider(
                          value: _textScale,
                          min: 1.0,
                          max: 2.0,
                          divisions: 4,
                          onChanged: (v) => setState(() => _textScale = v),
                        ),
                      ),
                    ],
                  ),
                  FilterChip(
                    label: Text(
                      _showSemantics
                          ? 'TalkBack / VoiceOver Overlay: ON'
                          : 'TalkBack / VoiceOver Overlay',
                    ),
                    selected: _showSemantics,
                    onSelected: (v) => setState(() => _showSemantics = v),
                  ),
                ],
              ),
            ),
            // Phone Bezel & Viewport
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Container(
                      width: screenSize.width + 24,
                      height: screenSize.height + 24,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(48),
                        border: Border.all(
                          color: const Color(0xFF475569),
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 30,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: SizedBox(
                          width: screenSize.width,
                          height: screenSize.height,
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              size: screenSize,
                              textScaler: TextScaler.linear(_textScale),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                platform: _isIos
                                    ? TargetPlatform.iOS
                                    : TargetPlatform.android,
                              ),
                              child: _showSemantics
                                  ? SemanticsDebugger(child: widget.child)
                                  : widget.child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
            ),
          ),
        ],
      ),
    );
  }
}
