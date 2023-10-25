import 'package:apk_manager/features/common/widgets/v_spacing.dart';
import 'package:flutter/material.dart';
import 'package:apk_manager/core/utils.dart';

Future<void> showInfoAlert(BuildContext context, String title, String message) async{
  await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      contentPadding: const EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(
            fontWeight: FontWeight.bold
          )),
          const VSpacing(2),
          Container(
            margin: EdgeInsets.only(
              bottom: mqHeigth(context, 1)
            ),
            child: Text(message)
          ),
        ],
      ),
      actions: [        
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text("Cerrar")
        )
      ],
    )
  );
  return;
}
Future<void> showSuccessAlert(BuildContext context, String title, String message) async{
  await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      contentPadding: const EdgeInsets.all(10),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text("Cerrar")
        )
      ],
    )
  );
  return;
}
Future<void> showLoadingAlert(BuildContext context) async{
  await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      contentPadding: const EdgeInsets.all(10),
      title: const Text("Cargando"),
      content: SizedBox(
        height: mqHeigth(context, 30),
        child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,))
      ),
    )
  );
  return;
}
Future<void> showErrorAlert({required BuildContext context, required String title, required List<String> message}) async{
  await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      contentPadding: const EdgeInsets.all(10),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const VSpacing(1),
          Text(title, style: const TextStyle(
            fontWeight: FontWeight.bold
          )),
          const VSpacing(2),
          ...message.map((e) => Container(
            margin: EdgeInsets.only(
              bottom: mqHeigth(context, 1)
            ),
            child: Text(e)
          ))
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text("Cerrar")
        )
      ],
    )
  );
  return;
}
Future<bool?> showConfirmAlert({required BuildContext context, required String title, required String message}) async{
  final confirmed = await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      contentPadding: const EdgeInsets.all(10),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text("Cancelar", style: TextStyle(color: Colors.grey))
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true), 
          child: const Text("Aceptar")
        )
      ],
    )
  );
  return confirmed;
}
Future<bool?> showCustomGeneralDialog({required BuildContext context, required Widget child}) async {
  final bool? confirmed = await showGeneralDialog(
    context: context,
    barrierDismissible: true, 
    barrierColor: Colors.black.withOpacity(0.7),
    barrierLabel: "Atrás",
    pageBuilder: (context, animation, secondaryAnimation) {
      return child;
    },
  );
  return confirmed;
}
Future<bool?> showCustomDialog({required BuildContext context, required Widget child}) async {
  final bool? confirmed = await showDialog(
    context: context,
    barrierDismissible: true, 
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (context) => child
  );
  return confirmed;
}
Future<dynamic> showCustomBottomSheet(BuildContext context, Widget child) async {
  final value = await showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10.0)
      )
    ),
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) => child
  );
  return value;
}