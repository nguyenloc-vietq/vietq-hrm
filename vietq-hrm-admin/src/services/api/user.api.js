import axiosInstance, { endpoints } from 'src/utils/axios';

class UserApi {
  static async createUser(body) {
    try {
      const res = await axiosInstance.post('/api/user/create-user', body);
      return res.data;
    } catch (error) {
      console.log('Respone Api User | ', error);
      throw error;
    }
  }

  static async getListUser() {
    try {
      const res = await axiosInstance.get(endpoints.user.getListUser);
      return res.data;
    } catch (error) {
      console.log('Respone Api User | ', error);
      throw error;
    }
  }

  static async getProfile() {
    try {
      const res = await axiosInstance.get(endpoints.user.profile);
      return res.data;
    } catch (error) {
      console.log('Respone Api User | ', error);
      throw error;
    }
  }

  static async updateProfile(body) {
    try {
      const res = await axiosInstance.put(endpoints.user.updateProfile, body);
      return res.data;
    } catch (error) {
      console.log('Respone Api User | ', error);
      throw error;
    }
  }

  static async updateAvatar(body) {
    try {
      const res = await axiosInstance.post(endpoints.user.updateAvatar, body, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      return res.data;
    } catch (error) {
      console.log('Respone Api User | ', error);
      throw error;
    }
  }

  static async updateUser(body) {
    try {
      const res = await axiosInstance.put(endpoints.user.updateUser, body);
      return res.data;
    } catch (error) {
      console.log('Respone Api User | ', error);
      throw error;
    }
  }
}

export default UserApi;
