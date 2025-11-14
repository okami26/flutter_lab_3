import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Федоров Антон Алексеевич"),
        ),
        body: MyHomePage(),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _formKey = GlobalKey<FormState>();
  final _fieldHeight = TextEditingController();
  final _fieldWeight = TextEditingController();
  bool _agreement = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Вес",
                style: TextStyle(fontSize: 20.0),
              ),
              TextFormField(
                controller: _fieldWeight,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Пожалуйста введите свой вес";
                  if (num.tryParse(value) == null) return "Введите число";
                  if (num.parse(value) <= 0) return "Вес должен быть больше 0";
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Введите вес",
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Рост",
                style: TextStyle(fontSize: 20.0),
              ),
              TextFormField(
                controller: _fieldHeight,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Пожалуйста введите свой рост";
                  if (num.tryParse(value) == null) return "Введите число";
                  if (num.parse(value) <= 0) return "Рост должен быть больше 0";
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Введите рост",
                ),
              ),
              CheckboxListTile(
                value: _agreement,
                title: const Text("Я согласен с условиями обработки персональных данных"),
                onChanged: (bool? value) {
                  setState(() {
                    _agreement = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (!_agreement) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пожалуйста, согласитесь с условиями.'))
                    );
                    return;
                  }
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                        SecondScreen(weight: _fieldWeight.text, height: _fieldHeight.text,)
                      )
                    );
                  }
                },
                child: const Text("Отправить"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {

  final String height;
  final String weight;

  SecondScreen({required this.height, required this.weight});

  double calculateIMT() {
    double h = double.parse(height);
    double w = double.parse(weight);
    return w / ((h/100)*(h/100));
  }

  String getTextIMT(double imt) {
    if (imt < 16) {
      return "Выраженный дефицит массы тела";
    } else if (imt >= 16 && imt < 18.5) {
      return "Недостаточная масса тела";
    } else if (imt >= 18.5 && imt < 25) {
      return "Норма (здоровый вес)";
    } else if (imt >= 25 && imt < 30) {
      return "Избыточная масса тела";
    } else if (imt >= 30 && imt < 35) {
      return "Ожирение I степени";
    } else if (imt >= 35 && imt < 40) {
      return "Ожирение II степени";
    } else {
      return "Ожирение III степени";
    }
  }

  @override
  Widget build(BuildContext context) {
    double imt = calculateIMT();
    String textIMT = getTextIMT(imt);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Вес: $weight",
              style: const TextStyle(fontSize: 20.0)
            ),
            Text("Рост: $height",
              style: const TextStyle(fontSize: 20.0)
            ),
            Text("ИМТ: ${imt.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 20.0)
            ),
            Text("Данное значение ИМТ соответствует: $textIMT",
              style: const TextStyle(fontSize: 20.0)
            )
          ],
        ),
      ),
    );
  }
}
