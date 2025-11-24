import { useForm, Controller } from 'react-hook-form'; // useForm trước Controller
import { z as zod } from 'zod';
import { useMemo } from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { isValidPhoneNumber } from 'react-phone-number-input/input';

import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import Button from '@mui/material/Button';
import Switch from '@mui/material/Switch';
import Grid from '@mui/material/Unstable_Grid2';
import IconButton from '@mui/material/IconButton';
import Typography from '@mui/material/Typography';
import LoadingButton from '@mui/lab/LoadingButton';
import InputAdornment from '@mui/material/InputAdornment';
import FormControlLabel from '@mui/material/FormControlLabel';

import { useRouter } from 'src/routes/hooks';

import { useBoolean } from 'src/hooks/use-boolean';
import usePasswordGenerator from 'src/hooks/use-generate-password';

import { fData } from 'src/utils/format-number';

import UserApi from 'src/services/api/user.api';

import { Label } from 'src/components/label';
import { toast } from 'src/components/snackbar';
import { Iconify } from 'src/components/iconify';
import { Form, Field, schemaHelper } from 'src/components/hook-form';

// ----------------------------------------------------------------------

// "fullName": "Ho Nguyen Loc 2",
// "email": "nguyenlocsss@viet-q.com",
// "phone": "0372663903",a
// "password": "Locasd4499@",
// "position": "Developer",
// "employeeType": "Fluu Time"
export const NewUserSchema = zod.object({
  avatarUrl: schemaHelper.file().optional(),
  fullName: zod.string().min(1, { message: 'Name is required!' }),
  email: zod
    .string()
    .min(1, { message: 'Email is required!' })
    .email({ message: 'Email must be a valid email address!' }),
  phone: schemaHelper.phoneNumber({ isValidPhoneNumber }),
  employeeType: zod.string().min(1, { message: 'Address is required!' }),
  position: zod.string().min(1, { message: 'Company is required!' }),
  password: zod
    .string()
    .min(6, { message: 'Password must be at least 6 characters' })
    .max(20, { message: 'Password must be at most 20 characters' })
    .refine((password) => /[A-Z]/.test(password), {
      message: 'Password must contain at least one uppercase letter',
    })
    .refine((password) => /[a-z]/.test(password), {
      message: 'Password must contain at least one lowercase letter',
    })
    .refine((password) => /[0-9]/.test(password), {
      message: 'Password must contain at least one number',
    })
    .refine((password) => /[!@#$%^&*]/.test(password), {
      message: 'Password must contain at least one special character (!@#$%^&*)',
    }),
});

// ----------------------------------------------------------------------

export function UserNewEditForm({ currentUser }) {
  const router = useRouter();
  const password = useBoolean();
  const generatePassword = usePasswordGenerator();

  const defaultValues = useMemo(
    () => ({
      avatarUrl: currentUser?.avatarUrl || null,
      fullName: currentUser?.fullName || '',
      email: currentUser?.email || '',
      phone: currentUser?.phone || '',
      employeeType: currentUser?.employeeType || '',
      position: currentUser?.position || '',
      password: '',
    }),
    [currentUser]
  );

  const methods = useForm({
    mode: 'onSubmit',
    resolver: zodResolver(NewUserSchema),
    defaultValues,
  });
  const { setValue } = methods;

  const {
    reset,
    watch,
    control,
    handleSubmit,
    formState: { isSubmitting },
  } = methods;

  const values = watch();

  const onSubmit = handleSubmit(async (data) => {
    try {
      const dataNewUser = await UserApi.createUser(data);
      toast.success(currentUser ? 'Update success!' : 'Create success!');
      // router.push(paths.dashboard.user.list);
      console.log(`[===============> success | `, dataNewUser);
      console.info('DATA', data);
      reset();
    } catch (error) {
      toast.error(error.message);
      console.error(error);
    }
  });

  return (
    <Form methods={methods} onSubmit={onSubmit}>
      <Grid container spacing={3}>
        <Grid xs={12} md={4}>
          <Card sx={{ pt: 10, pb: 5, px: 3 }}>
            {currentUser && (
              <Label
                color={
                  (values.status === 'active' && 'success') ||
                  (values.status === 'banned' && 'error') ||
                  'warning'
                }
                sx={{ position: 'absolute', top: 24, right: 24 }}
              >
                {values.status}
              </Label>
            )}

            <Box sx={{ mb: 5 }}>
              <Field.UploadAvatar
                name="avatarUrl"
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
            </Box>

            {currentUser && (
              <FormControlLabel
                labelPlacement="start"
                control={
                  <Controller
                    name="status"
                    control={control}
                    render={({ field }) => (
                      <Switch
                        {...field}
                        checked={field.value !== 'active'}
                        onChange={(event) =>
                          field.onChange(event.target.checked ? 'banned' : 'active')
                        }
                      />
                    )}
                  />
                }
                label={
                  <>
                    <Typography variant="subtitle2" sx={{ mb: 0.5 }}>
                      Banned
                    </Typography>
                    <Typography variant="body2" sx={{ color: 'text.secondary' }}>
                      Apply disable account
                    </Typography>
                  </>
                }
                sx={{
                  mx: 0,
                  mb: 3,
                  width: 1,
                  justifyContent: 'space-between',
                }}
              />
            )}

            {currentUser && (
              <Stack justifyContent="center" alignItems="center" sx={{ mt: 3 }}>
                <Button variant="soft" color="error">
                  Delete user
                </Button>
              </Stack>
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
              <Field.Text
                name="fullName"
                label={
                  <>
                    Full name <span style={{ color: "red" }}>*</span>
                  </>
                }
              />
              <Field.Text
                name="email"
                label={
                  <>
                    Email address <span style={{ color: "red" }}>*</span>
                  </>
                }
              />
              <Field.Phone
                name="phone"
                label={
                  <>
                    Phone number <span style={{ color: "red" }}>*</span>
                  </>
                }
              />
              <Field.Text
                name="position"
                label={
                  <>
                    Position <span style={{ color: "red" }}>*</span>
                  </>
                }
              />

              <Field.Text
                name="password"
                label={
                  <>
                  Password <span style={{ color: "red" }}>*</span>
                  </>
                }
                placeholder="6+ characters"
                type={password.value ? 'text' : 'password'}
                InputLabelProps={{ shrink: true }}
                InputProps={{
                  endAdornment: (
                    <InputAdornment position="end">
                      {/* Nút sinh mật khẩu */}
                      <IconButton
                        onClick={() => {
                          const newPass = generatePassword();
                          setValue('password', newPass, { shouldValidate: true });
                          toast.success('Generate password is success!');
                        }}
                        edge="end"
                        title="Generate strong password"
                      >
                        <Iconify icon="solar:key-bold" />
                      </IconButton>

                      {/* Nút show/hide */}
                      <IconButton onClick={password.onToggle} edge="end">
                        <Iconify
                          icon={password.value ? 'solar:eye-bold' : 'solar:eye-closed-bold'}
                        />
                      </IconButton>
                    </InputAdornment>
                  ),
                }}
              />
              <Field.Text name="employeeType" label={
                <>
                Employee type <span style={{color: "red"}}> * </span>
                </>
              } />
            </Box>

            <Stack alignItems="flex-end" sx={{ mt: 3 }}>
              <LoadingButton type="submit" variant="contained" loading={isSubmitting}>
                {!currentUser ? 'Create user' : 'Save changes'}
              </LoadingButton>
            </Stack>
          </Card>
        </Grid>
      </Grid>
    </Form>
  );
}
