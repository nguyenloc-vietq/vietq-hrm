import React from 'react';

import { Box } from '@mui/material';

import { paths } from 'src/routes/paths';

import { DashboardContent } from 'src/layouts/dashboard';

import { CustomBreadcrumbs } from 'src/components/custom-breadcrumbs';

export function RegistrationMain() {
  return (
    <DashboardContent>
      <CustomBreadcrumbs
        heading="Registration"
        links={[
          { name: 'Dashboard', href: paths.dashboard.root },
          { name: 'Registration', href: paths.dashboard.registration.root },
          { name: 'Registration' },
        ]}
        sx={{ mb: { xs: 3, md: 5 } }}
      />
      <Box>Registration</Box>
    </DashboardContent>
  );
}
