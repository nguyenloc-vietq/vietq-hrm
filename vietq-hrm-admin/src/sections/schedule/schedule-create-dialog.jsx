import dayjs from 'dayjs';
import { toast } from 'sonner';
import { useState, useEffect } from 'react';

import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import {
  Stack,
  Button,
  Dialog,
  MenuItem,
  TextField,
  DialogTitle,
  Autocomplete,
  DialogActions,
  DialogContent,
  CircularProgress,
} from '@mui/material';

import UserApi from 'src/services/api/user.api';
import ShiftApi from 'src/services/api/shift.api';
import ScheduleApi from 'src/services/api/schedule.api';

const ALL_USERS_OPTION = { userCode: 'ALL', fullName: 'All Users', isAllOption: true };

export function ScheduleCreateDialog({ open, onClose, onSuccess }) {
  const [users, setUsers] = useState([]);
  const [shifts, setShifts] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  const [selectedShift, setSelectedShift] = useState('');
  const [startDate, setStartDate] = useState(dayjs());
  const [endDate, setEndDate] = useState(dayjs().add(7, 'day'));
  const [isDateError, setIsDateError] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      fetchData();
    }
  }, [open]);

  const fetchData = async () => {
    try {
      setIsLoading(true);
      const [usersData, shiftsData] = await Promise.all([
        UserApi.getListUser(),
        ShiftApi.getListShift(),
      ]);
      setUsers([ALL_USERS_OPTION, ...(usersData || [])]);
      setShifts(shiftsData || []);
    } catch (error) {
      console.log(error);
      toast.error('Failed to load data');
    } finally {
      setIsLoading(false);
    }
  };

  const handleStartChange = (newStart) => {
    setStartDate(newStart);
    if (endDate && newStart.isAfter(endDate, 'day')) {
      setIsDateError(true);
    } else {
      setIsDateError(false);
    }
  };

  const handleEndChange = (newEnd) => {
    setEndDate(newEnd);
    if (startDate && newEnd.isBefore(startDate, 'day')) {
      setIsDateError(true);
    } else {
      setIsDateError(false);
    }
  };

  const generateWorkOnDates = (start, end) => {
    const dates = [];
    let current = start.startOf('day');
    const endDay = end.startOf('day');

    while (current.isBefore(endDay) || current.isSame(endDay, 'day')) {
      dates.push(`${current.format('YYYY-MM-DD')}T00:00:00.000Z`);
      current = current.add(1, 'day');
    }

    return dates;
  };

  const handleSubmit = async () => {
    if (!selectedUser || !selectedShift || isDateError) {
      toast.error('Please fill all required fields');
      return;
    }

    try {
      setIsSubmitting(true);
      const workOnDates = generateWorkOnDates(startDate, endDate);

      let body;
      if (selectedUser.isAllOption) {
        body = {
          action: 'all',
          shiftCode: selectedShift,
          workOn: workOnDates,
        };
      } else {
        body = {
          shiftCode: selectedShift,
          userCode: selectedUser.userCode,
          workOn: workOnDates,
        };
      }

      await ScheduleApi.createSchedule(body);
      toast.success('Schedule created successfully');
      handleClose();
      if (onSuccess) onSuccess();
    } catch (error) {
      console.log(error);
      toast.error(error.message || 'Failed to create schedule');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleClose = () => {
    setSelectedUser(null);
    setSelectedShift('');
    setStartDate(dayjs());
    setEndDate(dayjs().add(7, 'day'));
    setIsDateError(false);
    onClose();
  };

  return (
    <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
      <DialogTitle>Create Schedule</DialogTitle>
      <DialogContent>
        <Stack spacing={3} sx={{ pt: 2 }}>
          <Autocomplete
            options={users}
            getOptionLabel={(option) => {
              if (option.isAllOption) return option.fullName;
              return `${option.fullName} (${option.userCode})`;
            }}
            value={selectedUser}
            onChange={(event, newValue) => setSelectedUser(newValue)}
            loading={isLoading}
            renderInput={(params) => (
              <TextField
                {...params}
                label="Select User"
                required
                InputProps={{
                  ...params.InputProps,
                  endAdornment: (
                    <>
                      {isLoading ? <CircularProgress color="inherit" size={20} /> : null}
                      {params.InputProps.endAdornment}
                    </>
                  ),
                }}
              />
            )}
            renderOption={(props, option) => (
              <li
                {...props}
                key={option.userCode}
                style={option.isAllOption ? { fontWeight: 'bold', backgroundColor: '#f5f5f5' } : {}}
              >
                {option.isAllOption ? option.fullName : `${option.fullName} (${option.userCode})`}
              </li>
            )}
          />

          <TextField
            select
            label="Select Shift"
            value={selectedShift}
            onChange={(e) => setSelectedShift(e.target.value)}
            required
            disabled={isLoading}
          >
            {shifts.map((shift) => (
              <MenuItem key={shift.shiftCode} value={shift.shiftCode}>
                {shift.name} ({shift.startTime} - {shift.endTime})
              </MenuItem>
            ))}
          </TextField>

          <DatePicker
            label="Start Date"
            value={startDate}
            onChange={handleStartChange}
            slotProps={{
              textField: {
                required: true,
                error: isDateError,
              },
            }}
          />

          <DatePicker
            label="End Date"
            value={endDate}
            onChange={handleEndChange}
            slotProps={{
              textField: {
                required: true,
                error: isDateError,
                helperText: isDateError ? 'End date must be after start date' : '',
              },
            }}
          />
        </Stack>
      </DialogContent>
      <DialogActions>
        <Button variant="outlined" color="inherit" onClick={handleClose}>
          Cancel
        </Button>
        <Button
          variant="contained"
          onClick={handleSubmit}
          disabled={isSubmitting || isDateError || !selectedUser || !selectedShift}
        >
          {isSubmitting ? <CircularProgress size={24} /> : 'Create'}
        </Button>
      </DialogActions>
    </Dialog>
  );
}
