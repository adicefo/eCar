import 'package:flutter/material.dart';

//added for purposes of navigation func
abstract class ExamplePage extends StatefulWidget {
  /// [ExamplePage] constuctor
  const ExamplePage({required this.leading, required this.title, super.key});

  final Widget leading;

  final String title;

  @override
  ExamplePageState<ExamplePage> createState();
}

abstract class ExamplePageState<T extends ExamplePage> extends State<T>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _overlayOffsetAnimation;

  bool _isOverlayVisible = false;

  bool get isOverlayVisible => _isOverlayVisible;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _overlayOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @protected
  void toggleOverlay() {
    if (!_isOverlayVisible) {
      setState(() {
        _isOverlayVisible = !_isOverlayVisible;
      });
      _controller.forward();
    } else {
      _controller.reverse().then((_) {
        setState(() {
          _isOverlayVisible = false;
        });
      });
    }
  }

  @protected
  void hideOverlay() {
    if (_isOverlayVisible) {
      _controller.reverse().then((_) {
        setState(() {
          _isOverlayVisible = false;
        });
      });
    }
  }

  @protected
  Widget buildOverlayContent(BuildContext context) {
    throw UnimplementedError();
  }

  @protected
  Widget buildPage(BuildContext context, WidgetBuilder builder) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Builder(builder: (BuildContext context) => builder(context)),
        ),
        if (_isOverlayVisible) _buildOverlay(),
      ],
    );
  }

  Widget _buildOverlay() {
    return Stack(
      children: <Widget>[
        GestureDetector(
            onTap: hideOverlay,
            child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) => Container(
                    color: Colors.black.withAlpha(
                        (255.0 * _controller.value * 0.5).round())))),
        SlideTransition(
          position: _overlayOffsetAnimation,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: Material(
                color: Theme.of(context).cardColor,
                elevation: 4,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => hideOverlay(),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6),
                      child: SafeArea(
                        top: false,
                        minimum: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 16),
                        child: Scrollbar(
                          thumbVisibility: true,
                          radius: const Radius.circular(30),
                          child: SingleChildScrollView(
                            child: buildOverlayContent(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void showOverlaySnackBar(String message,
      {Alignment alignment = Alignment.bottomCenter}) {
    final OverlayState overlay = Overlay.of(context);
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Align(
        alignment: alignment,
        child: SizedBox(
          width: double.infinity,
          child: Material(
            elevation: 10.0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).snackBarTheme.backgroundColor,
              child: SafeArea(
                  top: false,
                  child: Text(
                    message,
                    style: Theme.of(context).snackBarTheme.contentTextStyle,
                  )),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future<void>.delayed(const Duration(seconds: 3))
        .then((_) => overlayEntry.remove());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
