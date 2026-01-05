import axios from 'axios';

import { CONFIG } from 'src/config-global';

// =================================================================
// Tạo instance axios
// =================================================================
const axiosInstance = axios.create({
  baseURL: CONFIG.site.serverUrl,
  headers: {
    'Content-Type': 'application/json',
  },
});

// =================================================================
// Request Interceptor – tự động gắn token (nếu có)
// =================================================================
axiosInstance.interceptors.request.use(
  (config) => {
    // Lấy token từ localStorage (hoặc từ redux, zustand, context tùy bạn)
    const accessToken = localStorage.getItem('accessToken');

    if (accessToken) {
      config.headers.Authorization = `Bearer ${accessToken}`;
    }

    return config;
  },
  (error) => {
    // Log lỗi request (rất hữu ích khi debug)
    console.error('Axios Request Error:', error);
    return Promise.reject(error);
  }
);

// =================================================================
// Response Interceptor – xử lý lỗi chung + refresh token (nếu cần)
// =================================================================
axiosInstance.interceptors.response.use(
  (response) => {
    console.log('response', response);
    if (response.data.error === true) {
      return Promise.reject(new Error(response.data.message));
    }
    return response.data;
  },
  // Trả về thẳng data nếu thành công
  async (error) => {
    const messageErr =
      error.response?.data?.message ||
      error.response?.data?.error ||
      error.message ||
      'Đã có lỗi xảy ra';
    const originalRequest = error.config;
    // 1. Xử lý lỗi 401 - Token hết hạn
    if (error.response?.status === 401 && !originalRequest._retry) {
      // return Promise.reject(error.response.data.message);
      console.log(originalRequest.url);

      if (originalRequest.url === endpoints.auth.signIn) {
        // Tạo error mới để dễ xử lý
        const customError = new Error(messageErr);
        customError.status = error.response?.status;
        customError.data = error.response?.data;
        return Promise.reject(customError);
      }
      originalRequest._retry = true;
      // Refresh thất bại → logout người dùng
      localStorage.removeItem('accessToken');
      localStorage.removeItem('refreshToken');
      // window.location.href = '/auth/jwt/sign-in';
      return Promise.reject(customError);
      // try {
      //   // Gọi API refresh token (nếu backend có)
      //   const refreshToken = localStorage.getItem('refreshToken');
      //   if (!refreshToken) throw new Error('No refresh token');

      //   const { data } = await axios.post(`${CONFIG.site.serverUrl}/api/auth/refresh-token`, {
      //     refreshToken,
      //   });

      //   const newAccessToken = data.accessToken;
      //   localStorage.setItem('accessToken', newAccessToken);

      //   // Gắn token mới và thử lại request cũ
      //   axiosInstance.defaults.headers.Authorization = `Bearer ${newAccessToken}`;
      //   originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;

      //   return axiosInstance(originalRequest);
      // } catch (refreshError) {
      //   // Refresh thất bại → logout người dùng
      //   localStorage.removeItem('accessToken');
      //   // localStorage.removeItem('refreshToken');
      //   window.location.href = '/auth/login';
      //   return Promise.reject(refreshError);
      // }
    }

    // 2. Xử lý các lỗi khác
    const status = error.response?.status;
    const message = error.response?.data?.message || error.message || 'Something went wrong!';

    // Tùy chỉnh thông báo lỗi theo status (dùng với toast/snackbar)
    let userMessage = message;

    switch (status) {
      case 400:
        userMessage = message || 'Yêu cầu không hợp lệ';
        break;
      case 403:
        userMessage = 'Bạn không có quyền thực hiện hành động này';
        break;
      case 404:
        userMessage = 'Không tìm thấy tài nguyên';
        break;
      case 500:
        userMessage = 'Lỗi máy chủ nội bộ. Vui lòng thử lại sau';
        break;
      case 502:
      case 503:
      case 504:
        userMessage = 'Máy chủ tạm thời không phản hồi. Đang thử lại...';
        break;
      default:
        break;
    }

    // Tạo error object chuẩn để dùng ở catch
    const customError = new Error(userMessage);
    customError.status = status;
    customError.data = error.response?.data;
    customError.isAxiosError = true;

    console.error(`API Error [${status}]:`, customError);

    return Promise.reject(customError);
  }
);

export default axiosInstance;

// ----------------------------------------------------------------------

export const fetcher = async (args) => {
  try {
    const [url, config] = Array.isArray(args) ? args : [args];

    const res = await axiosInstance.get(url, { ...config });

    return res.data;
  } catch (error) {
    console.error('Failed to fetch:', error);
    throw error;
  }
};

// ----------------------------------------------------------------------

export const endpoints = {
  chat: '/api/chat',
  kanban: '/api/kanban',
  calendar: '/api/calendar',
  salary: {
    getListSalary: '/api/salary/salary-list-user',
    createSalary: '/api/salary/create',
  },
  user: {
    profile: '/api/user/profile',
    createUser: '/api/user/create-user',
    getListUser: '/api/user/list-user',
    updateAvatar: '/api/user/upload-avatar',
    updateProfile: '/api/user/update',
    updateUser: '/api/user/user-update',
  },
  auth: {
    profile: '/api/auth/me',
    signIn: '/api/auth/login',
    forgot: '/api/auth/login',
    sendOtp: '/api/auth/login',
    validate: '/api/auth/login',
  },
  payroll: {
    getListPayroll: 'api/payroll/list-payroll',
    createPayroll: '/api/payroll/create',
    getPayrollConfig: '/api/payroll/list-payslips',
  },

  attendance: {
    adminListAttendance: '/api/attendance/admin-list-attendance',
    userListAttendance: '/api/attendance/user-list-attendance',
    createAttendance: '/api/attendance/create',
    updateAttendance: '/api/attendance/update',
    deleteAttendance: '/api/attendance/delete',
  },

  notification: {
    adminListNotification: '/api/notification/admin/list-notifications',
  },
  registration: {
    listRegistrations: '/api/registration/list-registrations',
    approveRegistration: '/api/registration/approve',
    rejectRegistration: '/api/registration/reject',
  },
  schedule: {
    adminListSchedules: '/api/schedule/admin/list-schedules',
    create: '/api/schedule/create',
  },
  shift: {
    getListShift: '/api/shift/get-list-shift',
  },
};
