import 'package:flutter/material.dart';
import 'package:productos_app/models/producto.dart';

class ProductoFormProvider extends ChangeNotifier{
  GlobalKey<FormState> formkey =
    new GlobalKey<FormState>();
  
  Producto producto;
  
  ProductoFormProvider(this.producto);

  bool isValidForm(){
    print(producto.nombre);
    print(producto.precio);
    print(producto.disponible);
    return formkey.currentState?.validate() ?? false;
  }

  updateDisponible(bool value) {
    print(value);
    this.producto.disponible = value;
    notifyListeners();
  }
}
