
// To get the user from the <AuthContext/>, you can use

// Change:
// import { useMockedUser } from 'src/auth/hooks';
// const { user } = useMockedUser();

// To:
// import { useAuthContext } from 'src/auth/hooks';
// const { user } = useAuthContext();

// ----------------------------------------------------------------------

export function useMockedUser() {
  const user = {
        "id": 1,
        "companyCode": "CPA000001",
        "userCode": "USR000001",
        "email": "nguyenloc@viet-q.com",
        "phone": "0372663903",
        "fullName": "Ho Nguyen Loc",
        "address": "ddd",
        "avatar": "avatar/avatar-1764490351875-614181745.jpg",
        "isActive": "Y",
        "createdAt": "2025-11-06T16:20:31.018Z",
        "updatedAt": "2025-11-30T08:12:31.877Z",
        "company": {
            "address": null,
            "companyName": "VietQ Tech Solution"
        },
        "userProfessionals": [
            {
                "position": "Software Engineer",
                "employeeType": "Full time"
            }
        ]
    };

  return { user };
}
