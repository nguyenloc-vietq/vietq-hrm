import * as fs from "fs";
import * as path from "path";

/* eslint-disable @typescript-eslint/no-explicit-any */
import { Injectable } from "@nestjs/common";
// DÙNG BẢN CHO NODE.JS
import PdfPrinter from "pdfmake/src/printer";

@Injectable()
export class PayrollPdfService {
  private readonly fonts = {
    Roboto: {
      normal: path.join(process.cwd(), "public", "fonts", "Roboto-Regular.ttf"),
      bold: path.join(process.cwd(), "public", "fonts", "Roboto-Medium.ttf"),
      italics: path.join(process.cwd(), "public", "fonts", "Roboto-Italic.ttf"),
      bolditalics: path.join(
        process.cwd(),
        "public",
        "fonts",
        "Roboto-MediumItalic.ttf",
      ),
    },
  };

  async generatePayrollPdf(userData: any): Promise<string> {
    const printer = new PdfPrinter(this.fonts);

    const salary = userData.salaryConfigs?.[0] || {};
    const baseSalary = Number(salary.baseSalary) || 0;
    const attendance = userData.attendanceRecs?.attendanceRecs || [];

    const docDefinition: any = {
      pageSize: "A4",
      pageMargins: [20, 20, 20, 20],
      defaultStyle: { font: "Roboto", fontSize: 12 },

      content: [
        {
          columns: [
            {
              // Using an SVG string
              svg: `
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="-38.601 111.6455 438.1602 84.67" width="100" height="20">
                      <defs>
                        <linearGradient id=":r3:-1" x1="0%" y1="0%" x2="100%" y2="100%">
                          <stop offset="0" stop-color="#6BB1F8"/>
                          <stop offset="0.3" stop-color="#0C68E9"/>
                          <stop offset="0.7" stop-color="#063BA7"/>
                          <stop offset="1" stop-color="#6BB1F8"/>
                        </linearGradient>
                      </defs>
                      <g id="object-0" transform="matrix(1, 0, 0, 1, 0, 1.4210854715202004e-14)">
                        <path fill="url(#:r3:-1)" d="M 113.749 126.636 L 113.749 111.646 L 69.739 111.646 C 69.739 111.646 67.019 111.646 67.019 111.646 L 50.619 111.646 L 25.049 168.926 C 24.399 170.546 22.789 171.516 20.949 171.516 L 7.469 171.516 C 5.739 171.516 4.129 170.546 3.369 168.926 L -22.201 111.646 L -38.601 111.646 L -9.911 175.936 C -7.001 182.296 -0.631 186.506 6.379 186.506 L 22.019 186.506 C 29.029 186.506 35.399 182.296 38.309 175.936 L 60.309 126.636 L 72.919 126.636 C 72.919 126.636 83.429 126.636 83.429 126.636 L 83.429 171.506 L 69.729 171.506 L 69.729 186.496 L 113.739 186.496 L 113.739 171.506 L 100.149 171.506 L 100.149 126.636 L 113.739 126.636 L 113.749 126.636 Z"/>
                        <g fill="url(#:r3:-1)" transform="matrix(1, 0, 0, 1, -69.520859, -96.024467)">
                          <path d="M467.03,257.5c1.29-3.88,2.05-8.09,2.05-12.4,0-21.14-17.15-37.43-38.29-37.43h-205.04c-21.25,0-38.4,16.29-38.4,37.43s17.15,37.43,38.4,37.43h42.23c8.28,0,14.99-6.71,14.99-14.99h-57.22c-2.5,0-5-.46-7.33-1.38-3.73-1.47-6.96-4.08-9.25-7.37-2.75-3.95-4.05-8.64-4.05-13.44,0-2.78.32-5.6,1.19-8.25.92-2.79,2.39-5.4,4.34-7.6,1.87-2.12,4.18-3.85,6.76-5.03,2.61-1.2,5.47-1.81,8.34-1.81,0,0,86.45-.11,86.45-.11v60.09h16.72v-60.09h33.46c-4.78,6.22-7.63,13.97-7.63,22.55,0,21.14,17.15,37.43,38.4,37.43h27.51c3.34,0,6.47,1.19,8.85,3.34l7.44,6.47h25.46l-28.37-24.81h-40.88c-11.43,0-20.71-9.49-20.71-22.44s9.28-22.44,20.71-22.44h37.65c11.43,0,20.6,9.49,20.6,22.44,0,4.64-1.19,8.84-3.24,12.4h18.88Z"/>
                          <path d="M221.93,245.5h0c0,4.14,3.36,7.5,7.5,7.5h25.42v-14.99h-25.42c-4.14,0-7.5,3.36-7.5,7.5Z"/>
                        </g>
                      </g>
                    </svg>
                    `,
            },
            {
              text: "CÔNG TY TNHH VIET-Q",
              bold: true,
              fontSize: 20,
              center: true,
              color: "#0C68E9",
            },
          ],
        },
        { text: "PHIEU LUONG", bold: true, center: true },
        {
          margin: [0, 15, 0, 10],
          columns: [
            {
              width: "50%",
              table: {
                widths: ["50%", "50%"],
                body: [
                  [
                    { text: "Họ tên / Full Name:", bold: true },
                    userData.fullName,
                  ],
                  [{ text: "Email:", bold: true }, userData.email],
                  [
                    { text: "Số diện thoại / Phone:", bold: true },
                    userData.phone,
                  ],
                  [
                    { text: "Mã NV / Emp. code:", bold: true },
                    userData.userCode,
                  ],
                  [{ text: "Chức vụ / Job Title:", bold: true }, "-"],
                  [
                    {
                      text: "Ngày công chuẩn / Standard working days:",
                      bold: true,
                    },
                    "22",
                  ],
                ],
              },
              layout: "noBorders",
            },
            {
              width: "50%",
              table: {
                widths: ["50%", "50%"],
                body: [
                  [
                    { text: "Số tài khoản / Bank account:", bold: true },
                    "1234567890",
                  ],
                  [
                    { text: "Ngân hàng / Bank:", bold: true },
                    "NH Ngoại thương VN - Vietcombank",
                  ],
                  [
                    { text: "Mã số thuế / PIT Code:", bold: true },
                    "1234567890",
                  ],
                ],
              },
              layout: "noBorders",
            },
          ],
        },
        // Thời gian làm việc
        {
          margin: [0, 10, 0, 10],
          table: {
            widths: ["25%", "15%", "25%", "15%", "20%"],
            body: [
              [
                {
                  text: "Ngày làm việc thực tế / Actual working days:",
                  bold: true,
                },
                "10",
                { text: "Giờ làm thêm / Overtime:", bold: true },
                "-",
                "",
              ],
              [
                { text: "Giờ làm ca đêm / Nightshift:", bold: true },
                "-",
                {
                  text: "Làm thêm giờ ca đêm / Overtime nightshift:",
                  bold: true,
                },
                "-",
                "",
              ],
            ],
          },
          layout: "lightHorizontalLines",
        },
        // Bảng lương chính (phần A + B + C)
        {
          margin: [0, 10, 0, 0],
          table: {
            headerRows: 1,
            widths: ["30%", "20%", "30%", "*"],
            body: [
              // Header
              [
                {
                  text: "Lương hợp đồng / Contracted salary:",
                  colSpan: 3,
                  alignment: "left",
                  bold: true,
                },
                {},
                {},
                {
                  text: baseSalary,
                  alignment: "right",
                  bold: true,
                },
              ],
              // A. Tổng thu nhập
              [
                {
                  text: "A. Tổng thu nhập / Income:",
                  colSpan: 4,
                  fillColor: "#eeeeee",
                  bold: true,
                },
                {},
                {},
                {},
              ],
              ["Lương", "1.825.930", "Lương làm thêm giờ", "193.333"],
              ["Phụ cấp công tác", "-", "Phụ cấp tiền nhà", "-"],
              ["Tiền ăn giữa ca", "204.630", "Hỗ trợ điện thoại", "-"],
              ["Meal allowance", "", "Telephone allowance", ""],
              [
                "Hỗ trợ đi lại - Gửi xe",
                "47.222",
                "Hỗ trợ đi lại - Xăng xe & Bảo trì",
                "0.00",
              ],
              [
                "Transportation allowance - Parking",
                "",
                "Transportation allowance - Petrol & Maintenance",
                "",
              ],
              ["Hỗ trợ trách nhiệm", "-", "Truy cập thời việc", "669.231"],
              ["Job allowance", "", "Severance allowance", ""],
              ["Thưởng", "-", "Phần trăm chăm sóc", "-"],
              ["Incentive", "", "Remaining annual leave", ""],
              ["Khác / Other:", "2.940.342", "", ""],
              // Tổng A
              [
                { text: "Tổng thu nhập (A)", colSpan: 3, bold: true },
                {},
                {},
                { text: "2.940.342", alignment: "right", bold: true },
              ],
              // B. Khoản trừ
              [
                {
                  text: "B. Khoản trừ / Deduction:",
                  colSpan: 4,
                  fillColor: "#eeeeee",
                  bold: true,
                },
                {},
                {},
                {},
              ],
              ["BHXH (8%)", "261.000", "Công đoàn", "23.760"],
              ["BHYT (1.5%)", "", "Đóng phục", ""],
              ["BHTN (1%)", "", "Uniform", ""],
              ["Thuế TNCN cá nhân", "273.571", "Thất thoát tài sản, tiền", "-"],
              ["PIT", "", "Asset and monetary loss", ""],
              // Tổng B
              [
                { text: "Tổng khoản trừ (B)", colSpan: 3, bold: true },
                {},
                {},
                { text: "558.331", alignment: "right", bold: true },
              ],
              // C. Tiền lương thực nhận
              [
                {
                  text: "C. Tiền lương thực nhận (A-B)",
                  colSpan: 3,
                  fillColor: "#ffcccc",
                  bold: true,
                },
                {},
                {},
                {
                  text: "2.382.011",
                  alignment: "right",
                  bold: true,
                  fillColor: "#ffcccc",
                },
              ],
              [
                { text: "• Net take home (A-B)", colSpan: 3, bold: true },
                {},
                {},
                { text: "2.382.011", alignment: "right", bold: true },
              ],
            ],
          },
          layout: {
            hLineWidth: () => 0.5,
            vLineWidth: () => 0.5,
            hLineColor: () => "#aaaaaa",
            vLineColor: () => "#aaaaaa",
            paddingLeft: () => 4,
            paddingRight: () => 4,
            paddingTop: () => 4,
            paddingBottom: () => 4,
          },
        },
        // Ghi chú dưới cùng
        {
          margin: [0, 15, 0, 0],
          text: [
            "Lưu ý / Remark: ...\n",
            "Nhân viên chịu trách nhiệm đối với tính chính xác... (các ghi chú dài như trong ảnh)\n\n",
            "Phiếu lương này được xem là bí mật...",
          ],
          fontSize: 8,
          color: "#555555",
        },
        // Chữ ký
        {
          columns: [
            {
              width: "50%",
              text: "Người lập bảng lương\nPrepared by",
              alignment: "center",
              margin: [0, 30, 0, 0],
              bold: true,
            },
            {
              width: "50%",
              text: "Nhân viên\nEmployee",
              alignment: "center",
              margin: [0, 30, 0, 0],
              bold: true,
            },
          ],
        },
        {
          canvas: [
            { type: "line", x1: 40, y1: 5, x2: 240, y2: 5, lineWidth: 1 },
            { type: "line", x1: 320, y1: 5, x2: 520, y2: 5, lineWidth: 1 },
          ],
        },
      ],
      styles: {
        companyName: { fontSize: 16, bold: true, color: "#d71920" },
        companyNameEn: { fontSize: 14, bold: true, color: "#d71920" },
        title: { fontSize: 18, bold: true, color: "#d71920" },
        period: { fontSize: 12, bold: true },
      },
    };

    const pdfDoc = printer.createPdfKitDocument(docDefinition);
    const filePath = path.join(
      process.cwd(),
      `payroll-${userData.userCode}.pdf`,
    );

    return new Promise<string>((resolve, reject) => {
      const stream = fs.createWriteStream(filePath);
      pdfDoc.pipe(stream);
      pdfDoc.end();
      stream.on("finish", () => resolve(filePath));
      stream.on("error", reject);
    });
  }
}

