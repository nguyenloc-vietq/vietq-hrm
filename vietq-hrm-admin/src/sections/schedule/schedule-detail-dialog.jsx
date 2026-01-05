import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import { CloseIcon } from 'yet-another-react-lightbox';

import {
  Box,
  Table,
  Stack,
  Avatar,
  Dialog,
  TableRow,
  TableBody,
  TableCell,
  TableHead,
  Typography,
  IconButton,
  DialogTitle,
  DialogContent,
} from '@mui/material';

import { CONFIG } from 'src/config-global';

import { Label } from 'src/components/label';
import { Scrollbar } from 'src/components/scrollbar';

dayjs.extend(utc);

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

export function ScheduleDetailDialog({ open, onClose, data, dateRange }) {
  if (!data) return null;

  const { user, schedules } = data;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        Schedule Details
        <IconButton
          aria-label="close"
          onClick={onClose}
          sx={{
            color: (theme) => theme.palette.grey[500],
          }}
        >
          <CloseIcon />
        </IconButton>
      </DialogTitle>
      <DialogContent>
        <Stack spacing={3} sx={{ pt: 1 }}>
          <Stack direction="row" spacing={2} alignItems="center">
            <Avatar
              alt={user?.fullName}
              src={CONFIG.site.imageUrl + user.avatar}
              sx={{ width: 64, height: 64 }}
            />
            <Box>
              <Typography variant="h6">{user?.fullName}</Typography>
              <Typography variant="body2" color="text.secondary">
                {user?.userCode}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                {user?.email}
              </Typography>
            </Box>
          </Stack>

          <Box
            sx={{
              paddingBottom: 5,
            }}
          >
            <Typography variant="subtitle1" sx={{ mb: 2 }}>
              Schedules ({schedules?.length || 0}) ({dateRange})
            </Typography>
            <Scrollbar>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>Schedule Code</TableCell>
                    <TableCell>Work Date</TableCell>
                    <TableCell>Shift</TableCell>
                    <TableCell>Time</TableCell>
                    <TableCell>Status</TableCell>
                    <TableCell>Payroll Code</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {schedules?.map((schedule) => (
                    <TableRow key={schedule.scheduleCode}>
                      <TableCell>{schedule.scheduleCode}</TableCell>
                      <TableCell>{dayjs.utc(schedule.workOn).format('DD/MM/YYYY')}</TableCell>
                      <TableCell>{schedule.shift?.name || schedule.shiftCode}</TableCell>
                      <TableCell>
                        {schedule.shift?.startTime} - {schedule.shift?.endTime}
                      </TableCell>
                      <TableCell>
                        <Label color={getStatusColor(schedule.status)}>{schedule.status}</Label>
                      </TableCell>
                      <TableCell>{schedule.payrollCode || '-'}</TableCell>
                    </TableRow>
                  ))}
                  {(!schedules || schedules.length === 0) && (
                    <TableRow>
                      <TableCell colSpan={6} align="center">
                        No schedules found
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            </Scrollbar>
          </Box>
        </Stack>
      </DialogContent>
    </Dialog>
  );
}
