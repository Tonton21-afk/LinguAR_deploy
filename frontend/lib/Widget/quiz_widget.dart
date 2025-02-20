// import 'package:lingua_arv1/model/Quiz_data.dart';
// class QuizWidget extends StatelessWidget {
//   final QuizWidget QuizData;
//   final Function(bool) onAnswerSelected;

//   const QuizCard({
//     required this.QuizData,
//     required this.onAnswerSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Display the phrase
//         Container(
//           width: 150,
//           height: 60,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black, width: 1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             quizData.phrase,
//             style: const TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         const SizedBox(height: 30),
//         // Answer Buttons
//         ElevatedButton(
//           onPressed: () => onAnswerSelected(true),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//           ),
//           child: Text(quizData.correctAnswer),
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () => onAnswerSelected(false),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red,
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//           ),
//           child: Text(quizData.wrongAnswer),
//         ),
//       ],
//     );
//   }
// }