import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vietq_hrm/configs/apiConfig/notification.api.dart';
import 'package:vietq_hrm/models/notification.models.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/CustomAppBar.widget.dart';
import 'package:vietq_hrm/widgets/customWidgets/CustomLoadingOverlay.dart';

class NotificationDetailPages extends StatefulWidget {
  const NotificationDetailPages({super.key});

  @override
  State<NotificationDetailPages> createState() => _NotificationDetailPagesState();
}

class _NotificationDetailPagesState extends State<NotificationDetailPages> {
  NotificationModel? dataNotification;
  bool isLoading = false;
  Future<void> _fetchNotificationDetail(String idProduct) async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await NotificationApi().getDetailNotification(id: idProduct);
      setState(() {
        dataNotification = data;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = GoRouterState.of(context).pathParameters['idNotification'];
    _fetchNotificationDetail(id.toString());
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CustomLoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: SelectionArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dataNotification?.notification?.title ?? '', style: textTheme.headlineMedium,),
                  SizedBox(height: 10.h,),
                  dataNotification != null ? Text('Last updated: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(dataNotification?.notification?.updatedAt as String).toLocal()).toString() }', style: textTheme.bodySmall,): SizedBox(height: 10,),
                  SizedBox(height: 10.h,),
                  //this content notification html converst to code
                  Html(
                    data: dataNotification?.notification?.body ?? '',
                    style: {
                      "*": Style(                     // áp dụng cho **tất cả** thẻ
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      "body": Style(
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      "p": Style(
                        margin: Margins.symmetric(vertical: 10.r), // giữ lại nếu bạn muốn
                        padding: HtmlPaddings.zero,
                      ),
                      "ul, ol": Style(
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      "li": Style(
                        padding: HtmlPaddings.zero,
                        margin: Margins.zero,
                      ),
                      "h1": Style(fontSize: FontSize(24.sp), fontWeight: FontWeight.bold),
                      "a": Style(
                        color: Colors.blue,
                        textDecoration: TextDecoration.underline,
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
