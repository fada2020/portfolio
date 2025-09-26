import 'dart:html' as html;

/// Performance monitoring utility for Core Web Vitals tracking
class PerformanceMonitor {
  static bool _initialized = false;

  /// Initialize performance monitoring
  static void initialize() {
    if (_initialized) return;
    _initialized = true;

    // Monitor Core Web Vitals
    _monitorLCP();
    _monitorFID();
    _monitorCLS();
  }

  /// Monitor Largest Contentful Paint (LCP)
  /// Target: < 2.5 seconds for good UX
  static void _monitorLCP() {
    try {
      final observer = html.PerformanceObserver((entries, observer) {
        final lcpEntries = entries.getEntries();
        if (lcpEntries.isNotEmpty) {
          final lastEntry = lcpEntries.last;
          final lcp = lastEntry.startTime;

          // Log LCP for monitoring
          print('LCP: ${lcp.toStringAsFixed(2)}ms');

          // Send to analytics if needed
          _sendToAnalytics('lcp', lcp);
        }
      });

      observer.observe({'type': 'largest-contentful-paint', 'buffered': true});
    } catch (e) {
      print('LCP monitoring failed: $e');
    }
  }

  /// Monitor First Input Delay (FID)
  /// Target: < 100 milliseconds for good UX
  static void _monitorFID() {
    try {
      final observer = html.PerformanceObserver((entries, observer) {
        final fidEntries = entries.getEntries();
        for (final entry in fidEntries) {
          // Use safe property access with fallback
          final processingStart = _getPropertySafe(entry, 'processingStart') ?? entry.startTime;
          final fid = processingStart - entry.startTime;

          // Log FID for monitoring
          print('FID: ${fid.toStringAsFixed(2)}ms');

          // Send to analytics if needed
          _sendToAnalytics('fid', fid);
        }
      });

      observer.observe({'type': 'first-input', 'buffered': true});
    } catch (e) {
      print('FID monitoring failed: $e');
    }
  }

  /// Monitor Cumulative Layout Shift (CLS)
  /// Target: < 0.1 for good UX
  static void _monitorCLS() {
    try {
      double clsValue = 0;

      final observer = html.PerformanceObserver((entries, observer) {
        final clsEntries = entries.getEntries();
        for (final entry in clsEntries) {
          // Use safe property access with fallback
          final hadRecentInput = _getPropertySafe(entry, 'hadRecentInput') as bool? ?? false;
          final value = _getPropertySafe(entry, 'value') as num? ?? 0;

          // CLS calculation logic
          if (!hadRecentInput) {
            clsValue += value.toDouble();
          }
        }

        // Log CLS for monitoring
        print('CLS: ${clsValue.toStringAsFixed(4)}');

        // Send to analytics if needed
        _sendToAnalytics('cls', clsValue);
      });

      observer.observe({'type': 'layout-shift', 'buffered': true});
    } catch (e) {
      print('CLS monitoring failed: $e');
    }
  }

  /// Send metrics to analytics (placeholder)
  static void _sendToAnalytics(String metric, num value) {
    // Implement analytics integration here
    // Example: Google Analytics, custom analytics, etc.

    // For now, just log to console
    print('Analytics: $metric = $value');
  }

  /// Get navigation timing information
  static Map<String, dynamic> getNavigationTiming() {
    try {
      final timing = html.window.performance.timing;
      final navigationStart = timing.navigationStart;

      return {
        'dns_lookup': timing.domainLookupEnd - timing.domainLookupStart,
        'tcp_connection': timing.connectEnd - timing.connectStart,
        'request_response': timing.responseEnd - timing.requestStart,
        'dom_processing': timing.domComplete - timing.domLoading,
        'total_load_time': timing.loadEventEnd - navigationStart,
        'dom_content_loaded': timing.domContentLoadedEventEnd - navigationStart,
        'first_paint': _getFirstPaint(),
      };
    } catch (e) {
      print('Navigation timing failed: $e');
      return {};
    }
  }

  /// Get First Paint timing
  static double? _getFirstPaint() {
    try {
      final entries = html.window.performance.getEntriesByType('paint');
      for (final entry in entries) {
        if (entry.name == 'first-paint') {
          return entry.startTime.toDouble();
        }
      }
    } catch (e) {
      print('First paint timing failed: $e');
    }
    return null;
  }

  /// Safe property access for PerformanceEntry
  static dynamic _getPropertySafe(html.PerformanceEntry entry, String property) {
    try {
      // Use JavaScript interop to safely access properties
      final jsEntry = entry as dynamic;
      return jsEntry[property];
    } catch (e) {
      return null;
    }
  }

  /// Log performance summary
  static void logPerformanceSummary() {
    final timing = getNavigationTiming();

    print('=== Performance Summary ===');
    timing.forEach((key, value) {
      if (value != null) {
        print('$key: ${value is double ? value.toStringAsFixed(2) : value}ms');
      }
    });
    print('========================');
  }
}

/// Extension for performance monitoring
extension PerformanceWidget on html.Element {
  /// Mark element as performance critical for LCP tracking
  void markAsLCPCandidate() {
    setAttribute('data-lcp-candidate', 'true');
  }
}