import 'package:flutter/material.dart';

class CurrentLocation extends StatefulWidget {
  final Future<void> Function() onPressed;
  const CurrentLocation({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  bool isLoading = false;

  void setLoading(bool value) {
    if (!mounted) return;
    isLoading = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _onPressed,
      backgroundColor: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.my_location,
            color: Colors.grey[900],
          ),
          if (isLoading)
            SizedBox.square(
              dimension: 53,
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _onPressed() async {
    setLoading(true);
    await widget.onPressed();
    setLoading(false);
  }
}
