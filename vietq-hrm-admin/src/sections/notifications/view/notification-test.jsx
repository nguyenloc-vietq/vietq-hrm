import * as Yup from 'yup';
import { toast } from 'sonner';
import { useForm } from 'react-hook-form';
import { useMemo, useState, useEffect } from 'react';
import { yupResolver } from '@hookform/resolvers/yup';

import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import MenuItem from '@mui/material/MenuItem';
import TextField from '@mui/material/TextField';
import Grid from '@mui/material/Unstable_Grid2';
import Typography from '@mui/material/Typography';
import CardHeader from '@mui/material/CardHeader';
import LoadingButton from '@mui/lab/LoadingButton';
import Autocomplete from '@mui/material/Autocomplete';

import { useResponsive } from 'src/hooks/use-responsive';

import UserApi from 'src/services/api/user.api';
import NotificationApi from 'src/services/api/notification.api';

import { Form, RHFSelect, RHFTextField } from 'src/components/hook-form';

// ----------------------------------------------------------------------

export const NotificationTestView = () => {
  const mdUp = useResponsive('up', 'md');
  const [users, setUsers] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  const TestSchema = Yup.object().shape({
    title: Yup.string().required('Title is required'),
    body: Yup.string().required('Body is required'),
    targetType: Yup.string().required('Target type is required'),
    userCodeList: Yup.array().when('targetType', {
      is: 'SINGLE',
      then: (schema) => schema.min(1, 'At least one user is required'),
      otherwise: (schema) => schema,
    }),
  });

  const defaultValues = useMemo(
    () => ({
      title: '',
      body: '',
      targetType: 'ALL',
      userCodeList: [],
    }),
    []
  );

  const methods = useForm({
    resolver: yupResolver(TestSchema),
    defaultValues,
  });

  const {
    reset,
    watch,
    setValue,
    handleSubmit,
    formState: { isValid },
  } = methods;

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const userData = await UserApi.getListUser();
        setUsers(userData.map((user) => ({ code: user.userCode, name: user.fullName })));
      } catch (error) {
        toast.error('Failed to load users');
      }
    };
    fetchUsers();
  }, []);

  const handleTest = handleSubmit(async (data) => {
    setIsLoading(true);
    try {
      const payload = {
        title: data.title,
        body: data.body,
        targetType: data.targetType,
      };

      if (data.targetType === 'SINGLE') {
        payload.userCodeList = data.userCodeList.map((user) => user.code || user);
      }

      await NotificationApi.testNotification(payload);
      toast.success('Test notification sent successfully!');
      reset();
    } catch (error) {
      toast.error(`Error: ${error.message}`);
    } finally {
      setIsLoading(false);
    }
  });

  const renderForm = (
    <Grid xs={12} md={8}>
      <Card>
        {!mdUp && <CardHeader title="Test Notification" />}

        <Stack spacing={3} sx={{ p: 3 }}>
          <RHFTextField name="title" label="Notification Title" />

          <RHFTextField name="body" label="Notification Body" multiline rows={4} />

          <RHFSelect name="targetType" label="Target Type" InputLabelProps={{ shrink: true }}>
            <MenuItem value="ALL">All Users</MenuItem>
            <MenuItem value="SINGLE">Specific Users</MenuItem>
          </RHFSelect>

          {watch('targetType') === 'SINGLE' && (
            <Autocomplete
              multiple
              options={users}
              getOptionLabel={(option) => option.name || ''}
              value={watch('userCodeList') || []}
              onChange={(event, newValue) => {
                setValue('userCodeList', newValue, { shouldValidate: true });
              }}
              renderOption={(props, option) => (
                <li {...props} key={option.code}>
                  {option.name}
                </li>
              )}
              renderInput={(params) => (
                <TextField
                  {...params}
                  label="Select Users"
                  placeholder="Choose users to send test notification"
                  error={!!methods.formState.errors.userCodeList}
                  helperText={methods.formState.errors.userCodeList?.message}
                />
              )}
            />
          )}
        </Stack>
      </Card>
    </Grid>
  );

  const renderActions = (
    <Grid xs={12} md={4}>
      <Card sx={{ p: 3 }}>
        <Stack spacing={2}>
          <Typography variant="h6">Test Notification</Typography>
          <Typography variant="body2" color="text.secondary">
            Send a test notification to verify your configuration before creating the actual
            notification.
          </Typography>
          <LoadingButton
            type="submit"
            variant="contained"
            size="large"
            loading={isLoading}
            disabled={!isValid}
            fullWidth
          >
            Send Test Notification
          </LoadingButton>
        </Stack>
      </Card>
    </Grid>
  );

  return (
    <Form methods={methods} onSubmit={handleTest}>
      <Grid container spacing={3}>
        {renderForm}
        {renderActions}
      </Grid>
    </Form>
  );
};
