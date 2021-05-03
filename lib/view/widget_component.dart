import 'package:flutter/material.dart';

Widget MainBottomNavigationBar(int selectedIndex, ValueChanged<int> callback) {
  Image item(String path) {
    return Image.asset(
      path,
      width: 24.0,
      height: 24.0,
    );
  }

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
          items: [
            BottomNavigationBarItem(
                activeIcon: item('images/tab1_active.png'),
                icon: item('images/tab1_inactive.png'),
                label: "Mua sắm"),
            BottomNavigationBarItem(
                activeIcon: item('images/tab2_active.png'),
                icon: item('images/tab2_inactive.png'),
                label: "Xếp hạng"),
            BottomNavigationBarItem(
                activeIcon: item('images/tab3_active.png'),
                icon: item('images/tab3_inactive.png'),
                label: "Đánh dấu")
          ],
          selectedItemColor: Color(0xff4E5968),
          unselectedItemColor: Color(0xff8B95A1),
          currentIndex: selectedIndex,
          onTap: (index) {
            callback(index);
          },
        ),
      ));
}
