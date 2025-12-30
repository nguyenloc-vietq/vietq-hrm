import dayjs from 'dayjs';

import axiosInstance, { endpoints } from 'src/utils/axios';

class AttendanceApi {
  static async getAdminListAttendance(
    startDate = dayjs().startOf('month').format('YYYY-MM-DD'),
    endDate = dayjs().endOf('month').format('YYYY-MM-DD')
  ) {
    try {
      const res = await axiosInstance.get(endpoints.attendance.adminListAttendance, {
        params: {
          startDate,
          endDate,
        },
      });
      return res.data;
    } catch (error) {
      console.log('Response Attendance | ', error);
      throw error;
    }
  }
}

export default AttendanceApi;
