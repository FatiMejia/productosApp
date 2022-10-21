
import 'package:flutter/material.dart';
import 'package:productos_app/pages/loading_page.dart';
import 'package:productos_app/services/producto_service.dart';
import 'package:productos_app/widgets/producto_card.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';

class HomePage extends StatelessWidget {
  //const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final productoService = Provider.of<ProductoService>(context);

    if(productoService.isLoading) return LoadingPage();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),  
      body: ListView.builder(
        itemCount: productoService.productos.length,
        itemBuilder: (BuildContext context, int index) =>
          GestureDetector(
            onTap: () { 
              productoService.productoSeleccionado =
                  productoService.productos[index].copy();
              Navigator.pushNamed(context, 'producto');
              },
            child: ProductoCard(
              producto: productoService.productos[index],
            )
          ),
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          productoService.productoSeleccionado = new Producto(
            disponible: false, nombre: '', precio: 0
          );
          Navigator.pushNamed(context, 'producto');
        },
      ),
    );
  }
}