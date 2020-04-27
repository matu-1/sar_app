import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sar_app/src/pages/home_page.dart';
import 'package:sar_app/src/pages/login_page.dart';
import 'package:sar_app/src/providers/equipo_provider.dart';
import 'package:sar_app/src/providers/persona_provider.dart';
import 'package:sar_app/src/providers/solicitud_provider.dart';
import 'package:sar_app/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SolicitudCreatePage extends StatefulWidget {
  static final routeName = 'solicituCreate';

  @override
  _SolicitudCreatePageState createState() => _SolicitudCreatePageState();
}

class _SolicitudCreatePageState extends State<SolicitudCreatePage> {
  List _personas = [];
  List _equipos = [];
  List _equiposBusqueda = [];
  String _ci = '';
  String _fechaDevoluion = '';
  String _observacion = '';
  List _detalles = [];
  String _cantidad = '';
  File _imagen ; 
  dynamic _equipo = '';

  TextEditingController textEditingControllerFecha = new TextEditingController();
  TextEditingController textEditingControllerEquipo = new TextEditingController();
  
  EquipoProvider equipoProvider = new EquipoProvider();
  PersonaProvider personaProvider = new PersonaProvider();
  SolicitudProvider solicitudProvider = new SolicitudProvider();

  ProgressDialog pr;

  @override
  void initState() {
    this.mostrarPersona();
    mostrarEquipo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal,);
    pr.style(message: 'Espere por favor...');

