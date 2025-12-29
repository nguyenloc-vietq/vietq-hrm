import React from 'react';

import { Box } from '@mui/material';

import { paths } from 'src/routes/paths';

import { DashboardContent } from 'src/layouts/dashboard';

import { CustomBreadcrumbs } from 'src/components/custom-breadcrumbs';

export function AttendanceListRecords() {
  return (
    <DashboardContent>
      <CustomBreadcrumbs
        heading="Payroll List"
        links={[
          { name: 'Dashboard', href: paths.dashboard.root },
          { name: 'Attendance', href: paths.dashboard.attendance.root },
          { name: 'Attendance List' },
        ]}
        sx={{ mb: { xs: 3, md: 5 } }}
      />
      <Box>List Attendance</Box>
    </DashboardContent>
  );
}
