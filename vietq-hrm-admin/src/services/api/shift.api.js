import axiosInstance, { endpoints } from 'src/utils/axios';

class ShiftApi {
  static async getListShift() {
    try {
      const res = await axiosInstance.get(endpoints.shift.getListShift);
      return res.data;
    } catch (error) {
      console.log('Response Shift | ', error);
      throw error;
    }
  }

  static async createShift(body) {
    try {
      const res = await axiosInstance.post(endpoints.shift.createShift, body);
      return res.data;
    } catch (error) {
      console.log('Create Shift Error | ', error);
      throw error;
    }
  }
}

export default ShiftApi;