    return Scaffold(
      appBar: AppBar(
        title: Text('CREAR SOLICITUD'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.pages), onPressed: () => pr.show())
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: contenidoHeight(),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              _crearForm(context),
              _detalles.length > 0?
              Expanded(child: _crearSolicitudDetalle())
              : Container(),
            ],
          ),
        ),
      ),
    );
  }

  double contenidoHeight() {
    final appBarHeight = AppBar().preferredSize.height;
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    final height = MediaQuery.of(context).size.height;
    final contenidoHeight = height - appBarHeight -statusbarHeight;
    return contenidoHeight;
  }

  void mostrarPersona() async{
    _personas = await personaProvider.getAll();
    print(_personas);
  }

  void mostrarEquipo() async {
    _equipos = await equipoProvider.getAll();
    _equiposBusqueda = _equipos;
  }

  Widget  _crearForm(BuildContext context){
    final size = MediaQuery.of(context).size;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: size.width * 0.7,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(),
                      hintText: 'C.I. DEL SOLICITANTE',
                    ),
                    onChanged: (value) => setState((){ _ci = value;}),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.visibility, color: Theme.of(context).primaryColor,), 
                  onPressed: _mostrarAlerta,
                ),
              ],
            ),
            SizedBox(height: 10,),
            TextField(
              controller: textEditingControllerFecha,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
                hintText: 'FECHA DEVOLUCION',
              ),
              onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
                 _selectDate(context);
              },
            ),
            SizedBox(height: 10,),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
                hintText: 'OBSERVACION',
              ),
              onChanged: (value) => setState((){ _observacion = value;}),
            ),
            SizedBox(height: 5,),
            RaisedButton(
              child: Container(
                width: double.infinity,
                child: Center(child: Text('AGREGAR EQUIPO')),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: _agregarDetalleSolicitudAlert
            ),
          ],
        ),
      ),
    );
  }

  dynamic getPersona(String ci) {
    var index = _personas.indexWhere((persona) {
      return persona['per_ci'].toString() == ci;
    });
    if(index != -1) return _personas[index];
    return null;
  }

  void _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context, 
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2019), 
      lastDate: new DateTime(2025),
      locale: Locale('es')
    );
    if(picked!=null){
      setState(() {
        _fechaDevoluion = picked.toString().substring(0, 10);
        textEditingControllerFecha.text = _fechaDevoluion;
      });
    }
  }

  void _mostrarAlerta() {
    final persona = getPersona(_ci);
    if(persona == null){
      utils.mensajeToast('No existe la persona');
    }else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Datos'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Nombre: ${persona["per_nombre"]}'),
              Text('Apellido: ${persona["per_apellido"]}'),
              Text('Grado:  ${persona["per_grado"]}'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(), 
            )
          ],
        );
      }
    );
    }
  }

  void _agregarDetalleSolicitudAlert(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.all(0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () => _imagenSelect(setState),
                          child: (_imagen == null)?
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: 
                            AssetImage('lib/src/assets/images/noimage.png')
                          ):
                          Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(50),
                            ),
                            child: Image.file(_imagen, 
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          )
                        ),
                      ),
                      TextField(
                        controller: textEditingControllerEquipo,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(),
                          hintText: 'SELECCIONE EL CODIGO',
                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _selectEquiposModal();
                        },
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(),
                          hintText: 'CANTIDAD',
                        ),
                        onChanged: (value) => setState((){ _cantidad = value;}),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            child: Text('CANCELAR'),
                            textColor: Colors.blue,
                            onPressed: () => Navigator.of(context).pop(), 
                          ),
                          FlatButton(
                            child: Text('AGREGAR'),
                            textColor: Colors.blue,
                            onPressed: _agregardetalleSolicitud, 
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          )
        );
      }
    );
  }

  void _imagenSelect(StateSetter setState) async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    if(image == null) return;
    setState(() => _imagen = image );
  }

  void _agregardetalleSolicitud(){
    final detalle = {
      'foto': _imagen,
      'cantidad': _cantidad,
      'codigo': _equipo['equ_codigo'],
      'id': _equipo['equ_id'],
    };
    Navigator.pop(context);
    setState(() {
      _detalles.add(detalle); 
      textEditingControllerEquipo.text = '';
      _imagen = null;
    });
    print(_detalles);
  }

  Widget _crearSolicitudDetalle(){
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _detalles.length,
              itemBuilder: (BuildContext context, int i) {
                return _detalleSolicitudBox(_detalles[i]);
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Container(
                width: double.infinity,
                child: Center(child: Text('GUARDAR')),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: _registrarSolicitud
            ),
          ),
        ],
      ),
    );
  }

  void  _registrarSolicitud() async{
    pr.show();
    await solicitudProvider.create({
      'sol_fecha_entrega': utils.getFechaActual(),
      'sol_fecha_devolucion': _fechaDevoluion,
      'sol_observaciones_entrega': _observacion,
      'sol_per_id': getPersona(_ci)["per_id"],
      'detalles': _detalles
    });
    pr.hide();
    print('ci: $_ci');
    print('fecha entrega: ${utils.getFechaActual()}');
    print('fecha: $_fechaDevoluion');
    print('obser: $_observacion');
    print('detalles: $_detalles');
    utils.mensajeToast('Se registro correctamente');
    Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, ModalRoute.withName(LoginPage.routeName));
  }

  Widget _detalleSolicitudBox(detalle) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _texto('CODIGO', detalle['codigo']),
                _texto('CANTIDAD',  detalle['cantidad']),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 30, color: Theme.of(context).primaryColor,), 
            onPressed: () => _deleteDetalleSolicitud(detalle),
          )
        ],
      ),
    );
  }

  void _deleteDetalleSolicitud(detalle) {
    setState(() {
      _detalles.remove(detalle);
    });
  }

  Widget _texto(String propiedad, String valor) {
    return Row(
      children: <Widget>[
        Text('$propiedad: ', style: TextStyle(fontWeight: FontWeight.bold),),
        Text(valor),
      ],
    );
  }

  void _selectEquiposModal(){
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(0),
          color: Color(0xfff2f2f2),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: size.width * 0.8,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              hintText: 'ESCRIBE EL CODIGO Y SELECCIONA',
                            ),
                            onChanged: (value) => _buscarEquipo(value, setState),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () { 
                            Navigator.pop(context);
                            _equiposBusqueda = _equipos;
                          }
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                  _crearCodigosList(),
                ],
              );
            }
          ),
        );
      }
    );
  }

  void _buscarEquipo(String texto, StateSetter setState) {
    texto = texto.toUpperCase();
    List newEquipos = [];
    _equipos.forEach((equipo) {
      var codigo = equipo['equ_codigo'].toString().toUpperCase();
      int index = codigo.indexOf(texto);
      if(index > -1) newEquipos.add(equipo);
    });
    setState(() => _equiposBusqueda = newEquipos );
    print('equipos busqueda:');
    print(_equiposBusqueda);

  }

  Widget _crearCodigosList(){
    return SingleChildScrollView(
      child: Wrap(
        children: _equiposBusqueda.map((value) => GestureDetector(
          child: _codigoBox(value),
          onTap: (){
            setState(() { 
              _equipo = value; 
              textEditingControllerEquipo.text = value['equ_codigo'];
              _equiposBusqueda = _equipos;
            });
            Navigator.pop(context);
          },
        )).toList(),
      )
    );
  }

  Widget _codigoBox(codigo){
    return Container(
      child: Text(codigo['equ_codigo']),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xffdbdbdb),
        )
      ),
    );
  }
}