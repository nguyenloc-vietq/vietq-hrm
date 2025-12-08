import customParseFormat from "dayjs/plugin/customParseFormat";
import dayjs from "dayjs";
import timezone from "dayjs/plugin/timezone";
import utc from "dayjs/plugin/utc";

dayjs.extend(utc);
dayjs.extend(timezone);
dayjs.extend(customParseFormat);

function getLateMinutes(checkinDayjs, userTimezone, startTime) {
  // 1. Xác định ngày check-in theo giờ địa phương của user

  // 2. Tạo mốc "08:00:00 hôm nay" theo giờ địa phương của user
  const startWorkToday = dayjs
    .tz(
      checkinDayjs.format("YYYY-MM-DD") + " " + startTime,
      "YYYY-MM-DD H:mm:ss",
      userTimezone,
    )
    .utc();

  console.log(`[===============> check in | `, checkinDayjs);

  console.log(`[===============> start work day | `, startWorkToday);
  // 3. So sánh thời gian check-in với 08:00 địa phương
  if (checkinDayjs.isBefore(startWorkToday)) {
    return 0; // đến sớm hoặc đúng giờ
  }
  console.log(
    `[===============> late minin | `,
    checkinDayjs.diff(startWorkToday, "minute"),
  );
  // 4. Tính số phút đi muộn
  return checkinDayjs.diff(startWorkToday, "minute");
}

export default getLateMinutes;

export function countWeekendsInMonth(year, month) {
  // month trong dayjs là zero-indexed (0 = tháng 1, 11 = tháng 12)
  // Đảm bảo đầu vào month được điều chỉnh phù hợp nếu cần thiết (ví dụ: nếu bạn dùng 1-indexed)
  const date = dayjs().year(year).month(month).startOf("month");
  const daysInMonth = date.daysInMonth();
  let saturdayCount = 0;
  let sundayCount = 0;

  for (let i = 0; i < daysInMonth; i++) {
    const currentDay = date.add(i, "day");
    const dayOfWeek = currentDay.day(); // day() trả về 0 (Chủ Nhật) đến 6 (Thứ Bảy)

    if (dayOfWeek === 0) {
      sundayCount++;
    } else if (dayOfWeek === 6) {
      saturdayCount++;
    }
  }

  return {
    saturday: saturdayCount,
    sunday: sundayCount,
    totalWeekends: saturdayCount + sundayCount,
  };
}
