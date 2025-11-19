// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stockmark/features/home/presentation/providers/stock_provider.dart';

// class SearchBox extends StatelessWidget {
//   const SearchBox({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<StockProvider>(context, listen: false);
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: "Search stocks and companies",
//           prefixIcon: const Icon(Icons.search),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//         ),
//         onChanged: (query) => provider.search(query),
//       ),
//     );
//   }
// }
