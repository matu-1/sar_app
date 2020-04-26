import 'package:flutter/material.dart';
import 'package:sar_app/src/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  static final String routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _crearLogo(context),
            _crearForm(context),
          ],
        ),
      ),
    );
  }

  Widget _crearLogo(context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // color: Colors.red,
      height: size.height * 0.5,
      child: Center(
        child: CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage('lib/src/assets/images/default.jpg'),
        ),
      ),
    );
  }

  Widget _crearForm(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hintText: 'ESCRIBE TU USUARIO',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              hintText: 'ESCRIBE TU USUARIO',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                child: Icon(Icons.visibility),
                onTap: () => print('pressed'),
              ),
            ),
          ),
          SizedBox(height: 25,),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: Text('INGRESAR'),
            ),
            shape: StadiumBorder(),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () => _login(context),
          ),
        ],
      ),
    );
  }

  void _login(BuildContext context) {
    Navigator.pushNamed(context, HomePage.routeName);
  }

}

