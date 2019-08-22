import 'package:ddish/src/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/blocs/service/account/account_bloc.dart';
import 'package:ddish/src/blocs/service/account/account_event.dart';
import 'package:ddish/src/blocs/service/account/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  double height;
  AccountPage(this.height);

  @override
  State<StatefulWidget> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  AccountBloc _bloc;

  @override
  void initState() {
    _bloc = AccountBloc(this);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<AccountEvent, AccountState>(
      bloc: _bloc,
      builder: (BuildContext context, AccountState state) {
        _bloc.dispatch(AccountTabSelected());
        return Container(
          height: height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: height * 0.05,
                width: screenWidth * 0.7,
//                margin: EdgeInsets.only(bottom: 10),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      style: const TextStyle(
                        color: const Color(0xff144478),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                      text: "Үндсэн дансны үлдэгдэл:   ",
                    ),
                    TextSpan(
                        style: const TextStyle(
                          color: const Color(0xff144478),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                        text: state is AccountBalanceLoaded
                            ? ' ${PriceFormatter.productPriceFormat(state.mainCounter.counterBalance)} ₮'
                            : '-')
                  ])),
                ),
              ),
              Container(
//                padding: EdgeInsets.only(top: 10, bottom: 10),
                height: height * 0.05,
                width: screenWidth * 0.5,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "Данс цэнэглэх заавар",
                    style: TextStyle(
                      color: const Color(0xff071f49),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: height * 0.89,
                child: showAccountChargeInstruction(),
              )
            ],
          ),
        );
      },
    );
  }

  Widget showAccountChargeInstruction() {
    Map<String, List<Widget>> instructions = {
      'Банкны салбарт багц сунгах, данс цэнэглэх:': [
        RichText(
          text: TextSpan(
            children: [
              createTextSpan('Гүйлгээний утга: ', isBold: true),
              createTextSpan(
                  'Смарт картын дугаар /****************/, багцын код болон сунгах сар /S01, M01, L01, XL01, Dans/,  утасны дугаар /********/ -аа бичнэ.')
            ],
          ),
        ),
        createColumn([
          createText('Жишээ нь:'),
          createText(
              '1.Үлэмж багцыг 12 сараар сунгах бол: 1234567891234567   L12   88123456'),
          createText('2.Дансаа цэнэглэх бол: 1234567891234567 DANS  88123456'),
        ]),
      ],
      'Мобайл банк, интернэт банкаар багц сунгах, данс цэнэглэх:': [
        RichText(
          text: TextSpan(
            children: [
              createTextSpan('Гүйлгээний утга: ', isBold: true),
              createTextSpan(
                  'Смарт картын дугаар /***************/, багцын код болон сунгах сар /S01, M01, L01, XL01, Dans/-aa бичнэ.')
            ],
          ),
        ),
        createColumn(
          [
            createText('Жишээ нь:'),
            createText(
                '1.Үлэмж багцыг 12 сараар сунгах бол: 1234567891234567   L12'),
            createText('2.Дансаа цэнэглэх бол: 1234567891234567 DANS'),
          ],
        ),
      ],
      'Social Pay аппликэйшнээр данс цэнэглэх:': [
        RichText(
          text: TextSpan(children: [
            createTextSpan('Аппликэйшний '),
            createTextSpan('“Нэмэлт” ', isBold: true),
            createTextSpan('цэсний '),
            createTextSpan('“Бусад үйлчилгээ” ', isBold: true),
            createTextSpan('ангиллаас '),
            createTextSpan('“Хэрэглээний төлбөр” ', isBold: true),
            createTextSpan('хэсгээс '),
            createTextSpan('“ДДЭШ”', isBold: true),
            createTextSpan(
                '-ийг сонгож смарт картын дугаараа оруулан дансаа цэнэглэнэ.'),
          ]),
        ),
      ],
      'Q Pay цэсээр данс цэнэглэх:': [
        RichText(
          text: createTextSpan(
              'Хаан банк, Төрийн банк болон Худалдаа хөгжлийн банкны аппликэйшн тус бүрийн Q-Pay цэс ашиглан QR код уншуулаад багцаа сунгаж, дансаа цэнэглэх боломжтой.'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: InkWell(
            child: createTitle('QR code: https://www.ddishtv.mn/helpdesk/84'),
            onTap: () => launch('https://www.ddishtv.mn/helpdesk/84'),
          ),
        ),
      ],
      'Хаан банкны мобайл банкны USSD үйлчилгээгээр данс цэнэглэх:': [
        RichText(
          text: TextSpan(children: [
            createTextSpan(
                'Хаан банкны Мобайл банк ашигладаг бол гар утаснаасаа '),
            createTextSpan('*1917# ', isBold: true),
            createTextSpan(
                'гэж залган илүү хялбараар үйлчилгээний багцаа сунгаж, дансаа цэнэглэх боломжтой.'),
          ]),
        ),
      ],
      'ЮНИТЕЛИЙН ТӨГС КАРТААР ДАНС ЦЭНЭГЛЭХ': [
        createColumn(
          [
            createTitle('Төгс картаар данс цэнэглэх:'),
            createColumn(
              [
                createText('Гар утаснаасаа: '),
                RichText(
                  text: createTextSpan(
                      'Төгс картын дугаар /****************/ зай аваад смарт картын дугаар /****************/ бичиж 139898 дугаарт илгээнэ.'),
                ),
                createText(
                    '***Урамшууллын цэнэглэгч картууд хамаарахгүй байж болно.')
              ],
            ),
          ],
        ),
        RichText(text: createTextSpan('Төгс картаар данс цэнэглэх:')),
      ],
      'ЮНИТЕЛИЙН “НЭГЖИЙН БЭЛЭГ”-ЭЭР ДАНС ЦЭНЭГЛЭХ': [
        Padding(
            padding: EdgeInsets.only(top: 8),
            child: RichText(
                text: createTextSpan(
                    'Юнителийн дараа төлбөрт дугаараас ДДЭШ-ийн смарт картыг 1000, 1500, 2000, 3000, 5000, 6000, 10000, 15000, 20000, 25000 төгрөгөөр цэнэглэх боломжтой.'))),
        Padding(
            padding: EdgeInsets.only(top: 8),
            child: RichText(
              text: createTextSpan(
                  'Нэгж бэлэглэхдээ: Смарт картын дугаар /****************/ зай аваад цэнэглэх мөнгөн дүнгээ бичиж 1444 дугаарт илгээнэ.'),
            )),
        Padding(
            padding: EdgeInsets.only(top: 8),
            child: RichText(
              text: createTextSpan(
                  '***таны бэлэглэсэн нэгжийн төлбөр сарын суурь хураамж дээр нэмэгдэж бодогдоно.'),
            )),
      ],
    };

    List<Widget> instructionWidgetChildren = [
      RichText(
        text: createTextSpan(
            'Та өөрт ойр байрлах ДДЭШ болон Юнителийн үйлчилгээний салбар, Юнителийн мобайл диллерүүдэд хандан дансаа цэнэглэх, үйлчилгээний багцаа сунгах боломжтой. '),
      ),
      createColumn(
        [
          createText('- Банк, банкны үйлчилгээгээр багц сунгах, данс цэнэглэх'),
          createText('- Юнителийн ТӨГС картаар данс цэнэглэх'),
          createText('- Юнителийн НЭГЖИЙН БЭЛЭГ-ээр данс цэнэглэх'),
          createText('- Мессежээр багц сунгах'),
          createTitle('БАНК, БАНКНЫ ҮЙЛЧИЛГЭЭГЭЭР БАГЦ СУНГАХ, ДАНС ЦЭНЭГЛЭХ'),
          RichText(
            text: createTextSpan(
                'Та банкны салбар болон банкны үйлчилгээгээр дансаа цэнэглэх, үйлчилгээний багцаа сунгахдаа гүйлгээний утга хэсэгт ДДЭШ-ийн смарт картын дугаар, сунгах багцын код, сунгах сар-аа доорх загварын дагуу бичээрэй. '),
          ),
          RichText(
              text: createTextSpan(
                  '***Таны смарт картын дугаар 16 оронтой бол сүүлийн 9 оронг, харин 12 оронтой бол эхний 10 оронг бичнэ.',
                  isBold: true)),
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(children: [
                createPadding(createTitle('Данс:')),
                createPadding(createTitle('Багцын код:')),
              ]),
              TableRow(children: [
                createPadding(createTitle('Хаан банк: 505 905 0128')),
                createPadding(createTitle('Энгийн: S')),
              ]),
              TableRow(children: [
                createPadding(createTitle('Төрийн банк: 1066 0000 4668')),
                createPadding(createTitle('Илүү: M')),
              ]),
              TableRow(children: [
                createPadding(createTitle('Хас банк: 5000 232 657')),
                createPadding(createTitle('Үлэмж: L')),
              ]),
              TableRow(children: [
                createPadding(
                    createTitle('Худалдаа Хөгжлийн банк: 499 135 803')),
                createPadding(createTitle('Бүрэн: XL')),
              ]),
              TableRow(children: [
                createPadding(createTitle('Голомт банк: 110 298 7935')),
                createPadding(createTitle('Данс цэнэглэх: Dans')),
              ]),
            ],
          )
        ],
      ),
    ];

    instructionWidgetChildren.addAll(List<Widget>.from(
      instructions.keys.map(
        (instructionTitle) => ExpansionTile(
          backgroundColor: Colors.grey[100],
          title: createTitle(instructionTitle),
          children: [
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: instructions[instructionTitle],
              ),
            )
          ],
        ),
      ),
    ));

    ListView instructionWidgets = ListView(
      children: instructionWidgetChildren
          .map((child) => Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: child,
              ))
          .toList(),
    );
    return instructionWidgets;
  }

  Text createTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }

  Text createText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 12),
    );
  }

  TextSpan createTextSpan(String text, {isBold = false}) {
    return TextSpan(
        text: text,
        style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal));
  }

  Column createColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map((child) => Padding(
                padding: EdgeInsets.only(top: 8),
                child: child,
              ))
          .toList(),
    );
  }

  Padding createPadding(child, {double paddingAll = 5}) {
    return Padding(
      padding: EdgeInsets.all(paddingAll),
      child: child,
    );
  }
}
