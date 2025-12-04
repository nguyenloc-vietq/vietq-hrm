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