// playground requires you to assign document definition to a variable called dd

// var dd = {
//     pageSize: "A4",
//     pageMargins: [20, 20, 20, 20],
//     defaultStyle: { font: "Roboto", fontSize: 9 },
// 	content: [
// 		{
//           columns: [

//             {
//                 width: 100,
//               // Using an SVG string
//               svg: `
//                     <svg xmlns="http://www.w3.org/2000/svg" viewBox="-38.601 111.6455 438.1602 84.67" width="100" height="20">
//                       <defs>
//                         <linearGradient id=":r3:-1" x1="0%" y1="0%" x2="100%" y2="100%">
//                           <stop offset="0" stop-color="#6BB1F8"/>
//                           <stop offset="0.3" stop-color="#0C68E9"/>
//                           <stop offset="0.7" stop-color="#063BA7"/>
//                           <stop offset="1" stop-color="#6BB1F8"/>
//                         </linearGradient>
//                       </defs>
//                       <g id="object-0" transform="matrix(1, 0, 0, 1, 0, 1.4210854715202004e-14)">
//                         <path fill="url(#:r3:-1)" d="M 113.749 126.636 L 113.749 111.646 L 69.739 111.646 C 69.739 111.646 67.019 111.646 67.019 111.646 L 50.619 111.646 L 25.049 168.926 C 24.399 170.546 22.789 171.516 20.949 171.516 L 7.469 171.516 C 5.739 171.516 4.129 170.546 3.369 168.926 L -22.201 111.646 L -38.601 111.646 L -9.911 175.936 C -7.001 182.296 -0.631 186.506 6.379 186.506 L 22.019 186.506 C 29.029 186.506 35.399 182.296 38.309 175.936 L 60.309 126.636 L 72.919 126.636 C 72.919 126.636 83.429 126.636 83.429 126.636 L 83.429 171.506 L 69.729 171.506 L 69.729 186.496 L 113.739 186.496 L 113.739 171.506 L 100.149 171.506 L 100.149 126.636 L 113.739 126.636 L 113.749 126.636 Z"/>
//                         <g fill="url(#:r3:-1)" transform="matrix(1, 0, 0, 1, -69.520859, -96.024467)">
//                           <path d="M467.03,257.5c1.29-3.88,2.05-8.09,2.05-12.4,0-21.14-17.15-37.43-38.29-37.43h-205.04c-21.25,0-38.4,16.29-38.4,37.43s17.15,37.43,38.4,37.43h42.23c8.28,0,14.99-6.71,14.99-14.99h-57.22c-2.5,0-5-.46-7.33-1.38-3.73-1.47-6.96-4.08-9.25-7.37-2.75-3.95-4.05-8.64-4.05-13.44,0-2.78.32-5.6,1.19-8.25.92-2.79,2.39-5.4,4.34-7.6,1.87-2.12,4.18-3.85,6.76-5.03,2.61-1.2,5.47-1.81,8.34-1.81,0,0,86.45-.11,86.45-.11v60.09h16.72v-60.09h33.46c-4.78,6.22-7.63,13.97-7.63,22.55,0,21.14,17.15,37.43,38.4,37.43h27.51c3.34,0,6.47,1.19,8.85,3.34l7.44,6.47h25.46l-28.37-24.81h-40.88c-11.43,0-20.71-9.49-20.71-22.44s9.28-22.44,20.71-22.44h37.65c11.43,0,20.6,9.49,20.6,22.44,0,4.64-1.19,8.84-3.24,12.4h18.88Z"/>
//                           <path d="M221.93,245.5h0c0,4.14,3.36,7.5,7.5,7.5h25.42v-14.99h-25.42c-4.14,0-7.5,3.36-7.5,7.5Z"/>
//                         </g>
//                       </g>
//                     </svg>
//                     `,
//             },

