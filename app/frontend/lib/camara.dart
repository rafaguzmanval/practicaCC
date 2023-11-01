

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

import 'captura.dart';
import 'main.dart';

class Camara extends StatefulWidget {
  const Camara({super.key,required this.perfil});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final bool perfil;

  @override
  State<Camara> createState() => _CamaraState();
}

class _CamaraState extends State<Camara> with WidgetsBindingObserver{


  List<CameraDescription>? camaras;
  late CameraController? controller;

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await controller?.dispose();
    super.dispose();
  }

  inicializarCamara() async{

    camaras = await availableCameras();
    controller = new CameraController(camaras![0], ResolutionPreset.max);
    await controller?.initialize();
    return "OK";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: camara()
    );
  }

  Widget camara()
  {
    return
      FutureBuilder(
          future: inicializarCamara(),
          builder: (context,snapshot)
          {
            if(snapshot.hasData)
              {
                return  Stack(
                    children:[

                      CameraPreview(controller!),

                      Align(
                        alignment: Alignment.bottomCenter,
                          child: IconButton(onPressed: () async{
                            var captura = await controller?.takePicture();

                            if(widget.perfil)
                            {
                              Navigator.pop(context,captura);
                            }
                            else
                            {
                              //await Navigator.push(context, MaterialPageRoute(builder: (context) => Captura(imagen: captura!)));
                            }

                          }, icon: Icon(Icons.camera))
                      ),

                      Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(onPressed: () async{


                            final CameraController? oldController = controller;
                            CameraController camaraNueva = controller!;

                            if(oldController != null)
                              {
                                controller = null;
                                await oldController.dispose();
                              }



                            for (final CameraDescription description in camaras!)
                              {
                                if(description.lensDirection == CameraLensDirection.front)
                                  {

                                    onNewCameraSelected(description);
                                    break;
                                  }
                              }


                          }, icon: Icon(Icons.change_circle))
                      )

                    ]

                );
              }
            else{
              return Center(child: new CircularProgressIndicator());
            }

          });

  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _logError(String code, String? message) {
    // ignore: avoid_print
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }



  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
          cameraController.getMinExposureOffset().then(
                  (double value) => _minAvailableExposureOffset = value),
          cameraController
              .getMaxExposureOffset()
              .then((double value) => _maxAvailableExposureOffset = value)
        ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
        // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
        // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }




}

}



