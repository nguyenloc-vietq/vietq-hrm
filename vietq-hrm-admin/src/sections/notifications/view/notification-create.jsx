import PropTypes from 'prop-types';
import * as Yup from 'yup';
import { useMemo, useCallback, useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';

import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import Switch from '@mui/material/Switch';
import Grid from '@mui/material/Unstable_Grid2';
import CardHeader from '@mui/material/CardHeader';
import Typography from '@mui/material/Typography';
import LoadingButton from '@mui/lab/LoadingButton';
import FormControlLabel from '@mui/material/FormControlLabel';

import { paths } from 'src/routes/paths';
import { useRouter } from 'src/routes/hooks';

import { useResponsive } from 'src/hooks/use-responsive';

import {
  FormProvider,
  RHFSelect,
  RHFEditor,
  RHFTextField,
  RHFUpload,
  RHFSwitch,
  RHFAutocomplete,
} from 'src/components/hook-form';
import { useSnackbar } from 'src/components/snackbar';
import { useMutation, useQuery } from '@tanstack/react-query';
import { notificationApi } from 'src/services/api/notification.api';
import UserApi from 'src/services/api/user.api';

// ----------------------------------------------------------------------

export default function NotificationCreateView({ currentPost }) {
  const router = useRouter();
  const { enqueueSnackbar } = useSnackbar();

  const mdUp = useResponsive('up', 'md');

  const [users, setUsers] = useState([]);

  const NewBlogSchema = Yup.object().shape({
    title: Yup.string().required('Title is required'),
    body: Yup.string().required('Content is required'),
    targetType: Yup.string().required('Target type is required'),
    listUserCode: Yup.array().when('targetType', {
      is: 'SINGLE',
      then: Yup.array().min(1, 'At least one user is required'),
    }),
  });

  const defaultValues = useMemo(
    () => ({
      title: currentPost?.title || '',
      body: currentPost?.body || '',
      notificationType: currentPost?.notificationType || 'NORMAIL',
      targetType: currentPost?.targetType || 'ALL',
      listUserCode: currentPost?.listUserCode || [],
      openSent: currentPost?.openSent || true,
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

  const { data: userData } = useQuery({
    queryKey: ['users'],
    queryFn: UserApi.getListUser,
  });

  useEffect(() => {
    if (userData) {
      setUsers(userData.map((user) => ({ code: user.code, name: user.fullName })));
    }
  }, [userData]);

  const { mutate, isPending } = useMutation({
    mutationFn: (data) => notificationApi.create(data),
    onSuccess: () => {
      reset();
      enqueueSnackbar(currentPost ? 'Update success!' : 'Create success!');
      router.push(paths.dashboard.notification.list);
    },
    onError: (error) => {
      enqueueSnackbar(`Error: ${error.message}`, { variant: 'error' });
    },
  });

  const handleCreate = handleSubmit(async (data) => {
    const payload = {
      ...data,
      listUserCode: data.listUserCode.map((user) => user.code),
    };
    if (payload.targetType === 'ALL') {
      delete payload.listUserCode;
    }
    mutate(payload);
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
            {[
              { value: 'NORMAIL', label: 'Normal' },
              { value: 'IMPORTANT', label: 'Important' },
            ].map((option) => (
              <option key={option.value} value={option.value}>
                {option.label}
              </option>
            ))}
          </RHFSelect>

          <RHFSelect name="targetType" label="Target Type" InputLabelProps={{ shrink: true }}>
            {[
              { value: 'ALL', label: 'All' },
              { value: 'SINGLE', label: 'Single' },
            ].map((option) => (
              <option key={option.value} value={option.value}>
                {option.label}
              </option>
            ))}
          </RHFSelect>

          {watch('targetType') === 'SINGLE' && (
            <RHFAutocomplete
              name="listUserCode"
              label="Users"
              placeholder="+ Users"
              multiple
              freeSolo
              options={users}
              getOptionLabel={(option) => option.name || ''}
              renderOption={(props, option) => (
                <li {...props} key={option.code}>
                  {option.name}
                </li>
              )}
            />
          )}

          <Stack spacing={1.5}>
            <Typography variant="subtitle2">Content</Typography>
            <RHFEditor simple name="body" />
          </Stack>
        </Stack>
      </Card>
    </Grid>
  );

  const renderActions = (
    <Grid xs={12} md={8} sx={{ display: 'flex', alignItems: 'center' }}>
      <FormControlLabel
        control={<RHFSwitch name="openSent" />}
        label="Open Sent"
        sx={{ flexGrow: 1, pl: 3 }}
      />

      <LoadingButton
        type="submit"
        variant="contained"
        size="large"
        loading={isPending}
        disabled={!isValid}
      >
        {!currentPost ? 'Create Notification' : 'Save Changes'}
      </LoadingButton>
    </Grid>
  );

  return (
    <FormProvider methods={methods} onSubmit={handleCreate}>
      <Grid container spacing={3}>
        {renderDetails}
        {renderActions}
      </Grid>
    </FormProvider>
  );
}

NotificationCreateView.propTypes = {
  currentPost: PropTypes.object,
};
