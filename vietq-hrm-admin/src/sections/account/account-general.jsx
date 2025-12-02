import { z as zod } from 'zod';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';

import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import Grid from '@mui/material/Unstable_Grid2';
import Typography from '@mui/material/Typography';
import LoadingButton from '@mui/lab/LoadingButton';

import { fData } from 'src/utils/format-number';

import { CONFIG } from 'src/config-global';

import { toast } from 'src/components/snackbar';
import { Form, Field, schemaHelper } from 'src/components/hook-form';

import { useMockedUser } from 'src/auth/hooks';

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
  address: zod.string().min(1, { message: 'Address is required!' }),
  position: zod.string().min(1, { message: 'State is required!' }),
  employeeType: zod.string().min(1, { message: 'City is required!' }),
});

export function AccountGeneral() {
  const { user } = useMockedUser();

  const defaultValues = {
    fullName: user?.fullName || '',
    email: user?.email || '',
    avatar: `${CONFIG.site.imageUrl}${user?.avatar}` || '',
    phoneNumber: "03726638903" || '',
    companyName: user.company.companyName || '',
    address: user?.address || '',
    position: user?.userProfessionals[0].position || '',
    employeeType: user?.userProfessionals[0].employeeType || '',
  };

  const methods = useForm({
    mode: 'all',
    resolver: zodResolver(UpdateUserSchema),
    defaultValues,
  });

  const {
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const onSubmit = handleSubmit(async (data) => {
    try {
      await new Promise((resolve) => setTimeout(resolve, 500));
      toast.success('Update success!');
      console.info('DATA', data);
    } catch (error) {
      console.error(error);
    }
  });

  return (
    <Form methods={methods} onSubmit={onSubmit}>
      <Grid container spacing={3}>
        <Grid xs={12} md={4}>
          <Card
            sx={{
              pt: 10,
              pb: 5,
              px: 3,
              textAlign: 'center',
            }}
          >
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
              <Field.Text disabled name="phoneNumber" label="Phone number" />
              <Field.Text disabled name="email" label="Email address" />
              <Field.Text name="fullName" label="Name" />
              <Field.Text name="address" label="Address" />

              <Field.Text name="companyName" label="Copany name" />

              <Field.Text name="position" label="Position" />
              <Field.Text name="employeeType" label="Employee type" />
            </Box>

            <Stack spacing={3} alignItems="flex-end" sx={{ mt: 3 }}>
              {/* <Field.Text name="about" multiline rows={4} label="About" /> */}

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
