import React from 'react';

import { Box } from '@mui/material';

import { paths } from 'src/routes/paths';

import { DashboardContent } from 'src/layouts/dashboard';

import { CustomBreadcrumbs } from 'src/components/custom-breadcrumbs';

export const ScheduleShift = () => (
  <DashboardContent>
    <CustomBreadcrumbs
      heading="Schedule Shift Page"
      links={[
        { name: 'Dashboard', href: paths.dashboard.root },
        { name: 'Schedule', href: paths.dashboard.schedule.root },
        { name: 'Schedule Shift Page' },
      ]}
      sx={{ mb: { xs: 3, md: 5 } }}
    />
    <Box>Schedule Shift Page</Box>
  </DashboardContent>
);
