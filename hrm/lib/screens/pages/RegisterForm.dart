import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _checkTime;
  final _lateHoursController = TextEditingController();
  final _reasonController = TextEditingController();

  final List<String> _leaveTypes = [
    "Sick Leave",
    "Annual Leave",
    "Medical Leave",
    "Maternity Leave",
    "Check In",
    "Check Out",
    "Late",
  ];

  bool get _isLeaveType => _selectedType != null &&
      ["Sick Leave", "Annual Leave", "Medical Leave", "Maternity Leave"]
          .contains(_selectedType);
  bool get _isCheckInOut => _selectedType == "Check In" || _selectedType == "Check Out";
  bool get _isLate => _selectedType == "Late";

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        isStart ? _startDate = picked : _endDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _checkTime = picked);
  }

  @override
  void dispose() {
    _lateHoursController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title (hiện loại đã chọn)
              _buildTextField(
                label: "Title",
                hint: "Sick Leave",
                controller: TextEditingController(text: _selectedType ?? ""),
                readOnly: true,
              ),
              SizedBox(height: 16.h),

              // Leave Type Dropdown
              _buildDropdown(textTheme),
              SizedBox(height: 16.h),

              // Start Date & End Date (Leave)
              if (_isLeaveType) ...[
                _buildDateField("Start Date", _startDate, () => _selectDate(true)),
                SizedBox(height: 16.h),
                _buildDateField("End Date", _endDate, () => _selectDate(false)),
                SizedBox(height: 16.h),
              ],

              // Time Picker (Check In / Check Out)
              if (_isCheckInOut) ...[
                _buildTimeField(),
                SizedBox(height: 16.h),
              ],

              // Late Hours
              if (_isLate)
                _buildTextField(
                  label: "Late Hours",
                  hint: "2.5",
                  controller: _lateHoursController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),

              if (_isCheckInOut || _isLate) SizedBox(height: 16.h),

              // Reason
              _buildTextField(
                label: "Reason for Leave",
                hint: "I need to take a medical leave.",
                controller: _reasonController,
                maxLines: 5,
              ),
              SizedBox(height: 32.h),

              // Apply Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {

                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Leave request submitted!"),
                          backgroundColor: colorScheme.primaryContainer,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Apply Leave",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // Dropdown
  Widget _buildDropdown(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Leave Type", style: textTheme.bodyMedium),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: _selectedType,
          hint: Text("Select leave type", style: textTheme.bodyMedium),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),

          dropdownColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
          icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
          items: _leaveTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type, style: textTheme.bodyMedium)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedType = value;
              _startDate = null;
              _endDate = null;
              _checkTime = null;
              _lateHoursController.clear();
            });
          },
          validator: (v) => v == null ? "Please select leave type" : null,
        ),
      ],
    );
  }

  // TextField chung
  Widget _buildTextField({
    required String label,
    required String hint,
    TextEditingController? controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodyMedium),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
          validator: (v) => v!.isEmpty ? "This field is required" : null,
        ),
      ],
    );
  }

  // Date Field
  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodyMedium),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Row(
              children: [
                Text(
                  date == null
                      ? "Select date"
                      : DateFormat('MMMM d, yyyy').format(date),
                  style: textTheme.bodyMedium,
                ),
                const Spacer(),
                Icon(Icons.calendar_today, size: 20.sp, color: Theme.of(context).primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Time Field
  Widget _buildTimeField() {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Time", style: textTheme.bodyMedium),
        SizedBox(height: 8.h),
        InkWell(
          onTap: _selectTime,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Row(
              children: [
                Text(
                  _checkTime == null ? "Select time" : _checkTime!.format(context),
                  style: textTheme.bodyMedium
                ),
                const Spacer(),
                Icon(Icons.access_time, size: 20.sp, color: Theme.of(context).primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}