
import 'dart:io';

import 'package:flutter/material.dart';

class ImagenProducto extends StatelessWidget {

  final String? url;

  const ImagenProducto({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10, right: 10, top: 10
      ),
      child: Container(
        width: double.infinity,
        height: 450,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          child: getImage(url),          
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0,5),
            )
          ],
        ),
      ),
    );
  }

  //metodo para determinar si la imagen es local o de internet
  Widget getImage(String? imagen){
    if(imagen == null){
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
        );
    }

    if(imagen.startsWith('http')){
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'), 
        image: NetworkImage(this.url!),
        fit: BoxFit.cover,
        );
    }

    return Image.file(
      File(imagen),
      fit: BoxFit.cover,
      );
     
  }
}