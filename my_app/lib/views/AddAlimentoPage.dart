import 'package:flutter/material.dart';
import 'package:my_app/controllers/databasehelpers.dart';

class AddAlimentoPage extends StatefulWidget {
  final String nombreUsuario;
  const AddAlimentoPage({
    required this.nombreUsuario
  });

  
  @override
  _AddAlimentoPageState createState() => _AddAlimentoPageState();
}

class _AddAlimentoPageState extends State<AddAlimentoPage> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController unidadesCantidadController = TextEditingController();
  final TextEditingController caloriasController = TextEditingController();
  final TextEditingController grasasController = TextEditingController();
  final TextEditingController proteinasController = TextEditingController();
  final TextEditingController carbohidratosController = TextEditingController();
  final TextEditingController imageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Introducir alimento'),
      ),
        body: Container(
            child: ListView(
      padding:
          const EdgeInsets.only(top: 62, left: 12.0, right: 12.0, bottom: 12.0),
      children: [
        Container(
          height: 50,
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'name',
              hintText: 'Product name',
              icon: new Icon(Icons.food_bank),
            ),
          ),
        ),
        Container(
          height: 50,
          child: TextField(
            controller: cantidadController,
            decoration: InputDecoration(
              labelText: 'cantidad',
              hintText: 'Product cantidad',
              icon: new Icon(Icons.food_bank),
            ),
          ),
        ),
        Container(
          height: 50,
          child: TextField(
            controller: cantidadController,
            decoration: InputDecoration(
              labelText: 'unidades de cantidad',
              hintText: 'Product unidades de cantidad',
              icon: new Icon(Icons.food_bank),
            ),
          ),
        ),
        Container(
          height: 50,
          child: TextField(
            controller: caloriasController,
            decoration: InputDecoration(
              labelText: 'calorias',
              hintText: 'Product calorias',
              icon: new Icon(Icons.food_bank),
            ),
          ),
        ),
        Container(
          height: 50,
          child: TextField(
            controller: grasasController,
            decoration: InputDecoration(
              labelText: 'grasas',
              hintText: 'Product grasas',
              icon: new Icon(Icons.food_bank),
            ),
          ),
        ),
        Container(
          height: 50,
          child: TextField(
            controller: carbohidratosController,
            decoration: InputDecoration(
              labelText: 'carbohidratos',
              hintText: 'Product carbohidratos',
              icon: new Icon(Icons.food_bank),
            ),
          ),
        ),
        Container(
          height: 50,
          child: TextField(
            controller: proteinasController,
            decoration: InputDecoration(
              labelText: 'proteinas',
              hintText: 'Product proteinas',
              icon: new Icon(Icons.food_bank),
            ),
          ),
        ),
                Container(
          height: 50,
          child: TextField(
            controller: imageController,
            decoration: InputDecoration(
              labelText: 'Image Link',
              hintText: 'Link de la imagen del alimento',
              icon: new Icon(Icons.link),
            ),
          ),
        ),
        Padding(
          padding: new EdgeInsets.only(top: 100.0),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 120.0),
            ),
            Container(
               // height: 50,
                child: IconButton(
                    onPressed: () {
                      dataBaseHelper.addAlimento(
                        nameController.text.trim(),
                        double.parse(cantidadController.text.trim()),
                        unidadesCantidadController.text.trim(),
                        double.parse(caloriasController.text.trim()),
                        double.parse(grasasController.text.trim()),
                        double.parse(proteinasController.text.trim()),
                        double.parse(carbohidratosController.text.trim()),
                        imageController.text.trim(),
                        widget.nombreUsuario.trim(),
                      );
                      Navigator.pop(context, true);
                    },
                    iconSize: 100.0,
                    icon: new Icon(Icons.add),
                    color: Colors.orange))
          ],
        )
      ],
    )));
  }
}
