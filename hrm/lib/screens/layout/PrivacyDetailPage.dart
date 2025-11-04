import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:vietq_hrm/widgets/customWidgets/CustomLoadingOverlay.dart';

class PrivacyDetailPage extends StatefulWidget {
  const PrivacyDetailPage({super.key});

  @override
  State<PrivacyDetailPage> createState() => _PrivacyDetailPageState();
}

class _PrivacyDetailPageState extends State<PrivacyDetailPage> {
  final Map<String, dynamic> DataNotification = {
    "MessageID": 33340,
    "MessageSubject": "THÔNG BÁO TỔ CHỨC THI KẾT THÚC HỌC PHẦN HỌC KỲ 1  NĂM HỌC 2025-2026",
    "MessageBody": """
    <h3>Privacy Policy — VietQ HRM</h3>

<p><strong>Effective Date:</strong> 10/10/2025</p>

<p>
VietQ ("we", "our", or "us") respects your privacy and is committed to protecting your personal information.
This Privacy Policy explains how we collect, use, and share data when you use VietQ HRM.
By using our Service, you agree to the practices described in this policy.
</p>

<h4>1. Information We Collect</h4>
<p>We may collect the following types of information:</p>
<ul>
  <li><strong>Personal Information:</strong> such as your name, email address, phone number, or other contact details provided during registration or use.</li>
  <li><strong>Usage Data:</strong> information on how you interact with the Service, including device type, IP address, and log data.</li>
  <li><strong>Cookies and Tracking:</strong> we may use cookies or similar technologies to enhance your experience.</li>
</ul>

<h4>2. How We Use Your Information</h4>
<ul>
  <li>To provide, maintain, and improve our Service.</li>
  <li>To communicate with you regarding updates, notifications, or support.</li>
  <li>To personalize user experience and recommend relevant content.</li>
  <li>To comply with legal obligations or enforce our Terms of Service.</li>
</ul>

<h4>3. Data Sharing and Disclosure</h4>
<p>We do not sell or rent your personal information.  
However, we may share your data in the following cases:</p>
<ul>
  <li>With trusted third-party service providers that help us operate our Service.</li>
  <li>When required by law or government authorities.</li>
  <li>In case of a business transfer, such as a merger or acquisition.</li>
</ul>

<h4>4. Data Security</h4>
<p>
We implement appropriate technical and organizational measures to protect your data from unauthorized access, alteration, or disclosure.
However, no system is completely secure, and we cannot guarantee absolute data security.
</p>

<h4>5. Your Rights</h4>
<p>You have the right to:</p>
<ul>
  <li>Access, update, or delete your personal information.</li>
  <li>Withdraw consent at any time, where applicable.</li>
  <li>Request information about how your data is processed.</li>
</ul>

<p>To exercise these rights, please contact us at <a href="mailto:support@viet-q.com">support@viet-q.com</a>.</p>

<h4>6. Data Retention</h4>
<p>
We retain personal data only as long as necessary to fulfill the purposes for which it was collected
or as required by applicable law.
</p>

<h4>7. Children’s Privacy</h4>
<p>
Our Service is not intended for children under the age of 13.
We do not knowingly collect data from minors. If you believe a child has provided personal information,
please contact us to delete it.
</p>

<h4>8. Changes to This Policy</h4>
<p>
We may update this Privacy Policy from time to time.
Any changes will be posted in the app or on our website, with an updated “Effective Date.”
Your continued use of the Service constitutes acceptance of the revised policy.
</p>

<h4>9. Contact Us</h4>
<p>
If you have any questions about this Privacy Policy, please contact:
</p>
<ul>
  <li>Email: <a href="mailto:support@viet-q.com">support@viet-q.com</a></li>
</ul>

<p>© 2025 VietQ. All rights reserved.</p>
<p>Version: <strong>{{Version}}</strong></p>

     """,
    // "MessageBody": "<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Kính gửi Quý Anh/ Chị Sinh viên,<?xml:namespace prefix = \"o\" ns = \"urn:schemas-microsoft-com:office:office\" /><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Nhà trường thông báo thời gian tổ chức kỳ thi kết thúc học phần học kỳ 1, năm học 2025-2026.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Vui lòng xem chi tiết tại link: <A href=\"https://ttktdbcl.vhu.edu.vn/vi/thong-bao-14/thong-bao-to-chuc-thi-ket-thuc-hoc-phan-hoc-ky-1-nam-hoc-2025-2026\">Thông báo tổ chức thi kết thúc học phần học kỳ 1, năm học 2025-2026</A></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>1. Đối tượng:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Học viên bậc sau đại học; sinh viên bậc đại học hệ chính quy, liên thông, văn bằng 2.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>2. Hình thức:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Thi kết thúc học phần gồm các hình thức thi tự luận, trắc nghiệm, vấn đáp, thuyết trình, tiểu luận hoặc hình thức khác phù hợp với tính chất của học phần/đề cương chi tiết học phần.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>3.Thời gian:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>- Các học phần có hình thức thi bài tập lớn, báo cáo, biểu diễn, đồ án, khóa luận, <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>thực hành, tiểu luận: sinh viên thực hiện theo yêu cầu của giảng viên phụ trách lớp học <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>phần. Thời gian nộp bài đảm bảo không quá hạn so với lịch nộp công bố trên cổng Portal <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>của học viên, sinh viên (cột “Ngày thi” trong “Lịch thi”). <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>- Các học phần có hình thức thi tự luận, trắc nghiệm, tổng hợp, vấn đáp: Trung tâm <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Khảo thí và Đảm bảo chất lượng sẽ thông báo lịch thi cụ thể trên cổng Portal của sinh <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>viên. Thời gian thi bắt đầu từ ngày 01/12/2025 đến ngày 28/12/2025.<SPAN style=\"mso-spacerun: yes\">&nbsp; </SPAN><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>- Lịch thi được công bố trên website Trung tâm Khảo thí và Đảm bảo chất lượng <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>và portal vào ngày 21/11/2025. <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>4. Điều kiện dự thi:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Sinh viên không vi phạm quy chế đào tạo và hoàn thành các nghĩa vụ theo quy định.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><I><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Mọi thông tin liên quan, học viên, sinh viên vui lòng liên hệ Trung tâm Chăm sóc Người học:</SPAN></I></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><FONT face=\"Times New Roman\"><SPAN style='FONT-FAMILY: \"Segoe UI Symbol\",sans-serif; mso-bidi-font-family: \"Segoe UI Symbol\"'>✓</SPAN><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Trụ sở chính: 613 Âu Cơ, P. Phú Trung, Q. Tân Phú, TP.HCM;<o:p></o:p></SPAN></FONT></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><FONT face=\"Times New Roman\"><SPAN style='FONT-FAMILY: \"Segoe UI Symbol\",sans-serif; mso-bidi-font-family: \"Segoe UI Symbol\"'>✓</SPAN><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> HungHau Campus: Khu chức năng 13E - Nguyễn Văn Linh, Phong Phú, Nam Thành phố, TP.HCM;<o:p></o:p></SPAN></FONT></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><FONT face=\"Times New Roman\"><SPAN style='FONT-FAMILY: \"Segoe UI Symbol\",sans-serif; mso-bidi-font-family: \"Segoe UI Symbol\"'>✓</SPAN><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Hotline: 18001568.<o:p></o:p></SPAN></FONT></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Trân trọng.<o:p></o:p></SPAN></P>",
    "CreationDate": "23/10/2025"
  };
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CustomLoadingOverlay(
      isLoading: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SelectionArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last updated: 10/10/2025 10:10:10', style: textTheme.bodySmall,),
                  SizedBox(height: 10,),
                  Text('Please read these privacy, carefully before using our app operated by us.', style: textTheme.bodyMedium,),
                  SizedBox(height: 10,),
                  //this content notification html converst to code
                  Html(
                    data: DataNotification['MessageBody'],

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