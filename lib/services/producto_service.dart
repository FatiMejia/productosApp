
import 'package:flutter/material.dart';
import '../models/producto.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ProductoService extends ChangeNotifier{
  
  final String _baseUrl='productosapp23m-default-rtdb.firebaseio.com';

  final List<Producto> productos = [];

  bool  isLoading = true;
  bool  isSaving = false;

  Producto? productoSeleccionado;
  File? pictureFile;

  //constructor
  ProductoService(){
    this.obtenerProductos();
  }
  //metodo que obtiene los productos de la BD
  Future obtenerProductos() async{
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'productos.json');
    final resp = await http.get(url);
    
    final Map<String, dynamic> productosMap = json.decode(resp.body);

    //print(productosMap);

    //recorremos el mapa y extraemos cada producto y lo agregamos a la lista
    productosMap.forEach((key, value) {
      final productoTemp = Producto.fromMap(value);
      productoTemp.id = key;
      this.productos.add(productoTemp);
    });

    this.isLoading = false;

   notifyListeners();

   //print(this.productos[0].nombre);
   return this.productos;
  }

  //metodo para actualizar un producto en la DB
  Future<String> updateProducto(Producto producto) async {
    final url = Uri.https(_baseUrl, 'productos/${producto.id}.json');
    final resp = await http.put(url,body: producto.toJson());
    final decodedData = resp.body;

    print(decodedData);

    //actualizar el listado de productos
    final index = this.productos.indexWhere((element) => element.id == producto.id);
    this.productos[index] = producto;

    return producto.id!;
  }

  //metodo para crear o actualizar el producto
  Future saveOrCreateProducto(Producto producto)async{
    isSaving = true;
    notifyListeners();

    if(producto.id == null){
      //producto nuevo
      await this.createProducto(producto);
    }else {
      //actualizar producto existente
      await this.updateProducto(producto);
    }

    isSaving = false;
    notifyListeners();
  }

  //metodo para crear un producto nuevo
  Future<String> createProducto(Producto producto) async{
    final url = Uri.https(_baseUrl, 'productos.json');
    final resp = await http.post(url,body: producto.toJson());
    final decodedData = json.decode(resp.body);
    
    producto.id = decodedData['name'];
    this.productos.add(producto);
    
    return producto.id!;
  }

  //metodo para actualizar la imagen del producto
  void actualizarImagenProducto(String path) {
    this.productoSeleccionado!.imagen = path;
    this.pictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  //metodo para subir la imagen a Cloudinary
Future<String?> uploadImage() async{
  if(this.pictureFile == null) return null;


  this.isSaving == true;
  notifyListeners();

  final url = Uri.parse('https://api.cloudinary.com/v1_1/dmp52t1yb/image/upload?upload_preset=wl2jjcml');

  final imagenUploadRequest = http.MultipartRequest('POST',url);
  final file = await http.MultipartFile.fromPath('file', pictureFile!.path);
  imagenUploadRequest.files.add(file);

  final streamResponse = await imagenUploadRequest.send();
  final resp = await http.Response.fromStream(streamResponse);
  
  //print(resp);

  //verificamos el status de la respuesta
  if(resp.statusCode !=200 && resp.statusCode != 201){
    print('Error en la peticion');
    print(resp.body);
    return null;
  }

  this.pictureFile = null;

  final decodedData = json.decode(resp.body);
  return decodedData['secure_url'];
}
}

