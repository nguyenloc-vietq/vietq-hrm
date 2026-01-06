import { z as zod } from 'zod';
import { useForm } from 'react-hook-form';
import React, { useMemo, useEffect } from 'react';
import { zodResolver } from '@hookform/resolvers/zod';

import Box from '@mui/material/Box';
import Alert from '@mui/material/Alert';
import Dialog from '@mui/material/Dialog';
import Button from '@mui/material/Button';
import LoadingButton from '@mui/lab/LoadingButton';
import DialogTitle from '@mui/material/DialogTitle';
import DialogContent from '@mui/material/DialogContent';
import DialogActions from '@mui/material/DialogActions';

import ShiftApi from 'src/services/api/shift.api';

import { toast } from 'src/components/snackbar';
import { Form, Field } from 'src/components/hook-form';

// ======================================================================

const CreateShiftSchema = zod.object({
  name: zod.string().min(1, 'Shift name is required'),
  startTime: zod.string().min(1, 'Start time is required'),
  endTime: zod.string().min(1, 'End time is required'),
  allowableDelay: zod.number().min(0, 'Allowable delay must be positive').optional(),
});

// ======================================================================

export function CreateShiftForm({ open, onClose, onSuccess }) {
  const defaultValues = useMemo(
    () => ({
      name: '',
      startTime: '00:00:00',
      endTime: '00:00:00',
      allowableDelay: 0,
    }),
    []
  );

  const methods = useForm({
    resolver: zodResolver(CreateShiftSchema),
    defaultValues,
  });

  const {
    reset,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  useEffect(() => {
    if (!open) {
      reset(defaultValues);
    }
  }, [open, reset, defaultValues]);

  const normalizeTime = (time) => {
    if (!time) return time;
    return time.length === 5 ? `${time}:00` : time;
  };

  const onSubmit = handleSubmit(async (data) => {
    try {
      const payload = {
        ...data,
        startTime: normalizeTime(data.startTime),
        endTime: normalizeTime(data.endTime),
      };

      await ShiftApi.createShift(payload);
      toast.success('Shift created successfully!');
      onSuccess();
      onClose();
    } catch (error) {
      console.error(error);
      toast.error('Failed to create shift');
    }
  });

  return (
    <Dialog fullWidth maxWidth="sm" open={open} onClose={onClose}>
      <Form methods={methods} onSubmit={onSubmit}>
        <DialogTitle>Create New Shift</DialogTitle>

        <DialogContent sx={{ pt: 2 }}>
          <Alert severity="info" sx={{ mb: 3 }}>
            Shift code will be auto-generated. Enter shift details.
          </Alert>

          <Box sx={{ display: 'grid', gap: 2 }}>
            <Field.Text name="name" label="Shift Name" />
            <Field.Text name="startTime" label="Start Time" type="time" />
            <Field.Text name="endTime" label="End Time" type="time" />
            <Field.Text name="allowableDelay" label="Allowable Delay (minutes)" type="number" />
          </Box>
        </DialogContent>

        <DialogActions>
          <Button variant="outlined" onClick={onClose}>
            Cancel
          </Button>
          <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
            Create
          </LoadingButton>
        </DialogActions>
      </Form>
    </Dialog>
  );
}
