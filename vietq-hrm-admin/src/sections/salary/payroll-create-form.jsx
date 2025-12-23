import dayjs from 'dayjs';
import { toast } from 'sonner';
import { z as zod } from 'zod';
import utc from 'dayjs/plugin/utc';
import { useMemo, useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';

import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import LoadingButton from '@mui/lab/LoadingButton';
import DialogTitle from '@mui/material/DialogTitle';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import { Chip, Alert, Stack, MenuItem, Typography } from '@mui/material';

import { ACTIVE_STATUS_OPTION } from 'src/_mock';
import PayrollApi from 'src/services/api/payroll.api';

import { Form, Field } from 'src/components/hook-form';

dayjs.extend(utc);

// ----------------------------------------------------------------------

export const PayrollCreateSchema = zod
  .object({
    startMonth: zod.string().min(1, 'Start month is required'),
    endMonth: zod.string().min(1, 'End month is required'),
    isLocked: zod.string().default('Y'),
    isActive: zod.boolean().default(true),
  })
  .refine(
    (data) => {
      const start = dayjs(data.startMonth);
      const end = dayjs(data.endMonth);
      return !end.isBefore(start);
    },
    {
      message: 'End month must be after or equal to start month',
      path: ['endMonth'],
    }
  );

// ----------------------------------------------------------------------

// Helper function to generate list of months with proper UTC times
function generateMonthsList(startMonth, endMonth, isLocked = 'Y', isActive = true) {
  const start = dayjs(startMonth);
  const end = dayjs(endMonth);

  const months = [];
  let current = start;

  while (current.isBefore(end, 'month') || current.isSame(end, 'month')) {
    // Create UTC dates directly to avoid timezone conversion
    const year = current.year();
    const month = current.month(); // 0-indexed

    // Start of month: YYYY-MM-01T00:00:00.000Z
    const monthStart = dayjs.utc(`${year}-${String(month + 1).padStart(2, '0')}-01T00:00:00.000Z`);

    // End of month: YYYY-MM-DDT23:59:59.000Z
    const daysInMonth = current.daysInMonth();
    const monthEnd = dayjs.utc(
      `${year}-${String(month + 1).padStart(2, '0')}-${String(daysInMonth).padStart(2, '0')}T23:59:59.000Z`
    );

    months.push({
      startDate: monthStart.toISOString(),
      endDate: monthEnd.toISOString(),
      isLocked,
      isActive,
    });

    current = current.add(1, 'month');
  }

  return months;
}

// ----------------------------------------------------------------------

export function PayrollCreateForm({ open, onClose, onUpdateRow }) {
  const [previewMonths, setPreviewMonths] = useState([]);

  const defaultValues = useMemo(
    () => ({
      startMonth: dayjs(),
      endMonth: dayjs().add(11, 'month'),
      isLocked: 'Y',
      isActive: true,
    }),
    []
  );

  const methods = useForm({
    mode: 'all',
    resolver: zodResolver(PayrollCreateSchema),
    defaultValues,
  });

  const {
    reset,
    handleSubmit,
    watch,
    formState: { isSubmitting },
  } = methods;

  const startMonth = watch('startMonth');
  const endMonth = watch('endMonth');
  const isLocked = watch('isLocked');
  const isActive = watch('isActive');

  useMemo(() => {
    if (startMonth && endMonth) {
      try {
        const months = generateMonthsList(startMonth, endMonth, isLocked, isActive);
        setPreviewMonths(months);
      } catch (error) {
        setPreviewMonths([]);
      }
    } else {
      setPreviewMonths([]);
    }
  }, [startMonth, endMonth, isLocked, isActive]);

  const onSubmit = handleSubmit(async (data) => {
    const loadingToast = toast.loading('Creating payrolls...');

    try {
      const listCreatePayroll = generateMonthsList(
        data.startMonth,
        data.endMonth,
        data.isLocked,
        data.isActive
      );

      const requestBody = {
        listCreatePayroll,
      };

      console.log('[API Request Body]:', JSON.stringify(requestBody, null, 2));

      // Call your API
      const response = await PayrollApi.createPayroll(requestBody);

      toast.dismiss(loadingToast);
      toast.success(`Successfully created ${listCreatePayroll.length} payroll period(s)!`);

      reset();
      setPreviewMonths([]);
      onClose();

      if (onUpdateRow) {
        onUpdateRow(response);
      }
    } catch (error) {
      toast.dismiss(loadingToast);
      toast.error(error?.message || 'Failed to create payrolls');
      console.error('Create Payroll Error:', error);
    }
  });

  const handleClose = () => {
    reset();
    setPreviewMonths([]);
    onClose();
  };

  return (
    <Dialog fullWidth maxWidth="md" open={open} onClose={handleClose}>
      <Form methods={methods} onSubmit={onSubmit}>
        <DialogTitle>Create Multiple Payrolls</DialogTitle>

        <DialogContent dividers sx={{ pt: 3 }}>
          <Alert severity="info" sx={{ mb: 3 }}>
            Select start and end months to automatically generate payroll periods for each month in
            the range.
          </Alert>

          <Box
            rowGap={3}
            columnGap={2}
            display="grid"
            gridTemplateColumns={{ xs: 'repeat(1, 1fr)', sm: 'repeat(2, 1fr)' }}
          >
            <Field.DatePicker
              views={['month', 'year']}
              name="startMonth"
              label="Start Month"
              format="MMM YYYY"
            />

            <Field.DatePicker
              views={['month', 'year']}
              name="endMonth"
              label="End Month"
              format="MMM YYYY"
            />

            <Field.Select name="isLocked" label="Locked">
              {ACTIVE_STATUS_OPTION.map((status) => (
                <MenuItem key={status.value} value={status.value}>
                  {status.label}
                </MenuItem>
              ))}
            </Field.Select>
            <Field.Switch name="isActive" label="Active Status" />
          </Box>

          {previewMonths.length > 0 && (
            <Box sx={{ mt: 4 }}>
              <Alert severity="success" sx={{ mb: 2 }}>
                <Typography variant="body2">
                  <strong>{previewMonths.length} payroll period(s)</strong> will be created from{' '}
                  {dayjs(previewMonths[0].startDate).format('MMM YYYY')} to{' '}
                  {dayjs(previewMonths[previewMonths.length - 1].startDate).format('MMM YYYY')}
                </Typography>
              </Alert>

              <Box sx={{ mb: 1 }}>
                <Typography variant="subtitle2" color="text.secondary">
                  Preview Months:
                </Typography>
              </Box>

              <Stack
                direction="row"
                flexWrap="wrap"
                gap={1}
                sx={{
                  maxHeight: 200,
                  overflow: 'auto',
                  p: 2,
                  bgcolor: 'background.neutral',
                  borderRadius: 1,
                  border: '1px solid',
                  borderColor: 'divider',
                }}
              >
                {previewMonths.map((month, index) => {
                  const monthLabel = dayjs(month.startDate).format('MMM YYYY');
                  return (
                    <Chip
                      key={index}
                      label={monthLabel}
                      size="small"
                      color="primary"
                      variant="outlined"
                    />
                  );
                })}
              </Stack>
            </Box>
          )}
        </DialogContent>

        <DialogActions>
          <Button variant="outlined" onClick={handleClose}>
            Cancel
          </Button>

          <LoadingButton
            type="submit"
            variant="contained"
            loading={isSubmitting}
            disabled={previewMonths.length === 0}
          >
            Create {previewMonths.length > 0 && `${previewMonths.length} Payroll(s)`}
          </LoadingButton>
        </DialogActions>
      </Form>
    </Dialog>
  );
}
