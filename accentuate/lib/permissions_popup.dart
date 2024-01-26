import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
class PermissionsPopup extends StatelessWidget {
  const PermissionsPopup
({super.key});


  Future<bool> request_permission(Permission permission)async{
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if(build.version.sdkInt>=33){
      var request = await Permission.manageExternalStorage.request();
      if(request.isGranted){
        return true;
      } else {
        return false;
      }
    } else {
      if(await permission.isGranted){
        return true;
      } else {
        var result = await permission.request();
        if(result.isGranted){
          return true;
        } else {
          return false;
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Storage Permission')),
      body: Center(child: ElevatedButton(onPressed: () async {  
        if(await request_permission(Permission.storage)){
           // permission granted
          } else {
            // permission denied
          }
        }, child: const Text('Set Permissions'),),
      ),
    );
  }
}