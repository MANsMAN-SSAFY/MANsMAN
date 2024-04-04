import 'package:timeago/timeago.dart' as timeago;

class TimeUtil {
  static setLocalMessages() {
    timeago.setLocaleMessages('ko', KoMessages());
    // 다른 언어 설정이 필요하다면 여기에 추가합니다.
  }

  static String timeAgo({required int milliseconds}) {
    final date =
        DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: false);
    return timeago.format(date, locale: 'ko', allowFromNow: true);
  }
}

class KoMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '전';
  @override
  String suffixFromNow() => '전';
  @override
  String lessThanOneMinute(int seconds) => '방금';
  @override
  String aboutAMinute(int minutes) => '방금';
  @override
  String minutes(int minutes) => '$minutes분';
  @override
  String aboutAnHour(int minutes) => '1시간';
  @override
  String hours(int hours) => '$hours시간';
  @override
  String aDay(int hours) => '1일';
  @override
  String days(int days) => '$days일';
  @override
  String aboutAMonth(int days) => '한달';
  @override
  String months(int months) => '$months개월';
  @override
  String aboutAYear(int year) => '1년';
  @override
  String years(int years) => '$years년';
  @override
  String wordSeparator() => ' ';

  DateTime nowInKorea() {
    var now = DateTime.now().toUtc();
    return now.add(const Duration(hours: 9)); // UTC에서 KST(UTC+9)로 변환
  }
}
