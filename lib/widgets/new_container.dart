// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';

// class NewContainer extends StatefulWidget {
//   const NewContainer({
//     Key? key,
//     required this.containers,
//   }) : super(key: key);

//   final List<Widget> containers;

//   @override
//   State<NewContainer> createState() => _NewContainerState();
// }

// class _NewContainerState extends State<NewContainer> {
//   List<Widget> containers = [];
//   void _addContainers() {
//     setState(() {
//       containers.add(containerContent());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: buildContainerList(
//         widget.containers,
//       ),
//     );
//   }
// }

// Widget containerContent() {
//   return Column(
//     children: const [
//       SizedBox(
//         height: 40,
//         width: double.infinity,
//         child: TextField(
//           maxLength: 33,
//           decoration: InputDecoration(
//             counterText: '',
//             hintText: 'Field Name',
//             border: OutlineInputBorder(borderSide: BorderSide.none),
//           ),
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       SizedBox(
//         height: 40,
//         width: double.infinity,
//         child: TextField(
//           maxLength: 33,
//           decoration: InputDecoration(
//             counterText: '',
//             hintText: 'Value',
//             border: OutlineInputBorder(borderSide: BorderSide.none),
//           ),
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     ],
//   );
// }

// List<Widget> buildContainerList(List<Widget> containers) {
//   void removeContainer(int index) {
//     containers.removeAt(index);
//     // setState(() {
//     // });
//   }

//   return containers.map(
//     (container) {
//       final index = containers.indexOf(container);
//       return Container(
//         padding: const EdgeInsets.only(top: 3),
//         height: 85,
//         width: double.infinity,
//         margin: const EdgeInsets.only(
//           top: 5,
//         ),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Colors.grey,
//           ),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Row(
//           children: [
//             Expanded(child: container),
//             IconButton(
//               onPressed: () => removeContainer(index),
//               icon: const Icon(Icons.remove),
//             ),
//           ],
//         ),
//       );
//     },
//   ).toList();
// }
