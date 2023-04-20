import 'package:flutter/material.dart';

class But extends StatelessWidget {

  But(this.colour,this.title, this.onPressed,this.tag);
  final Color colour;
  final String title;
  final VoidCallback onPressed;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Hero(
        tag: tag,
        child: Material(
          elevation: 5.0,
          color: colour,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            minWidth: 200.0,
            // onPressed: () {
            //   Navigator.pushNamed(context, LoginScreen.id);
            // },
            onPressed: onPressed,
            height: 42.0,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}