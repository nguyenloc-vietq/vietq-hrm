import axiosInstance, { endpoints } from 'src/utils/axios';

class NotificationApi {
  static async getAdminListNotification() {
    try {
      const res = await axiosInstance.get(endpoints.notification.adminListNotification);
      return res.data;
    } catch (error) {
      console.log('Response Attendance | ', error);
      throw error;
    }
  }
}

export default NotificationApi;
