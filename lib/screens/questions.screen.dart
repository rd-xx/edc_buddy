import 'package:edc_buddy/api/get_questions.dart';
import 'package:flutter/material.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int _currentIndex = 0;
  final List<Map<String, String>> _questions = apiQuestions;
  bool _isButtonDisabled = false;
  TextEditingController _inputController = TextEditingController();

  List<TextSpan> _generateTextSpans() {
    List<TextSpan> textSpans = [];
    var words = _questions[_currentIndex]["Label"]!.split(" ");

    for (var word in words) {
      if (word.startsWith("_")) {
        textSpans.add(TextSpan(
            text: "${word.substring(1)} ",
            style: TextStyle(color: Colors.redAccent.shade400)));
      } else {
        textSpans.add(TextSpan(text: "$word "));
      }
    }

    return textSpans;
  }

  void _onButtonPressed() {
    setState(() {
      _currentIndex++;
      _isButtonDisabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: Center(
          child: Container(
              color: Colors.lightBlue.shade100,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: _generateTextSpans())),
                  const SizedBox(height: 10),
                  Text(
                    _questions[_currentIndex]["Description"]!,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 80),
                  TextField(
                    decoration: InputDecoration(
                        hintText: _questions[_currentIndex]["InputHint"]!),
                    cursorColor: Colors.redAccent.shade400,
                    autocorrect: false,
                    controller: _inputController,
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                      onPressed: _isButtonDisabled ? null : _onButtonPressed,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade400,
                          minimumSize: const Size.fromHeight(50),
                          elevation: 4),
                      child: const Text("Suivant",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))
                ],
              ))),
    );
  }
}
