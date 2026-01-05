import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:vietq_hrm/blocs/payslip/payslip_bloc.dart';
import 'package:vietq_hrm/utils/downloadAndShareFile.dart';
import 'package:vietq_hrm/utils/openPdf.dart';

class Payrollpage extends StatefulWidget {
  const Payrollpage({super.key});

  @override
  State<Payrollpage> createState() => _PayrollpageState();
}

class _PayrollpageState extends State<Payrollpage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        context.read<PayslipBloc>().add(const FetchPayslipEvent());
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
        body: BlocBuilder<PayslipBloc, PayslipState>(
          builder: (context, state) {
            if (state is PayslipLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PayslipLoaded) {
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: state.listPayslip?.length,
                itemBuilder: (context, index) {
                  final payslip = state.listPayslip?[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5).r,
                    child: Container(
                      padding: EdgeInsets.all(16).r,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Theme.of(context).appBarTheme.foregroundColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16).r,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        spacing: 15.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            padding: EdgeInsets.all(5).r,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/money-receive.svg',
                              width: 5.w,
                              height: 5.h,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              print(
                                "${dotenv.env['API_ENDPOINT']}file/${payslip["payslipFile"]}",
                              );
                              await openPdf(
                                "${dotenv.env['API_ENDPOINT']}file/${payslip["payslipFile"]}",
                                context,
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payslip["payroll"]["payrollName"] ??
                                      '',
                                  style: textTheme.headlineSmall,
                                ),
                                Text(
                                  DateFormat("MMMM d, yyyy").format(
                                    DateTime.parse(
                                      payslip["createdAt"] ?? '',
                                    ).toLocal(),
                                  ),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ), // Adjust the radius as needed
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                              onPressed: () async {
                                await downloadAndShareFile(
                                  "https://www.orimi.com/pdf-test.pdf",
                                  "payroll.pdf",
                                  context,
                                );
                              },
                              child: Icon(
                                Icons.download,
                                size: 30.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is PayslipError) {
              return Text('Error: ${state.message}');
            } else {
              return const Text('Unknown state');
            }
          },
        ),
      ),
    );
  }
}