//             {
//               text: "CÔNG TY TNHH VIET-Q",
//               marginLeft: -100,
//               bold: true,
//               fontSize: 20,
//               style: [ 'header', 'anotherStyle' ],
//               alignment: "center",
//               color: "#0C68E9",
//             },
//           ],
//         },
//         {
//               text: "PHIEU LUONG",
//               bold: true,
//               fontSize: 20,
//               alignment: "center",

//         },
//         {},
//         {},
//         {
//           margin: [0, 15, 0, 10],
//           columns: [
//             {
//               width: "50%",
//               table: {
//                 widths: ["50%", "50%"],
//                 body: [
//                   [
//                     { text: "Họ tên / Full Name:", bold: true },
//                     "<FULLNAME>",
//                   ],
//                   [{ text: "Email:", bold: true }, "LOC"],
//                   [
//                     { text: "Số diện thoại / Phone:", bold: true },
//                     "<PHONE>",
//                   ],
//                   [
//                     { text: "Mã NV / Emp. code:", bold: true },
//                     "<USERCODE>",
//                   ],
//                   [{ text: "Chức vụ / Job Title:", bold: true }, "<CHUC VU>"],
//                   [
//                     {
//                       text: "Ngày công chuẩn / Standard working days:",
//                       bold: true,
//                     },
//                     "<TOTALDAY IN MONTH>",
//                   ],
//                 ],
//               },
//               layout: "noBorders",
//             },
//             {
//               width: "50%",
//               table: {
//                 widths: ["50%", "50%"],
//                 body: [
//                   [
//                     { text: "Số tài khoản / Bank account:", bold: true },
//                     "1234567890",
//                   ],
//                   [
//                     { text: "Ngân hàng / Bank:", bold: true },
//                     "NH Ngoại thương VN - Vietcombank",
//                   ],
//                   [
//                     { text: "Mã số thuế / PIT Code:", bold: true },
//                     "1234567890",
//                   ],
//                 ],
//               },
//               layout: "noBorders",
//             },
//           ],
//         },
//         {},
//         {},
//         {
//           text: 'Sample value',
//           fillOpacity: 0.15,
//           fillColor: 'blue',
//           overlayPattern: ['stripe45d', 'gray'],
//           overlayOpacity: 0.15
//         },
//         {text: "---------------------------------------------------------------"}

// 	]

// }
