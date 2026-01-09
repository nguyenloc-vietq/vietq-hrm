import axiosInstance, { endpoints } from 'src/utils/axios';

export default class NotificationApi {
  static async create(data) {
    try {
      const res = await axiosInstance.post(endpoints.notification.create, data);
      return res.data;
    } catch (error) {
      console.log('Get list payroll is error | ', error);
      throw error;
    }
  }

  static async testNotification(data) {
    try {
      const res = await axiosInstance.post('/api/notification/admin/test-noti', data);
      return res.data;
    } catch (error) {
      console.log('Test notification error | ', error);
      throw error;
    }
  }

  static async getAdminListNotification() {
    try {
      const res = await axiosInstance.get(endpoints.notification.adminListNotification);
      return res.data;
    } catch (error) {
      console.log('Get list payroll is error | ', error);
      throw error;
    }
  }
}
