import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vietq_hrm/utils/cacheFunc.dart';

class CacheInfoWidget extends StatefulWidget {
  const CacheInfoWidget({super.key});

  @override
  State<CacheInfoWidget> createState() => _CacheInfoWidgetState();
}

class _CacheInfoWidgetState extends State<CacheInfoWidget> {
  double? cacheSize;

  @override
  void initState() {
    super.initState();
    _loadCache();
  }

  Future<void> _loadCache() async {
    final size = await getCacheSizeMB();
    setState(() {
      cacheSize = size;
    });
  }

  Future<void> _clearCache() async {
    final dir = await getTemporaryDirectory();
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    await _loadCache();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: GestureDetector(
          onTap: _clearCache,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Delete cache", style: textTheme.headlineSmall?.copyWith(color: Colors.red),),
              Spacer(),
              Text(
                cacheSize == null
                    ? "Loading..."
                    : "${cacheSize!.toStringAsFixed(2)} MB",
                style: textTheme.bodyLarge?.copyWith(color: Colors.red),
              ),
              const SizedBox(height: 20),

            ],
          ),
        ),
    );
  }
}
