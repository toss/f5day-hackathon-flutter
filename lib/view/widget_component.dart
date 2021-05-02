import 'package:flutter/material.dart';

Widget MainBottomNavigationBar(int selectedIndex, ValueChanged<int> callback) {
  return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        child: BottomNavigationBar(
          elevation: 16.0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.image), label: "모아보기"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "마켓 랭킹"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "찜한 상품")
          ],
          currentIndex: selectedIndex,
          onTap: (index) {
            callback(index);
          },
        ),
      ));
}
