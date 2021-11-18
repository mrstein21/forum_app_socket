import 'package:html/parser.dart';
import 'package:intl/intl.dart';


class Utils{
  String getDiff(String date) {
    final f = new DateFormat('dd/MMM/ yyyy');
    DateTime dates = DateTime.parse(date);
    return f.format(dates);
  }

  String removeAllHtmlTags(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }



}