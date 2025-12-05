import axiosInstance, { endpoints } from "src/utils/axios";

class SalaryApi {


    static async createSalary(body) {
        try {
            const res = await axiosInstance.post(endpoints.salary.createSalary, body);
            return res.data;
        } catch (error) {
            console.log(`[===============> ERROR CALL API | `, error);
            throw error;
        }
    }

    static async getListSalary() {
        try {
            const res = await axiosInstance.get(endpoints.salary.getListSalary);
            return res.data;
        } catch (error) {
            console.log(`[===============> ERROR CALL API | `, error);
            throw error;
        }
    }
}

export default SalaryApi;