
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/producto_form_provider.dart';
import 'package:productos_app/services/producto_service.dart';
import 'package:productos_app/widgets/imagen_producto.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productoService = Provider.of<ProductoService>(context);

    //return _ProductoPageBody(productoService: productoService);
    return ChangeNotifierProvider(
      create: (_) =>
        ProductoFormProvider(productoService.productoSeleccionado!),
        child: _ProductoPageBody(productoService: productoService,),
    );
  }
}

class _ProductoPageBody extends StatelessWidget {
  const _ProductoPageBody({
    Key? key,
    required this.productoService,
  }) : super(key: key);

  final ProductoService productoService;

  @override
  Widget build(BuildContext context) {
    final productoForm = Provider.of<ProductoFormProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ImagenProducto(
                    url: productoService.productoSeleccionado!.imagen,
                  ),
                  Positioned(
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 40,
                        color: Color.fromARGB(255, 224, 224, 224),
                      ),
                      onPressed: () => 
                      Navigator.of(context).pop(),
                    ),
                    top: 60,
                    left: 20,
                  ),
                  Positioned(
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Color.fromARGB(255, 237, 237, 237),
                      ),
                      onPressed: () async{
                        final picker = new ImagePicker();
                        final PickedFile? pickedFile = 
                          await picker.getImage(
                            source: ImageSource.camera,
                            imageQuality: 100,
                          );
                          if(pickedFile == null){
                            print("No se selecciono nada");
                            return;
                          }
                          print('Imagen: ${pickedFile.path}');
                          productoService.actualizarImagenProducto(pickedFile.path);
                      },
                    ),
                    top: 60,
                    right: 20,
                  )
                ],
              ),
              _ProductoForm(),
              SizedBox(height: 100,),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.save_outlined
        ),
        onPressed: () async {
          if(!productoForm.isValidForm()) return;
          await productoService.saveOrCreateProducto(productoForm.producto);
        },
      ),
    );
  }
}

class _ProductoForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final productoForm = Provider.of<ProductoFormProvider>(context);
    final producto = productoForm.producto;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        //height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0,5),
            ),
          ],
        ),
        child: Form(
          key: productoForm.formkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10,),
              TextFormField(
                initialValue: producto.nombre,
                onChanged: (value) => producto.nombre = value,
                validator:  (value) {
                  if(value == null || value.length < 1){
                    return 'El nombre es obligatiorio';
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre del producto',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                initialValue: '${producto.precio}',
                onChanged: (value){
                  if(double.tryParse(value) == null) {
                    producto.precio = 0;
                  }else{
                    producto.precio = double.parse(value);
                  }
                },
                decoration: InputDecoration(
                  hintText: '\$99.99',
                  labelText: 'Precio',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SwitchListTile(
                value: producto.disponible,
                title: Text('Dispobible'),
                activeColor: Colors.indigo,
                onChanged: (value) => productoForm.updateDisponible(value),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),

    );
  }
}