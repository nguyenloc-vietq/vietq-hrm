import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vietq_hrm/widgets/customWidgets/CustomLoadingOverlay.dart';

class TermsDetailPage extends StatefulWidget {
  const TermsDetailPage({super.key});

  @override
  State<TermsDetailPage> createState() => _TermsDetailPageState();
}

class _TermsDetailPageState extends State<TermsDetailPage> {
  final Map<String, dynamic> DataNotification = {
    "MessageID": 33340,
    "MessageSubject": "THÔNG BÁO TỔ CHỨC THI KẾT THÚC HỌC PHẦN HỌC KỲ 1  NĂM HỌC 2025-2026",
    "MessageBody": """
    <h3>Terms & Conditions — VietQ HRM</h3>

<p><strong>Effective Date:</strong> 10/10/2025</p>

<p>
Please read these Terms and Conditions carefully before using our services.
By accessing or using VietQ HRM, you agree to be bound by these terms.
</p>

<h4>1. Definitions</h4>
<p>In this Agreement:</p>
<ul>
  <li><strong>"Service"</strong> means the VietQ HRM application, website, or system provided by VietQ.</li>
  <li><strong>"User"</strong> means any individual or organization accessing or using the Service.</li>
</ul>

<h4>2. Scope</h4>
<p>
These Terms govern the relationship between the User and VietQ regarding the use of the Service.
By using the Service, you agree to comply with all provisions stated herein.
</p>

<h4>3. User Responsibilities</h4>
<ul>
  <li>Provide accurate and up-to-date information during registration and use.</li>
  <li>Do not use the Service for unlawful activities, spamming, or distributing malware.</li>
  <li>Do not share your account or credentials. Unauthorized use may lead to account suspension.</li>
</ul>

<h4>4. Company Rights & Obligations</h4>
<ul>
  <li>VietQ reserves the right to update, maintain, or suspend the Service for technical or legal reasons.</li>
  <li>We strive to ensure data security in accordance with our <a href="#privacy">Privacy Policy</a>.</li>
</ul>

<h4 id="privacy">5. Privacy & Data Protection</h4>
<p>
Personal data is collected, processed, and stored as described in our
<a href="https://vietq.com.vn">Privacy Policy</a>.
You may request to access, correct, or delete your personal data as required by applicable law.
</p>

<h4>6. Intellectual Property</h4>
<p>
All content, trademarks, logos, software, and materials within the Service are owned or licensed by VietQ.
You may not reproduce, distribute, or use any part of the Service without prior written consent.
</p>

<h4>7. Limitation of Liability</h4>
<p>
To the maximum extent permitted by law, VietQ shall not be liable for any direct, indirect, incidental,
or consequential damages resulting from the use or inability to use the Service.
</p>

<h4>8. Termination</h4>
<p>
VietQ may suspend or terminate user access at any time in the event of a violation of these Terms.
Users may also deactivate their account at any time by following the in-app instructions.
</p>

<h4>9. Changes to the Terms</h4>
<p>
VietQ reserves the right to amend these Terms at any time.
Any updates will be published on the Service, and continued use will constitute acceptance of the revised Terms.
</p>

<h4>10. Governing Law</h4>
<p>
These Terms are governed by the laws of Viet Nam.
Any disputes shall be resolved amicably or, failing that, submitted to a competent court in .
</p>

<h4>11. Contact</h4>
<p>
For questions regarding these Terms, please contact:
</p>

<p>© 2025 VietQ. All rights reserved.</p>
<p>Version: <strong>1.0.0</strong></p>

    """,
    // "MessageBody": "<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Kính gửi Quý Anh/ Chị Sinh viên,<?xml:namespace prefix = \"o\" ns = \"urn:schemas-microsoft-com:office:office\" /><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Nhà trường thông báo thời gian tổ chức kỳ thi kết thúc học phần học kỳ 1, năm học 2025-2026.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Vui lòng xem chi tiết tại link: <A href=\"https://ttktdbcl.vhu.edu.vn/vi/thong-bao-14/thong-bao-to-chuc-thi-ket-thuc-hoc-phan-hoc-ky-1-nam-hoc-2025-2026\">Thông báo tổ chức thi kết thúc học phần học kỳ 1, năm học 2025-2026</A></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>1. Đối tượng:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Học viên bậc sau đại học; sinh viên bậc đại học hệ chính quy, liên thông, văn bằng 2.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>2. Hình thức:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Thi kết thúc học phần gồm các hình thức thi tự luận, trắc nghiệm, vấn đáp, thuyết trình, tiểu luận hoặc hình thức khác phù hợp với tính chất của học phần/đề cương chi tiết học phần.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>3.Thời gian:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>- Các học phần có hình thức thi bài tập lớn, báo cáo, biểu diễn, đồ án, khóa luận, <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>thực hành, tiểu luận: sinh viên thực hiện theo yêu cầu của giảng viên phụ trách lớp học <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>phần. Thời gian nộp bài đảm bảo không quá hạn so với lịch nộp công bố trên cổng Portal <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>của học viên, sinh viên (cột “Ngày thi” trong “Lịch thi”). <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>- Các học phần có hình thức thi tự luận, trắc nghiệm, tổng hợp, vấn đáp: Trung tâm <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Khảo thí và Đảm bảo chất lượng sẽ thông báo lịch thi cụ thể trên cổng Portal của sinh <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>viên. Thời gian thi bắt đầu từ ngày 01/12/2025 đến ngày 28/12/2025.<SPAN style=\"mso-spacerun: yes\">&nbsp; </SPAN><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>- Lịch thi được công bố trên website Trung tâm Khảo thí và Đảm bảo chất lượng <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>và portal vào ngày 21/11/2025. <o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>4. Điều kiện dự thi:</SPAN></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Sinh viên không vi phạm quy chế đào tạo và hoàn thành các nghĩa vụ theo quy định.<o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><B><I><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Mọi thông tin liên quan, học viên, sinh viên vui lòng liên hệ Trung tâm Chăm sóc Người học:</SPAN></I></B><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'><o:p></o:p></SPAN></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><FONT face=\"Times New Roman\"><SPAN style='FONT-FAMILY: \"Segoe UI Symbol\",sans-serif; mso-bidi-font-family: \"Segoe UI Symbol\"'>✓</SPAN><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Trụ sở chính: 613 Âu Cơ, P. Phú Trung, Q. Tân Phú, TP.HCM;<o:p></o:p></SPAN></FONT></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><FONT face=\"Times New Roman\"><SPAN style='FONT-FAMILY: \"Segoe UI Symbol\",sans-serif; mso-bidi-font-family: \"Segoe UI Symbol\"'>✓</SPAN><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> HungHau Campus: Khu chức năng 13E - Nguyễn Văn Linh, Phong Phú, Nam Thành phố, TP.HCM;<o:p></o:p></SPAN></FONT></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><FONT face=\"Times New Roman\"><SPAN style='FONT-FAMILY: \"Segoe UI Symbol\",sans-serif; mso-bidi-font-family: \"Segoe UI Symbol\"'>✓</SPAN><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'> Hotline: 18001568.<o:p></o:p></SPAN></FONT></P>\r\n<P class=MsoNormal style=\"TEXT-ALIGN: justify; MARGIN: 0cm 0cm 8pt\"><SPAN style='FONT-FAMILY: \"Times New Roman\",serif'>Trân trọng.<o:p></o:p></SPAN></P>",
    "CreationDate": "23/10/2025"
  };
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return CustomLoadingOverlay(
      isLoading: false,
      child: Scaffold(
        backgroundColor: isDarkMode ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: SelectionArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last updated: 10/10/2025 10:10:10', style: textTheme.bodySmall,),
                  SizedBox(height: 10.h,),
                  Text('Please read these terms of service, carefully before using our app operated by us.', style: textTheme.bodyMedium,),
                  SizedBox(height: 10.h,),
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