import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:provider/provider.dart';
import '../providers/QuoteProvider.dart';

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  List<Color> bgColors = [
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.purple.shade200,
    Colors.orange.shade200,
    Colors.red.shade200,
  ];

  int _colorIndex = 0;

  void _changeColor() {
    setState(() {
      _colorIndex = (_colorIndex + 1) % bgColors.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<QuoteProvider>(context, listen: false).loadQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quotes')),
      body: Consumer<QuoteProvider>(
        builder: (context, provider, _) {
          if (provider.quotes.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < 0) {
                  provider.nextQuote();
                } else if (details.primaryVelocity! > 0) {
                  provider.previousQuote();
                }
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              color: bgColors[_colorIndex],
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '"${provider.currentQuote?.text}"',
                        style: TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '- ${provider.currentQuote?.author}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              provider.previousQuote();
                              _changeColor();
                            },
                            child: Icon(Icons.arrow_back),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              provider.nextQuote();
                              _changeColor();
                            },
                            child: Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
