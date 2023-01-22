import 'package:edc_buddy/api/get_questions.dart';
import 'package:edc_buddy/screens/home.screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isButtonDisabled = true;
  final TextEditingController _inputController = TextEditingController();
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(handleInputChanges);
    _progressController = AnimationController(vsync: this, value: 0);
    _progressController.stop();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  /// Generate a list of TextSpan from the current question.
  /// This is used to highlight the words the words that start with an underscore.
  List<TextSpan> _generateTextSpans() {
    List<TextSpan> textSpans = [];
    var words = apiQuestions[_currentIndex]["Question"]!.split(" ");

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

  /// Validate the input based on the current question.
  /// This is used to enable/disable the button.
  void handleInputChanges() {
    bool validated = false;
    if (apiQuestions[_currentIndex]["InputType"] == "str") {
      validated = GetUtils.isAlphabetOnly(_inputController.text);
    } else if (apiQuestions[_currentIndex]["InputType"] == "nbr") {
      validated = GetUtils.isNumericOnly(_inputController.text);
    }

    setState(() {
      _isButtonDisabled = !validated;
    });
  }

  void _onButtonPressed() {
    GetStorage()
        .write(apiQuestions[_currentIndex]["Key"]!, _inputController.text);

    if (_currentIndex == apiQuestions.length - 1) {
      Get.to(() => const HomeScreen());
      return;
    }

    setState(() {
      _currentIndex++;
      _isButtonDisabled = true;
      _inputController.clear();
      _progressController.value = _currentIndex / apiQuestions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: LinearProgressIndicator(value: _progressController.value),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: SizedBox(
              // color: Colors.lightBlue.shade100,
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
                    apiQuestions[_currentIndex]["Warning"]!,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 80),
                  TextField(
                    decoration: InputDecoration(
                        hintText: apiQuestions[_currentIndex]["InputHint"]!),
                    cursorColor: Colors.redAccent.shade400,
                    autocorrect: false,
                    autofocus: true,
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
