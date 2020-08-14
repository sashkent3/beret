import 'package:beret/telegram_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text('Шляпа'),
                bottom: TabBar(tabs: <Widget>[
                  Tab(text: 'Авторы'),
                  Tab(text: 'Доп. информация')
                ])),
            body: Builder(
                builder: (context) => Padding(
                    padding: EdgeInsets.all(12),
                    child: TabBarView(children: [
                      SingleChildScrollView(
                          child: RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                            TextSpan(
                                text: 'Новый Android-клиент:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            WidgetSpan(
                                child: Row(children: [
                              Text('Зинов Александр',
                                  style: TextStyle(fontSize: 14)),
                              InkWell(
                                  child: Icon(TelegramIcon.telegram),
                                  onTap: () {
                                    launch('tg://resolve?domain=sashkent3')
                                        .catchError((e) {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Telegram: @sashkent3')));
                                    });
                                  }),
                              InkWell(
                                  child: Icon(Icons.email),
                                  onTap: () {
                                    launch('mailto:sashkent3@gmail.com');
                                  }),
                            ])),
                            TextSpan(
                                text: '\nпод руководством Зинова Николая\n\n'),
                            TextSpan(
                                text: 'Старый Android-клиент: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Денис Кузнецов\n\n'),
                            TextSpan(
                                text: 'Сервер: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    'ЛКШ.Зима 2013-2014, Параллель П в составе:\n\n'),
                            TextSpan(
                                text: 'Преподаватели:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Дробин Вадим Дмитриевич\n'),
                            TextSpan(text: 'Кузнецов Денис Васильевич\n\n'),
                            TextSpan(
                                text: 'Школьники:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Калинин Николай\n'),
                            TextSpan(text: 'Козловцев Константин\n'),
                            TextSpan(text: 'Лабутин Игорь\n'),
                            TextSpan(text: 'Павлов Иван\n'),
                            TextSpan(text: 'Торба Дмитрий\n\n'),
                            TextSpan(
                                text: 'Последующая работа над сервером:\n\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Зинов Николай\n'),
                            TextSpan(text: 'Павлов Иван\n'),
                            TextSpan(text: 'под руководством\n'),
                            TextSpan(text: 'Гольдштейна Виталия Борисовича\n'),
                            TextSpan(text: 'Кузнецова Дениса Васильевича\n\n'),
                            TextSpan(
                                text:
                                    'Разработка основана на приложении, написанном участниками параллели П в ЛКШ.Август 2013:\n\n'),
                            TextSpan(
                                text: 'Преподаватели\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Гольдштейн Виталий Борисович\n'),
                            TextSpan(text: 'Дробин Вадим Дмитриевич\n'),
                            TextSpan(text: 'Кузнецов Денис Васильевич\n'),
                            TextSpan(text: 'Назаров Сергей Игоревич\n'),
                            TextSpan(text: 'Шестимеров Андрей Алексеевич\n\n'),
                            TextSpan(
                                text: 'Школьники:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Зинов Николай\n'),
                            TextSpan(text: 'Калинин Николай\n'),
                            TextSpan(text: 'Карпенко Даниил\n'),
                            TextSpan(text: 'Козловцев Константин\n'),
                            TextSpan(text: 'Кравченко Дмитрий\n'),
                            TextSpan(text: 'Лабутин Игорь\n'),
                            TextSpan(text: 'Лиференко Даниил\n'),
                            TextSpan(text: 'Павлов Иван\n'),
                            TextSpan(text: 'Сергеев Иван\n'),
                            TextSpan(text: 'Торба Дмитрий')
                          ]))),
                      ListView(children: [
                        Card(
                            child: ListTile(
                                title: Text(
                                  'Политика конфиденциальности',
                                ),
                                subtitle: Text('Условия и положения'),
                                onTap: () {
                                  launch(
                                      'https://docs.google.com/document/d/1T81rAWe-KG2_7RJ946Qb628zBHS9eqdMf4ik8uB_jIU/edit',
                                      forceWebView: true,
                                      enableJavaScript: true);
                                }))
                      ])
                    ])))));
  }
}
