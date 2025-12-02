import axiosInstance, { endpoints } from "src/utils/axios";

class UserApi {
    static async createUser(body) {
        try {
            const res = await axiosInstance.post("/api/user/create-user", body);
            console.log(`[===============> Res Api Create user | `, res.data);
            return res.data;
        } catch (error) {
            console.log("Respone Api User | ", error );
            throw error;
        }
    }

    static async getListUser() {
        try {
            const res = await axiosInstance.get(endpoints.user.getListUser);
            console.log(`[===============> Res Api Create user | `, res.data);
            return res.data;
        } catch (error) {
            console.log("Respone Api User | ", error );
            throw error;
        }
    }

    static async getProfile() {
        try {
            const res = await axiosInstance.get(endpoints.user.profile);
            console.log(`[===============> Res Api Create user | `, res.data);
            return res.data;
        } catch (error) {
            console.log("Respone Api User | ", error );
            throw error;
        }
    }

}

export default UserApi;