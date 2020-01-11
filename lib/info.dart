import 'dart:convert';
import 'dart:io';

import 'package:beret/telegram_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_state.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                title: Text('Шляпа'),
                bottom: TabBar(tabs: <Widget>[
                  Tab(text: 'История игр'),
                  Tab(text: 'Правила'),
                  Tab(text: 'Авторы')
                ])),
            body: Padding(
                padding: EdgeInsets.all(12),
                child: TabBarView(children: [
                  GameHistory(),
                  ListView(children: [
                    Card(
                        child: ListTile(
                            title: Text('Цель игры\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'За ограниченное время объяснить партнёру как можно больше слов.',
                                style: TextStyle(color: Colors.black)))),
                    Card(
                        child: ListTile(
                            title: Text('Общий ход игры\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Игроки садятся вокруг стола (обычно — 6-10 человек). В шляпе находится некоторое количество слов; игроки этих слов не знают. В каждый момент времени играют два человека — объясняющий и отгадывающий, остальные игроки ждут своей очереди и слушают. Объясняющий игрок при начале хода, читает написанное на экране слово (про себя) и объясняет это слово отгадывающему игроку, не используя слова, однокоренные загаданному. Отгадывающий игрок предлагает версии до тех пор, пока не назовёт загаданное слово. После этого объясняющий нажимает "Угадано" и объясняет следующее слово. Отгаданные слова в шляпу не возвращаются. По истечении времени ход заканчивается. Если слово не отгадано, то слово возвращается в шляпу, остальным игрокам слово не показывается. После этого ход переходит к следующему по часовой стрелке игроку.',
                                style: TextStyle(color: Colors.black)))),
                    Card(
                        child: Column(children: [
                          ListTile(
                              title: Text('Разновидности игры\n',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  'Игра может происходить в двух форматах: парном и личном.',
                                  style: TextStyle(color: Colors.black))),
                          ListTile(
                              title: Text('А. Парная игра\n',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  'При парной игре, как чаще всего и играют в компаниях, все игроки разбиваются на пары (поэтому число играющих обязательно должно быть чётным). Игроки каждой пары садятся друг напротив друга, чтобы не было путаницы со сменой игроков. Каждый игрок объясняет слова только своему партнёру. Каждая пара получает столько очков, сколько слов она отгадала.',
                                  style: TextStyle(color: Colors.black))),
                          ListTile(
                              title: Text('B. Личная игра\n',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  'При игре в личном зачёте каждый игрок объясняет слова разным игрокам. За каждое загаданное и за каждое отгаданное слово игрок получает по очку. Оптимальная схема для личной игры — когда каждый загадывает слова каждому по одному разу. Добавлять игроков в игру для удобства стоит в порядке рассадки.',
                                  style: TextStyle(color: Colors.black)))
                        ])),
                    Card(
                        child: Column(children: [
                          ListTile(
                            title: Text('Частности\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'A. Загадываемые слова — существительные нарицательные в единственном числе (если оно есть; «ножницы» и т.п. загадывать можно). Слово считается отгаданным, если отгадывающий произнёс его в любой форме (например, «Мама мыла…» — «Раму», если загадано «Рама»). Слово считается отгаданным, если отгадывающий произнёс слово, звучащее так же, как написанное на бумажке, так называемый омофон (например, «Такой с колчаном» — «Лук», если загадано «Луг»). Можно также совмещать эти правила (например, «Я вступаю в…» — «Брак», если загадано «Брага»).\n\n' +
                                    'B. Объясняющему запрещено произносить слова, однокоренные загаданному слову (в случаях сомнения по поводу однокоренности слов можно воспользоваться викисловарем https://ru.wiktionary.org/ (а именно, разбором слова по составу и разделом «родственные слова»)). Слова, имеющие ту же приставку или суффикс, что и загаданное, произносить можно, не сообщая при этом, что у загаданного слова такая же приставка или суффикс. Объясняющему запрещено произносить аббревиатуры, одна из букв которых обозначает загаданное слово (например, нельзя говорить «МГУ» для «Университет»).\n\n' +
                                    'C. Объясняющему запрещено произносить слова, созвучные загаданному слову (а также слова, имеющие общие морфемы с загаданным), сообщая явно или намекая при этом (например, выделяя интонацией), что слова созвучны (или имеют общие морфемы, например, «большезга»). Объясняющему запрещено произносить слова, не существующие в русском языке, если такие слова вместе с загаданным и, возможно, дополнительными буквами образуют существующее слово. Например, нельзя сказать «птеро…» (для «дактиля») — так как вместе они образуют «птеродактиль», а также «бомбо…» (для «убежища») — так как вместе они образуют «бомбоубежище».\n\n' +
                                    'D. Объясняющий не может никаким образом апеллировать к буквам и слогам загаданного слова («первая буква – такая же, как и у …», «убери последние четыре буквы», «слово из трёх слогов» и т.п.). В частности, нельзя загадывать слова, прямо называя их анаграммы (например, «анаграмма от слова рост» нельзя, а «анаграмма к слову, обозначающему высоту» можно). Также запрещено апеллировать к начертанию буквы («круглая приставка», «в середине как крест»). Однако разрешено апеллировать к частям слова, не уточняя их размер («измени начало слова», «середина – как у слова, которое …»), а также к морфемам («измени окончание», «возьми приставку, как у моей фамилии»)\n\n' +
                                    'E. Также запрещено при объяснении передавать любую информацию мимикой или жестами.\n\n' +
                                    'F. При объяснении слова нельзя пользоваться переводами в случае, если одного из слов (сказанного объясняющим или его перевода) нет в русском языке с тем же значением. Это включает случаи и без явной апелляции к переводу на заданный язык. Например: нельзя говорить «хенд по-русски», «солнце по-английски» (загаданы рука и сан), «она длинная» (загадан шезлонг).Однако, если иностранное слово заимствованием перешло в русский язык, называть его можно: «рефрижератор по-простому», «установка по-английски». Если загадано иностранное слово, допускается говорить, из какого языка оно заимствовано, и произносить перевод: «любослов по-гречески». Также это правило действует в отношении объясняемых приставок и корней иностранного происхождения.\n\n' +
                                    'G. Если слово загадывается не через смысл, а по созвучию или по частям, то к объяснению любого из вспомогательных слов также относятся ограничения B-F.\n\n' +
                                    'H. Если объясняющий называет однокоренное с загаданным слово или иным образом нарушает правила B-F, он нажимает "Ошибка" (слово удаляется из шляпы) и передаёт ход следующему игроку. Если факт нарушения фиксируется после окончания хода, то слова, загаданные с нарушением или после него, не засчитываются.\n\n' +
                                    'I. Если отгадывающий называет слово, однокоренное загаданному, слово ещё не считается отгаданным. При этом объясняющий может сообщить о том, что загадано однокоренное слово, и попросить уточнить слово.\n\n' +
                                    'J. Объясняющий, отчаявшийся объяснить вытянутое слово, может вернуть слово в шляпу, нажав кнопку "Не угадано" и досрочно закончить объяснение. Заменить слово на другое не разрешается.\n\n' +
                                    'K. Время, отведённое на загадывание слов каждой парой игроков, — 20 секунд. По истечении этого времени объясняющий перестаёт объяснять, а у отгадывающего есть ещё 3 секунды и одно слово на то, чтобы дать ответ, после чего ответы больше не принимаются. Если загадывающий не смог остановиться по истечении времени, право трёх секунд отгадывающему не даётся.\n\n' +
                                    'L. Игроки, не загадывающие и не отгадывающие слово в данный момент, не должны ни мешать, ни помогать играющей паре . Не допускается никаким образом обсуждать ещё не отгаданные слова.\n\n',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ]))
                  ]),
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
                                            launch('tg://resolve?domain=sashkent3');
                                          }),
                                      InkWell(
                                          child: Icon(Icons.email),
                                          onTap: () {
                                            launch('mailto:sashkent3@gmail.com');
                                          }),
                                    ])),
                                TextSpan(text: '\nпод руководством Зинова Николая\n\n'),
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
                              ])))
                ]))));
  }
}

class GameHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState = Provider.of<AppState>(context);
    if (File('${currentState.documentsPath}/gameHistory.json').existsSync() &&
        File('${currentState.documentsPath}/gameHistory.json')
            .readAsStringSync() !=
            '') {
      List gameHistory = jsonDecode(
          File('${currentState.documentsPath}/gameHistory.json')
              .readAsStringSync());
      return ListView.builder(
          itemCount: gameHistory.length,
          itemBuilder: (BuildContext context, int idx) {
            List game = gameHistory[gameHistory.length - idx - 1];
            if (game[3] == 'quickgame') {
              String names = game[0].map((var player) => player[3]).join(', ');
              return Card(
                  child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ScoreBoard(game[0], game[2])));
                      },
                      title: Text(
                        names,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(DateFormat('dd/MM/yyyy').add_Hm().format(
                          DateTime.fromMillisecondsSinceEpoch(game[1])) +
                          ', быстрая игра')));
            } else {
              return Card(
                  child: ListTile(
                    title: Text('Я и ${game[0]} объяснили ${game[1]}'),
                    subtitle: Text(DateFormat('dd/MM/yyyy')
                        .add_Hm()
                        .format(DateTime.fromMillisecondsSinceEpoch(game[2])) +
                        ', режим для двоих'),
                  ));
            }
          });
    } else {
      return Text('У вас еще нет сыгранных игр!');
    }
  }
}

