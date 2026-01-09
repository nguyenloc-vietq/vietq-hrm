import * as Yup from 'yup';
import { toast } from 'sonner';
import PropTypes from 'prop-types';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import React, { useMemo, useState, useEffect } from 'react';

import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import MenuItem from '@mui/material/MenuItem';
import TextField from '@mui/material/TextField';
import Grid from '@mui/material/Unstable_Grid2';
import CardHeader from '@mui/material/CardHeader';
import Typography from '@mui/material/Typography';
import LoadingButton from '@mui/lab/LoadingButton';
import Autocomplete from '@mui/material/Autocomplete';
import FormControlLabel from '@mui/material/FormControlLabel';

import { paths } from 'src/routes/paths';
import { useRouter } from 'src/routes/hooks';

import { useResponsive } from 'src/hooks/use-responsive';

import UserApi from 'src/services/api/user.api';
import NotificationApi from 'src/services/api/notification.api';

import {
  Form,
  RHFSelect,
  RHFEditor,
  RHFSwitch,
  RHFTextField,
  RHFMobileDateTimePicker,
} from 'src/components/hook-form';

// ----------------------------------------------------------------------

export const NotificationCreateView = ({ currentPost }) => {
  const router = useRouter();

  const mdUp = useResponsive('up', 'md');

  const [users, setUsers] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  const NewBlogSchema = Yup.object().shape({
    title: Yup.string().required('Title is required'),
    body: Yup.string().required('Content is required'),
    targetType: Yup.string().required('Target type is required'),
    listUserCode: Yup.array().when('targetType', {
      is: 'SINGLE',
      then: (schema) => schema.min(1, 'At least one user is required'),
      otherwise: (schema) => schema,
    }),
    scheduleTime: Yup.string().nullable(),
  });

  const defaultValues = useMemo(
    () => ({
      title: currentPost?.title || '',
      body: currentPost?.body || '',
      notificationType: currentPost?.notificationType || 'NORMAIL',
      targetType: currentPost?.targetType || 'ALL',
      listUserCode: currentPost?.listUserCode || [],
      isSent: currentPost?.isSent || true,
      scheduleTime: currentPost?.scheduleTime || null,
    }),
    [currentPost]
  );

  const methods = useForm({
    resolver: yupResolver(NewBlogSchema),
    defaultValues,
  });

  const {
    reset,
    watch,
    setValue,
    handleSubmit,
    formState: { isSubmitting, isValid },
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

  const handleCreate = handleSubmit(async (data) => {
    setIsLoading(true);
    try {
      const payload = {
        notificationType: data.notificationType,
        title: data.title,
        body: data.body,
        targetType: data.targetType,
        openSent: 1,
        isSent: !!data.isSent,
      };

      if (!data.isSent && data.scheduleTime) {
        payload.scheduleTime = data.scheduleTime;
      }

      if (data.targetType === 'SINGLE') {
        payload.listUserCode = data.listUserCode.map((user) => user.code || user);
      }
      console.log('[==================> payload', payload);
      await NotificationApi.create(payload);
      reset();
      toast.success(currentPost ? 'Update success!' : 'Create success!');
      router.push(paths.dashboard.notification.list);
    } catch (error) {
      toast.error(`Error: ${error.message}`);
    } finally {
      setIsLoading(false);
    }
  });

  const renderDetails = (
    <Grid xs={12} md={12}>
      <Card>
        {!mdUp && <CardHeader title="Details" />}

        <Stack spacing={3} sx={{ p: 3 }}>
          <RHFTextField name="title" label="Notification Title" />

          <RHFSelect
            name="notificationType"
            label="Notification Type"
            InputLabelProps={{ shrink: true }}
          >
            <MenuItem value="NORMAIL">Normal</MenuItem>
            <MenuItem value="IMPORTANT">Important</MenuItem>
          </RHFSelect>

          <RHFSelect name="targetType" label="Target Type" InputLabelProps={{ shrink: true }}>
            <MenuItem value="ALL">All</MenuItem>
            <MenuItem value="SINGLE">Single</MenuItem>
          </RHFSelect>

          {watch('targetType') === 'SINGLE' && (
            <Autocomplete
              multiple
              options={users}
              getOptionLabel={(option) => option.name || ''}
              value={watch('listUserCode') || []}
              onChange={(event, newValue) => {
                setValue('listUserCode', newValue, { shouldValidate: true });
              }}
              renderOption={(props, option) => (
                <li {...props} key={option.code}>
                  {option.name}
                </li>
              )}
              renderInput={(params) => (
                <TextField
                  {...params}
                  label="Users"
                  placeholder="Select users"
                  error={!!methods.formState.errors.listUserCode}
                  helperText={methods.formState.errors.listUserCode?.message}
                />
              )}
            />
          )}

          {!watch('isSent') && (
            <RHFMobileDateTimePicker
              name="scheduleTime"
              label="Schedule Time"
              slotProps={{
                textField: {
                  helperText: 'Set schedule time for delayed sending',
                },
              }}
            />
          )}
          <FormControlLabel
            control={<RHFSwitch name="isSent" />}
            label="Open Sent"
            sx={{ flexGrow: 1, pl: 3 }}
          />
          <Stack spacing={1.5}>
            <Typography variant="subtitle2">Content</Typography>
            <RHFEditor simple name="body" />
          </Stack>
        </Stack>
      </Card>
    </Grid>
  );

  const renderActions = (
    <Grid xs={12} md={8} ml={3} sx={{ display: 'flex', alignItems: 'center' }}>
      <LoadingButton
        type="submit"
        variant="contained"
        size="large"
        loading={isLoading}
        disabled={!isValid}
      >
        {!currentPost ? 'Create Notification' : 'Save Changes'}
      </LoadingButton>
    </Grid>
  );

  return (
    <Form methods={methods} onSubmit={handleCreate}>
      <Grid container spacing={3}>
        {renderDetails}
        {renderActions}
      </Grid>
    </Form>
  );
};

NotificationCreateView.propTypes = {
  currentPost: PropTypes.shape({
    title: PropTypes.string,
    body: PropTypes.string,
    notificationType: PropTypes.string,
    targetType: PropTypes.string,
    listUserCode: PropTypes.arrayOf(PropTypes.string),
    openSent: PropTypes.bool,
    scheduleTime: PropTypes.string,
  }),
};
