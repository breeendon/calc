import 'package:flutter/material.dart';
//



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double num = 50.0;

  void computeAnswer() {
    
  }

  void _incrementCounter() {
    setState(() {
      num++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 150, 15, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$num',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 80.0,
                        decorationThickness: 0.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$num',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 50.0,
                        decorationThickness: 0.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: const Color.fromARGB(31, 157, 144, 144),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: computeAnswer,
                      child: Text(
                        '√',
                        style: TextStyle(color: Colors.white54, fontSize: 30.0),
                      ),
                    ),
                    TextButton(
                      onPressed: computeAnswer,
                      child: Text(
                        'π',
                        style: TextStyle(color: Colors.white54, fontSize: 30.0),
                      ),
                    ),
                    TextButton(
                      onPressed: computeAnswer,
                      child: Text(
                        '^',
                        style: TextStyle(color: Colors.white54, fontSize: 30.0),
                      ),
                    ),
                    TextButton(
                      onPressed: computeAnswer,
                      child: Text(
                        '!',
                        style: TextStyle(color: Colors.white54, fontSize: 30.0),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          'AC',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '( )',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(side: BorderSide(width: 0.0)),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '%',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '/',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '7',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '8',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(side: BorderSide(width: 0.0)),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '9',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '*',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '4',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '5',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(side: BorderSide(width: 0.0)),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '6',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '-',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '1',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '2',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(side: BorderSide(width: 0.0)),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '3',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '+',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '0',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '.',
                          style: TextStyle(color: Colors.white, fontSize: 60.0),
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(side: BorderSide(width: 0.0)),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Icon(Icons.backspace, size: 40.0),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: CircleBorder(),
                      ),
                      onPressed: computeAnswer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Text(
                          '=',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/*
return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 200.0),
      child: Container(
        color: Colors.lightBlue,
        child: Column(
          children: [
            Text('$num'),
            
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  FilledButton(onPressed: null, child: Text('7')),
                  FilledButton(onPressed: null, child: Text('8')),
                  FilledButton(onPressed: null, child: Text('9')),
                  FilledButton(onPressed: null, child: Text('/')),
                ],
                ),
              ),

               Padding(
                 padding: const EdgeInsets.all(25.0),
                 child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                  FilledButton(onPressed: null, child: Text('4')),
                  FilledButton(onPressed: null, child: Text('5')),
                  FilledButton(onPressed: null, child: Text('6')),
                  FilledButton(onPressed: null, child: Text('*')),
                               ],
                             ),
               ),

               Padding(
                 padding: const EdgeInsets.all(25.0),
                 child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                  FilledButton(onPressed: null, child: Text('1')),
                  FilledButton(onPressed: null, child: Text('2')),
                  FilledButton(onPressed: null, child: Text('3')),
                  FilledButton(onPressed: null, child: Text('-')),
                               ],
                             ),
               ),

               Padding(
                 padding: const EdgeInsets.all(25.0),
                 child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                  FilledButton(onPressed: null, child: Text('0')),
                  FilledButton(onPressed: null, child: Text('C')),
                  FilledButton(onPressed: null, child: Text('=')),
                  FilledButton(onPressed: null, child: Text('+')),
                               ],
                             ),
               ),
             
          ],
        ),
        ),
    );


*/
