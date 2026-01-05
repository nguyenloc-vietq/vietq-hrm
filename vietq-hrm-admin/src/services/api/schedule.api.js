import axiosInstance, { endpoints } from 'src/utils/axios';

class ScheduleApi {
  static async getAdminListSchedules(startDate, endDate) {
    try {
      const params = {};
      if (startDate) params.startDate = startDate;
      if (endDate) params.endDate = endDate;

      const res = await axiosInstance.get(endpoints.schedule.adminListSchedules, { params });
      return res.data;
    } catch (error) {
      console.log('Response Schedule | ', error);
      throw error;
    }
  }

  static async createSchedule(body) {
    try {
      const res = await axiosInstance.post(endpoints.schedule.create, body);
      return res.data;
    } catch (error) {
      console.log('Response Schedule | ', error);
      throw error;
    }
  }
}

export default ScheduleApi;
