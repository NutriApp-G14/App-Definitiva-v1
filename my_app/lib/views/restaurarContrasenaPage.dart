// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ForgotPasswordButton extends StatefulWidget {
//   @override
//   _ForgotPasswordButtonState createState() => _ForgotPasswordButtonState();
// }

// class _ForgotPasswordButtonState extends State<ForgotPasswordButton> {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String _email;
//   String _newPassword;

//   void _sendPasswordResetEmail() async {
//     if (_formKey.currentState.validate()) {
//       _formKey.currentState.save();
//       try {
//         await _firebaseAuth.sendPasswordResetEmail(email: _email);
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Correo enviado'),
//               content: Text('Se ha enviado un correo electrónico a $_email con instrucciones para restablecer la contraseña.'),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text('Cerrar'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       } catch (error) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Error'),
//               content: Text('Ocurrió un error al enviar el correo electrónico de restablecimiento de contraseña. Por favor, intenta de nuevo.'),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text('Cerrar'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RaisedButton(
//       child: Text('Olvidé mi contraseña'),
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Restablecer contraseña'),
//               content: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     TextFormField(
//                       decoration: InputDecoration(hintText: 'Ingresa tu correo electrónico'),
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Por favor, ingresa una dirección de correo electrónico válida.';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _email = value.trim();
//                       },
//                     ),
//                     TextFormField(
//                       decoration: InputDecoration(hintText: 'Ingresa una nueva contraseña'),
//                       obscureText: true,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Por favor, ingresa una nueva contraseña.';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _newPassword = value.trim();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text('Cancelar'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 FlatButton(
//                   child: Text('Enviar'),
//                   onPressed: _sendPasswordResetEmail,
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
