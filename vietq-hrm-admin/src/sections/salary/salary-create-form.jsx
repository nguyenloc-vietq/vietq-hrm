import dayjs from 'dayjs';
import { toast } from 'sonner';
import { z as zod } from 'zod';
import { useMemo } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';

import Box from '@mui/material/Box';
import { Alert } from '@mui/material';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import LoadingButton from '@mui/lab/LoadingButton';
import DialogTitle from '@mui/material/DialogTitle';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';

import SalaryApi from 'src/services/api/salary.api';

import { Form, Field } from 'src/components/hook-form';

// ----------------------------------------------------------------------

export const SalaryCreateScheme = zod.object({
  user: zod.object({
    userCode: zod.string().min(1, 'User code is required'),
  }),
  baseSalary: zod.number().min(1000, { message: 'Base salary must be at least 1000' }),
  overtimeRate: zod
    .number()
    .min(0, { message: 'Overtime rate must be at least 0' })
    .max(10, { message: 'Overtime rate must be at most 1' }),
  otNightRate: zod
    .number()
    .min(0, { message: 'Overtime rate must be at least 0' })
    .max(10, { message: 'Overtime rate must be at most 1' }),
  nightRate: zod
    .number()
    .min(0, { message: 'Overtime rate must be at least 0' })
    .max(10, { message: 'Overtime rate must be at most 1' }),
  lateRate: zod
    .number()
    .min(0, { message: 'Overtime rate must be at least 0' })
    .max(1, { message: 'Overtime rate must be at most 1' }),
  earlyRate: zod
    .number()
    .min(0, { message: 'Overtime rate must be at least 0' })
    .max(1, { message: 'Overtime rate must be at most 1' }),
  effectiveDate: zod.string().optional(),
});

// ----------------------------------------------------------------------

export function SalaryCreateForm({ currentUser, open, onClose, onUpdateRow }) {
  const defaultValues = useMemo(
    () => ({
      user: {},
      baseSalary: currentUser?.baseSalary || 1000,
      overtimeRate: currentUser?.overtimeRate || 0,
      otNightRate: currentUser?.otNightRate || 0,
      nightRate: currentUser?.nightRate || 0,
      lateRate: currentUser?.lateRate || 0,
      earlyRate: currentUser?.earlyRate || 0,
      effectiveDate: currentUser?.expireDate || dayjs().format(),
    }),
    [currentUser]
  );

  const methods = useForm({
    mode: 'all',
    resolver: zodResolver(SalaryCreateScheme),
    defaultValues,
  });
  const {
    reset,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;
  // const options = currentUser.map((item) => ({
  //     value: item.userCode,
  //     label: item.fullName,
  console.log('[==================> current user', currentUser);
  //   }))
  const onSubmit = handleSubmit(async (data) => {
    toast.loading('crate user...');
    try {
      console.log(`[===============> show data | `, data);
      reset();
      onClose();
      const { user, ...body } = data;
      const CreateSalary = await SalaryApi.createSalary({
        userCode: user.userCode,
        ...body,
      });
      toast.dismiss();
      toast.success('Update success!');
      // onUpdateRow(CreateSalary);
      console.info('DATA', data);
    } catch (error) {
      console.error(error);
    }
  });

  return (
    <Dialog
      fullWidth
      maxWidth={false}
      open={open}
      onClose={onClose}
      PaperProps={{ sx: { maxWidth: 720 } }}
    >
      <Form methods={methods} onSubmit={onSubmit}>
        <DialogTitle>Create Salary</DialogTitle>

        <DialogContent>
          <Alert variant="outlined" severity="info" sx={{ mb: 3 }}>
            Create base salary information
          </Alert>

          <Box
            rowGap={3}
            columnGap={2}
            display="grid"
            gridTemplateColumns={{ xs: 'repeat(1, 1fr)', sm: 'repeat(2, 1fr)' }}
          >
            {/* <Field.Select name="isActive" label="Status">
              {USER_STATUS_OPTIONS.map((status) => (
                <MenuItem key={status.value} value={status.value}>
                  {status.label}
                </MenuItem>
              ))}
            </Field.Select> */}
            <Field.Autocomplete
              name="user"
              label="Select user"
              autoHighlight
              options={currentUser.map((item) => item.user)}
              getOptionLabel={(option) => option.fullName ?? ''}
              isOptionEqualToValue={(option, value) => option.userCode === value.userCode}
              renderOption={(props, option) => (
                <li {...props} key={option.userCode}>
                  <div style={{ display: 'flex', flexDirection: 'column' }}>
                    <span>{option.fullName}</span>
                    <small style={{ color: '#777' }}>
                      {option.userProfessionals?.[0]?.position || ''}
                    </small>
                  </div>
                </li>
              )}
            />

            <Box sx={{ display: { xs: 'none', sm: 'block' } }} />
            <Field.Text type="number" name="baseSalary" label="Base salary" />
            <Field.Text type="number" name="overtimeRate" label="Overtime rate" />
            <Field.Text type="number" name="otNightRate" label="Ot night rate" />
            <Field.Text type="number" name="nightRate" label="Night rate" />
            <Field.Text type="number" name="lateRate" label="Late rate" />
            <Field.Text type="number" name="earlyRate" label="Early rate" />
            <Field.DatePicker name="effectiveDate" label="Expire date" />
          </Box>
        </DialogContent>

        <DialogActions>
          <Button variant="outlined" onClick={onClose}>
            Cancel
          </Button>

          <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
            Update
          </LoadingButton>
        </DialogActions>
      </Form>
    </Dialog>
  );
}
