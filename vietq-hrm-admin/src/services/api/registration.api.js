import axiosInstance, { endpoints } from 'src/utils/axios';

export default class RegistrationApi {
  static async getList() {
    const response = await axiosInstance.get(endpoints.registration.listRegistrations);
    return response.data;
  }

  static async approve({ registrationCode, status }) {
    const response = await axiosInstance.post(endpoints.registration.approveRegistration, {
      registrationCode,
      status,
    });
    return response.data;
  }

  static async reject({ registrationCode, status }) {
    const response = await axiosInstance.post(endpoints.registration.rejectRegistration, {
      registrationCode,
      status,
    });
    return response.data;
  }
}
