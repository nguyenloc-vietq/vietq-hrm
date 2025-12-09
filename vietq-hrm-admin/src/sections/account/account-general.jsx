/* eslint-disable react-hooks/exhaustive-deps */
import { z as zod } from 'zod';
import { useForm } from 'react-hook-form';
import { useState, useEffect } from 'react';
import { zodResolver } from '@hookform/resolvers/zod';

import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import { Skeleton } from '@mui/material';
import Grid from '@mui/material/Unstable_Grid2';
import Typography from '@mui/material/Typography';
import LoadingButton from '@mui/lab/LoadingButton';

import { useBoolean } from 'src/hooks/use-boolean';

import { fData } from 'src/utils/format-number';

import { CONFIG } from 'src/config-global';
import UserApi from 'src/services/api/user.api';

import { toast } from 'src/components/snackbar';
import { Form, Field, schemaHelper } from 'src/components/hook-form';

// ----------------------------------------------------------------------

export const UpdateUserSchema = zod.object({
  fullName: zod.string().min(1, { message: 'Name is required!' }),
  email: zod
    .string()
    .min(1, { message: 'Email is required!' })
    .email({ message: 'Email must be a valid email address!' }),
  avatar: schemaHelper.file({
    message: { required_error: 'Avatar is required!' },
  }),
  // phoneNumber: schemaHelper.phoneNumber({ isValidPhoneNumber }),
  companyName: schemaHelper.objectOrNull({
    message: { required_error: 'Company name is required!' },
  }),
  phoneNumber: zod.string().min(1, { message: 'Phone number is required!' }),
  address: zod.string().min(1, { message: 'Address is required!' }),
  position: zod.string().min(1, { message: 'State is required!' }),
  employeeType: zod.string().min(1, { message: 'City is required!' }),
});

export function AccountGeneral() {
  // const { user } = useMockedUser();
  const { userData, setUserData } = useState({});
  const isLoading = useBoolean();
  const defaultValues = {
    fullName: '',
    email: '',
    avatar: '',
    phoneNumber: '',
    companyName: '',
    address: '',
    position: '',
    employeeType: '',
  };

  const methods = useForm({
    mode: 'all',
    resolver: zodResolver(UpdateUserSchema),
    defaultValues,
  });
  const {
    handleSubmit,
    watch,
    reset,
    formState: { isSubmitting, isDirty },
  } = methods;
  console.log(`[===============> isD | `, isDirty);
  const isAvatarChange = typeof watch('avatar') === 'string';
  const onSubmit = handleSubmit(async (data) => {
    if (document.activeElement instanceof HTMLElement) {
      document.activeElement.blur();
    }
    try {
      await new Promise((resolve) => setTimeout(resolve, 500));

      if (!isAvatarChange) {
        const formData = new FormData();
        formData.append('avatar', data.avatar);
        console.log(`[===============> formdata | `, data.avatar);
        await UserApi.updateAvatar(formData);
      }
      if (isDirty) {
        const newDataUser = await UserApi.updateProfile({
          phone: data.phoneNumber,
          fullName: data.fullName,
          address: data.address,
          email: data.email,
        });
        //   reset({
        //     fullName: newDataUser?.fullName || '',
        //     email: newDataUser?.email || '',
        //     // avatar: `${CONFIG.site.imageUrl}${newDataUser.avatar}`,
        //     phoneNumber: newDataUser?.phone || '',
        //     address: newDataUser?.address || '',
        //   },
        // {keepDirty: false});

        reset({
          fullName: newDataUser?.fullName || '',
          email: newDataUser?.email || '',
          avatar: newDataUser?.avatar ? `${CONFIG.site.imageUrl}${newDataUser.avatar}` : '',
          phoneNumber: newDataUser?.phone || '',
          companyName: watch('companyName'),
          address: newDataUser?.address || '',
          position: watch('position'),
          employeeType: watch('employeeType'),
        });
        console.log(`[===============> dataUpdate | `, newDataUser);
      }
      toast.success('Update success!');
      console.info('DATA', data);
    } catch (error) {
      toast.error(error.message);
      console.error(error);
    }
  });
  const fetchUserProfile = async () => {
    isLoading.onTrue();
    try {
      const profileUser = await UserApi.getProfile();
      console.log(`[===============> profile user | `, profileUser);
      reset({
        fullName: profileUser?.fullName || '',
        email: profileUser?.email || '',
        avatar: profileUser?.avatar ? `${CONFIG.site.imageUrl}${profileUser.avatar}` : '',
        phoneNumber: profileUser?.phone || '',
        companyName: profileUser?.company?.companyName || '',
        address: profileUser?.address || '',
        position: profileUser?.userProfessionals?.position || '',
        employeeType: profileUser?.userProfessionals?.employeeType || '',
      });
      setUserData(profileUser);
    } catch (error) {
      console.log(error);
    } finally {
      isLoading.onFalse();
    }
  };
  useEffect(() => {
    fetchUserProfile();
  }, []);
  return (
    <Form methods={methods} onSubmit={onSubmit}>
      <Grid container spacing={3}>
        <Grid xs={12} md={4}>
          <Card
            sx={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              pt: 10,
              pb: 5,
              px: 3,
              textAlign: 'center',
            }}
          >
            {isLoading.value ? (
              <Skeleton variant="circular" width={120} height={120} />
            ) : (
              <Field.UploadAvatar
                name="avatar"
                maxSize={3145728}
                helperText={
                  <Typography
                    variant="caption"
                    sx={{
                      mt: 3,
                      mx: 'auto',
                      display: 'block',
                      textAlign: 'center',
                      color: 'text.disabled',
                    }}
                  >
                    Allowed *.jpeg, *.jpg, *.png, *.gif
                    <br /> max size of {fData(3145728)}
                  </Typography>
                }
              />
            )}
          </Card>
        </Grid>

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
              {' '}
              {isLoading.value ? (
                <>
                  <Skeleton width="100%" height={50} />
                  <Skeleton width="100%" height={50} />
                  <Skeleton width="100%" height={50} />
                  <Skeleton width="100%" height={50} />
                  <Skeleton width="100%" height={50} />
                  <Skeleton width="100%" height={50} />
                  <Skeleton width="100%" height={50} />
                </>
              ) : (
                <>
                  <Field.Text disabled name="email" label="Email address" />
                  <Field.Text disabled name="companyName" label="Copany name" />
                  <Field.Text disabled name="position" label="Position" />
                  <Field.Text disabled name="employeeType" label="Employee type" />
                  <Field.Text name="fullName" label="Name" />
                  <Field.Text name="phoneNumber" label="Phone number" />
                  <Field.Text name="address" label="Address" />
                </>
              )}
            </Box>

            <Stack spacing={3} alignItems="flex-end" sx={{ mt: 3 }}>
              {/* <Field.Text name="about" multiline rows={4} label="About" /> */}

              <LoadingButton
                disabled={isLoading.value || (!isAvatarChange ? false : !isDirty)}
                type="submit"
                variant="contained"
                loading={isSubmitting}
              >
                Save changes
              </LoadingButton>
            </Stack>
          </Card>
        </Grid>
      </Grid>
    </Form>
  );
}
