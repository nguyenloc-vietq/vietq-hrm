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
}

export default ShiftApi;
