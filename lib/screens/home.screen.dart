import 'package:edc_buddy/api/get_questions.dart';
import 'package:edc_buddy/screens/questions.screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Generate a list of Row from the stored answers.
  List<Row> _getAnswers() {
    List<Row> rows = [];

    for (var question in apiQuestions) {
      if (!GetStorage().hasData(question["Key"]!)) continue;
      String answer = GetStorage().read(question["Key"]!);

      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${question["Label"]} : ",
            style: const TextStyle(fontSize: 24),
          ),
          Text(
            answer,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent),
          ),
        ],
      ));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Étude de cas - Buddy"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300, elevation: 4),
                child: const Text(
                  "Aller aux questions",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () => Get.to(() => const QuestionsScreen())),
            const Divider(
              height: 50,
              indent: 30,
              endIndent: 30,
              thickness: 1,
            ),
            ..._getAnswers()
          ],
        ),
      ),
    );
  }
}
