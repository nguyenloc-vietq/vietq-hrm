import axiosInstance, { endpoints } from 'src/utils/axios';

class PayrollApi {
  static async getListPayroll({ type = 'all', year = null }) {
    try {
      const res = await axiosInstance.get(
        year !== null
          ? `${endpoints.payroll.getListPayroll}?year=${year}`
          : `${endpoints.payroll.getListPayroll}?${type}=true`
      );
      return res.data;
    } catch (error) {
      console.log('Get list payroll is error | ', error);
      throw error;
    }
  }

  static async createPayroll(requestBody) {
    try {
      const res = await axiosInstance.post(endpoints.payroll.createPayroll, requestBody);
      return res.data;
    } catch (error) {
      console.log('Create payroll is error | ', error);
      throw error;
    }
  }
}

export default PayrollApi;
