import 'package:flutter/material.dart';
import 'package:sar_app/src/pages/solicitud_create_page.dart';
import 'package:sar_app/src/providers/solicitud_provider.dart';

class HomePage extends StatelessWidget {
  static final routeName = 'home';
  final solicitudProvider = new SolicitudProvider();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOLICITUDES'),
        actions: <Widget>[
          PopupMenuButton(
            padding: EdgeInsets.zero,
            onSelected: _selectedPopupItem,
            itemBuilder: (BuildContext context){
              return [
                PopupMenuItem(child: Text('Perfil'), value: 'perfil',),
                PopupMenuItem(child: Text('Otros'), value: 'otros',),
              ];
            }
          ),
        ],
      ),
      body: _solicitudList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, SolicitudCreatePage.routeName)
      ),
    );
  }

  Widget _solicitudList() {
    return FutureBuilder(
      future: solicitudProvider.getAll(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }else{
          final solicitudes = snapshot.data;
          return ListView.builder(
            itemCount: solicitudes.length,
            itemBuilder: (BuildContext context, int i) {
              return _solicitudBox(solicitudes[i]);
            }
          );
        }
      },
    );
  }

  Widget _solicitudBox(solicitud) {
    final inicial = solicitud['persona'].substring(0, 1).toUpperCase();
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color(0xfff2f2f2),
          )
        )
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.grey, 
              child: Text(inicial, style: TextStyle(color: Colors.white),),
              radius: 20,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _texto('NOMBRE', solicitud['persona']),
              _texto('FECHA ENTREGA', solicitud['sol_fecha_entrega']),
              _texto('FEHA DEVOLUCION', solicitud['sol_fecha_devolucion']),
            ],
          )
        ],
      ),
    );
  }

  Widget _texto(String propiedad, String valor) {
    return Row(
      children: <Widget>[
        Text('$propiedad: ', style: TextStyle(fontWeight: FontWeight.bold),),
        Text(valor),
      ],
    );
  }

  _selectedPopupItem(String value){
    print(value);
  }
}