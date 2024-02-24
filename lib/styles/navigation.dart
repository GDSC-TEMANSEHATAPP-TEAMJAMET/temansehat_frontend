import 'package:flutter/material.dart';

void showCommentsPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              'Comments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 4,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         leading: const CircleAvatar(
            //           radius: 25,
            //           backgroundImage: AssetImage('assets/images/user.png'),
            //         ),
            //         title: Text(
            //           'Nama $index',
            //           style: const TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         subtitle: Text(
            //           'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis convallis aliquam arcu, eget ullamcorper nulla consectetur egest.',
            //           style: const TextStyle(
            //             fontSize: 14,
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            const SizedBox(height: 10),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Send a heartfelt comment...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

// To use this function, call showCommentsPopup(context) where you want to show the container.
