import 'package:beret/telegram_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: const Text('Шляпа'),
                bottom: const TabBar(tabs: <Widget>[
                  Tab(text: 'Авторы'),
                  Tab(text: 'Доп. информация')
                ])),
            body: Builder(
                builder: (context) => Padding(
                    padding: const EdgeInsets.all(12),
                    child: TabBarView(children: [
                      SingleChildScrollView(
                          child: RichText(
                              text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                            const TextSpan(
                                text: 'Новый Android-клиент:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            WidgetSpan(
                                child: Row(children: [
                              const Text('Зинов Александр',
                                  style: TextStyle(fontSize: 14)),
                              InkWell(
                                  child: const Icon(TelegramIcon.telegram),
                                  onTap: () {
                                    launchUrlString(
                                            'tg://resolve?domain=sashkent3')
                                        .catchError((e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Telegram: @sashkent3')));
                                      return false;
                                    });
                                  }),
                              InkWell(
                                  child: const Icon(Icons.email),
                                  onTap: () {
                                    launchUrlString(
                                        'mailto:sashkent3@gmail.com');
                                  }),
                            ])),
                            const TextSpan(
                                text: '\nпод руководством Зинова Николая\n\n'),
                            const TextSpan(
                                text: 'Старый Android-клиент: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Денис Кузнецов\n\n'),
                            const TextSpan(
                                text: 'Сервер: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(
                                text:
                                    'ЛКШ.Зима 2013-2014, Параллель П в составе:\n\n'),
                            const TextSpan(
                                text: 'Преподаватели:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Дробин Вадим Дмитриевич\n'),
                            const TextSpan(
                                text: 'Кузнецов Денис Васильевич\n\n'),
                            const TextSpan(
                                text: 'Школьники:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Калинин Николай\n'),
                            const TextSpan(text: 'Козловцев Константин\n'),
                            const TextSpan(text: 'Лабутин Игорь\n'),
                            const TextSpan(text: 'Павлов Иван\n'),
                            const TextSpan(text: 'Торба Дмитрий\n\n'),
                            const TextSpan(
                                text: 'Последующая работа над сервером:\n\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Зинов Николай\n'),
                            const TextSpan(text: 'Павлов Иван\n'),
                            const TextSpan(text: 'под руководством\n'),
                            const TextSpan(
                                text: 'Гольдштейна Виталия Борисовича\n'),
                            const TextSpan(
                                text: 'Кузнецова Дениса Васильевича\n\n'),
                            const TextSpan(
                                text:
                                    'Разработка основана на приложении, написанном участниками параллели П в ЛКШ.Август 2013:\n\n'),
                            const TextSpan(
                                text: 'Преподаватели\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(
                                text: 'Гольдштейн Виталий Борисович\n'),
                            const TextSpan(text: 'Дробин Вадим Дмитриевич\n'),
                            const TextSpan(text: 'Кузнецов Денис Васильевич\n'),
                            const TextSpan(text: 'Назаров Сергей Игоревич\n'),
                            const TextSpan(
                                text: 'Шестимеров Андрей Алексеевич\n\n'),
                            const TextSpan(
                                text: 'Школьники:\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Зинов Николай\n'),
                            const TextSpan(text: 'Калинин Николай\n'),
                            const TextSpan(text: 'Карпенко Даниил\n'),
                            const TextSpan(text: 'Козловцев Константин\n'),
                            const TextSpan(text: 'Кравченко Дмитрий\n'),
                            const TextSpan(text: 'Лабутин Игорь\n'),
                            const TextSpan(text: 'Лиференко Даниил\n'),
                            const TextSpan(text: 'Павлов Иван\n'),
                            const TextSpan(text: 'Сергеев Иван\n'),
                            const TextSpan(text: 'Торба Дмитрий')
                          ]))),
                      ListView(children: [
                        Card(
                            child: ListTile(
                                title: const Text(
                                  'Политика конфиденциальности',
                                ),
                                subtitle: const Text('Условия и положения'),
                                onTap: () {
                                  launchUrlString(
                                    'https://docs.google.com/document/d/1T81rAWe-KG2_7RJ946Qb628zBHS9eqdMf4ik8uB_jIU/edit',
                                    mode: LaunchMode.inAppWebView,
                                  );
                                }))
                      ])
                    ])))));
  }
}