class ScoreBoard extends StatelessWidget {
  final List players;
  final bool fixTeams;

  ScoreBoard(this.players, this.fixTeams);

  @override
  Widget build(BuildContext context) {
    if (fixTeams) {
      return Scaffold(
          appBar: AppBar(title: Text('Шляпа')),
          body: Padding(
              padding: EdgeInsets.all(12),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: players.length ~/ 2 + 1,
                  itemBuilder: (BuildContext context, int idx) {
                    if (idx > 0) {
                      idx = (idx - 1) * 2;
                      return Card(
                          child: ListTile(
                              leading: Icon(Icons.group,
                                  color: Color(players[idx][2])),
                              title: Container(
                                  child: Column(children: [
                                    Text(players[idx][3]),
                                    Text(players[idx + 1][3])
                                  ]),
                                  alignment: Alignment.centerLeft),
                              trailing: Container(
                                width: 93,
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(players[idx][1].toString()),
                                            Text(players[idx + 1][1].toString())
                                          ]),
                                      Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(players[idx][0].toString()),
                                            Text(players[idx + 1][0].toString())
                                          ]),
                                      Text((players[idx][1] + players[idx][0])
                                          .toString())
                                    ]),
                              )));
                    } else {
                      return ListTile(
                          leading: Visibility(
                              child: Icon(Icons.person), visible: false),
                          title: Text('Имя игрока',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Container(
                            width: 100,
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(Icons.lightbulb_outline),
                                  Icon(Icons.chat),
                                  Text(
                                    '\u{03A3}',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black45),
                                  )
                                ]),
                          ));
                    }
                  })));
    } else {
      return Scaffold(
          appBar: AppBar(title: Text('Шляпа')),
          body: Padding(
              padding: EdgeInsets.all(12),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: players.length + 1,
                  itemBuilder: (BuildContext context, int idx) {
                    if (idx > 0) {
                      idx -= 1;
                      return ListTile(
                          leading: Icon(Icons.person, color: Colors.blue),
                          title: Text(players[idx][3]),
                          trailing: Container(
                            width: 93,
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(players[idx][1].toString()),
                                  Text(players[idx][0].toString()),
                                  Text((players[idx][1] + players[idx][0])
                                      .toString())
                                ]),
                          ));
                    } else {
                      return ListTile(
                          leading: Visibility(
                              child: Icon(Icons.person), visible: false),
                          title: Text('Имя игрока',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Container(
                            width: 100,
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Icon(Icons.lightbulb_outline),
                                  Icon(Icons.chat),
                                  Text(
                                    '\u{03A3}',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black45),
                                  )
                                ]),
                          ));
                    }
                  })));
    }
  }
}
