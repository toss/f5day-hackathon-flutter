import 'package:chatchat/profile/image_upload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileInputWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileInputState();
}

class _ProfileInputState extends State<ProfileInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ImageUpload();
            }));
          },
          child: Text("Next")),
      body: Container(
        child: Column(
          children: [
            _inputName(),
            _inputGender(context),
          ],
        ),
      ),
    );
  }
}

TextFormField _inputName() {
  final TextEditingController _controller = TextEditingController();

  return TextFormField(
    controller: _controller,
    decoration:
        const InputDecoration(labelText: "Nick name", hintText: "Nick name"),
  );
}

TextFormField _inputGender(BuildContext context) {
  final TextEditingController _controller = TextEditingController();

  const String _man = "Man";
  const String _woman = "Woman";

  return TextFormField(
    enabled: true,
    controller: _controller,
    readOnly: true,
    onTap: () {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Choose Gender",
                      style: TextStyle(color: Color(0xff191f28), fontSize: 18),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _controller.text = _man;
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: Text(_man),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        _controller.text = _woman;
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: Text(_woman),
                      ))
                ],
              ),
            );
          });
    },
    decoration: InputDecoration(labelText: "Gender", hintText: "gender"),
  );
}
