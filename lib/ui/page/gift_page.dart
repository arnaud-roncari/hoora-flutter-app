import 'package:flutter/widgets.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Center(child: Text("Gift"));
  }

  @override
  bool get wantKeepAlive => true;
}
