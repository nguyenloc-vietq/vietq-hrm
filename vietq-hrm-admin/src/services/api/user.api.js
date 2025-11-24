import axiosInstance from "src/utils/axios";

class UserApi {
    static async createUser(body) {
        try {
            const res = await axiosInstance.post("http://localhost:1900/api/user/create-user", body);
            console.log(`[===============> Res Api Create user | `, res.data);
            return res.data;
        } catch (error) {
            console.log("Respone Api User | ", error );
            throw error;
        }
    }

}

export default UserApi;