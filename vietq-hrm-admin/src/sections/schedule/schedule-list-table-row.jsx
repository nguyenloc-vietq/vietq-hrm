import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';

import Stack from '@mui/material/Stack';
import Tooltip from '@mui/material/Tooltip';
import Checkbox from '@mui/material/Checkbox';
import TableRow from '@mui/material/TableRow';
import TableCell from '@mui/material/TableCell';
import { Avatar, Skeleton } from '@mui/material';
import IconButton from '@mui/material/IconButton';

import { CONFIG } from 'src/config-global';

import { Label } from 'src/components/label';
import { Iconify } from 'src/components/iconify';

dayjs.extend(utc);
dayjs.extend(timezone);

const getStatusColor = (status) => {
  switch (status) {
    case 'NEXT':
      return 'info';
    case 'DONE':
      return 'success';
    case 'ABSENT':
      return 'error';
    default:
      return 'default';
  }
};

export function ScheduleListTableRow({ row, selected, onSelectRow, onViewDetail }) {
  return (
    <TableRow hover selected={selected} aria-checked={selected} tabIndex={-1}>
      <TableCell padding="checkbox">
        <Checkbox id={row.user?.userCode} checked={selected} onClick={onSelectRow} />
      </TableCell>

      <TableCell>
        <Stack direction="row" alignItems="center" spacing={2}>
          <Avatar
            alt={row.user?.fullName}
            src={CONFIG.site.imageUrl + row.user.avatar}
            sx={{ width: 36, height: 36 }}
          />
          <Stack>
            <span style={{ fontWeight: 600 }}>{row.user?.fullName}</span>
            <span style={{ fontSize: 12, color: '#637381' }}>{row.user?.userCode}</span>
          </Stack>
        </Stack>
      </TableCell>

      <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.user?.email}</TableCell>

      <TableCell sx={{ whiteSpace: 'nowrap' }}>{row.schedules?.length || 0}</TableCell>

      <TableCell>
        <Stack direction="row" spacing={1} flexWrap="wrap">
          {row.schedules?.slice(0, 3).map((schedule) => (
            <Tooltip
              key={schedule.scheduleCode}
              title={`${schedule.shift?.name} (${schedule.shift?.startTime} - ${schedule.shift?.endTime})`}
            >
              <Label color={getStatusColor(schedule.status)}>
                {dayjs(schedule.workOn).format('DD/MM')}
              </Label>
            </Tooltip>
          ))}
          {row.schedules?.length > 3 && <Label color="default">+{row.schedules.length - 3}</Label>}
        </Stack>
      </TableCell>

      <TableCell>
        <Stack direction="row" alignItems="center">
          <Tooltip title="View Details" placement="top" arrow>
            <IconButton color="default" onClick={onViewDetail}>
              <Iconify icon="solar:eye-bold" />
            </IconButton>
          </Tooltip>
        </Stack>
      </TableCell>
    </TableRow>
  );
}

export function TableSkeleton({ length = 5 }) {
  return [...Array(5)].map((_, index) => (
    <TableRow key={index}>
      {[...Array(length)].map((__, i) => (
        <TableCell key={i}>
          <Skeleton />
        </TableCell>
      ))}
    </TableRow>
  ));
}
