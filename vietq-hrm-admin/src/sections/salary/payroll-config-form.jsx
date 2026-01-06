import { useForm } from 'react-hook-form'; // useForm trước Controller
import { z as zod } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { useState, useEffect, useCallback } from 'react';

import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import Grid from '@mui/material/Unstable_Grid2';
import LoadingButton from '@mui/lab/LoadingButton';

import { useRouter } from 'src/routes/hooks';

import PayrollApi from 'src/services/api/payroll.api';

import { toast } from 'src/components/snackbar';
import { Form, Field } from 'src/components/hook-form';

// ----------------------------------------------------------------------

export const PayrollConfigSchema = zod.object({
  companyName: zod.string().min(1, { message: 'Company name is required!' }),
  cycleType: zod.string().min(1, { message: 'cycleType is invalid!' }),
  paymentDelayDays: zod.string().min(1, { message: 'paymentDelayDays is required!' }),
  startDay: zod.string().min(1, { message: 'startDay is required!' }),
  endDay: zod.string().min(1, { message: 'endDay is required!' }),
});

// ----------------------------------------------------------------------

export function PayrollConfigForm({ currentUser }) {
  const router = useRouter();
  const [payrollConfig, setPayrollConfig] = useState({});

  // const defaultValues = useMemo(
  //   () => ({
  //     companyName: payrollConfig?.companyName || '',
  //     cycleType: payrollConfig?.cycleType || '',
  //     paymentDelayDays: payrollConfig?.paymentDelayDays || '',
  //     startDay: payrollConfig?.startDay || '',
  //     endDay: payrollConfig?.endDay || '',
  //   }),
  //   [payrollConfig]
  // );

  const methods = useForm({
    mode: 'onSubmit',
    resolver: zodResolver(PayrollConfigSchema),
    defaultValues: {
      companyName: '',
      cycleType: '',
      paymentDelayDays: '',
      startDay: '',
      endDay: '',
    },
  });

  const {
    reset,
    watch,
    control,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const fetchDatapayrollConfig = useCallback(async () => {
    try {
      const response = await PayrollApi.getPayrollConfig();
      console.log('[==================> response', response);
      setPayrollConfig(response);
      reset({
        companyName: response?.companyCode || '',
        cycleType: response?.cycleType || '',
        paymentDelayDays: response?.paymentDelayDays?.toString() || '',
        startDay: response?.startDay?.toString() || '',
        endDay: response?.endDay?.toString() || '',
      });
    } catch (error) {
      console.error('Error fetching payroll config:', error);
      toast.error(error.message);
    }
  }, [reset]);
  const onSubmit = handleSubmit(async (data) => {
    try {
      // const dataNewUser = await UserApi.createUser(data);
      toast.success(currentUser ? 'Update success!' : 'Create success!');
      // router.push(paths.dashboard.user.list);
      // console.log(`[===============> success | `, dataNewUser);
      console.info('DATA', data);
      reset();
    } catch (error) {
      toast.error(error.message);
      console.error(error);
    }
  });
  useEffect(() => {
    try {
      fetchDatapayrollConfig();
    } catch (error) {
      toast.error(error.message);
      console.error(error);
    }
  }, [fetchDatapayrollConfig]);
  return (
    <Form methods={methods} onSubmit={onSubmit}>
      <Grid container spacing={3}>
        <Grid xs={12} md={8}>
          <Card sx={{ p: 3 }}>
            <Box
              rowGap={3}
              columnGap={2}
              display="grid"
              gridTemplateColumns={{
                xs: 'repeat(1, 1fr)',
                sm: 'repeat(2, 1fr)',
              }}
            >
              <Field.Text name="companyName" disabled label={<>Company name</>} />
              <Field.Text name="cycleType" disabled label={<>Cycle type</>} />
              <Field.Text name="paymentDelayDays" label={<>Payment days</>} />
              <Field.Text name="startDay" label={<>Start day</>} />
              <Field.Text name="endDay" label={<>End day</>} />
            </Box>

            <Stack alignItems="flex-end" sx={{ mt: 3 }}>
              <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                Save changes
              </LoadingButton>
            </Stack>
          </Card>
        </Grid>
      </Grid>
    </Form>
  );
}
