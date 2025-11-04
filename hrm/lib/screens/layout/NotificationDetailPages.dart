import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:vietq_hrm/widgets/CustomAppbar/CustomAppBar.widget.dart';
import 'package:vietq_hrm/widgets/customWidgets/CustomLoadingOverlay.dart';

class NotificationDetailPages extends StatefulWidget {
  const NotificationDetailPages({super.key});

  @override
  State<NotificationDetailPages> createState() => _NotificationDetailPagesState();
}

class _NotificationDetailPagesState extends State<NotificationDetailPages> {
  final Map<String, dynamic> DataNotification = {
    "MessageID": 33340,
    "MessageSubject": "THÔNG BÁO TỔ CHỨC THI KẾT THÚC HỌC PHẦN HỌC KỲ 1  NĂM HỌC 2025-2026",
    "MessageBody": "<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Kính gửi Quý Anh/ Chị Sinh viên,<?xml:namespace prefix = \"o\" ns = \"urn:schemas-microsoft-com:office:office\" /><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Nhà trường thông báo thời gian tổ chức kỳ thi kết thúc học phần học kỳ 1, năm học 2025-2026.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Vui lòng xem chi tiết tại link: <A href=\"https://ttktdbcl.vhu.edu.vn/vi/thong-bao-14/thong-bao-to-chuc-thi-ket-thuc-hoc-phan-hoc-ky-1-nam-hoc-2025-2026\">Thông báo tổ chức thi kết thúc học phần học kỳ 1, năm học 2025-2026</A></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>1. Đối tượng:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Học viên bậc sau đại học; sinh viên bậc đại học hệ chính quy, liên thông, văn bằng 2.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>2. Hình thức:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Thi kết thúc học phần gồm các hình thức thi tự luận, trắc nghiệm, vấn đáp, thuyết trình, tiểu luận hoặc hình thức khác phù hợp với tính chất của học phần/đề cương chi tiết học phần.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>3.Thời gian:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>- Các học phần có hình thức thi bài tập lớn, báo cáo, biểu diễn, đồ án, khóa luận, <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>thực hành, tiểu luận: sinh viên thực hiện theo yêu cầu của giảng viên phụ trách lớp học <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>phần. Thời gian nộp bài đảm bảo không quá hạn so với lịch nộp công bố trên cổng Portal <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>của học viên, sinh viên (cột “Ngày thi” trong “Lịch thi”). <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>- Các học phần có hình thức thi tự luận, trắc nghiệm, tổng hợp, vấn đáp: Trung tâm <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Khảo thí và Đảm bảo chất lượng sẽ thông báo lịch thi cụ thể trên cổng Portal của sinh <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>viên. Thời gian thi bắt đầu từ ngày 01/12/2025 đến ngày 28/12/2025.<SPAN style=\"mso-spacerun: yes\">&nbsp; </SPAN><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>- Lịch thi được công bố trên website Trung tâm Khảo thí và Đảm bảo chất lượng <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>và portal vào ngày 21/11/2025. <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>4. Điều kiện dự thi:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Sinh viên không vi phạm quy chế đào tạo và hoàn thành các nghĩa vụ theo quy định.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><I><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Mọi thông tin liên quan, học viên, sinh viên vui lòng liên hệ Trung tâm Chăm sóc Người học:</SPAN></I></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><FONT face=\"Times New Roman\"><SPAN style='FONT-FAMILY: \"Segoe UI Symbol\",sans-serif; mso-bidi-font-family: \"Segoe UI Symbol\"'>✓</SPAN><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Trụ sở chính: 613 Âu Cơ, P. Phú Trung, Q. Tân Phú, TP.HCM;<o:p></o:p></SPAN></FONT></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><FONT face=\"Times New Roman\"><SPAN style='FONT-FAMILY: \"Segoe UI Symbol\",sans-serif; mso-bidi-font-family: \"Segoe UI Symbol\"'>✓</SPAN><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> HungHau Campus: Khu chức năng 13E - Nguyễn Văn Linh, Phong Phú, Nam Thành phố, TP.HCM;<o:p></o:p></SPAN></FONT></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><FONT face=\"Times New Roman\"><SPAN style='FONT-FAMILY: \"Segoe UI Symbol\",sans-serif; mso-bidi-font-family: \"Segoe UI Symbol\"'>✓</SPAN><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Hotline: 18001568.<o:p></o:p></SPAN></FONT></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Trân trọng.<o:p></o:p></SPAN></P>",
    "CreationDate": "23/10/2025"
  };
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CustomLoadingOverlay(
      isLoading: true,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SelectionArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title Notification', style: textTheme.headlineMedium,),
                  SizedBox(height: 10,),
                  Text('Last updated: 10/10/2025 10:10:10', style: textTheme.bodySmall,),
                  SizedBox(height: 10,),
                  //this content notification html converst to code
                  Html(
                    data: DataNotification['MessageBody'] ?? '',

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
                        margin: Margins.symmetric(vertical: 10), // giữ lại nếu bạn muốn
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
                      "h1": Style(fontSize: FontSize(24), fontWeight: FontWeight.bold),
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
