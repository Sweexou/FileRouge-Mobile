import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../models/test_answer.dart';
import '../services/quiz_service.dart';
import '../services/evaluation_service.dart';
import 'answer_page.dart';
import 'test_result_page.dart';

class ExercisePage extends StatefulWidget {
  final String difficulty;
  final int? type;
  final String exerciseTitle;
  final bool isTest;

  const ExercisePage({
    Key? key,
    required this.difficulty,
    this.type,
    required this.exerciseTitle,
    this.isTest = false,
  }) : super(key: key);

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  List<Question> _questions = [];
  List<QuizResult> _trainingResults = [];
  List<TestAnswer> _testAnswers = [];
  String? _questionnaireId;
  int _currentQuestionIndex = 0;
  bool _isLoading = true;
  bool _isSubmitting = false;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  int _getDifficultyLevel() {
    switch (widget.difficulty.toLowerCase()) {
      case 'easy':
        return 0;
      case 'medium':
        return 1;
      case 'hard':
        return 2;
      default:
        return 1;
    }
  }

  Future<void> _loadQuestions() async {
    try {
      final questionsData = await QuizService.generateQuestions(
        level: _getDifficultyLevel(),
        type: widget.type,
        isTest: widget.isTest,
      );

      setState(() {
        _questions = questionsData['questions'];
        _questionnaireId = questionsData['questionnaireId'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading questions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submitAnswer() {
    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an answer'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final userAnswer = _answerController.text.trim();
    final currentQuestion = _questions[_currentQuestionIndex];

    if (widget.isTest) {
      // Mode Test : stocker les réponses pour évaluation
      _testAnswers.add(TestAnswer(
        questionId: currentQuestion.id,
        answer: userAnswer,
      ));
    } else {
      // Mode Training : vérifier immédiatement
      final isCorrect = userAnswer.toLowerCase() == 
                       currentQuestion.correctAnswer?.toLowerCase();

      _trainingResults.add(QuizResult(
        question: currentQuestion,
        userAnswer: userAnswer,
        isCorrect: isCorrect,
      ));
    }

    _answerController.clear();

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _finishExercise();
    }
  }

  Future<void> _finishExercise() async {
    if (widget.isTest) {
      await _finishTest();
    } else {
      _finishTraining();
    }
  }

  Future<void> _finishTest() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final evaluationResult = await EvaluationService.evaluateTest(
        questionnaireId: _questionnaireId!,
        answers: _testAnswers,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TestResultPage(
              evaluationResult: evaluationResult,
              exerciseTitle: widget.exerciseTitle,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error evaluating test: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _finishTraining() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AnswerPage(
          results: _trainingResults,
          exerciseTitle: widget.exerciseTitle,
        ),
      ),
    );
  }

  String _getExerciseTypeText() {
    if (widget.type == null) return 'Mixed Questions';
    
    switch (widget.type!) {
      case 0:
        return 'Find the Result';
      case 1:
        return 'Find the Number';
      case 2:
        return 'Find the Sign';
      default:
        return 'Mixed Questions';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.exerciseTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7FDFB8),
              ),
            )
          : _questions.isEmpty
              ? const Center(
                  child: Text(
                    'No questions available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress indicator
                      Container(
                        width: double.infinity,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (_currentQuestionIndex + 1) / _questions.length,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF7FDFB8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Question info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              if (widget.isTest)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'TEST',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7FDFB8).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.difficulty,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF7FDFB8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      
                      Text(
                        _getExerciseTypeText(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Question
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _questions[_currentQuestionIndex].questionText,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Answer input
                      const Text(
                        'Your Answer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      TextFormField(
                        controller: _answerController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-*/=.]')),
                        ],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your answer',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F8F8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                        ),
                        onFieldSubmitted: (_) => _submitAnswer(),
                      ),
                      
                      const Spacer(),
                      
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7FDFB8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                  ),
                                )
                              : Text(
                                  _currentQuestionIndex < _questions.length - 1
                                      ? 'Next Question'
                                      : widget.isTest ? 'Submit Test' : 'Finish Exercise',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
