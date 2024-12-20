import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AIAssistantPageState createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  //bool _speechEnabled = false;
  String _transcription = "Say something...";
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _initSpeech();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _startInfiniteLoop();
  }


    void _startInfiniteLoop() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;  // Check if widget is still in the widget tree
      setState(() {
        _isListening = _speechToText.isListening;
      });
    });
  }


    void _initSpeech() async {
    await _speechToText.initialize(finalTimeout :const Duration(seconds: 20));
    setState(() {});
  }

  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult , listenOptions: stt.SpeechListenOptions(listenMode: stt.ListenMode.dictation ));
    _isListening = true;
    setState(() {
      
    });
    /*bool available = await _speech.initialize(onStatus :(e){print("------------------\n\n\n\n$e.errorMsg\n\n\n\n\n-------------------");});
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        
        onResult: (result) {
        setState(() { 
          _transcription = result.recognizedWords;
          
        });},
        _speech.,

        listenFor: Duration(seconds: 15),
        pauseFor: Duration(seconds: 15),
        );
    } else {
      setState(() => _isListening = false);
    }

   // _speech.changePauseFor(pauseFor)*/
  }

   void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _transcription = result.recognizedWords;
    });
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() => _isListening = false);
    
  }

  @override
  void dispose() {
   // _speech.stop();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0,20,0,100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fixed-sized container for the AI logo with animation
            SizedBox(
              height: 200, // Fixed height for the animation
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(120, 120),
                      painter: AISymbolPainter(),
                    ),
                    if (_isListening)
                      AnimatedBuilder(
                        animation: _waveController,
                        builder: (context, child) {
                          return Container(
                            width: 150 + (_waveController.value * 20),
                            height: 150 + (_waveController.value * 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 120), // Vertical spacing
            // Transcription widget
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                _transcription,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40), // Vertical spacing
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    if(!_isListening){
                      _startListening();
                    }else{
                      _stopListening();
                    }
                  } ,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic ,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                //const SizedBox(width: 20),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AISymbolPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw the outer circle for the logo
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    // Add some abstract AI-inspired lines and shapes
    // Horizontal line in the middle
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.7, size.height * 0.5),
      paint,
    );

    // Vertical line from top to center
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.5),
      paint,
    );

    // Add dots or circles as a connection in the design
    final circlePaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.2), 5, circlePaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.5), 5, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
